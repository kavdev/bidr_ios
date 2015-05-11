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
        item = [self->auction->wonItems objectAtIndex:indexPath.row];
    } else {
        item = [self->auction->lostItems objectAtIndex:indexPath.row];
    }
   
    cell.textLabel.text = item.getName;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@%.2f", @"$ ", item.getHightestBid];
    cell.imageView.image = item.getPicture;
   
   
   return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Item *item;
    if (indexPath.section == 0) {
        item = [self->auction->wonItems objectAtIndex:indexPath.row];
    } else {
        item = [self->auction->lostItems objectAtIndex:indexPath.row];
    }
    
    NSString * storyboardName = @"Main";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
    CompleteAuctionItemViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"CompleteAuctionItemViewController"];
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
        [self->auction->wonItems removeAllObjects];
        [self->auction->lostItems removeAllObjects];
        
        for (int count = 0; count < bidables.count; count++) {
            jsonDict = bidables[count];
            NSString *name;
            NSString *imageURL;
            NSString *description;
            UIImage *picture;
            int itemID = -1;
            double minPrice = 0;
            Bid *highestBid;
            
            if ([jsonDict objectForKey:@"name"] != nil) {
                name = [jsonDict objectForKey:@"name"];
            }
            if ([jsonDict objectForKey:@"highest_bid"] != nil && ![[jsonDict objectForKey:@"highest_bid"] isKindOfClass:[NSNull class]]) {
                NSDictionary *highestBidDict = [jsonDict objectForKey:@"highest_bid"];
                double amount;
                int userID;
                if ([highestBidDict objectForKey:@"amount"] != nil) {
                    amount = [(NSString *)[highestBidDict objectForKey:@"amount"] doubleValue];
                }
                if ([highestBidDict objectForKey:@"user"] != nil) {
                    userID = [(NSNumber *)[highestBidDict objectForKey:@"user"] intValue];
                }
                highestBid = [[Bid alloc] initWithAmount:amount userID:userID];
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
            Item *completedItem;
            if (highestBid != nil) {
                completedItem = [[Item alloc] initWithName:name description:description highestBid:highestBid->amount condition:nil picture:picture itemID:itemID minimumBid:minPrice];
            } else {
                completedItem = [[Item alloc] initWithName:name description:description highestBid:0 condition:nil picture:picture itemID:itemID minimumBid:minPrice];
            }
            
            
            
            NSArray *bids;
            if ([jsonDict objectForKey:@"bids"] != nil) {
                bids = [jsonDict objectForKey:@"bids"];
            }
            
            BOOL bidOnItem = false;
            BOOL wonItem = false;
            for (int count = 0; count < bids.count; count++) {
                NSDictionary *bidDict = bids[count];
                
                if ([bidDict objectForKey:@"user"] != nil) {
                    if ([(NSNumber *)[bidDict objectForKey:@"user"] intValue] == [userSessionInfo.user_id intValue]) {
                        bidOnItem = true;
                        break;
                    }                
                }
            }
            if (highestBid != nil && highestBid->userID == [userSessionInfo.user_id intValue]) {
                wonItem = true;
            }
            
            if (bidOnItem && wonItem) {
                if (self->auction->wonItems == nil) {
                    self->auction->wonItems = [NSMutableArray arrayWithObject:completedItem];
                } else {
                    [self->auction->wonItems addObject:completedItem];
                }
            } else if (bidOnItem) {
                if (self->auction->lostItems == nil) {
                    self->auction->lostItems = [NSMutableArray arrayWithObject:completedItem];
                } else {
                    [self->auction->lostItems addObject:completedItem];
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
