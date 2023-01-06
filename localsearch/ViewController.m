//
//  ViewController.m
//  localsearch
//
//  Created by 黄伟 on 2023/1/2.
//

#import "ViewController.h"
#import "LSSearchManager.h"
#import "AppDelegate.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  AppDelegate *dgt = (AppDelegate *)[[UIApplication sharedApplication] delegate];
  NSPersistentContainer *container = [dgt persistentContainer];
  
  // Do any additional setup after loading the view.
  LSSearchManager *search = [LSSearchManager sharedSearchManager];
  [search doSearch:@"hello"];
}


@end
