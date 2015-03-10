//
//  UpcomingAuctionItemViewController.h
//  BidrBird
//
//  Created by Zachary Glazer on 3/7/15.
//  Copyright (c) 2015 Zachary Glazer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Item.h"

@interface UpcomingAuctionItemViewController : UIViewController {
    Item *item;
}

- (id) initWithItem:(Item*)item;

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) IBOutlet UILabel *minBidLabel;

@end
