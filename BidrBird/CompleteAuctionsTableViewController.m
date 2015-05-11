//
//  CompleteAuctionsTableViewController.m
//  BidrBird
//
//  Created by Zachary Glazer on 4/20/15.
//  Copyright (c) 2015 Zachary Glazer. All rights reserved.
//

#import "CompleteAuctionsTableViewController.h"

@interface CompleteAuctionsTableViewController ()

@end

@implementation CompleteAuctionsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //    UINavigationController * cont = self.navigationController;
    //    UIViewController * cont2 = self.parentViewController;
    
    //[self.tableView setContentInset:UIEdgeInsetsMake(64,0,0,0)];
    
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self->loggedOut = false;
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    
    self.refreshControl = refreshControl;
//    self.tableView.contentOffset = CGPointMake(0, -self.refreshControl.frame.size.height);
//    [self.refreshControl beginRefreshing];
}

- (void) refresh {
    NSString *extension = [NSString stringWithFormat:@"users/%@/auctions/", ((NavigationController*)self.navigationController).userSessionInfo.user_id];
    
    [HTTPRequest GET:@"" toExtension:extension withAuthToken:((NavigationController*)self.navigationController).userSessionInfo.auth_token delegate:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int num = ((AuctionsPageViewController *)self.parentViewController)->completeAuctions.count;
    return num;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Complete Auctions";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    Auction *auction;
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
    }
    
    auction = ((CompleteAuction *)[((AuctionsPageViewController *)self.parentViewController)->completeAuctions objectAtIndex:indexPath.row]);
    
    cell.textLabel.text = auction.getName;
    cell.imageView.image = auction.getPicture;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Auction *auction;
    UIViewController * vc;
    
    auction = [((AuctionsPageViewController *)self.parentViewController)->completeAuctions objectAtIndex:indexPath.row];
    
    NSString * storyboardName = @"Main";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
    
    vc = [storyboard instantiateViewControllerWithIdentifier:@"CompleteAuctionTableViewController"];
    vc = [(CompleteAuctionTableViewController*)vc initWithAuction:(CompleteAuction*)auction userSessionInfo:((NavigationController*)self.navigationController).userSessionInfo];
    
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
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Uh Oh" message:@"Something went wrong. Please try again by swiping down on the list." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

// This method is used to process the data after connection has made successfully.
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"Finished Loading");
    
    NSString* jsonString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:nil];
    NSLog(@"jsonString: %@", jsonString);
    if ([jsonDict objectForKey:@"participants"] != nil) {
        NSArray *auctionsSignedUpFor = [jsonDict objectForKey:@"participants"];
        [((AuctionsPageViewController *)self.parentViewController)->completeAuctions removeAllObjects];
        //        [self->completeAuctions removeAllObjects];
        //        [self->completeAuctions removeAllObjects];
        
        for (int count = 0; count < auctionsSignedUpFor.count; count++) {
            jsonDict = auctionsSignedUpFor[count];
            NSString *name;
            NSString *auctionid;
            if ([jsonDict objectForKey:@"name"] != nil) {
                name = [jsonDict objectForKey:@"name"];
            }
            if ([jsonDict objectForKey:@"id"] != nil) {
                auctionid = [NSString stringWithFormat:@"%@", [jsonDict objectForKey:@"id"]];
            }
            if ([jsonDict objectForKey:@"stage"] != nil) {
                if ([((NSNumber *)[jsonDict objectForKey:@"stage"]) intValue] >= 2) {
                    if (((AuctionsPageViewController *)self.parentViewController)->completeAuctions == nil) {
                        ((AuctionsPageViewController *)self.parentViewController)->completeAuctions = [[NSMutableArray alloc] initWithObjects:[[CompleteAuction alloc] initWithName:name auctionID:auctionid picture:nil], nil];
                    } else {
                        [((AuctionsPageViewController *)self.parentViewController)->completeAuctions addObject:[[CompleteAuction alloc] initWithName:name auctionID:auctionid picture:nil]];
                    }
                } //else if ([((NSNumber *)[jsonDict objectForKey:@"stage"]) intValue] == 1) {
                //                    if (self->completeAuctions == nil) {
                //                        self->completeAuctions = [[NSMutableArray alloc] initWithObjects:[[completeAuction alloc] initWithName:name auctionID:auctionid picture:nil], nil];
                //                    } else {
                //                        [self->completeAuctions addObject:[[completeAuction alloc] initWithName:name auctionID:auctionid picture:nil]];
                //                    }
                //                } else {
                //                    if (self->completeAuctions == nil) {
                //                        self->completeAuctions = [[NSMutableArray alloc] initWithObjects:[[CompleteAuction alloc] initWithName:name auctionID:auctionid picture:nil], nil];
                //                    } else {
                //                        [self->completeAuctions addObject:[[CompleteAuction alloc] initWithName:name auctionID:auctionid picture:nil]];
                //                    }
                //                }
            }
        }
        
        //        if ((self->completeAuctions == nil || self->completeAuctions.count == 0) &&
        //            (self->completeAuctions == nil || self->completeAuctions.count == 0) &&
        //            (self->completeAuctions == nil || self->completeAuctions.count == 0) &&
        //            !self->loggedOut) {
        //            //programatically "press" the add auction bar button item. Could have simply loaded the 
        //            //view from the storyboard but whatever
        //            [[UIApplication sharedApplication] sendAction:self.addAuctionViewControllerButton.action
        //                                                       to:self.addAuctionViewControllerButton.target
        //                                                     from:nil
        //                                                 forEvent:nil];
        //        }
        [self.tableView reloadData];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Uh Oh" message:@"Something went wrong. Please try again by swiping down on the list." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    
    [responseData setData:nil];
    
    [self.refreshControl endRefreshing];
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    //dont do anything
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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
