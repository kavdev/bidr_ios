//
//  UpcomingAuctionsTableTableViewController.h
//  BidrBird
//
//  Created by Zachary Glazer on 4/20/15.
//  Copyright (c) 2015 Zachary Glazer. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UpcomingAuction.h"
#import "Auction.h"
#import "UpcomingAuctionTableViewController.h"
#import "NavigationController.h"
#import "HTTPRequest.h"
#import "AuctionsPageViewController.h"

@interface UpcomingAuctionsTableTableViewController : UITableViewController <NSURLConnectionDelegate, NSURLConnectionDataDelegate, UIPopoverControllerDelegate, UITableViewDataSource, UITableViewDelegate> {
    NSMutableData *responseData;
    BOOL loggedOut;
}

@property (strong, nonatomic) IBOutlet UIBarButtonItem *addAuctionViewControllerButton;

-(id) initWithUpcomingAuctions:(NSMutableArray*)upcoming;

- (IBAction)signOut:(id)sender;

@end
