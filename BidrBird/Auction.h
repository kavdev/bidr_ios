//
//  Auction.h
//  BidrBird
//
//  Created by Zachary Glazer on 3/7/15.
//  Copyright (c) 2015 Zachary Glazer. All rights reserved.
//




/* 
   Do not instanciate this class.  
   It is an abstract class and should be treated as such.
*/
#ifndef BidrBird_Auction_h
#define BidrBird_Auction_h

#import <UIKit/UIKit.h>

@interface Auction : NSObject {
    NSString *name;
    UIImage *picture;
    NSString *auctionID;
}

-(id) initWithName:(NSString*)name auctionID:(NSString *)auctionid picture:(UIImage*)picture;

- (NSString*) getName;
- (UIImage*) getPicture;
- (NSString*) getAuctionID;

@end

#endif
