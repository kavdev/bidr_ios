//
//  OngoingAuctionItemViewController.m
//  BidrBird
//
//  Created by Zachary Glazer on 12/2/14.
//  Copyright (c) 2014 Zachary Glazer. All rights reserved.
//

#import "OngoingAuctionItemViewController.h"

@interface OngoingAuctionItemViewController ()

@end

@implementation OngoingAuctionItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.imageView.image = self->item.getPicture;
    self.currentBidLabel.text = [NSString stringWithFormat:@"Current Bid: $ %.2lf", self->item.getHightestBid];
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

- (IBAction)placeBid:(id)sender {
    float bidAmount = [self.makeBidTextField.text floatValue];
    NSString *post = [NSString stringWithFormat:@"amount=%.2lf&user=%@&item_id=%d", bidAmount, ((NavigationController*)self.navigationController).user_id, self->item->itemID];
    
    NSString *exten = [NSString stringWithFormat:@"bids/create/"];
    
    [HTTPRequest POST:post toExtension:exten withAuthToken:((NavigationController*)self.navigationController).auth_token delegate:self];
}

- (IBAction)hideKeypad:(id)sender {
    [self.makeBidTextField resignFirstResponder];
    self.hidKeypadButton.hidden = true;
}

- (IBAction)startedEditing:(id)sender {
    self.hidKeypadButton.hidden = false;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    responseData = [[NSMutableData alloc] init];
}

// This method is used to receive the data which we get using post method.
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData*)data {
    NSLog(@"Received Data!");
    [responseData appendData:data];
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
   //dont do anything
}

// This method receives the error report in case of connection is not made to server.
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"FAIL");
    NSLog([error description]);
    
    if (responseData != nil) {
        [responseData setData:nil];
    }
}

// This method is used to process the data after connection has made successfully.
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"Finished Loading");
    
    NSString* jsonString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:nil];
    NSLog(@"jsonString: %@", jsonString);
    
    if ([jsonDict objectForKey:@"current_highest_bid"] != nil) {
        NSString *moneyString = [jsonDict objectForKey:@"current_highest_bid"];
        NSString *message = [NSString stringWithFormat:@"Your bid must be greater than the current highest bid of %@.", moneyString];
        moneyString = [moneyString substringFromIndex:1];
        double highest = [moneyString doubleValue];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Bid too low" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        self->item->highestBid = highest;
        self.currentBidLabel.text = [NSString stringWithFormat:@"Current Bid: $ %.2lf", self->item.getHightestBid];
        [alert show];
    } else if ([jsonDict objectForKey:@"amount"] != nil) {
        double highest = [(NSNumber*)[jsonDict objectForKey:@"amount"] doubleValue];
        NSString *message = [NSString stringWithFormat:@"You now have the highest bid on this item at $%.2lf!", highest];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"New highest bid!" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        self->item->highestBid = highest;
        self.currentBidLabel.text = [NSString stringWithFormat:@"Current Bid: $ %.2lf", self->item.getHightestBid];
        [alert show];
    }
    
    [responseData setData:nil];
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
