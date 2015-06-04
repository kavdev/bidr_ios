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
    NSMutableDictionary *winningItems;
    NSMutableDictionary *losingItems;
    NSMutableDictionary *unbidItems;
}

-(id) initWithWinningItems:(NSMutableDictionary*)winning losingItems:(NSMutableDictionary*)losing unbidItems:(NSMutableDictionary*)unbid name:(NSString*)name auctionID:(NSString *)auctionid picture:(UIImage*)picture  minBidInc:(int)minBidInc;

@end


#endif
