//
//  Fort+LocalSearch.m
//  localsearch
//
//  Created by 黄伟 on 2023/1/5.
//

#import "Fort+LocalSearch.h"

@implementation Fort (LocalSearch)
+(void)queryAll:(NSPersistentContainer *)container callback:(FortCallback)callback {
  NSFetchRequest<Fort *> *fortReq = [Fort fetchRequest];
  fortReq.fetchLimit = 10;
  
  NSAsynchronousFetchRequest *asyncFortReq = [[NSAsynchronousFetchRequest alloc] initWithFetchRequest:fortReq completionBlock:^(NSAsynchronousFetchResult * _Nonnull rlt) {
    callback(nil, rlt.finalResult);
  }];
  
  NSError *err;
  [container.viewContext executeRequest:asyncFortReq error:&err];
  if (err) {
    callback(err, nil);
  }
}
@end
