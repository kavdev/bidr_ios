//
//  CompleteAuctionTableViewController.h
//  BidrBird
//
//  Created by Zachary Glazer on 12/3/14.
//  Copyright (c) 2014 Zachary Glazer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Item.h"
#import "CompleteAuctionItemViewController.h"
#import "Bid.h"
#import "CompleteAuction.h"
//#import "NavigationController.h"
#import "HTTPRequest.h"
#import "UserSessionInfo.h"

@interface CompleteAuctionTableViewController : UITableViewController <NSURLConnectionDelegate, NSURLConnectionDataDelegate, UIPopoverControllerDelegate> {
    CompleteAuction *auction;
    NSMutableData *responseData;
    UserSessionInfo *userSessionInfo;
}

-(id) initWithAuction:(CompleteAuction *)auction userSessionInfo:(UserSessionInfo *)info;

@end
