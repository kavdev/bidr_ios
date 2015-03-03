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

@interface NewAuctionViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *auctionIDTextEditor;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextEditor;

- (IBAction)connectToAuction:(id)sender;

@end
