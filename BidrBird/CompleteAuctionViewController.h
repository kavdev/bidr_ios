//
//  CompleteAuctionViewController.h
//  BidrBird
//
//  Created by Zachary Glazer on 12/2/14.
//  Copyright (c) 2014 Zachary Glazer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConstraintManager.h"
#import "Item.h"

@interface CompleteAuctionViewController : UIViewController {
   NSArray *boughtItems;
}

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

- (void) setUpPage;

@end
