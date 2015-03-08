//
//  AuctionsTableViewController.h
//  BidrBird
//
//  Created by Zachary Glazer on 12/3/14.
//  Copyright (c) 2014 Zachary Glazer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CompleteAuction.h"
#import "OngoingAuction.h"
#import "UpcomingAuction.h"
#import "Auction.h"
#import "UpcomingAuctionTableViewController.h"
#import "OngoingAuctionTableViewController.h"
#import "CompleteAuctionTableViewController.h"
#import "NavigationController.h"
#import "HTTPRequest.h"

@interface AuctionsTableViewController : UITableViewController <NSURLConnectionDelegate, NSURLConnectionDataDelegate, UIPopoverControllerDelegate, UITableViewDataSource, UITableViewDelegate> {
    NSMutableArray *upcomingAuctions;
    NSMutableArray *ongoingAuctions;
    NSMutableArray *completeAuctions;
}

-(id) initWithOngoingAuctions:(NSMutableArray*)ongoing completeAuctions:(NSMutableArray*)complete upcomingAuctions:(NSMutableArray*)upcoming;

- (IBAction)signOut:(id)sender;

@end
