//
//  UpcomingAuctionTableViewController.h
//  BidrBird
//
//  Created by Zachary Glazer on 3/7/15.
//  Copyright (c) 2015 Zachary Glazer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UpcomingAuction.h"
#import "UpcomingAuctionItemViewController.h"
#import "Item.h"
//#import "NavigationController.h"
#import "HTTPRequest.h"
#import "UserSessionInfo.h"

@interface UpcomingAuctionTableViewController : UITableViewController <NSURLConnectionDelegate, NSURLConnectionDataDelegate, UIPopoverControllerDelegate> {
    UpcomingAuction *auction;
    NSMutableData *responseData;
    UserSessionInfo *userSessionInfo;
}

-(id) initWithAuction:(UpcomingAuction *)auction userSessionInfo:(UserSessionInfo *)info;

@end
