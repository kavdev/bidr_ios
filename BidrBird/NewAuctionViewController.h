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
#import "NavigationController.h"

@interface NewAuctionViewController : UIViewController <NSURLConnectionDelegate, NSURLConnectionDataDelegate, UIPopoverControllerDelegate>

@property (strong, nonatomic) IBOutlet UITextField *auctionIDTextEditor;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextEditor;

- (IBAction)connectToAuction:(id)sender;

@end
