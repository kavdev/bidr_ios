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
    if ([viewController isKindOfClass:[UpcomingAuctionsTableViewController class]]) {
        return nil;
    } else if ([viewController isKindOfClass:[OngoingAuctionsTableViewController class]]) {
        UpcomingAuctionsTableViewController *upcoming = [self.storyboard instantiateViewControllerWithIdentifier:@"UpcomingAuctionsTableViewController"];
        upcoming->userSessionInfo = self->userSessionInfo;
        return upcoming;
    } else if ([viewController isKindOfClass:[CompleteAuctionsTableViewController class]]) {
        OngoingAuctionsTableViewController *ongoing = [self.storyboard instantiateViewControllerWithIdentifier:@"OngoingAuctionsTableViewController"];
        ongoing->userSessionInfo = self->userSessionInfo;
        return ongoing;
    }
    return nil;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    if ([viewController isKindOfClass:[UpcomingAuctionsTableViewController class]]) {
        OngoingAuctionsTableViewController *ongoing = [self.storyboard instantiateViewControllerWithIdentifier:@"OngoingAuctionsTableViewController"];
        ongoing->userSessionInfo = self->userSessionInfo;
        return ongoing;
    } else if ([viewController isKindOfClass:[OngoingAuctionsTableViewController class]]) {
        CompleteAuctionsTableViewController *complete = [self.storyboard instantiateViewControllerWithIdentifier:@"CompleteAuctionsTableViewController"];
        complete->userSessionInfo = self->userSessionInfo;
        return complete;
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
    [HTTPRequest POST:@"" toExtension:@"auth/logout/" withAuthToken:self->userSessionInfo.auth_token delegate:self];
    self->loggedOut = true;
    [self.view.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
    //[self dismissViewControllerAnimated:TRUE completion:nil];
}

- (IBAction)showAddAuctionView:(id)sender {
    NewAuctionViewController *addAuctionView = [self.storyboard instantiateViewControllerWithIdentifier:@"NewAuctionViewController"];
    addAuctionView.delegate = self;
    addAuctionView->userSessionInfo = self->userSessionInfo;
    [self.navigationController pushViewController:addAuctionView animated:YES];
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
    ongoing->userSessionInfo = self->userSessionInfo;
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
            int minBidInc = 1;
            if ([jsonDict objectForKey:@"name"] != nil) {
                name = [jsonDict objectForKey:@"name"];
            }
            if ([jsonDict objectForKey:@"id"] != nil) {
                auctionid = [NSString stringWithFormat:@"%@", [jsonDict objectForKey:@"id"]];
            }
            if ([jsonDict objectForKey:@"bid_increment"] != nil) {
                minBidInc = [(NSNumber *)[jsonDict objectForKey:@"bid_increment"] intValue];
            }
            if ([jsonDict objectForKey:@"stage"] != nil) {
                if ([((NSNumber *)[jsonDict objectForKey:@"stage"]) intValue] == 0) {
                    [self addUpcomingAuction:[[UpcomingAuction alloc] initWithName:name auctionID:auctionid picture:nil minBidInc:minBidInc]];
                } else if ([((NSNumber *)[jsonDict objectForKey:@"stage"]) intValue] == 1) {
                    [self addOngoingAuction:[[OngoingAuction alloc] initWithName:name auctionID:auctionid picture:nil minBidInc:minBidInc]];
                } else {
                    [self addCompleteAuction:[[CompleteAuction alloc] initWithName:name auctionID:auctionid picture:nil minBidInc:minBidInc]];
                }
            }
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
    ongoing->userSessionInfo = self->userSessionInfo;
    [self setViewControllers:@[ongoing] direction:UIPageViewControllerNavigationDirectionForward animated:true completion:nil];
    
    if ((self->upcomingAuctions == nil || self->upcomingAuctions.count == 0) &&
        (self->ongoingAuctions == nil || self->ongoingAuctions.count == 0) &&
        (self->completeAuctions == nil || self->completeAuctions.count == 0) &&
        !self->loggedOut) {
        
        [self showAddAuctionView:nil];
        //programatically "press" the add auction bar button item. Could have simply loaded the 
        //view from the storyboard but whatever
//        [[UIApplication sharedApplication] sendAction:self.addAuctionViewControllerButton.action
//                                                   to:self.addAuctionViewControllerButton.target
//                                                 from:nil
//                                             forEvent:nil];
    }
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    //dont do anything
}

- (void) replaceOngoingItemWithID:(NSString *)itemID forAuctionWithID:(NSString *)auctionID withItem:(Item *)item {
    OngoingAuction *ongoingAuc = [self->ongoingAuctions objectForKey:auctionID];
    Item *oldItem;
    
    if (ongoingAuc->unbidItems && [ongoingAuc->unbidItems objectForKey:itemID] != nil) {
        oldItem = [ongoingAuc->unbidItems objectForKey:itemID];
        [ongoingAuc->unbidItems removeObjectForKey:itemID];
    } else if (ongoingAuc->winningItems && [ongoingAuc->winningItems objectForKey:itemID] != nil) {
        oldItem = [ongoingAuc->winningItems objectForKey:itemID];
        [ongoingAuc->winningItems removeObjectForKey:itemID];
    } else if (ongoingAuc->losingItems && [ongoingAuc->losingItems objectForKey:itemID] != nil) {
        oldItem = [ongoingAuc->losingItems objectForKey:itemID];
        [ongoingAuc->losingItems removeObjectForKey:itemID];
    }
    
    if (item) {
        if (item->highestBid == nil || item->highestBid->userID < 0) {
            if (ongoingAuc->unbidItems == nil) {
                ongoingAuc->unbidItems = [NSMutableDictionary dictionaryWithObject:item forKey:itemID];
            } else {
                [ongoingAuc->unbidItems setObject:item forKey:itemID];
            }
        } else if (item->highestBid->userID == [self->userSessionInfo.user_id intValue]) {
            if (ongoingAuc->winningItems == nil) {
                ongoingAuc->winningItems = [NSMutableDictionary dictionaryWithObject:item forKey:itemID];
            } else {
                [ongoingAuc->winningItems setObject:item forKey:itemID];
            }
        } else {
            if (ongoingAuc->losingItems == nil) {
                ongoingAuc->losingItems = [NSMutableDictionary dictionaryWithObject:item forKey:itemID];
            } else {
                [ongoingAuc->losingItems setObject:item forKey:itemID];
            }
        }
    }
    
    [self addOngoingAuction:ongoingAuc];
}

- (OngoingAuction *) getOngoingAuctionWithID:(NSString *)auctionID {
    return [self->ongoingAuctions objectForKey:auctionID];
}

- (void) replaceOngoingAuctionWithID:(NSString *)auctionID withAuction:(OngoingAuction *)auction {    
    [self addOngoingAuction:auction];
}

- (void) replaceUsersHighestBidForItemWithID:(NSString *)itemID forAuctionWithID:(NSString *)auctionID withBid:(Bid *)bid {
    OngoingAuction *ongoingAuc = [self->ongoingAuctions objectForKey:auctionID];
    Item *item;
    
    if (ongoingAuc->unbidItems && [ongoingAuc->unbidItems objectForKey:itemID] != nil) {
        item = [ongoingAuc->unbidItems objectForKey:itemID];
        [ongoingAuc->unbidItems removeObjectForKey:itemID];
    } else if (ongoingAuc->winningItems && [ongoingAuc->winningItems objectForKey:itemID] != nil) {
        item = [ongoingAuc->winningItems objectForKey:itemID];
        [ongoingAuc->winningItems removeObjectForKey:itemID];
    } else if (ongoingAuc->losingItems && [ongoingAuc->losingItems objectForKey:itemID] != nil) {
        item = [ongoingAuc->losingItems objectForKey:itemID];
        [ongoingAuc->losingItems removeObjectForKey:itemID];
    }
    
    if (item) {
        item->usersHighestBid = bid;
        if (item->highestBid == nil || item->highestBid->userID < 0) {
            if (ongoingAuc->unbidItems == nil) {
                ongoingAuc->unbidItems = [NSMutableDictionary dictionaryWithObject:item forKey:itemID];
            } else {
                [ongoingAuc->unbidItems setObject:item forKey:itemID];
            }
        } else if (item->highestBid->userID == [self->userSessionInfo.user_id intValue]) {
            if (ongoingAuc->winningItems == nil) {
                ongoingAuc->winningItems = [NSMutableDictionary dictionaryWithObject:item forKey:itemID];
            } else {
                [ongoingAuc->winningItems setObject:item forKey:itemID];
            }
        } else {
            if (ongoingAuc->losingItems == nil) {
                ongoingAuc->losingItems = [NSMutableDictionary dictionaryWithObject:item forKey:itemID];
            } else {
                [ongoingAuc->losingItems setObject:item forKey:itemID];
            }
        }
    }
}

- (void) replaceMinBidIncrementForOngoingAuctionWithID:(NSString *)auctionID withMinBidInc:(int)minBidInc {
    OngoingAuction *ongoingAuc = [self->ongoingAuctions objectForKey:auctionID];
    ongoingAuc->minBidInc = minBidInc;
    [self addOngoingAuction:ongoingAuc];
}

- (void) auctionWithIDEnded:(NSString *)auctionID {
    OngoingAuction *ongoingAuc = [self->ongoingAuctions objectForKey:auctionID];

    [self->ongoingAuctions removeObjectForKey:auctionID];
    
    [self addCompleteAuction:[[CompleteAuction alloc] initWithName:ongoingAuc->name auctionID:auctionID picture:ongoingAuc->picture minBidInc:ongoingAuc->minBidInc]];
}

- (void) auctionEndedWithID:(NSString *)auctionID {
    UpcomingAuction *upcomingAuc = [self->upcomingAuctions objectForKey:auctionID];
    
    [self->upcomingAuctions removeObjectForKey:auctionID];
    
    [self addCompleteAuction:[[CompleteAuction alloc] initWithName:upcomingAuc->name auctionID:upcomingAuc->auctionID picture:upcomingAuc->picture minBidInc:upcomingAuc->minBidInc]];
}

- (void) aucitonBeganWithID:(NSString *)auctionID {
    UpcomingAuction *upcomingAuc = [self->upcomingAuctions objectForKey:auctionID];
    
    [self->upcomingAuctions removeObjectForKey:auctionID];
    
    [self addOngoingAuction:[[OngoingAuction alloc] initWithName:upcomingAuc->name auctionID:upcomingAuc->auctionID picture:upcomingAuc->picture minBidInc:upcomingAuc->minBidInc]];
}

- (void) addUpcomingAuction:(UpcomingAuction *)auction {
    if (self->upcomingAuctions == nil) {
        self->upcomingAuctions = [NSMutableDictionary dictionaryWithObject:auction forKey:auction->auctionID];
    } else {
        [self->upcomingAuctions setObject:auction forKey:auction->auctionID];
    }
}

- (void) addOngoingAuction:(OngoingAuction *)auction {
    if (self->ongoingAuctions == nil) {
        self->ongoingAuctions = [NSMutableDictionary dictionaryWithObject:auction forKey:auction->auctionID];
    } else {
        [self->ongoingAuctions setObject:auction forKey:auction->auctionID];
    }
}

- (void) addCompleteAuction:(CompleteAuction *)auction {
    if (self->completeAuctions == nil) {
        self->completeAuctions = [NSMutableDictionary dictionaryWithObject:auction forKey:auction->auctionID];
    } else {
        [self->completeAuctions setObject:auction forKey:auction->auctionID];
    }
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
