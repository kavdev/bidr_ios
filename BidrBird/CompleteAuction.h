//
//  Auction.h
//  BidrBird
//
//  Created by Zachary Glazer on 12/2/14.
//  Copyright (c) 2014 Zachary Glazer. All rights reserved.
//

#ifndef BidrBird_CompleteAuction_h
#define BidrBird_CompleteAuction_h

#import <UIKit/UIKit.h>
#import "Auction.h"

@interface CompleteAuction : Auction {
    @public
    NSMutableArray *wonItems;
    NSMutableArray *lostItems;
}

- (id) initWithWonItems:(NSMutableArray*)wonItems lostItems:(NSMutableArray *)lostItems name:(NSString*)name auctionID:(NSString *)auctionid picture:(UIImage*)picture;

- (NSMutableArray *) getWonItems;
- (NSMutableArray *) getLostItems;

@end

#endif
