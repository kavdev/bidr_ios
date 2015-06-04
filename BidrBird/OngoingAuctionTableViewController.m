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
    NSString *exten = [[NSString alloc] initWithFormat:@"auctions/%@/items/", [self->auction getAuctionID]];
    
    [HTTPRequest GET:@"" toExtension:exten withAuthToken:userSessionInfo.auth_token delegate:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(id) initWithAuction:(OngoingAuction *)auction userSessionInfo:(UserSessionInfo *)info {
    self->auction = auction;
    self->userSessionInfo = info;
    
    NSString *exten = [[NSString alloc] initWithFormat:@"auctions/%@/items/", [self->auction getAuctionID]];

    [HTTPRequest GET:@"" toExtension:exten withAuthToken:info.auth_token delegate:self];
        
    return self;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return NUM_SECTIONS;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
   if (section == WINNING_SECTION) {
      return self->auction->winningItems.count;
   } else if (section == LOSING_SECTION) {
      return self->auction->losingItems.count;
   } else {
       return self->auction->unbidItems.count;
   }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
   if (section == WINNING_SECTION) {
      return @"Winning";
   } else if (section == LOSING_SECTION) {
      return @"Losing";
   } else {
       return @"Unbid";
   }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   static NSString *simpleTableIdentifier = @"Cell";
   
   UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
   Item *item;
   
   if (cell == nil) {
      cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
   }
   
   if (indexPath.section == WINNING_SECTION) {
       NSArray *keys = [self->auction->winningItems allKeys];
       item = [self->auction->winningItems objectForKey:[keys objectAtIndex:indexPath.row]];
   } else  if (indexPath.section == LOSING_SECTION) {
       NSArray *keys = [self->auction->losingItems allKeys];
       item = [self->auction->losingItems objectForKey:[keys objectAtIndex:indexPath.row]];
   } else {
       NSArray *keys = [self->auction->unbidItems allKeys];
       item = [self->auction->unbidItems objectForKey:[keys objectAtIndex:indexPath.row]];
   }
   
   cell.textLabel.text = item.getName;
   cell.detailTextLabel.text = [NSString stringWithFormat:@"%@%d", @"$ ", item.getHightestBid->amount];
   cell.imageView.image = item.getPicture;
   
   return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   Item *item;
   if (indexPath.section == WINNING_SECTION) {
       NSArray *keys = [self->auction->winningItems allKeys];
       item = [self->auction->winningItems objectForKey:[keys objectAtIndex:indexPath.row]];
   } else if (indexPath.section == LOSING_SECTION) {
       NSArray *keys = [self->auction->losingItems allKeys];
       item = [self->auction->losingItems objectForKey:[keys objectAtIndex:indexPath.row]];
   } else {
       NSArray *keys = [self->auction->unbidItems allKeys];
       item = [self->auction->unbidItems objectForKey:[keys objectAtIndex:indexPath.row]];
   }
   
   NSString * storyboardName = @"Main";
   UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
   OngoingAuctionItemViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"OngoingAuctionItemViewController"];
    vc.delegate = self;
   vc = [vc initWithItem:item fromAuctionWithID:auction->auctionID userSessionInfo:self->userSessionInfo minBidInc:self->auction->minBidInc];
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
    
    if ([jsonDict objectForKey:@"stage"] != nil) {
        int stage = [(NSNumber *)[jsonDict objectForKey:@"stage"] intValue];
        
        if (stage == 1) {
    
            if([jsonDict objectForKey:@"bidables"] != nil) {
                NSArray *bidables = [jsonDict objectForKey:@"bidables"];
                [self->auction->winningItems removeAllObjects];
                [self->auction->losingItems removeAllObjects];
                [self->auction->unbidItems removeAllObjects];
                
                for (int count = 0; count < bidables.count; count++) {
                    jsonDict = bidables[count];
                    NSString *name;
                    int highestBid = 0;
                    int highestBidUserID = -1;
                    NSString *highestBidDisplayName;
                    NSString *imageURL;
                    NSString *description;
                    UIImage *picture;
                    int itemID = -1;
                    int minPrice = 0;
                    
                    if ([jsonDict objectForKey:@"name"] != nil) {
                        name = [jsonDict objectForKey:@"name"];
                    }
                    if ([jsonDict objectForKey:@"highest_bid"] != nil && ![[jsonDict objectForKey:@"highest_bid"] isKindOfClass:[NSNull class]]) {
                        NSDictionary *highestBidDict = [jsonDict objectForKey:@"highest_bid"];
                        if ([highestBidDict objectForKey:@"amount"] != nil) {
                            highestBid = [(NSString *)[highestBidDict objectForKey:@"amount"] intValue];
                        }
                        if ([highestBidDict objectForKey:@"user"] != nil) {
                            highestBidUserID = [(NSNumber *)[highestBidDict objectForKey:@"user"] intValue];
                        }
                        if ([highestBidDict objectForKey:@"user_display_name"] != nil) {
                            highestBidDisplayName = [highestBidDict objectForKey:@"user_display_name"];
                        }
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
                    if ([jsonDict objectForKey:@"total_starting_bid"] != nil) {
                        minPrice = [(NSNumber*)[jsonDict objectForKey:@"total_starting_bid"] intValue];
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
                    
                    Item *ongoingItem = [[Item alloc] initWithName:name description:description highestBid:[[Bid alloc] initWithAmount:highestBid userID:highestBidUserID displayName:highestBidDisplayName] condition:nil picture:picture itemID:itemID minimumBid:minPrice usersHighestBid:usersHighestBid];
                    
                    
                    NSArray *bidders;
                    if ([jsonDict objectForKey:@"bidders"] != nil) {
                        bidders = [jsonDict objectForKey:@"bidders"];
                    }
                    
                    BOOL bidOnItem = false;
                    for (int count = 0; count < bidders.count; count++) {
                        NSDictionary *singleUserDict = bidders[count];
                        
                        if ([singleUserDict objectForKey:@"id"] != nil) {
                            if ([(NSNumber *)[singleUserDict objectForKey:@"id"] intValue] == [userSessionInfo.user_id intValue]) {
                                bidOnItem = true;
                                break;
                            }                
                        }
                    }
                    if (highestBidUserID == [userSessionInfo.user_id intValue]) {
                        if (self->auction->winningItems == nil) {
                            self->auction->winningItems = [NSMutableDictionary dictionaryWithObject:ongoingItem forKey:[@(itemID) stringValue]];
                        } else {
                            [self->auction->winningItems setObject:ongoingItem forKey:[@(itemID) stringValue]];
                        }
                    } else if (bidOnItem) {
                        if (self->auction->losingItems == nil) {
                            self->auction->losingItems = [NSMutableDictionary dictionaryWithObject:ongoingItem forKey:[@(itemID) stringValue]];
                        } else {
                            [self->auction->losingItems setObject:ongoingItem forKey:[@(itemID) stringValue]];
                        }
                    } else {
                        if (self->auction->unbidItems == nil) {
                            self->auction->unbidItems = [NSMutableDictionary dictionaryWithObject:ongoingItem forKey:[@(itemID) stringValue]];
                        } else {
                            [self->auction->unbidItems setObject:ongoingItem forKey:[@(itemID) stringValue]];
                        }
                    }
                }
            }
            
            [self.delegate replaceOngoingAuctionWithID:self->auction->auctionID withAuction:self->auction];
            [self.tableView reloadData];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Auction Over" message:@"This auction has ended. You can now find it on the Complete Auctions page." delegate:self cancelButtonTitle:@"Go Back" otherButtonTitles:nil];
            [alert show];
        }
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Uh Oh" message:@"Something went wrong. Please try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    [responseData setData:nil];
    [self.refreshControl endRefreshing];
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if ([title isEqualToString:@"Go Back"]) {
        [self.delegate auctionWithIDEnded:self->auction->auctionID];
        [self.navigationController popToRootViewControllerAnimated:TRUE];
    }
}

- (void) replaceOngoingItemWithID:(NSString *)itemID forAuctionWithID:(NSString *)auctionID withItem:(Item *)item {
    [self.delegate replaceOngoingItemWithID:itemID forAuctionWithID:auctionID withItem:item];
    self->auction = [self.delegate getOngoingAuctionWithID:auctionID];
    if (self->auction) {
        [self.tableView reloadData];
    } else {
        [self.navigationController popViewControllerAnimated:TRUE];
    }
}

- (void) auctionWithIDEnded:(NSString *)auctionID {
    [self.delegate auctionWithIDEnded:auctionID];
}

- (void) replaceUsersHighestBidForItemWithID:(NSString *)itemID forAuctionWithID:(NSString *)auctionID withBid:(Bid *)bid {
    [self.delegate replaceUsersHighestBidForItemWithID:(NSString *)itemID forAuctionWithID:(NSString *)auctionID withBid:(Bid *)bid];
}

- (void) replaceMinBidIncrementForOngoingAuctionWithID:(NSString *)auctionID withMinBidInc:(int)minBidInc {
    [self.delegate replaceMinBidIncrementForOngoingAuctionWithID:auctionID withMinBidInc:minBidInc];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self->auction && self->auction->auctionID > 0) {
        self->auction = [self.delegate getOngoingAuctionWithID:self->auction->auctionID];
        [self.tableView reloadData];
    }
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
//    if ([self isMovingFromParentViewController]) {
//        [self.delegate removeImagesFromAuctionWithID:self->auction->auctionID];
//    }
}


//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    
//    if (self.isMovingToParentViewController == false)
//    {
//        // we're already on the navigation stack
//        // another controller must have been popped off
//        [self.refreshControl beginRefreshing];
//        [self refresh];
//    }
//}

//- (void)viewDidAppear:(BOOL)animated {
//    [self.refreshControl beginRefreshing];
//    [self refresh];
//}

@end
