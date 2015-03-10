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
   NSString *idString = self.auctionIDTextEditor.text;
   NSString *password = self.passwordTextEditor.text;
   
   //check if auction is real
    int idnum = [idString intValue];
    if (idnum != NAN) {
        NSString *extenstion = [NSString stringWithFormat:@"auctions/%d/participants/add/", idnum];
        NSString *put;
        if (password.length > 0) {
            put = [NSString stringWithFormat:@"user_email=%@&optional_password=%@", ((NavigationController *)self.parentViewController).user_email, password];
        } else {
            put = [NSString stringWithFormat:@"user_email=%@", ((NavigationController *)self.parentViewController).user_email];
        }
    
        [HTTPRequest PUT:put toExtension:extenstion withAuthToken:((NavigationController *)self.parentViewController).auth_token delegate:self];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    responseData = [[NSMutableData alloc] init];
}

// This method is used to receive the data which we get using post method.
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData*)data {
    NSString *token;
    
    NSLog(@"Received Data!");
    [responseData appendData:data];
    
    NSString* jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    NSLog(@"jsonString: %@", jsonString);
    if ([jsonDict objectForKey:@"participant_added"] != nil) {
        NSString *name;
        NSString *auctionid;
        int stage;
        if ([jsonDict objectForKey:@"name"] != nil) {
            name = [jsonDict objectForKey:@"name"];
        }
        if ([jsonDict objectForKey:@"id"] != nil) {
            auctionid = [NSString stringWithFormat:@"%@", [jsonDict objectForKey:@"id"]];
        }
        if ([jsonDict objectForKey:@"stage"] != nil) {
            UIViewController * vc;
            NSString * storyboardName = @"Main";
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
            Auction *auction;
            
            if ([((NSNumber *)[jsonDict objectForKey:@"stage"]) intValue] == 0) {
                auction = [[UpcomingAuction alloc] initWithName:name auctionID:auctionid picture:nil];
                vc = [storyboard instantiateViewControllerWithIdentifier:@"UpcomingAuctionTableViewController"];
                vc = [(UpcomingAuctionTableViewController*)vc initWithAuction:(UpcomingAuction*)auction navigationController:(NavigationController*)self.navigationController];
            } else if ([((NSNumber *)[jsonDict objectForKey:@"stage"]) intValue] == 1) {
                auction = [[OngoingAuction alloc] initWithName:name auctionID:auctionid picture:nil];
                vc = [storyboard instantiateViewControllerWithIdentifier:@"OngoingAuctionTableViewController"];
                vc = [(OngoingAuctionTableViewController*)vc initWithAuction:(OngoingAuction*)auction navigationController:(NavigationController*)self.navigationController];
            } else {
                auction = [[CompleteAuction alloc] initWithName:name auctionID:auctionid picture:nil];
                vc = [storyboard instantiateViewControllerWithIdentifier:@"UpcomingAuctionTableViewController"];
                vc = [(CompleteAuctionTableViewController*)vc initWithAuction:(CompleteAuction*)auction navigationController:(NavigationController*)self.navigationController];
            }
            [self.navigationController pushViewController:vc animated:YES];
        }
    } else if ([jsonDict objectForKey:@"password_required"] != nil) {
        NSString *errorString = [jsonDict objectForKey:@"password_required"];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Password required" message:errorString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    } else if ([jsonDict objectForKey:@"password_incorrect"] != nil) {
        NSString *errorString = [jsonDict objectForKey:@"password_incorrect"];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Incorrect password" message:errorString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    } else if ([jsonDict objectForKey:@"detail"] != nil) {
        NSString *message = [jsonDict objectForKey:@"detail"];
        if ([message isEqualToString:@"Not found"]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid auction ID" message:@"There is no auction with that ID." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Server Error" message:@"There was a server error. Please try again later" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
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
    
    
    
    [responseData setData:nil];
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    //dont do anything
}

@end
