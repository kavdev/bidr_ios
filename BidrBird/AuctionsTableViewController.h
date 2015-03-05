//
//  AuctionsTableViewController.h
//  BidrBird
//
//  Created by Zachary Glazer on 12/3/14.
//  Copyright (c) 2014 Zachary Glazer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CompleteAuction.h"
#import "OngoingAuction.h"
#import "OngoingAuctionTableViewController.h"
#import "CompleteAuctionTableViewController.m"
#import "NavigationController.h"
#import "HTTPRequest.h"

@interface AuctionsTableViewController : UITableViewController <NSURLConnectionDelegate, NSURLConnectionDataDelegate, UIPopoverControllerDelegate, UITableViewDataSource, UITableViewDelegate> {
   NSMutableArray *ongoingAuctions;
   NSMutableArray *completeAuctions;
}

-(id) initWithOngoingAuctions:(NSMutableArray*)ongoing completeAuctions:(NSMutableArray*)complete;

- (IBAction)signOut:(id)sender;

@end
