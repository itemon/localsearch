//
//  ViewController.m
//  localsearch
//
//  Created by 黄伟 on 2023/1/2.
//

#import "ViewController.h"
#import "LSSearchManager.h"
#import "AppDelegate.h"
#import "LSSearchResultController.h"

@interface ViewController ()<UISearchBarDelegate, UISearchResultsUpdating, UISearchControllerDelegate>
@property (nonnull, nonatomic) NSString *term;
@end

@implementation ViewController

- (IBAction)handleButtonSearch:(id)sender {
  LSSearchManager *search = [LSSearchManager sharedSearchManager];
  dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0), ^{
    [search doSearch:@"汽车"];
  });
}

- (void)viewDidLoad {
  [super viewDidLoad];
  AppDelegate *dgt = (AppDelegate *)[[UIApplication sharedApplication] delegate];
  NSPersistentContainer *container = [dgt persistentContainer];
  
  // Do any additional setup after loading the view.
  UIViewController *searchResult = [[self storyboard] instantiateViewControllerWithIdentifier:@"search_result"];
  UISearchController *searchController = [[UISearchController alloc] initWithSearchResultsController:searchResult];
  searchController.delegate = self;
  searchController.searchResultsUpdater = self;
  searchController.searchBar.placeholder = @"搜索财富500强";
//  searchController.hidesNavigationBarDuringPresentation = NO;

  self.navigationItem.searchController = searchController;
  self.navigationItem.hidesSearchBarWhenScrolling = NO;
  
//  self.navigationItem.title = @"";
  
  UISearchBar *searchBar = searchController.searchBar;
//  UIButton *cancelButton = [searchBar valueForKey:@"cancelButton"];
//  [cancelButton setTitle:@"hhh" forState:UIControlStateNormal];
  searchBar.delegate = self;
}

-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
  NSString *term = searchController.searchBar.text;
  term = [term stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
  
  self.term = term;
  [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(performSearch:) object:searchController];
  [self performSelector:@selector(performSearch:) withObject:searchController afterDelay:0.3];
}

-(void)performSearch:(UISearchController *)controller {
  LSSearchResultController *resultController = (LSSearchResultController *)controller.searchResultsController;
  if (self.term.length == 0) {
    resultController.result = nil;
    return;
  }
  
  LSSearchManager *searchMgr = [LSSearchManager sharedSearchManager];
  dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0), ^{
    SearchResult results = [searchMgr doSearch:self.term];
    dispatch_async(dispatch_get_main_queue(), ^{
      resultController.result = results;
    });
  });
}
@end
