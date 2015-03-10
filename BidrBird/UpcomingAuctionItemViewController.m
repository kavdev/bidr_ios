//
//  UpcomingAuctionItemViewController.m
//  BidrBird
//
//  Created by Zachary Glazer on 3/7/15.
//  Copyright (c) 2015 Zachary Glazer. All rights reserved.
//

#import "UpcomingAuctionItemViewController.h"

@interface UpcomingAuctionItemViewController ()

@end

@implementation UpcomingAuctionItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imageView.image = self->item.getPicture;
    self.minBidLabel.text = [NSString stringWithFormat:@"Minimum Bid: $ %.2lf", self->item->minBid];
    self.descriptionLabel.text = self->item.getDescription;
    
    UINavigationController *navCon  = (UINavigationController*) [self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers indexOfObject:self]];
    navCon.navigationItem.title = self->item.getName;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id) initWithItem:(Item*)item {
    self->item = item;
    
    return self;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
