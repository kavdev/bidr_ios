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
#import "HTTPRequest.h"
#import "UserSessionInfo.h"
#import "UIImage+resizeImage.h"

@class UpcomingAuctionTableViewController;

@protocol UpcomingAuctionTableViewProtocol
- (void) aucitonBeganWithID:(NSString *)auctionID;
- (void) auctionEndedWithID:(NSString *)auctionID;
@end

@interface UpcomingAuctionTableViewController : UITableViewController <NSURLConnectionDelegate, NSURLConnectionDataDelegate, UIPopoverControllerDelegate> {
    @public
    UpcomingAuction *auction;
    NSMutableData *responseData;
    UserSessionInfo *userSessionInfo;
}

@property (weak, nonatomic) id <UpcomingAuctionTableViewProtocol> delegate;

-(id) initWithAuction:(UpcomingAuction *)auction userSessionInfo:(UserSessionInfo *)info;

@end
