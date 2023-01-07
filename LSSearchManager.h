//
//  LSSearchManager.h
//  localsearch
//
//  Created by 黄伟 on 2023/1/2.
//

#import <Foundation/Foundation.h>
#import "Fort+LocalSearch.h"

typedef NSMutableArray<NSDictionary<NSString *, id> *> *SearchResult;

NS_ASSUME_NONNULL_BEGIN

@interface LSSearchManager : NSObject
-(SearchResult)doSearch:(NSString *)term;

-(instancetype)init NS_UNAVAILABLE;
+(instancetype)sharedSearchManager;

-(void)indexDocs:(NSArray<Fort *> *)list;
@end

NS_ASSUME_NONNULL_END
