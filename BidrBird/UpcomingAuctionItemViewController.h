//
//  UpcomingAuctionItemViewController.h
//  BidrBird
//
//  Created by Zachary Glazer on 3/7/15.
//  Copyright (c) 2015 Zachary Glazer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Item.h"
#include "UserSessionInfo.h"

@class UpcomingAuctionItemViewController;

@protocol UpcomingAuctionItemViewDelegate
- (void) replaceUpcomingItemWithID:(NSString *)itemID forAuctionWithID:(NSString *)auctionID withItem:(Item *)item;
@end

@interface UpcomingAuctionItemViewController : UIViewController {
    Item *item;
    NSString *auctionID;
    UserSessionInfo *userSessionInfo;
}

- (id) initWithItem:(Item*)item fromAuctionWithID:(NSString *)auctionID userSessionInfo:(UserSessionInfo *)info;

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (strong, nonatomic) IBOutlet UILabel *minBidLabel;

@end
