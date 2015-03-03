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

@interface AuctionsTableViewController : UITableViewController {
   NSArray *ongoingAuctions;
   NSArray *completeAuctions;
}

-(id) initWithOngoingAuctions:(NSArray*)ongoing completeAuctions:(NSArray*)complete;

- (IBAction)signOut:(id)sender;

@end
