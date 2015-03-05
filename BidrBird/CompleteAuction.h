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

@interface CompleteAuction : NSObject {
   NSArray *boughtItems;
   NSString *name;
   UIImage *picture;
    NSString *auctionID;
}

-(id) initWithBoughtItems:(NSArray*)items name:(NSString*)name auctionID:(NSString *)auctionid picture:(UIImage*)picture;
-(id) initWithName:(NSString*)name auctionID:(NSString *)auctionid picture:(UIImage*)picture;

- (NSArray*) getBoughtItems;
- (NSString*) getName;
- (UIImage*) getPicture;

@end

#endif
