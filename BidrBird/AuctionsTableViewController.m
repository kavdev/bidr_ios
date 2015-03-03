//
//  AuctionsTableViewController.m
//  BidrBird
//
//  Created by Zachary Glazer on 12/3/14.
//  Copyright (c) 2014 Zachary Glazer. All rights reserved.
//

#import "AuctionsTableViewController.h"

@interface AuctionsTableViewController ()

@end

@implementation AuctionsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
   NSString* imageName = [[NSBundle mainBundle] pathForResource:@"iPhone" ofType:@"jpg"];
   NSString* imageName2 = [[NSBundle mainBundle] pathForResource:@"Toy" ofType:@"jpg"];
   NSString* imageName3 = [[NSBundle mainBundle] pathForResource:@"Chair" ofType:@"jpg"];
   NSString* blueHouseName = [[NSBundle mainBundle] pathForResource:@"BlueHouse" ofType:@"jpg"];
   NSString* redHouseName = [[NSBundle mainBundle] pathForResource:@"RedHouse" ofType:@"jpg"];
   self->ongoingAuctions = [NSArray arrayWithObject:[[OngoingAuction alloc] initWithBidOnItems:[NSArray arrayWithObjects:[[Item alloc] initWithName:@"iPhone" description:@"An iPhone" highestBid:0 condition:@"Used" picture:[[UIImage alloc] initWithContentsOfFile:imageName] itemID:1],[[Item alloc] initWithName:@"iPhone2" description:@"Another iPhone" highestBid:0 condition:@"Used" picture:[[UIImage alloc] initWithContentsOfFile:imageName] itemID:2] ,nil] otherItems:[NSArray arrayWithObjects:[[Item alloc] initWithName:@"Toy" description:@"A Toy" highestBid:0 condition:@"Used" picture:[[UIImage alloc] initWithContentsOfFile:imageName2] itemID:1],[[Item alloc] initWithName:@"Toy 2" description:@"Another Toy" highestBid:0 condition:@"Used" picture:[[UIImage alloc] initWithContentsOfFile:imageName2] itemID:2] ,nil] name:@"RedHouse" picture:[[UIImage alloc] initWithContentsOfFile:redHouseName]]];
   self->completeAuctions = [NSArray arrayWithObject:[[CompleteAuction alloc] initWithBoughItems:[NSArray arrayWithObjects:[[Item alloc] initWithName:@"Sock" description:@"A Sock" highestBid:2 condition:@"Used" picture:[[UIImage alloc] initWithContentsOfFile:imageName3] itemID:1],[[Item alloc] initWithName:@"Sock2" description:@"Another Sock" highestBid:1.55 condition:@"Used" picture:[[UIImage alloc] initWithContentsOfFile:imageName3] itemID:2] ,nil] name:@"BlueHouse" picture:[[UIImage alloc] initWithContentsOfFile:blueHouseName]]];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(id) initWithOngoingAuctions:(NSArray*)ongoing completeAuctions:(NSArray*)complete {
   self->completeAuctions = complete;
   self->ongoingAuctions = ongoing;
   
   return self;
}

- (IBAction)signOut:(id)sender {
   [self dismissViewControllerAnimated:TRUE completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
   if (section == 0) {
      return self->ongoingAuctions.count;
   } else {
      return self->completeAuctions.count;
   }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
   if(section == 0) {
      return @"Current Auctions";
   } else {
      return @"Complete Auctions";
   }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   static NSString *simpleTableIdentifier = @"Cell";
   
   UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
   CompleteAuction *auction;
   
   if (cell == nil) {
      cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
   }
   
   if (indexPath.section == 0) {
      auction = ((CompleteAuction *)[self->ongoingAuctions objectAtIndex:indexPath.row]);
   } else {
      auction = ((CompleteAuction *)[self->completeAuctions objectAtIndex:indexPath.row]);
   }
   
   cell.textLabel.text = auction.getName;
   cell.imageView.image = auction.getPicture;
   
   return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   CompleteAuction *completeAuction;
   OngoingAuction *ongoingAuction;
   UIViewController * vc;
   
   if (indexPath.section == 0) {
      ongoingAuction = [self->ongoingAuctions objectAtIndex:indexPath.row];
   } else {
      completeAuction = [self->completeAuctions objectAtIndex:indexPath.row];
   }
   
   NSString * storyboardName = @"Main";
   UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
   if (indexPath.section == 0) {
      vc = [storyboard instantiateViewControllerWithIdentifier:@"OngoingAuctionTableViewController"];
      vc = [(OngoingAuctionTableViewController*)vc initWithBidOnItems:ongoingAuction.getBidOnItems otherItems:ongoingAuction.getOtherItems];
   } else {
      vc = [storyboard instantiateViewControllerWithIdentifier:@"CompleteAuctionTableViewController"];
      vc = [(CompleteAuctionTableViewController*)vc initWithBoughtItems:completeAuction.getBoughtItems];
   }
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
