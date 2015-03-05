//
//  Auction.m
//  BidrBird
//
//  Created by Zachary Glazer on 12/2/14.
//  Copyright (c) 2014 Zachary Glazer. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CompleteAuction.h"

@implementation CompleteAuction

- (id) initWithBoughtItems:(NSArray*)items name:(NSString*)name auctionID:(NSString *)auctionid picture:(UIImage*)picture {
   self->boughtItems = items;
   self->name = name;
   self->picture = picture;
    self->auctionID = auctionid;
   
   return self;
}

-(id) initWithName:(NSString*)name auctionID:(NSString *)auctionid picture:(UIImage*)picture {
    self->name = name;
    self->picture = picture;
    self->auctionID = auctionid;
    
    return self;
}

- (NSArray*) getBoughtItems {
   return self->boughtItems;
}

- (NSString*) getName {
   return self->name;
}

- (UIImage*) getPicture {
   return self->picture;
}

@end