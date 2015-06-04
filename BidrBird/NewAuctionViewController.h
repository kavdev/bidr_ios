//
//  NewAuctionViewController.h
//  BidrBird
//
//  Created by Zachary Glazer on 12/2/14.
//  Copyright (c) 2014 Zachary Glazer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OngoingAuction.h"
#import "OngoingAuctionTableViewController.h"
#import "CompleteAuction.h"
#import "CompleteAuctionTableViewController.h"
#import "UpcomingAuction.h"
#import "UpcomingAuctionTableViewController.h"
#import "HTTPRequest.h"

@class NewAuctionViewController;

@protocol NewAuctionViewProtocol
- (void) addUpcomingAuction:(UpcomingAuction *)auction;
- (void) addOngoingAuction:(OngoingAuction *)auction;
- (void) addCompleteAuction:(CompleteAuction *)auction;
@end

@interface NewAuctionViewController : UIViewController <NSURLConnectionDelegate, NSURLConnectionDataDelegate, UIPopoverControllerDelegate> {
    @public
    NSMutableData *responseData;
    UserSessionInfo *userSessionInfo;
}

@property (strong, nonatomic) IBOutlet UITextField *auctionIDTextEditor;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextEditor;
@property (strong, nonatomic) IBOutlet UIButton *connectButton;
@property (strong, nonatomic) IBOutlet UIView *loadingView;
@property (weak, nonatomic) id <NewAuctionViewProtocol, OngoinAuctionTableViewDelegate, UpcomingAuctionTableViewProtocol> delegate;

- (IBAction)connectToAuction:(id)sender;

@end
