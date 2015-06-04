//
//  CompleteAuctionsTableViewController.h
//  BidrBird
//
//  Created by Zachary Glazer on 4/20/15.
//  Copyright (c) 2015 Zachary Glazer. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CompleteAuction.h"
#import "Auction.h"
#import "CompleteAuctionTableViewController.h"
#import "HTTPRequest.h"
#import "AuctionsPageViewController.h"

@interface CompleteAuctionsTableViewController : UITableViewController <NSURLConnectionDelegate, NSURLConnectionDataDelegate, UIPopoverControllerDelegate, UITableViewDataSource, UITableViewDelegate> {
    @public
    NSMutableData *responseData;
    BOOL loggedOut;
    UserSessionInfo *userSessionInfo;
}

@end
