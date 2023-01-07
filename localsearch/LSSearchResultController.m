//
//  LSSearchResultController.m
//  localsearch
//
//  Created by 黄伟 on 2023/1/7.
//

#import "LSSearchResultController.h"

@interface LSSearchResultController ()
@property (nonatomic, weak, nullable) UILabel *emptyLabel;
@end

@implementation LSSearchResultController

@synthesize result = result_;

-(void)setResult:(SearchResult)result {
  result_ = result;
//  [self displayEmptyList:!result || result.count == 0];
  [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
  self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
//  [self displayEmptyList:YES];
}

-(void)displayEmptyList:(BOOL)display {
  if (display) {
    if (!self.emptyLabel) {
      UILabel *label = [[UILabel alloc] init];
      label.translatesAutoresizingMaskIntoConstraints = NO;
      label.text = @"没有数据";
      self.tableView.backgroundView = label;
      [NSLayoutConstraint activateConstraints:@[
        [label.superview.centerYAnchor constraintEqualToAnchor:label.centerYAnchor],
        [label.superview.centerXAnchor constraintEqualToAnchor:label.centerXAnchor],
      ]];
    }
    self.emptyLabel.hidden = NO;
  } else {
    self.emptyLabel.hidden = YES;
  }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return result_ && result_.count > 0 ? result_.count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"corp" forIndexPath:indexPath];
    
    // Configure the cell...
  NSDictionary<NSString *, id> *corpData = result_[indexPath.item];
  UILabel *corpNameLbl = [cell viewWithTag:1];
  corpNameLbl.text = [corpData[@"corp_name"] stringByReplacingOccurrencesOfString:@" " withString:@""];
  
  UILabel *corpIndustryCon = [cell viewWithTag:2];
  corpIndustryCon.text = corpData[@"corp_industry_con"];
  
  UILabel *corpNetIncome = [cell viewWithTag:3];
  corpNetIncome.text = corpData[@"corp_net_income"];
  
  UILabel *corpRank = [cell viewWithTag:4];
  corpRank.text = [NSString stringWithFormat:@"#%@", corpData[@"corp_rank"]];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
