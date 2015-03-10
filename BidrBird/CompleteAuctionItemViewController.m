//
//  CompleteAuctionItemViewController.m
//  BidrBird
//
//  Created by Zachary Glazer on 12/2/14.
//  Copyright (c) 2014 Zachary Glazer. All rights reserved.
//

#import "CompleteAuctionItemViewController.h"

@interface CompleteAuctionItemViewController ()

@end

@implementation CompleteAuctionItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
   self.imageView.image = self->item.getPicture;
   self.wonForLabel.text = [NSString stringWithFormat:@"Won for: $ %.2f", self->item.getHightestBid];
   self.descriptionLabel.text = self->item.getDescription;
   
   UINavigationController *navCon  = (UINavigationController*) [self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers indexOfObject:self]];
   navCon.navigationItem.title = self->item.getName;
   
    // Do any additional setup after loading the view.
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
