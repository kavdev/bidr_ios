//
//  OngoingAuctionItemViewController.h
//  BidrBird
//
//  Created by Zachary Glazer on 12/2/14.
//  Copyright (c) 2014 Zachary Glazer. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "Item.h"
#include "NavigationController.h"
#include "HTTPRequest.h"

@interface OngoingAuctionItemViewController : UIViewController <NSURLConnectionDelegate, NSURLConnectionDataDelegate, UIPopoverControllerDelegate> {
    Item *item;
    NSMutableData *responseData;
}

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *currentBidLabel;
@property (strong, nonatomic) IBOutlet UITextField *makeBidTextField;
@property (strong, nonatomic) IBOutlet UIButton *placeBidButton;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) IBOutlet UIButton *hidKeypadButton;
@property (strong, nonatomic) IBOutlet UIView *loadingView;

- (IBAction)placeBid:(id)sender;
- (IBAction)hideKeypad:(id)sender;
- (IBAction)startedEditing:(id)sender;
- (bool) isNumeric:(NSString*)checkText;

-(id) initWithItem:(Item*)items;

@end
