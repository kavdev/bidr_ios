//
//  UpcomginAuction.h
//  BidrBird
//
//  Created by Zachary Glazer on 3/7/15.
//  Copyright (c) 2015 Zachary Glazer. All rights reserved.
//

#ifndef BidrBird_UpcomingAuction_h
#define BidrBird_UpcomingAuction_h

#import <UIKit/UIKit.h>
#import "Auction.h"

@interface UpcomingAuction : Auction {
    @public
    NSMutableArray *items;
}

-(id) initWithItems:(NSMutableArray*)items name:(NSString*)name auctionID:(NSString *)auctionid picture:(UIImage*)picture;

- (NSMutableArray*) getItems;

@end

#endif
