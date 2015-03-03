//
//  CompleteAuctionTableViewController.h
//  BidrBird
//
//  Created by Zachary Glazer on 12/3/14.
//  Copyright (c) 2014 Zachary Glazer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Item.h"
#import "CompleteAuctionItemViewController.h"

@interface CompleteAuctionTableViewController : UITableViewController {
   NSArray *boughtItems;
}

-(id) initWithBoughtItems:(NSArray*)items;

@end
