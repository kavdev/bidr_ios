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
    
    [HTTPRequest GET:@"" toExtension:exten withAuthToken:((NavigationController*)self.navigationController).auth_token delegate:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(id) initWithAuction:(UpcomingAuction *)auction navigationController:(NavigationController *)controller {
    self->auction = auction;
    
    NSString *exten = [[NSString alloc] initWithFormat:@"auctions/%@/items/", [self->auction getAuctionID]];
    
    [HTTPRequest GET:@"" toExtension:exten withAuthToken:controller.auth_token delegate:self];
    
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
    
    if (indexPath.section == 0) {
        item = [self->auction->items objectAtIndex:indexPath.row];
    }
    
    cell.textLabel.text = item.getName;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@%.2f", @"$ ", item->minBid];
    cell.imageView.image = item.getPicture;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Item *item;
    if (indexPath.section == 0) {
        item = [self->auction->items objectAtIndex:indexPath.row];
    }
    
    NSString * storyboardName = @"Main";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
    UpcomingAuctionItemViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"UpcomingAuctionItemViewController"];
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
        [self->auction->items removeAllObjects];
        
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
            Item *upcomingItem = [[Item alloc] initWithName:name description:description highestBid:highestBid condition:nil picture:picture itemID:itemID minimumBid:minPrice];
            
            if (self->auction->items == nil) {
                self->auction->items = [NSMutableArray arrayWithObject:upcomingItem];
            } else {
                [self->auction->items addObject:upcomingItem];
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
