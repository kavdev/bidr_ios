//
//  OngoingAuctionTableViewController.h
//  BidrBird
//
//  Created by Zachary Glazer on 12/3/14.
//  Copyright (c) 2014 Zachary Glazer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OngoingAuctionItemViewController.h"
#import "OngoingAuction.h"
#import "Item.h"
#import "HTTPRequest.h"
#import "NavigationController.h"

@interface OngoingAuctionTableViewController : UITableViewController <NSURLConnectionDelegate, NSURLConnectionDataDelegate, UIPopoverControllerDelegate> {
    OngoingAuction *auction;
}

-(id) initWithAuction:(OngoingAuction *)auction navigationController:(NavigationController *)controller;

@end
