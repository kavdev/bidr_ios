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
   
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    
    self.refreshControl = refreshControl;
    self.tableView.contentOffset = CGPointMake(0, -self.refreshControl.frame.size.height);
    [self.refreshControl beginRefreshing];
}

- (void) refresh {
    NSString *exten = [[NSString alloc] initWithFormat:@"auctions/%@/get-auction-bidables/", [self->auction getAuctionID]];
    
    [HTTPRequest GET:@"" toExtension:exten withAuthToken:((NavigationController*)self.navigationController).auth_token delegate:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(id) initWithAuction:(OngoingAuction *)auction navigationController:(NavigationController *)controller {
    self->auction = auction;
    
    NSString *exten = [[NSString alloc] initWithFormat:@"auctions/%@/get-auction-bidables/", [self->auction getAuctionID]];

    [HTTPRequest GET:@"" toExtension:exten withAuthToken:controller.auth_token delegate:self];
    
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
      return self->auction->bidOnItems.count;
   } else {
      return self->auction->otherItems.count;
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
      item = [self->auction->bidOnItems objectAtIndex:indexPath.row];
   } else {
      item = [self->auction->otherItems objectAtIndex:indexPath.row];
   }
   
   cell.textLabel.text = item.getName;
   cell.detailTextLabel.text = [NSString stringWithFormat:@"%@%.2f", @"$ ", item.getHightestBid];
   cell.imageView.image = item.getPicture;
   
   return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   Item *item;
   if (indexPath.section == 0) {
      item = [self->auction->bidOnItems objectAtIndex:indexPath.row];
   } else {
      item = [self->auction->otherItems objectAtIndex:indexPath.row];
   }
   
   NSString * storyboardName = @"Main";
   UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
   OngoingAuctionItemViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"OngoingAuctionItemViewController"];
   vc = [vc initWithItem:item];
   [self.navigationController pushViewController:vc animated:YES];
}

// This method is used to receive the data which we get using post method.
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData*)data {
    
    NSLog(@"Received Data!");
    NSString* jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    NSLog(@"jsonString: %@", jsonString);

    if([jsonDict objectForKey:@"bidables"] != nil) {
        NSArray *bidables = [jsonDict objectForKey:@"bidables"];
        [self->auction->bidOnItems removeAllObjects];
        [self->auction->otherItems removeAllObjects];
        
        for (int count = 0; count < bidables.count; count++) {
            jsonDict = bidables[count];
            NSString *name;
            double highestBid = 0;
            NSString *imageURL;
            NSString *description;
            UIImage *picture;
            int itemID = -1;
            double minPrice = 0;
            
            if ([jsonDict objectForKey:@"name"] != nil) {
                name = [jsonDict objectForKey:@"name"];
            }
            if ([jsonDict objectForKey:@"highest_bid"] != nil && ![[jsonDict objectForKey:@"highest_bid"] isKindOfClass:[NSNull class]]) {
                NSDictionary *highestBidDict = [jsonDict objectForKey:@"highest_bid"];
                if ([highestBidDict objectForKey:@"amount"] != nil) {
                    highestBid = [(NSString *)[highestBidDict objectForKey:@"amount"] doubleValue];
                }
            }
            if ([jsonDict objectForKey:@"image_url"]) {
                imageURL = [jsonDict objectForKey:@"image_url"];
                //do this
                picture = nil;
            }
            if ([jsonDict objectForKey:@"description"] != nil) {
                description = [jsonDict objectForKey:@"description"];
            }
            if ([jsonDict objectForKey:@"id"] != nil) {
                itemID = [[NSString stringWithFormat:@"%@", [jsonDict objectForKey:@"id"]] intValue];
            }
            if ([jsonDict objectForKey:@"min_price"] != nil) {
                minPrice = [(NSNumber*)[jsonDict objectForKey:@"min_price"] doubleValue];
            }
            Item *ongoingItem = [[Item alloc] initWithName:name description:description highestBid:highestBid condition:nil picture:picture itemID:itemID minimumBid:minPrice];
            
            
            NSArray *bids;
            if ([jsonDict objectForKey:@"bids"] != nil) {
                bids = [jsonDict objectForKey:@"bids"];
            }
            
            BOOL bidOnItem = false;
            for (int count = 0; count < bids.count; count++) {
                NSDictionary *bidDict = bids[count];
                
                if ([bidDict objectForKey:@"user"] != nil) {
                    if ([(NSNumber *)[bidDict objectForKey:@"user"] intValue] == [((NavigationController*)self.navigationController).user_id intValue]) {
                        bidOnItem = true;
                        break;
                    }                
                }
            }
            if (bidOnItem) {
                if (self->auction->bidOnItems == nil) {
                    self->auction->bidOnItems = [NSMutableArray arrayWithObject:ongoingItem];
                } else {
                    [self->auction->bidOnItems addObject:ongoingItem];
                }
            } else {
                if (self->auction->otherItems == nil) {
                    self->auction->otherItems = [NSMutableArray arrayWithObject:ongoingItem];
                } else {
                    [self->auction->otherItems addObject:ongoingItem];
                }
            }
        }
    }
}

// This method receives the error report in case of connection is not made to server.
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"FAIL");
    NSLog([error description]);
    [self.refreshControl endRefreshing];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Uh Oh" message:@"Something went wrong. Please try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

// This method is used to process the data after connection has made successfully.
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"Finished Loading");
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
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
