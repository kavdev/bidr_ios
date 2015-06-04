//
//  CurrentAuctionsTableViewController.h
//  BidrBird
//
//  Created by Zachary Glazer on 4/20/15.
//  Copyright (c) 2015 Zachary Glazer. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "OngoingAuction.h"
#import "Auction.h"
#import "OngoingAuctionTableViewController.h"
#import "HTTPRequest.h"
#import "AuctionsPageViewController.h"

@interface OngoingAuctionsTableViewController : UITableViewController <NSURLConnectionDelegate, NSURLConnectionDataDelegate, UIPopoverControllerDelegate, UITableViewDataSource, UITableViewDelegate> {
    @public
    NSMutableData *responseData;
    BOOL loggedOut;
    UserSessionInfo *userSessionInfo;
}

@end
