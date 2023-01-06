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

-(void)indexDocs:(NSArray<Fort *> *)list {
  Fort *corp = list.firstObject;
  IndexValue::IndexValueType textType = IndexValue::Text;
  std::string corp_name_shortcut = "CN";

  std::string corp_name = corp.corp_name.UTF8String;
  IndexValue corp_name_val(corp_name, corp_name_shortcut, textType);
  std::unordered_map<std::string, IndexValue> doc = {
    {"corp_name", corp_name_val},
  };
}

-(void)doSearch:(NSString *)term {
  
  std::cout << "search " << term.UTF8String << std::endl;
  
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
