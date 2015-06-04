//
//  Item.h
//  BidrBird
//
//  Created by Zachary Glazer on 12/2/14.
//  Copyright (c) 2014 Zachary Glazer. All rights reserved.
//

#ifndef BidrBird_Item_h
#define BidrBird_Item_h

#import <UIKit/UIKit.h>
#import "Bid.h"

@interface Item : NSObject {
   @public
   NSString *name;
   NSString *description;
   Bid *highestBid;
   NSString *condition;
   UIImage *picture;
   int itemID;
    int minBid;
    Bid *usersHighestBid;
}

- (id) initWithName:(NSString*)name description:(NSString*)description highestBid: (Bid *)highestBid condition:(NSString*)condition picture:(UIImage*)picture itemID:(int)itemID minimumBid:(int)minBid usersHighestBid:(Bid*)uHBid;

- (NSString*) getName;
- (NSString*) getDescription;
- (Bid *) getHightestBid;
- (NSString*) getCondition;
- (UIImage*) getPicture;

@end

#endif
