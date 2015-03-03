//
//  NewAuctionViewController.m
//  BidrBird
//
//  Created by Zachary Glazer on 12/2/14.
//  Copyright (c) 2014 Zachary Glazer. All rights reserved.
//

#import "NewAuctionViewController.h"

@interface NewAuctionViewController ()

@end

@implementation NewAuctionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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

- (IBAction)connectToAuction:(id)sender {
   OngoingAuction *ongoingAuction = nil;
   UIViewController * vc;
   NSString *idString = self.auctionIDTextEditor.text;
   NSString *password = self.passwordTextEditor.text;
   
   //check if auction is real
   
   
   //ongoingAuction = //get from server
   
   if (ongoingAuction != nil) {
      NSString * storyboardName = @"Main";
      UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
      vc = [storyboard instantiateViewControllerWithIdentifier:@"OngoingAuctionTableViewController"];
      vc = [(OngoingAuctionTableViewController*)vc initWithBidOnItems:ongoingAuction.getBidOnItems otherItems:ongoingAuction.getOtherItems];
      [self.navigationController pushViewController:vc animated:YES];
   } else {
      //auction not valid
   }
}

@end
