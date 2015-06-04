//
//  OngoingAuctionItemViewController.h
//  BidrBird
//
//  Created by Zachary Glazer on 12/2/14.
//  Copyright (c) 2014 Zachary Glazer. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "Item.h"
#include "HTTPRequest.h"
#include "UserSessionInfo.h"

@class OngoingAuctionItemViewController;

@protocol OngoingAuctionItemViewDelegate
- (void) replaceOngoingItemWithID:(NSString *)itemID forAuctionWithID:(NSString *)auctionID withItem:(Item *)item;
- (void) auctionWithIDEnded:(NSString *)auctionID;
- (void) replaceUsersHighestBidForItemWithID:(NSString *)itemID forAuctionWithID:(NSString *)auctionID withBid:(Bid *)bid;
- (void) replaceMinBidIncrementForOngoingAuctionWithID:(NSString *)auctionID withMinBidInc:(int)minBidInc;
@end

@interface OngoingAuctionItemViewController : UIViewController <NSURLConnectionDelegate, NSURLConnectionDataDelegate, UIPopoverControllerDelegate> {
    Item *item;
    NSString *auctionID;
    NSMutableData *responseData;
    UserSessionInfo *userSessionInfo;
    int minBidInc;
}

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *currentBidLabel;
@property (strong, nonatomic) IBOutlet UILabel *lastBidLabel;
@property (strong, nonatomic) IBOutlet UITextField *makeBidTextField;
@property (strong, nonatomic) IBOutlet UIButton *placeBidButton;
@property (strong, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (strong, nonatomic) IBOutlet UIButton *hidKeypadButton;
@property (strong, nonatomic) IBOutlet UIView *loadingView;
@property (weak, nonatomic) UITextField *activeField;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) id <OngoingAuctionItemViewDelegate> delegate;

- (IBAction)placeBid:(id)sender;
- (IBAction)hideKeypad:(id)sender;
- (IBAction)startedEditing:(id)sender;
- (bool) isNumeric:(NSString*)checkText;

-(id) initWithItem:(Item*)items fromAuctionWithID:(NSString *)auctionID userSessionInfo:(UserSessionInfo *)info minBidInc:(int)minBidInc;

@end
