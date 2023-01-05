//
//  LSSearchManager.m
//  localsearch
//
//  Created by 黄伟 on 2023/1/2.
//

#import "LSSearchManager.h"
#import "local_search.hpp"

@implementation LSSearchManager
-(void)doSearch:(NSString *)term {
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
  
  LocalSearch search(std::move(dbpath));
  std::string one_term("hello");
  search.search(one_term);
 
  /*std::unordered_map<std::string, std::string> doc = {
    {"x", "1"},
    {"y", "2"},
    {"id", "1"},
  };
  std::string docId = "doc_1";
  search.index_doc(docId, doc);
  search.commit_index();*/
}
@end
