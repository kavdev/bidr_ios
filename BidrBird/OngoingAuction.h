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
#import "Auction.h"

@interface OngoingAuction : Auction {
    @public
    NSMutableArray *bidOnItems;
    NSMutableArray *otherItems;
}

-(id) initWithBidOnItems:(NSMutableArray*)items otherItems:(NSMutableArray*)otherItems name:(NSString*)name auctionID:(NSString *)auctionid picture:(UIImage*)picture;

- (NSMutableArray*) getBidOnItems;
- (NSMutableArray*) getOtherItems;

@end


#endif
