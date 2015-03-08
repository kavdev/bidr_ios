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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(id) initWithOngoingAuctions:(NSMutableArray*)ongoing completeAuctions:(NSMutableArray*)complete upcomingAuctions:(NSMutableArray*)upcoming {
    self->upcomingAuctions = upcoming;
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
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (section == 0) {
        return self->upcomingAuctions.count;
    } else if (section == 1) {
        return self->ongoingAuctions.count;
    } else {
        return self->completeAuctions.count;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"Upcoming Auctions";
    } else if(section == 1) {
        return @"Current Auctions";
    } else {
        return @"Complete Auctions";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   static NSString *simpleTableIdentifier = @"Cell";
   
   UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
   Auction *auction;
   
   if (cell == nil) {
      cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
   }
   
    if (indexPath.section == 0) {
        auction = ((UpcomingAuction *)[self->upcomingAuctions objectAtIndex:indexPath.row]);
    } else if (indexPath.section == 1) {
        auction = ((OngoingAuction *)[self->ongoingAuctions objectAtIndex:indexPath.row]);
    } else {
        auction = ((CompleteAuction *)[self->completeAuctions objectAtIndex:indexPath.row]);
    }
   
   cell.textLabel.text = auction.getName;
   cell.imageView.image = auction.getPicture;
   
   return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Auction *auction;
    UIViewController * vc;
   
    
    if (indexPath.section == 0) {
        auction = [self->upcomingAuctions objectAtIndex:indexPath.row];
    } else if (indexPath.section == 1) {
        auction = [self->ongoingAuctions objectAtIndex:indexPath.row];
    } else {
        auction = [self->completeAuctions objectAtIndex:indexPath.row];
    }
   
    NSString * storyboardName = @"Main";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
    
    if (indexPath.section == 0) {
        vc = [storyboard instantiateViewControllerWithIdentifier:@"UpcomingAuctionTableViewController"];
        vc = [(UpcomingAuctionTableViewController*)vc initWithAuction:(UpcomingAuction*)auction navigationController:((NavigationController*)self.navigationController)];
    } else if (indexPath.section == 1) {
        vc = [storyboard instantiateViewControllerWithIdentifier:@"OngoingAuctionTableViewController"];
        vc = [(OngoingAuctionTableViewController*)vc initWithAuction:(OngoingAuction*)auction navigationController:((NavigationController*)self.navigationController)];
    } else {
        vc = [storyboard instantiateViewControllerWithIdentifier:@"CompleteAuctionTableViewController"];
        vc = [(CompleteAuctionTableViewController*)vc initWithAuction:(CompleteAuction*)auction navigationController:((NavigationController*)self.navigationController)];
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
                if ([((NSNumber *)[jsonDict objectForKey:@"stage"]) intValue] == 0) {
                    if (self->upcomingAuctions == nil) {
                        self->upcomingAuctions = [[NSMutableArray alloc] initWithObjects:[[UpcomingAuction alloc] initWithName:name auctionID:auctionid picture:nil], nil];
                    } else {
                        [self->upcomingAuctions addObject:[[UpcomingAuction alloc] initWithName:name auctionID:auctionid picture:nil]];
                    }
                } else if ([((NSNumber *)[jsonDict objectForKey:@"stage"]) intValue] == 1) {
                    if (self->ongoingAuctions == nil) {
                        self->ongoingAuctions = [[NSMutableArray alloc] initWithObjects:[[OngoingAuction alloc] initWithName:name auctionID:auctionid picture:nil], nil];
                    } else {
                        [self->ongoingAuctions addObject:[[OngoingAuction alloc] initWithName:name auctionID:auctionid picture:nil]];
                    }
                } else {
                    if (self->completeAuctions == nil) {
                        self->completeAuctions = [[NSMutableArray alloc] initWithObjects:[[CompleteAuction alloc] initWithName:name auctionID:auctionid picture:nil], nil];
                    } else {
                        [self->completeAuctions addObject:[[CompleteAuction alloc] initWithName:name auctionID:auctionid picture:nil]];
                    }
                }
            }
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
    [self.tableView reloadData];
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
