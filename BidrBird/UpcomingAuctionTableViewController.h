//
//  UpcomingAuctionTableViewController.h
//  BidrBird
//
//  Created by Zachary Glazer on 3/7/15.
//  Copyright (c) 2015 Zachary Glazer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UpcomingAuction.h"
#import "UpcomingAuctionItemViewController.h"
#import "Item.h"
#import "NavigationController.h"

@interface UpcomingAuctionTableViewController : UITableViewController <NSURLConnectionDelegate, NSURLConnectionDataDelegate, UIPopoverControllerDelegate> {
    UpcomingAuction *auction;
}

-(id) initWithAuction:(UpcomingAuction *)auction navigationController:(NavigationController *)controller;

@end
