//
//  CompleteAuctionItemViewController.h
//  BidrBird
//
//  Created by Zachary Glazer on 12/2/14.
//  Copyright (c) 2014 Zachary Glazer. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "Item.h"

@interface CompleteAuctionItemViewController : UIViewController {
   Item *item;
}

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *wonForLabel;
@property (strong, nonatomic) IBOutlet UILabel *conditionLabel;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;

- (id) initWithItem:(Item*)item;

@end
