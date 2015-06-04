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
    int amount;
    int userID;
    NSString *displayName;
}

-(id) initWithAmount:(int)amount userID:(int)userID displayName:(NSString *)displayName;

@end

#endif
