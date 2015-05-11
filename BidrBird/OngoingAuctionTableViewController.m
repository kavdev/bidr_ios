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
      return self->auction->bidOnItems.count;
   } else if (section == LOSING_SECTION) {
      return self->auction->otherItems.count;
   } else if (section == UNBID) {
       
   }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
   if(section == BID_ON_ITEMS_SECTION) {
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
   
   if (indexPath.section == BID_ON_ITEMS_SECTION) {
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
   if (indexPath.section == BID_ON_ITEMS_SECTION) {
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
            if ([jsonDict objectForKey:@"image_urls"]) {
                NSArray *urls = [jsonDict objectForKey:@"image_urls"];
                imageURL = urls[0];
                
                picture = [HTTPRequest getImageFromFileExtension:imageURL];
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
                    if ([(NSNumber *)[bidDict objectForKey:@"user"] intValue] == [userSessionInfo.user_id intValue]) {
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
    
    [responseData setData:nil];
    
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    //dont do anything
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
