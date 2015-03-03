//
//  OngoingAuctionItemViewController.h
//  BidrBird
//
//  Created by Zachary Glazer on 12/2/14.
//  Copyright (c) 2014 Zachary Glazer. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "Item.h"

@interface OngoingAuctionItemViewController : UIViewController <NSURLConnectionDelegate, NSURLConnectionDataDelegate, UIPopoverControllerDelegate> {
   Item *item;
}

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *currentBidLabel;
@property (strong, nonatomic) IBOutlet UITextField *makeBidTextField;
@property (strong, nonatomic) IBOutlet UIButton *placeBidButton;
@property (strong, nonatomic) IBOutlet UILabel *conditionLabel;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) IBOutlet UIButton *hidKeypadButton;

- (IBAction)placeBid:(id)sender;
- (IBAction)hideKeypad:(id)sender;
- (IBAction)startedEditing:(id)sender;

-(id) initWithItem:(Item*)items;
- (void) loadHighestBid;

@end
