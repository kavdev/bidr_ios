//
//  AuctionsPageViewController.m
//  BidrBird
//
//  Created by Zachary Glazer on 4/20/15.
//  Copyright (c) 2015 Zachary Glazer. All rights reserved.
//

#import "AuctionsPageViewController.h"

@interface AuctionsPageViewController ()

@end

@implementation AuctionsPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //self.automaticallyAdjustsScrollViewInsets = false;
    
    self.dataSource = self;
    
//    OngoingAuctionsTableViewController *ongoing = [self.storyboard instantiateViewControllerWithIdentifier:@"OngoingAuctionsTableViewController"];
//    [self setViewControllers:@[ongoing] direction:UIPageViewControllerNavigationDirectionForward animated:true completion:nil];
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



- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    if ([viewController isKindOfClass:[UpcomingAuctionsTableTableViewController class]]) {
        return nil;
    } else if ([viewController isKindOfClass:[OngoingAuctionsTableViewController class]]) {
        return [self.storyboard instantiateViewControllerWithIdentifier:@"UpcomingAuctionsTableViewController"];
    } else if ([viewController isKindOfClass:[CompleteAuctionsTableViewController class]]) {
        return [self.storyboard instantiateViewControllerWithIdentifier:@"OngoingAuctionsTableViewController"];
    }
    return nil;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    if ([viewController isKindOfClass:[UpcomingAuctionsTableTableViewController class]]) {
        return [self.storyboard instantiateViewControllerWithIdentifier:@"OngoingAuctionsTableViewController"];
    } else if ([viewController isKindOfClass:[OngoingAuctionsTableViewController class]]) {
        return [self.storyboard instantiateViewControllerWithIdentifier:@"CompleteAuctionsTableViewController"];
    } else if ([viewController isKindOfClass:[CompleteAuctionsTableViewController class]]) {
        return nil;
    }
    return nil;
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    // The number of items reflected in the page indicator.
    return 3;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    // The selected item reflected in the page indicator.
    return 1;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    responseData = [[NSMutableData alloc] init];
}

- (IBAction)signOut:(id)sender {
    [HTTPRequest POST:@"" toExtension:@"auth/logout/" withAuthToken:((NavigationController*)self.navigationController).userSessionInfo.auth_token delegate:self];
    self->loggedOut = true;
    [self.view.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
    //[self dismissViewControllerAnimated:TRUE completion:nil];
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
    
    OngoingAuctionsTableViewController *ongoing = [self.storyboard instantiateViewControllerWithIdentifier:@"OngoingAuctionsTableViewController"];
    [self setViewControllers:@[ongoing] direction:UIPageViewControllerNavigationDirectionForward animated:true completion:nil];
    
    //[self.refreshControl endRefreshing];
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
        [self->upcomingAuctions removeAllObjects];
        [self->completeAuctions removeAllObjects];
        [self->ongoingAuctions removeAllObjects];
        
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
        
        if ((self->upcomingAuctions == nil || self->upcomingAuctions.count == 0) &&
            (self->ongoingAuctions == nil || self->ongoingAuctions.count == 0) &&
            (self->completeAuctions == nil || self->completeAuctions.count == 0) &&
            !self->loggedOut) {
            //programatically "press" the add auction bar button item. Could have simply loaded the 
            //view from the storyboard but whatever
            [[UIApplication sharedApplication] sendAction:self.addAuctionViewControllerButton.action
                                                       to:self.addAuctionViewControllerButton.target
                                                     from:nil
                                                 forEvent:nil];
        }
    } else {
        //this is what we get back when they log out
        if (responseData.length != 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Uh Oh" message:@"Something went wrong. Please try again by swiping down on the list." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }
    
    [responseData setData:nil];
    
    OngoingAuctionsTableViewController *ongoing = [self.storyboard instantiateViewControllerWithIdentifier:@"OngoingAuctionsTableViewController"];
    [self setViewControllers:@[ongoing] direction:UIPageViewControllerNavigationDirectionForward animated:true completion:nil];
    
//    [self.tableView reloadData];
//    [self.refreshControl endRefreshing];
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    //dont do anything
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
