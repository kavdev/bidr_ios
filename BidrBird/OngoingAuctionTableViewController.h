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
#import "HTTPRequest.h"
#import "UserSessionInfo.h"
#import "UIImage+resizeImage.h"

#define NUM_SECTIONS 3
#define WINNING_SECTION 0
#define LOSING_SECTION 1
#define UNBID_SECTION 2

@class OngoingAuctionTableViewController;

@protocol OngoinAuctionTableViewDelegate
- (void) replaceOngoingItemWithID:(NSString *)itemID forAuctionWithID:(NSString *)auctionID withItem:(Item *)item;
- (OngoingAuction *) getOngoingAuctionWithID:(NSString *)auctionID;
- (void) replaceOngoingAuctionWithID:(NSString *)auctionID withAuction:(OngoingAuction *)auction;
- (void) auctionWithIDEnded:(NSString *)auctionID;
- (void) replaceUsersHighestBidForItemWithID:(NSString *)itemID forAuctionWithID:(NSString *)auctionID withBid:(Bid *)bid;
- (void) replaceMinBidIncrementForOngoingAuctionWithID:(NSString *)auctionID withMinBidInc:(int)minBidInc;
@end

@interface OngoingAuctionTableViewController : UITableViewController <NSURLConnectionDelegate, NSURLConnectionDataDelegate, UIPopoverControllerDelegate, OngoingAuctionItemViewDelegate> {
    @public
    OngoingAuction *auction;
    NSMutableData *responseData;
    UserSessionInfo *userSessionInfo;
}

@property (nonatomic, weak) id <OngoinAuctionTableViewDelegate> delegate;

-(id) initWithAuction:(OngoingAuction *)auction userSessionInfo:(UserSessionInfo *)info;
- (void) refresh;

@end
