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

- (id) initWithBoughItems:(NSArray*)items name:(NSString*)name picture:(UIImage*)picture {
   self->boughtItems = items;
   self->name = name;
   self->picture = picture;
   
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