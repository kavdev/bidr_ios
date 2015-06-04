//
//  CompleteAuctionItemViewController.h
//  BidrBird
//
//  Created by Zachary Glazer on 12/2/14.
//  Copyright (c) 2014 Zachary Glazer. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "Item.h"
#include "UserSessionInfo.h"

@class CompleteAuctionItemViewController;

@protocol CompletAuctionItemViewDelegate
- (void) replaceCompletedItemWithID:(NSString *)itemID forAuctionWithID:(NSString *)auctionID withItem:(Item *)item;
@end

@interface CompleteAuctionItemViewController : UIViewController {
    Item *item;
    NSString *auctionID;
    UserSessionInfo *userSessionInfo;
}

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *wonForLabel;
@property (strong, nonatomic) IBOutlet UITextView *descriptionTextView;

- (id) initWithItem:(Item*)item fromAuctionWithID:(NSString *)auctionID userSessionInfo:(UserSessionInfo *)info;

@end
