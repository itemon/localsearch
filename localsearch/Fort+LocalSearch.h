//
//  Fort+LocalSearch.h
//  localsearch
//
//  Created by 黄伟 on 2023/1/5.
//
#import <UIKit/UIKit.h>
#import "Fort+CoreDataClass.h"
// fort callback
typedef void (^FortCallback)(NSError * _Nullable err, NSArray<Fort *> * _Nullable list);

NS_ASSUME_NONNULL_BEGIN

@interface Fort (LocalSearch)
+(void)queryAll:(NSPersistentContainer *)container callback:(FortCallback)callback;
@end

NS_ASSUME_NONNULL_END
