//
//  AuctionsPageViewController.h
//  BidrBird
//
//  Created by Zachary Glazer on 4/20/15.
//  Copyright (c) 2015 Zachary Glazer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UpcomingAuctionsTableTableViewController.h"
#import "OngoingAuctionsTableViewController.h"
#import "CompleteAuctionsTableViewController.h"
#import "CompleteAuction.h"
#import "OngoingAuction.h"
#import "UpcomingAuction.h"
#import "Auction.h"
#import "UpcomingAuctionTableViewController.h"
#import "OngoingAuctionTableViewController.h"
#import "CompleteAuctionTableViewController.h"
#import "NavigationController.h"
#import "HTTPRequest.h"

@interface AuctionsPageViewController : UIPageViewController <UIPageViewControllerDataSource, NSURLConnectionDelegate, NSURLConnectionDataDelegate, UIPopoverControllerDelegate> {
    @public NSMutableArray *upcomingAuctions;
    @public NSMutableArray *ongoingAuctions;
    @public NSMutableArray *completeAuctions;
    NSMutableData *responseData;
    BOOL loggedOut;
}

@property (strong, nonatomic) IBOutlet UIBarButtonItem *addAuctionViewControllerButton;

-(id) initWithOngoingAuctions:(NSMutableArray*)ongoing completeAuctions:(NSMutableArray*)complete upcomingAuctions:(NSMutableArray*)upcoming;

- (IBAction)signOut:(id)sender;

@end
