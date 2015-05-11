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
    if ([self.makeBidTextField.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No bid entered" message:@"You must enter bid amount to place a bid." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    } else {
        if ([self isNumeric:self.makeBidTextField.text]) {
            float bidAmount = [self.makeBidTextField.text floatValue];
            NSString *post = [NSString stringWithFormat:@"amount=%.2lf&user=%@&item_id=%d", bidAmount, ((NavigationController*)self.navigationController).userSessionInfo.user_id, self->item->itemID];
            
            NSString *exten = [NSString stringWithFormat:@"bids/create/"];
            
            UIActivityIndicatorView  *spinner = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            [spinner setCenter:self.view.center];
            [spinner setColor:[UIColor whiteColor]];
            spinner.tag  = 1;
            [self.view addSubview:spinner];
            [spinner startAnimating];
            self.loadingView.hidden = false;
            [self hideKeypad:self];
            [self.navigationController.navigationBar setUserInteractionEnabled:false];
            
            [HTTPRequest POST:post toExtension:exten withAuthToken:((NavigationController*)self.navigationController).userSessionInfo.auth_token delegate:self];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Not a number" message:@"Please enter a properly formatted number." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }
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
    
    UIActivityIndicatorView *spinner = (UIActivityIndicatorView *)[self.view viewWithTag:1];
    [spinner stopAnimating];
    [spinner removeFromSuperview];
    self.loadingView.hidden = true;
    [self.navigationController.navigationBar setUserInteractionEnabled:true];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Something went wrong" message:@"Please try again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    
    if (responseData != nil) {
        [responseData setData:nil];
    }
}

// This method is used to process the data after connection has made successfully.
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"Finished Loading");
    
    UIActivityIndicatorView *spinner = (UIActivityIndicatorView *)[self.view viewWithTag:1];
    [spinner stopAnimating];
    [spinner removeFromSuperview];
    self.loadingView.hidden = true;
    [self.navigationController.navigationBar setUserInteractionEnabled:true];
    
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

-(bool) isNumeric:(NSString*) checkText{
    return ([[checkText componentsSeparatedByString:@"."] count] - 1) < 2;
}

//-(void) viewWillDisappear:(BOOL)animated {
//    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
//        // back button was pressed.  We know this is true because self is no longer
//        // in the navigation stack.  
//        UIViewController *controller = self.navigationController.topViewController;
//        [((OngoingAuctionTableViewController *)self.navigationController.topViewController).refreshControl beginRefreshing];
//        [((OngoingAuctionTableViewController *)self.navigationController.topViewController) refresh];
//    }
//    [super viewWillDisappear:animated];
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
