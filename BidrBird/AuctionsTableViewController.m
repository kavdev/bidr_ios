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
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
   
   NSString* imageName = [[NSBundle mainBundle] pathForResource:@"iPhone" ofType:@"jpg"];
   NSString* imageName2 = [[NSBundle mainBundle] pathForResource:@"Toy" ofType:@"jpg"];
   NSString* imageName3 = [[NSBundle mainBundle] pathForResource:@"Chair" ofType:@"jpg"];
   NSString* blueHouseName = [[NSBundle mainBundle] pathForResource:@"BlueHouse" ofType:@"jpg"];
   NSString* redHouseName = [[NSBundle mainBundle] pathForResource:@"RedHouse" ofType:@"jpg"];
//   self->ongoingAuctions = [NSMutableArray arrayWithObject:[[OngoingAuction alloc] initWithBidOnItems:[NSArray arrayWithObjects:[[Item alloc] initWithName:@"iPhone" description:@"An iPhone" highestBid:0 condition:@"Used" picture:[[UIImage alloc] initWithContentsOfFile:imageName] itemID:1],[[Item alloc] initWithName:@"iPhone2" description:@"Another iPhone" highestBid:0 condition:@"Used" picture:[[UIImage alloc] initWithContentsOfFile:imageName] itemID:2] ,nil] otherItems:[NSArray arrayWithObjects:[[Item alloc] initWithName:@"Toy" description:@"A Toy" highestBid:0 condition:@"Used" picture:[[UIImage alloc] initWithContentsOfFile:imageName2] itemID:1],[[Item alloc] initWithName:@"Toy 2" description:@"Another Toy" highestBid:0 condition:@"Used" picture:[[UIImage alloc] initWithContentsOfFile:imageName2] itemID:2] ,nil] name:@"RedHouse" picture:[[UIImage alloc] initWithContentsOfFile:redHouseName]]];
//   self->completeAuctions = [NSMutableArray arrayWithObject:[[CompleteAuction alloc] initWithBoughtItems:[NSArray arrayWithObjects:[[Item alloc] initWithName:@"Sock" description:@"A Sock" highestBid:2 condition:@"Used" picture:[[UIImage alloc] initWithContentsOfFile:imageName3] itemID:1],[[Item alloc] initWithName:@"Sock2" description:@"Another Sock" highestBid:1.55 condition:@"Used" picture:[[UIImage alloc] initWithContentsOfFile:imageName3] itemID:2] ,nil] name:@"BlueHouse" picture:[[UIImage alloc] initWithContentsOfFile:blueHouseName]]];
    
    
//    NSString *extension = [NSString stringWithFormat:@"bidruser/%@/get-auctions-participating-in/", ((NavigationController *)self.parentViewController).user_id];
//    //NSString *get = [NSString stringWithFormat:@"email=%@", ((NavigationController *)self.parentViewController).user_email];
//    
//    [HTTPRequest GET:@"" toExtension:extension withAuthToken:((NavigationController *)self.parentViewController).auth_token delegate:self];
        
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(id) initWithOngoingAuctions:(NSMutableArray*)ongoing completeAuctions:(NSMutableArray*)complete {
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

// This method is used to receive the data which we get using post method.
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData*)data {    
    NSLog(@"Received Data!");
    NSString* jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    NSLog(@"jsonString: %@", jsonString);
    if ([jsonDict objectForKey:@"participants"] != nil) {
        NSArray *auctionsSignedUpFor = [jsonDict objectForKey:@"participants"];
        
        for (int count = 0; count < auctionsSignedUpFor.count; count++) {
            NSString *extension = [NSString stringWithFormat:@"auctions/%@/get=auction-data/", auctionsSignedUpFor[count]];
            [HTTPRequest GET:@"" toExtension:extension withAuthToken:((NavigationController *)self.parentViewController).auth_token delegate:self];
        }
    } else {
        NSString *name;
        NSString *auctionid;
        if ([jsonDict objectForKey:@"name"] != nil) {
            name = [jsonDict objectForKey:@"name"];
        }
        if ([jsonDict objectForKey:@"id"] != nil) {
            auctionid = [NSString stringWithFormat:@"%@", [jsonDict objectForKey:@"id"]];
        }
        if ([jsonDict objectForKey:@"stage"] != nil) {
            if ([((NSNumber *)[jsonDict objectForKey:@"stage"]) intValue] <= 1) {
                if (self->ongoingAuctions == nil) {
                    self->ongoingAuctions = [[NSMutableArray alloc] initWithObjects:[[OngoingAuction alloc] initWithName:name auctionID:auctionid picture:nil], nil];
                } else {
                    [self->ongoingAuctions addObject:[[OngoingAuction alloc] initWithName:name auctionID:auctionid picture:nil]];
                }
            } else {
                if (self->completeAuctions == nil) {
                    self->ongoingAuctions = [[NSMutableArray alloc] initWithObjects:[[CompleteAuction alloc] initWithName:name auctionID:auctionid picture:nil], nil];
                } else {
                    [self->completeAuctions addObject:[[CompleteAuction alloc] initWithName:name auctionID:auctionid picture:nil]];
                }
            }
            [self.tableView reloadData];
        }
    }
}

// This method receives the error report in case of connection is not made to server.
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"FAIL");
    NSLog([error description]);
}

// This method is used to process the data after connection has made successfully.
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"Finished Loading");
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    //dont do anything
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
