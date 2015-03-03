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
   
//   NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
//   [request setURL:[NSURL URLWithString:@"https://bidr-2.herokuapp.com/api/bids/?ordering=-amount"]];
//   [request setHTTPMethod:@"GET"];
//
//   NSURLResponse *requestResponse;
//   NSData *requestHandler = [NSURLConnection sendSynchronousRequest:request returningResponse:&requestResponse error:nil];
//   
//   NSString *requestReply = [[NSString alloc] initWithBytes:[requestHandler bytes] length:[requestHandler length] encoding:NSASCIIStringEncoding];
//   NSLog(@"requestReply: %@", requestReply);
//   NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:requestHandler options:kNilOptions error:nil];
//   //NSLog(@"jsonString: %@", jsonString);
//   NSArray *bids = [jsonDict objectForKey:@"results"];
//   if (bids.count > 0) {
//      NSDictionary* dic = [bids objectAtIndex:0];
//      str = [dic objectForKey:@"amount"];
//   }
   
   self.imageView.image = self->item.getPicture;
   [self loadHighestBid];
   //self.currentBidLabel.text = [NSString stringWithFormat:@"%@%@", @"Current Bid: $ ", str];
   self.conditionLabel.text = [NSString stringWithFormat:@"%@%@", @"Condition: ", self->item.getCondition];
   self.descriptionLabel.text = self->item.getDescription;
   
   UINavigationController *navCon  = (UINavigationController*) [self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers indexOfObject:self]];
   navCon.navigationItem.title = self->item.getName;
   
    // Do any additional setup after loading the view.
}

- (void) loadHighestBid {
   NSString *str = @"problem";
   
   NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
   [request setURL:[NSURL URLWithString:@"https://bidr-2.herokuapp.com/api/bids/?ordering=-amount"]];
   [request setHTTPMethod:@"GET"];
   
   NSURLResponse *requestResponse;
   NSData *requestHandler = [NSURLConnection sendSynchronousRequest:request returningResponse:&requestResponse error:nil];
   
   NSString *requestReply = [[NSString alloc] initWithBytes:[requestHandler bytes] length:[requestHandler length] encoding:NSASCIIStringEncoding];
   NSLog(@"requestReply: %@", requestReply);
   NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:requestHandler options:kNilOptions error:nil];
   //NSLog(@"jsonString: %@", jsonString);
   NSArray *bids = [jsonDict objectForKey:@"results"];
   if (bids.count > 0) {
      NSDictionary* dic = [bids objectAtIndex:0];
      str = [dic objectForKey:@"amount"];
   }
   
   self.currentBidLabel.text = [NSString stringWithFormat:@"%@%@", @"Current Bid: $ ", str];
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
   
   
   
   
//   NSString *queryString = [NSString stringWithFormat:@"http://www.posttestserver.com/post.php"];
//   NSMutableURLRequest *theRequest=[NSMutableURLRequest
//                                    requestWithURL:[NSURL URLWithString:
//                                                    queryString]
//                                    cachePolicy:NSURLRequestUseProtocolCachePolicy
//                                    timeoutInterval:60.0];
//   [theRequest setHTTPMethod:@"POST"];
//   //NSMutableData *body = [NSMutableData data];
//   //[body appendData:[[NSString stringWithFormat:@"Contestant1 %@ ",contestant1] dataUsingEncoding:NSUTF8StringEncoding]];
//   //[body appendData:[[NSString stringWithFormat:@"Contestant2 %@ ",contestant2] dataUsingEncoding:NSUTF8StringEncoding]];
//   //[theRequest setHTTPBody:body];
//   
//   NSDictionary *postDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%.2f",bidAmount], @"amount", @"https://bidr-2herokuapp.com/api/bidders/6/", @"user", nil];
//   
//   NSError *error=nil;
//   
//   NSData* jsonData = [NSJSONSerialization dataWithJSONObject:postDict
//                                                      options:NSJSONWritingPrettyPrinted error:&error];
//   [theRequest setHTTPBody:jsonData];
//
//   
//   
//   NSURLConnection *con = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
   
   
   
   
   
   
   
   
//   NSString *post = [NSString stringWithFormat:@"{'amount':'%.2f','user':'%@'}",bidAmount, @"https://bidr-2herokuapp.com/api/bidders/6/"];
//   
//   NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:true];
//   
//   NSString *postLength = [NSString stringWithFormat:@"%d",[postData length]];
//   
//   NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
//   
//   //[request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.posttestserver.com/post.php"]]];
//   [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://bidr-2.herokuapp.com/api/bids/"]]];
//   
//   [request setHTTPMethod:@"POST"];
//   
//   [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
//   
//   [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//   //[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
//   
//   [request setHTTPBody:postData];
//   
//   NSURLConnection *con = [[NSURLConnection alloc]initWithRequest:request delegate:self];
   
   
   
   
   
   
   NSString *post = [NSString stringWithFormat:@"amount=%.2f&user=%@", bidAmount, @"https://bidr-2herokuapp.com/api/bidders/6/"];
   NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
   NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[post length]];
   
   NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://bidr-2.herokuapp.com/api/bids/"]];
   
   [request setHTTPMethod:@"POST"];
   [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
   [request setHTTPBody:postData];
   
   NSURLConnection *con = [NSURLConnection connectionWithRequest:request delegate:self];
   
   if(con) {
      NSLog(@"Connection Successful");
   } else {
      NSLog(@"Connection could not be made");
   }
}

- (IBAction)hideKeypad:(id)sender {
   [self.makeBidTextField resignFirstResponder];
   self.hidKeypadButton.hidden = true;
}

- (IBAction)startedEditing:(id)sender {
   self.hidKeypadButton.hidden = false;
}

// This method is used to receive the data which we get using post method.
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData*)data {
   NSLog(@"Received Data!");
   NSString* jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
   NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
   NSLog(@"jsonString: %@", jsonString);
   
   if ([[jsonDict objectForKey:@"amount"] isKindOfClass:[NSString class]]) {
      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Bid complete" message:@"You now have the highest bid!" delegate:self cancelButtonTitle:@"WOOO!!" otherButtonTitles: nil];
      [alert show];
   } else if ([[((NSArray*)[jsonDict objectForKey:@"amount"]) objectAtIndex:0]  isEqual: @"Your bid must exceed the current bid amount."]) {
      NSLog(@"YES!!!");
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Bid too low" message:@"Your bid was not higher than the current max bid." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
         [alert show];
   }
   [self loadHighestBid];
   //NSLog(@"jsonString: %@", jsonString);
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
   //dont do anything
}

// This method receives the error report in case of connection is not made to server.
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
   NSLog(@"FAIL");
   NSLog([error description]);
}

// This method is used to process the data after connection has made successfully.
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
   NSLog(@"Finished Loading");
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
