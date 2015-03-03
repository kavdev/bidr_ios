//
//  CompleteAuctionViewController.m
//  BidrBird
//
//  Created by Zachary Glazer on 12/2/14.
//  Copyright (c) 2014 Zachary Glazer. All rights reserved.
//

#import "CompleteAuctionViewController.h"

@interface CompleteAuctionViewController ()

@end

@implementation CompleteAuctionViewController

- (void)viewDidLoad {
   [super viewDidLoad];
   [self setUpPage];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void) setUpPage {
   UIView* lastView = nil;
   
   NSString* imageName = [[NSBundle mainBundle] pathForResource:@"Chair" ofType:@"jpg"];
   //self->boughtItems = [NSArray arrayWithObject:[[Item alloc] initWithName:@"Sock" description:@"A Sock" highestBid:0 condition:@"Used" picture:[[UIImage alloc] initWithContentsOfFile:imageName]]];
   self->boughtItems = [NSArray arrayWithObjects:[[Item alloc] initWithName:@"Sock" description:@"A Sock" highestBid:0 condition:@"Used" picture:[[UIImage alloc] initWithContentsOfFile:imageName] itemID:1],[[Item alloc] initWithName:@"Sock2" description:@"Another Sock" highestBid:0 condition:@"Used" picture:[[UIImage alloc] initWithContentsOfFile:imageName] itemID:2] ,nil];
   [self.scrollView setBackgroundColor:[UIColor yellowColor]];
   
   for (int count = 0; count < self->boughtItems.count; count++) {
      Item *item = self->boughtItems[count];
      UIView *view = [[UIView alloc] init];
      UIImageView *imageView = [[UIImageView alloc] initWithImage:item.getPicture];
      UILabel *nameLabel = [[UILabel alloc] init];
      
      view.translatesAutoresizingMaskIntoConstraints = false;
      [view setBounds:CGRectMake(0, 0, 5, 5)];
      //[view setBackgroundColor:[UIColor blackColor]];
      [self.scrollView addSubview:view];
      
      [ConstraintManager setWidthPercent:.95 forView:view inView:self.scrollView plusConstant:0];
      [ConstraintManager setHeightPercent:0.0 forView:view inView:self.scrollView plusConstant:60];
      [ConstraintManager setHorDistancePercent:.5 forView:view inView:self.scrollView plusConstant:0];
      if (count == 0) {
         [ConstraintManager setTopDistance:30 forView:view inView:self.scrollView];
      } else {
         [ConstraintManager setTopDistance:15 forView:view fromView:lastView inView:self.scrollView];
      }
      lastView = view;
      
      
      imageView.translatesAutoresizingMaskIntoConstraints = false;
      [imageView setBounds:CGRectMake(0, 0, 5, 5)];
      [view addSubview:imageView];
      [ConstraintManager setHeightPercent:1.0 forView:imageView inView:view plusConstant:0];
      [view addConstraint:[NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0]];
      [ConstraintManager setTopDistance:0 forView:imageView inView:view];
      [ConstraintManager setLeftDistance:0 forView:imageView inView:view];

      nameLabel.translatesAutoresizingMaskIntoConstraints = false;
      [nameLabel setBounds:CGRectMake(0, 0, 5, 5)];
      [nameLabel setText:item.getName];
      [nameLabel setFont:[UIFont systemFontOfSize:17]];
      [nameLabel setTextAlignment:NSTextAlignmentCenter];
      [view addSubview:nameLabel];
      [ConstraintManager setLeftDistance:0 forView:nameLabel fromView:imageView inView:view];
      [ConstraintManager setRightDistance:0 forView:nameLabel inView:view];
   }
}

@end
