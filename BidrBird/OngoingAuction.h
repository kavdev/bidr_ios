//
//  OnoingAuction.h
//  BidrBird
//
//  Created by Zachary Glazer on 12/3/14.
//  Copyright (c) 2014 Zachary Glazer. All rights reserved.
//

#ifndef BidrBird_OngoingAuction_h
#define BidrBird_OngoingAuction_h

#import <UIKit/UIKit.h>

@interface OngoingAuction : NSObject {
   NSArray *bidOnItems;
   NSArray *otherItems;
   NSString *name;
   UIImage *picture;
    NSString *auctionID;
}

-(id) initWithBidOnItems:(NSArray*)items otherItems:(NSArray*)otherItems name:(NSString*)name auctionID:(NSString *)auctionid picture:(UIImage*)picture;
-(id) initWithName:(NSString*)name auctionID:(NSString *)auctionid picture:(UIImage*)picture;

- (NSArray*) getBidOnItems;
- (NSArray*) getOtherItems;
- (NSString*) getName;
- (UIImage*) getPicture;

@end


#endif
