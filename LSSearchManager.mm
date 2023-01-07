//
//  LSSearchManager.m
//  localsearch
//
//  Created by 黄伟 on 2023/1/2.
//

#import "LSSearchManager.h"
#import "local_search.hpp"
#import "index_value.hpp"

@interface LSSearchManager () {
  @private
  LocalSearch *localSearch;
}
-(void)initSearchMgr;
@end

@implementation LSSearchManager


+(instancetype)sharedSearchManager {
  static dispatch_once_t t;
  static LSSearchManager *mgr;
  dispatch_once(&t, ^{
    mgr = [[LSSearchManager alloc] init];
    [mgr initSearchMgr];
  });
  return mgr;
}

-(void)initSearchMgr {
  NSError *err;
  NSURL *folder = [[NSFileManager defaultManager]
                      URLForDirectory:NSDocumentDirectory
                      inDomain:NSUserDomainMask
                      appropriateForURL:nil
                      create:YES
                      error:&err];
  NSURL *searchPath = [folder URLByAppendingPathComponent:@"xapian" isDirectory:YES];
  if (![[NSFileManager defaultManager] fileExistsAtPath:searchPath.path]) {
    [[NSFileManager defaultManager]
     createDirectoryAtURL:searchPath
     withIntermediateDirectories:YES
     attributes:nil
     error:&err];
  }
  NSLog(@"local search database path %@", searchPath);
  std::string dbpath(searchPath.path.UTF8String);
  
  localSearch = new LocalSearch(std::move(dbpath));
}

-(void)dealloc {
  delete localSearch;
}

+(NSString *)splitWords:(NSString *)words {
  
  NSMutableString *buf = [[NSMutableString alloc] init];
  CFStringTokenizerRef tokenizer = CFStringTokenizerCreate(
                                                           NULL,
                                                           (__bridge CFStringRef)words,
                                                           CFRangeMake(0, words.length),
                                                           kCFStringTokenizerUnitWordBoundary,
                                                           NULL);
  CFStringTokenizerAdvanceToNextToken(tokenizer);
  CFRange range;
  range = CFStringTokenizerGetCurrentTokenRange(tokenizer);
  NSString *token;
  while (range.length > 0) {
    token = [words substringWithRange:NSMakeRange(range.location, range.length)];
    [buf appendFormat:@" %@", token];
    CFStringTokenizerAdvanceToNextToken(tokenizer);
    range = CFStringTokenizerGetCurrentTokenRange(tokenizer);
  }
  CFRelease(tokenizer);
  
//  return outTokens;
  return buf;
}

-(void)indexDocs:(NSArray<Fort *> *)list {
  IndexValue::IndexValueType textType(IndexValue::Text);
  IndexValue::IndexValueType realType(IndexValue::Numberic);
  
  std::string corp_name_sc("CN");
  std::string corp_industry_con_sc("INC");
  std::string corp_industry_sc("IN");
  std::string corp_net_income_sc("NI");
  std::string corp_net_profit_sc("PT");
  
  // map is used to index properties
  std::unordered_map<std::string, IndexValue> doc(10);
  for (Fort *f in list) {
    doc.clear();
    std::string common_key([LSSearchManager splitWords:f.corp_name].UTF8String);
    IndexValue corp_name_val(common_key, corp_name_sc, textType);
    doc["corp_name"] = corp_name_val;
    
    common_key = [LSSearchManager splitWords:f.corp_industry_con].UTF8String;
    IndexValue corp_industry_con(common_key, corp_industry_con_sc, textType);
    doc["corp_industry_con"] = corp_industry_con;
    
    common_key = [LSSearchManager splitWords:f.corp_industry].UTF8String;
    IndexValue corp_industry(common_key, corp_industry_sc, textType);
    doc["corp_industry"] = corp_industry;
    
    common_key = std::to_string(f.corp_net_income);
    IndexValue corp_net_income(common_key, corp_net_income_sc, realType);
    doc["corp_net_income"] = corp_net_income;
    
    common_key = std::to_string(f.corp_net_profit);
    IndexValue corp_net_profit(common_key, corp_net_profit_sc, textType);
    doc["corp_net_profit"] = corp_net_profit;
    
    std::string doc_id(std::to_string(f.rank));
    localSearch->index_doc(doc_id, doc);
  }
  
  localSearch->commit_index();
}

-(SearchResult)doSearch:(NSString *)term {
  
  std::cout << "**search** " << term.UTF8String << std::endl;
  
  SearchResult searchResult = [[NSMutableArray alloc] initWithCapacity:20];
  
  void *context = (void *)CFBridgingRetain(searchResult);
  
  search_callback callback = [](const void *context,
                                const std::string &corp_name,
                                const std::string &corp_industry_con,
                                const std::string &corp_industry,
                                const std::string &corp_net_income,
                                const std::string &corp_net_profit,
                                const std::string &corp_rank) {
    std::cout << "corp_name" << corp_name << std::endl;
    SearchResult searchResult = (__bridge SearchResult)context;
    [searchResult addObject:@{
      @"corp_name": [NSString stringWithUTF8String:corp_name.c_str()],
      @"corp_industry_con": [NSString stringWithUTF8String:corp_industry_con.c_str()],
      @"corp_industry": [NSString stringWithUTF8String:corp_industry.c_str()],
      @"corp_net_income": [NSString stringWithUTF8String:corp_net_income.c_str()],
      @"corp_rank": [NSString stringWithUTF8String:corp_rank.c_str()],
    }];
  };
  
  localSearch->search([LSSearchManager splitWords:term].UTF8String, context, callback);
  
  CFBridgingRelease(context);
  NSLog(@"search result %@", searchResult);
  return searchResult;
  
  /*LocalSearch search(std::move(dbpath));
  std::string one_term("hello");
  search.search(one_term);
 
  std::unordered_map<std::string, std::string> doc = {
    {"x", "1"},
    {"y", "2"},
    {"id", "1"},
  };
  std::string docId = "doc_1";
  search.index_doc(docId, doc);
  search.commit_index();*/
}
@end
