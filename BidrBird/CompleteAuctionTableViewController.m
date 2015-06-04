//
//  CompleteAuctionTableViewController.m
//  BidrBird
//
//  Created by Zachary Glazer on 12/3/14.
//  Copyright (c) 2014 Zachary Glazer. All rights reserved.
//

#import "CompleteAuctionTableViewController.h"

@interface CompleteAuctionTableViewController ()

@end

@implementation CompleteAuctionTableViewController

- (void)viewDidLoad {
   [super viewDidLoad];

    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    
    self.refreshControl = refreshControl;
    self.tableView.contentOffset = CGPointMake(0, -self.refreshControl.frame.size.height);
    [self.refreshControl beginRefreshing];
}

- (void) refresh {
    NSString *exten = [[NSString alloc] initWithFormat:@"auctions/%@/items/", [self->auction getAuctionID]];
    
    [HTTPRequest GET:@"" toExtension:exten withAuthToken:userSessionInfo.auth_token delegate:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(id) initWithAuction:(CompleteAuction *)auction userSessionInfo:(UserSessionInfo *)info {
    self->auction = auction;
    self->userSessionInfo = info;
    
    NSString *exten = [[NSString alloc] initWithFormat:@"auctions/%@/items/", [self->auction getAuctionID]];
    
    [HTTPRequest GET:@"" toExtension:exten withAuthToken:info.auth_token delegate:self];
    
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
        return [self->auction->wonItems count];
    } else {
        return [self->auction->lostItems count];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Won";
    } else {
        return @"Lost";
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
        NSArray *keys = [self->auction->wonItems allKeys];
        item = [self->auction->wonItems objectForKey:[keys objectAtIndex:indexPath.row]];
    } else {
        NSArray *keys = [self->auction->lostItems allKeys];
        item = [self->auction->lostItems objectForKey:[keys objectAtIndex:indexPath.row]];
    }
   
    cell.textLabel.text = item.getName;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@%d", @"$ ", item.getHightestBid->amount];
    cell.imageView.image = item.getPicture;
   
   
   return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Item *item;
    if (indexPath.section == 0) {
        NSArray *keys = [self->auction->wonItems allKeys];
        item = [self->auction->wonItems objectForKey:[keys objectAtIndex:indexPath.row]];
    } else {
        NSArray *keys = [self->auction->lostItems allKeys];
        item = [self->auction->lostItems objectForKey:[keys objectAtIndex:indexPath.row]];
    }
    
    NSString * storyboardName = @"Main";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
    CompleteAuctionItemViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"CompleteAuctionItemViewController"];
    vc = [vc initWithItem:item fromAuctionWithID:self->auction->auctionID userSessionInfo:self->userSessionInfo];
    [self.navigationController pushViewController:vc animated:YES];

}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    responseData = [[NSMutableData alloc] init];
}

// This method is used to receive the data which we get using post method.
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData*)data {
    NSLog(@"Received Data!");
    [responseData appendData:data];
}

// This method receives the error report in case of connection is not made to server.
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"FAIL");
    NSLog([error description]);
    
    if (responseData != nil) {
        [responseData setData:nil];
    }
    
    [self.refreshControl endRefreshing];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Uh Oh" message:@"Something went wrong. Please try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

// This method is used to process the data after connection has made successfully.
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"Finished Loading");
    
    NSString* jsonString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:nil];
    NSLog(@"jsonString: %@", jsonString);
    
    if([jsonDict objectForKey:@"bidables"] != nil) {
        NSArray *bidables = [jsonDict objectForKey:@"bidables"];
        [self->auction->wonItems removeAllObjects];
        [self->auction->lostItems removeAllObjects];
        
        for (int count = 0; count < bidables.count; count++) {
            jsonDict = bidables[count];
            NSString *name;
            NSString *imageURL;
            NSString *description;
            UIImage *picture;
            int itemID = -1;
            int minPrice = 0;
            Bid *highestBid;
            
            if ([jsonDict objectForKey:@"name"] != nil) {
                name = [jsonDict objectForKey:@"name"];
            }
            if ([jsonDict objectForKey:@"highest_bid"] != nil && ![[jsonDict objectForKey:@"highest_bid"] isKindOfClass:[NSNull class]]) {
                NSDictionary *highestBidDict = [jsonDict objectForKey:@"highest_bid"];
                NSString *displayName;
                int amount;
                int userID;
                if ([highestBidDict objectForKey:@"amount"] != nil) {
                    amount = [(NSString *)[highestBidDict objectForKey:@"amount"] doubleValue];
                }
                if ([highestBidDict objectForKey:@"user"] != nil) {
                    userID = [(NSNumber *)[highestBidDict objectForKey:@"user"] intValue];
                }
                if ([highestBidDict objectForKey:@"user_display_name"] != nil) {
                    displayName = [highestBidDict objectForKey:@"user_display_name"];
                }
                highestBid = [[Bid alloc] initWithAmount:amount userID:userID displayName:displayName];
            }
            if ([jsonDict objectForKey:@"image_urls"]) {
                NSArray *urls = [jsonDict objectForKey:@"image_urls"];
                imageURL = urls[0];
                
                picture = [HTTPRequest getImageFromFileExtension:imageURL];
                int newWidth, newHeight;
                if (picture.size.width > picture.size.height) {
                    newWidth = 200;
                    newHeight = 200 / picture.size.width * picture.size.height;
                } else {
                    newHeight = 200;
                    newWidth = 200 / picture.size.height * picture.size.width;
                }
                picture = [picture resizedImageWithSize:CGSizeMake(newWidth, newHeight)];
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
            
            Bid *usersHighestBid;
            
            if ([jsonDict objectForKey:@"highest_bid_for_each_bidder"]) {
                NSArray *highestBidsForEachBidder = [jsonDict objectForKey:@"highest_bid_for_each_bidder"];
                for (int count = 0; count < highestBidsForEachBidder.count; count++) {
                    NSDictionary *bidDict = highestBidsForEachBidder[count];
                    if ([bidDict objectForKey:@"user"]) {
                        NSNumber *bidUserID = [bidDict objectForKey:@"user"];
                        if ([[bidUserID stringValue] isEqualToString:self->userSessionInfo.user_id]) {
                            int amount = [(NSString *)[bidDict objectForKey:@"amount"] intValue];
                            usersHighestBid = [[Bid alloc] initWithAmount:amount userID:[bidUserID intValue] displayName:[bidDict objectForKey:@"user_display_name"]];
                            
                            break;
                        }
                    }
                }
            }
            
            Item *completedItem;
            if (highestBid != nil) {
                completedItem = [[Item alloc] initWithName:name description:description highestBid:highestBid condition:nil picture:picture itemID:itemID minimumBid:minPrice usersHighestBid:usersHighestBid];
            } else {
                completedItem = [[Item alloc] initWithName:name description:description highestBid:nil condition:nil picture:picture itemID:itemID minimumBid:minPrice usersHighestBid:usersHighestBid];
            }
            
            
            
            NSArray *bids;
            if ([jsonDict objectForKey:@"bidders"] != nil) {
                bids = [jsonDict objectForKey:@"bidders"];
            }
            
            BOOL bidOnItem = false;
            BOOL wonItem = false;
            for (int count = 0; count < bids.count; count++) {
                NSDictionary *bidDict = bids[count];
                
                if ([bidDict objectForKey:@"id"] != nil) {
                    if ([(NSNumber *)[bidDict objectForKey:@"id"] intValue] == [userSessionInfo.user_id intValue]) {
                        bidOnItem = true;
                        break;
                    }                
                }
            }

            if ([jsonDict objectForKey:@"claimed"] != nil && [jsonDict objectForKey:@"claimed"]) {
                
                
            } else if (highestBid != nil && highestBid->userID == [userSessionInfo.user_id intValue]) {
                wonItem = true;
            }
            
            if (bidOnItem && wonItem) {
                if (self->auction->wonItems == nil) {
                    self->auction->wonItems = [NSMutableDictionary dictionaryWithObject:completedItem forKey:[@(itemID) stringValue]];
                } else {
                    [self->auction->wonItems setObject:completedItem forKey:[@(itemID) stringValue]];
                }
            } else if (bidOnItem) {
                if (self->auction->lostItems == nil) {
                    self->auction->lostItems = [NSMutableDictionary dictionaryWithObject:completedItem forKey:[@(itemID) stringValue]];
                } else {
                    [self->auction->lostItems setObject:completedItem forKey:[@(itemID) stringValue]];
                }
            }
        }
    }
    
    [responseData setData:nil];
    
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
