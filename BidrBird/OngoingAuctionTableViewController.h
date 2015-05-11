//
//  OngoingAuctionTableViewController.h
//  BidrBird
//
//  Created by Zachary Glazer on 12/3/14.
//  Copyright (c) 2014 Zachary Glazer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OngoingAuctionItemViewController.h"
#import "OngoingAuction.h"
#import "Item.h"
//#import "NavigationController.h"
#import "HTTPRequest.h"
#import "UserSessionInfo.h"

#define NUM_SECTIONS 3
#define WINNING_SECTION 0
#define LOSING_SECTION 1
#define UNBID 2

@interface OngoingAuctionTableViewController : UITableViewController <NSURLConnectionDelegate, NSURLConnectionDataDelegate, UIPopoverControllerDelegate> {
    OngoingAuction *auction;
    NSMutableData *responseData;
    UserSessionInfo *userSessionInfo;
}

-(id) initWithAuction:(OngoingAuction *)auction userSessionInfo:(UserSessionInfo *)info;
- (void) refresh;

@end
