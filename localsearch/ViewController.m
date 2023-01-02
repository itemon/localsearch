//
//  ViewController.m
//  localsearch
//
//  Created by 黄伟 on 2023/1/2.
//

#import "ViewController.h"
#import "LSSearchManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  LSSearchManager *search = [[LSSearchManager alloc] init];
  [search doSearch:@"hello"];
}


@end
