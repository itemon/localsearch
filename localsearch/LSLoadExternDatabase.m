//
//  LSLoadExternDatabase.m
//  localsearch
//
//  Created by 黄伟 on 2023/1/4.
//

#import "LSLoadExternDatabase.h"
#import "AppDelegate.h"
#import <sqlite3.h>

@implementation LSLoadExternDatabase
-(instancetype)init {
  self = [super init];
  if (self) {
    [self loadExtern];
  }
  return self;
}

- (void)importExten:(NSPersistentContainer *)container {
  NSArray<NSPersistentStore *> *stores = container.persistentStoreCoordinator.persistentStores;
  NSURL *storeUrl;
  for (NSPersistentStore *store in stores) {
    if ([NSSQLiteStoreType isEqualToString:store.type]) {
      storeUrl = store.URL;
      break;
    }
  }
  
  if (!storeUrl) {
    NSLog(@"warning, no sqlite store found, pls retry");
    return;
  }
  
  NSString *dbFile = [[NSBundle mainBundle] pathForResource:@"500" ofType:@"db" inDirectory:nil];
  NSLog(@"store url %@\nlocal db file %@", storeUrl, dbFile);
  
  // open database
  sqlite3 *db;
  int state = sqlite3_open_v2(dbFile.UTF8String, &db, SQLITE_OPEN_READWRITE, NULL);
  if (state != SQLITE_OK) {
    NSLog(@"can not open local db file");
    return;
  }
  
  char file_buf[256];
  int sz = sprintf(file_buf, "ATTACH DATABASE \"%s\" AS app", storeUrl.path.UTF8String);
  if (sz > 0) {
    char *buf;
    state = sqlite3_exec(db, file_buf, NULL, NULL, &buf);
    state = sqlite3_exec(db, "insert or ignore into app.zfort(zcorp_name,zcorp_industry_con,zcorp_industry,zcorp_net_income,zcorp_net_profit,zcorp_profit_margin,znation,zrank) select corp_name,corp_industry_con,corp_industry,corp_net_income,corp_net_profit,corp_profit_margin,nation,rank from main.fort", NULL, NULL, &buf);
    puts(buf);
  }
  
  sqlite3_close(db);
  NSLog(@"load external data done");
}

-(void)loadExtern {
  AppDelegate *dgt = (AppDelegate *)[[UIApplication sharedApplication] delegate];
  NSPersistentContainer *container = [dgt persistentContainer];
  
  NSUserDefaults *perf = [NSUserDefaults standardUserDefaults];
  if (![perf boolForKey:@"extern_import"]) {
    [self importExten:container];
    [perf setBool:YES forKey:@"extern_import"];
  }
}
@end
