//
//  OngoingAuctionTableViewController.m
//  BidrBird
//
//  Created by Zachary Glazer on 12/3/14.
//  Copyright (c) 2014 Zachary Glazer. All rights reserved.
//

#import "OngoingAuctionTableViewController.h"

@interface OngoingAuctionTableViewController ()

@end

@implementation OngoingAuctionTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(id) initWithBidOnItems:(NSArray*)bidOnItems otherItems:(NSArray*)otherItems {
   self->bidOnItemList = bidOnItems;
   self->otherItemList = otherItems;
   
   return self;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
   if (section == 0) {
      return self->bidOnItemList.count;
   } else {
      return self->otherItemList.count;
   }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
   if(section == 0) {
      return @"My Bids";
   } else {
      return @"Other Items";
   }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   static NSString *simpleTableIdentifier = @"Cell";
   
   UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
   Item *item;
   
   if (cell == nil) {
      cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
   }
   
   if (indexPath.section == 0) {
      item = ((Item *)[self->bidOnItemList objectAtIndex:indexPath.row]);
   } else {
      item = ((Item *)[self->otherItemList objectAtIndex:indexPath.row]);
   }
   
   cell.textLabel.text = item.getName;
   cell.detailTextLabel.text = [NSString stringWithFormat:@"%@%.2f", @"$ ", item.getHightestBid];
   cell.imageView.image = item.getPicture;
   
   return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   Item *item;
   if (indexPath.section == 0) {
      item = [self->bidOnItemList objectAtIndex:indexPath.row];
   } else {
      item = [self->otherItemList objectAtIndex:indexPath.row];
   }
   
   NSString * storyboardName = @"Main";
   UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
   UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"OngoingAuctionItemViewController"];
   vc = [(OngoingAuctionItemViewController*)vc initWithItem:item];
   [self.navigationController pushViewController:vc animated:YES];
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
