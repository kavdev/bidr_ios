//
//  Bid.h
//  BidrBird
//
//  Created by Zachary Glazer on 3/8/15.
//  Copyright (c) 2015 Zachary Glazer. All rights reserved.
//

#ifndef BidrBird_Bid_h
#define BidrBird_Bid_h

#import <Foundation/Foundation.h>

@interface Bid : NSObject {
    @public
    double amount;
    int userID;
}

-(id) initWithAmount:(double)amount userID:(int)userID;

@end

#endif
