//
//  UpcomginAuction.m
//  BidrBird
//
//  Created by Zachary Glazer on 3/7/15.
//  Copyright (c) 2015 Zachary Glazer. All rights reserved.
//

#import "UpcomingAuction.h"

@implementation UpcomingAuction

- (id) initWithItems:(NSArray*)items name:(NSString*)name auctionID:(NSString *)auctionid picture:(UIImage*)picture {
    self->items = items;
    self->name = name;
    self->picture = picture;
    self->auctionID = auctionid;
    
    return self;
}

- (NSMutableArray*) getItems {
    return self->items;
}

@end
