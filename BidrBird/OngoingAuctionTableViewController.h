//
//  OngoingAuctionTableViewController.h
//  BidrBird
//
//  Created by Zachary Glazer on 12/3/14.
//  Copyright (c) 2014 Zachary Glazer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OngoingAuctionItemViewController.h"
#import "Item.h"

@interface OngoingAuctionTableViewController : UITableViewController {
   NSArray *bidOnItemList;
   NSArray *otherItemList;
}

-(id) initWithBidOnItems:(NSArray*)bidOnItems otherItems:(NSArray*)otherItems;

@end
