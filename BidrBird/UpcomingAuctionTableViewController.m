//
//  UpcomingAuctionTableViewController.m
//  BidrBird
//
//  Created by Zachary Glazer on 3/7/15.
//  Copyright (c) 2015 Zachary Glazer. All rights reserved.
//

#import "UpcomingAuctionTableViewController.h"

@interface UpcomingAuctionTableViewController ()

@end

@implementation UpcomingAuctionTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    
    self.refreshControl = refreshControl;
    self.tableView.contentOffset = CGPointMake(0, -self.refreshControl.frame.size.height);
    [self.refreshControl beginRefreshing];
}

- (void)refresh {
    NSString *exten = [[NSString alloc] initWithFormat:@"auctions/%@/items/", [self->auction getAuctionID]];
    
    [HTTPRequest GET:@"" toExtension:exten withAuthToken:userSessionInfo.auth_token delegate:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(id) initWithAuction:(UpcomingAuction *)auction userSessionInfo:(UserSessionInfo *)info; {
    self->auction = auction;
    self->userSessionInfo = info;
    
    NSString *exten = [[NSString alloc] initWithFormat:@"auctions/%@/items/", [self->auction getAuctionID]];
    
    [HTTPRequest GET:@"" toExtension:exten withAuthToken:info.auth_token delegate:self];
    
    return self;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self->auction->items.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Items";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    Item *item;
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
    }
    
    NSArray *keys = [self->auction->items allKeys];
    
    item = [self->auction->items objectForKey:[keys objectAtIndex:indexPath.row]];
    
    cell.textLabel.text = item.getName;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@%d", @"$ ", item->minBid];
    cell.imageView.image = item.getPicture;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Item *item;
    
    NSArray *keys = [self->auction->items allKeys];
    
    item = [self->auction->items objectForKey:[keys objectAtIndex:indexPath.row]];
    
    NSString * storyboardName = @"Main";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
    UpcomingAuctionItemViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"UpcomingAuctionItemViewController"];
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
    
    if ([jsonDict objectForKey:@"stage"] != nil) {
        int stage = [(NSNumber *)[jsonDict objectForKey:@"stage"] intValue];
        
        if (stage == 0) {
    
            if([jsonDict objectForKey:@"bidables"] != nil) {
                NSArray *bidables = [jsonDict objectForKey:@"bidables"];
                [self->auction->items removeAllObjects];
                
                for (int count = 0; count < bidables.count; count++) {
                    jsonDict = bidables[count];
                    NSString *name;
                    int highestBid = 0;
                    int highestBidUserID = -1;
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
                        minPrice = [(NSNumber*)[jsonDict objectForKey:@"min_price"] intValue];
                    }
                    Item *upcomingItem = [[Item alloc] initWithName:name description:description highestBid:nil condition:nil picture:picture itemID:itemID minimumBid:minPrice usersHighestBid:nil];
                    
                    if (self->auction->items == nil) {
                        //self->auction->items = [NSMutableArray arrayWithObject:upcomingItem];
                        self->auction->items = [NSMutableDictionary dictionaryWithObject:upcomingItem forKey:[@(itemID) stringValue]];
                    } else {
                        //[self->auction->items addObject:upcomingItem];
                        [self->auction->items setObject:upcomingItem forKey:[@(itemID) stringValue]];
                    }
                }
            }
        } else {
            if (stage == 1){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Auction Started" message:@"This auction has already started! You can now find it on the Ongoing Auctions page." delegate:self cancelButtonTitle:@"Go Back" otherButtonTitles:nil];
                [alert show];
                [self.delegate aucitonBeganWithID:self->auction->auctionID];
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Auction Over" message:@"This auction has ended. You can now find it on the Complete Auctions page." delegate:self cancelButtonTitle:@"Go Back" otherButtonTitles:nil];
                [alert show];
                [self.delegate auctionEndedWithID:self->auction->auctionID];
            }
        }
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Uh Oh" message:@"Something went wrong. Please try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    
    [responseData setData:nil];
    
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if ([title isEqualToString:@"Go Back"]) {
        [self.navigationController popToRootViewControllerAnimated:TRUE];
    }
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
