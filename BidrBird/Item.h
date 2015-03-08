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

@interface Item : NSObject {
   @public
   NSString *name;
   NSString *description;
   double highestBid;
   NSString *condition;
   UIImage *picture;
   int itemID;
    double minBid;
}

- (id) initWithName:(NSString*)name description:(NSString*)description highestBid: (double)highestBid condition:(NSString*)condition picture:(UIImage*)picture itemID:(int)itemID minimumBid:(double)minBid;

- (NSString*) getName;
- (NSString*) getDescription;
- (double) getHightestBid;
- (NSString*) getCondition;
- (UIImage*) getPicture;

@end

#endif
