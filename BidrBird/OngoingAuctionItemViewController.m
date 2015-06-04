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
    
    [self.makeBidTextField addTarget:self action:@selector(textFieldDidBeginEditing:) forControlEvents:UIControlEventEditingDidBegin];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
   
    self.imageView.image = self->item.getPicture;
    self.currentBidLabel.text = [NSString stringWithFormat:@"Highest Bid: $ %d", self->item.getHightestBid->amount];
    if (self->item->usersHighestBid) {
        self.lastBidLabel.text = [NSString stringWithFormat:@"Your Previous Bid: $ %d", self->item->usersHighestBid->amount];
    } else {
        self.lastBidLabel.text = [NSString stringWithFormat:@"Your Previous Bid: Unbid"];
    }
    self.descriptionTextView.text = self->item.getDescription;
    self.makeBidTextField.text = [NSString stringWithFormat:@"%d", self->item.getHightestBid->amount + self->minBidInc];
   
    UINavigationController *navCon  = (UINavigationController*) [self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers indexOfObject:self]];
    navCon.navigationItem.title = self->item.getName;
   
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id) initWithItem:(Item*)item fromAuctionWithID:(NSString *)auctionID userSessionInfo:(UserSessionInfo *)info minBidInc:(int)minBidInc{
    self->item = item;
    self->auctionID = auctionID;
    
    self->userSessionInfo = info;
    
    self->minBidInc = minBidInc;
    
   return self;
}

- (IBAction)placeBid:(id)sender {
    if ([self.makeBidTextField.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No bid entered" message:@"You must enter a bid amount to place a bid." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    } else {
        if ([self isNumeric:self.makeBidTextField.text]) {
            int bidAmount = [self.makeBidTextField.text intValue];
            if (bidAmount - self->item->highestBid->amount >= self->minBidInc) {
                NSString *post = [NSString stringWithFormat:@"amount=%d&user=%@&item_id=%d", bidAmount, self->userSessionInfo.user_id, self->item->itemID];
                
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
                
                [HTTPRequest POST:post toExtension:exten withAuthToken:self->userSessionInfo.auth_token delegate:self];
            } else if (bidAmount - self->item->highestBid->amount > 0) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Bid too low" message:[NSString stringWithFormat:@"Your bid must be bigger than the current highest bid by at least $ %d for this auction.", self->minBidInc] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                self.makeBidTextField.text = [NSString stringWithFormat:@"%d", self->item.getHightestBid->amount + self->minBidInc];
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Bid too low" message:[NSString stringWithFormat:@"Your bid must be greater than the current highest bid of %d.", self->item->highestBid->amount] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                self.makeBidTextField.text = [NSString stringWithFormat:@"%d", self->item.getHightestBid->amount + self->minBidInc];
            }
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Not a number" message:@"Please enter a properly formatted number." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            self.makeBidTextField.text = [NSString stringWithFormat:@"%d", self->item.getHightestBid->amount + self->minBidInc];
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
    
    if ([jsonDict objectForKey:@"current_highest_bid"] != nil && [jsonDict objectForKey:@"highest_bid_user_id"] != nil) {
        NSString *moneyString = [jsonDict objectForKey:@"current_highest_bid"];
        NSString *userID = [jsonDict objectForKey:@"highest_bid_user_id"];
        
        moneyString = [moneyString substringFromIndex:1];
        int highest = [moneyString intValue];
        
        self->item->highestBid->amount = highest;
        self->item->highestBid->userID = [userID intValue];
        [self.delegate replaceOngoingItemWithID:[@(self->item->itemID) stringValue] forAuctionWithID:auctionID withItem:self->item];
        self.currentBidLabel.text = [NSString stringWithFormat:@"Highest Bid: $ %d", self->item.getHightestBid->amount];
        
        if ([userID isEqualToString:self->userSessionInfo.user_id]) {
            Bid *highestBid = [[Bid alloc] initWithAmount:highest userID:[userID intValue] displayName:nil];
            [self.delegate replaceUsersHighestBidForItemWithID:[@(self->item->itemID) stringValue] forAuctionWithID:auctionID withBid:highestBid];
            self->item->usersHighestBid = highestBid;
            self.lastBidLabel.text = [NSString stringWithFormat:@"Your Previous Bid: $ %d", highest];
        }
        UIAlertView *alert;
        if ([jsonDict objectForKey:@"bid_increment_error"] != nil) {
            int minBidIncrement = [(NSNumber *)[jsonDict objectForKey:@"bid_increment_error"] intValue];
            self->minBidInc = minBidIncrement;
            alert = [[UIAlertView alloc] initWithTitle:@"Bid too low" message:[NSString stringWithFormat:@"Your bid must be bigger than the current highest bid by at least $ %d for this auction.", self->minBidInc] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            
            [self.delegate replaceMinBidIncrementForOngoingAuctionWithID:self->auctionID withMinBidInc:minBidIncrement];
        } else {
            NSString *message = [NSString stringWithFormat:@"Your bid must be greater than the current highest bid of %@.", moneyString];
            alert = [[UIAlertView alloc] initWithTitle:@"Bid too low" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        }
        self.makeBidTextField.text = [NSString stringWithFormat:@"%d", self->item.getHightestBid->amount + self->minBidInc];
        [alert show];
    } else if([jsonDict objectForKey:@"auction_over"] != nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Auction Over" message:@"This auction has ended. Please exit the auction and refresh the list to see the results." delegate:self cancelButtonTitle:@"Go Back" otherButtonTitles:nil];
        [alert show];
    } else if ([jsonDict objectForKey:@"amount"] != nil && [jsonDict objectForKey:@"user"] != nil) {
        int highest = [(NSNumber*)[jsonDict objectForKey:@"amount"] intValue];
        int userID = [(NSNumber*)[jsonDict objectForKey:@"user"] intValue];
        NSString *message = [NSString stringWithFormat:@"You now have the highest bid on this item at $%d!", highest];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"New highest bid!" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        self->item->highestBid->amount = highest;
        self->item->highestBid->userID = userID;
        [self.delegate replaceOngoingItemWithID:[@(self->item->itemID) stringValue] forAuctionWithID:auctionID withItem:self->item];
        self.currentBidLabel.text = [NSString stringWithFormat:@"Highest Bid: $ %d", self->item.getHightestBid->amount];
        
        if ([[@(userID) stringValue] isEqualToString:self->userSessionInfo.user_id]) {
            Bid *highestBid = [[Bid alloc] initWithAmount:highest userID:userID displayName:nil];
            [self.delegate replaceUsersHighestBidForItemWithID:[@(self->item->itemID) stringValue] forAuctionWithID:auctionID withBid:highestBid];
            self->item->usersHighestBid = highestBid;
            self.lastBidLabel.text = [NSString stringWithFormat:@"Your Previous Bid: $ %d", highest];
        }
        
        [alert show];
    }
    
    [responseData setData:nil];
}

-(bool) isNumeric:(NSString*) checkText{
    return [[checkText componentsSeparatedByString:@"."] count] == 1;
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];

    if ([title isEqualToString:@"Go Back"]) {
        [self.delegate auctionWithIDEnded:self->auctionID];
        [self.navigationController popToRootViewControllerAnimated:TRUE];
    }
}

- (IBAction)textFieldDidBeginEditing:(UITextField *)sender {
    self.activeField = sender;
}

- (IBAction)textFieldDidEndEditing:(UITextField *)sender {
    self.activeField = nil;
}

- (void) keyboardDidShow:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    CGRect kbRect = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    kbRect = [self.view convertRect:kbRect fromView:nil];
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbRect.size.height, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbRect.size.height;
    if (!CGRectContainsPoint(aRect, self.activeField.frame.origin)) {
        [self.scrollView scrollRectToVisible:self.activeField.frame animated:TRUE];
    }
}

- (void) keyboardWillBeHidden:(NSNotification *)notification {
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
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
