//
//  NavigationController.m
//  BidrBird
//
//  Created by Zachary Glazer on 1/22/15.
//  Copyright (c) 2015 Zachary Glazer. All rights reserved.
//

#import "NavigationController.h"

@interface NavigationController ()

@end

@implementation NavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //[self.navigationBar setBackgroundColor:[UIColor colorWithRed:60 green:199 blue:97 alpha:1]];
    //[[UINavigationBar appearance] setBarTintColor: [UIColor colorWithRed:60.f/255.0 green:199.f/255.0 blue:97.f/255.0 alpha:1.0]];
    //[[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];

//    [[UINavigationBar appearance] setBackgroundImage: [UIImage imageNamed: @"bidr_bird.png"] forBarMetrics:UIBarMetricsDefault];
    
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
    
    if (responseData != nil) {
        [responseData setData:nil];
    }
    
    //do this even though it will not work in order to show the list
    NSString *extension = [NSString stringWithFormat:@"users/%@/auctions/", self.userSessionInfo.user_id];
    [HTTPRequest GET:@"" toExtension:extension withAuthToken:self.userSessionInfo.auth_token delegate:[self topViewController]];
}

// This method is used to process the data after connection has made successfully.
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSString *token;
    
    NSLog(@"Finished Loading");
    
    NSString* jsonString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:nil];
    NSLog(@"jsonString: %@", jsonString);
    
    if (![jsonDict objectForKey:@"ios_device_token_updated"] && ![jsonDict objectForKey:@"ios_device_token_not_updated"]) {
        NSString *name;
        NSString *phone;
        NSString *ID;
        NSString *email;
        
        if ([jsonDict objectForKey:@"name"]) {
            name = [jsonDict objectForKey:@"name"];
        }
        if ([jsonDict objectForKey:@"phone_number"]) {
            phone = [jsonDict objectForKey:@"phone_number"];
        }
        if ([jsonDict objectForKey:@"id"]) {
            ID = [NSString stringWithFormat:@"%@", [jsonDict objectForKey:@"id"]];
        }
        if ([jsonDict objectForKey:@"email"]) {
            email = [jsonDict objectForKey:@"email"];
        }
        
        [self.userSessionInfo initWithUserEmail:email userID:ID userName:name userPhoneNumber:phone];
        
        [responseData setData:nil];
        
        NSString *updateDeviceTokenextension = [NSString stringWithFormat:@"users/%@/update_ios_device_token/", self.userSessionInfo.user_id];
        
        NSString *put = [NSString stringWithFormat:@"ios_device_token=%@", ((AppDelegate *)[[UIApplication sharedApplication] delegate]).deviceToken];
        [HTTPRequest PUT:put toExtension:updateDeviceTokenextension withAuthToken:self.userSessionInfo.auth_token delegate:self];
        
        NSString *extension = [NSString stringWithFormat:@"users/%@/auctions/", self.userSessionInfo.user_id];
        [HTTPRequest GET:@"" toExtension:extension withAuthToken:self.userSessionInfo.auth_token delegate:[self topViewController]];
        ((AuctionsPageViewController *)self.topViewController)->userSessionInfo = self.userSessionInfo;
    }
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    if([[self.viewControllers lastObject] class] == [UpcomingAuctionTableViewController class] || 
       [[self.viewControllers lastObject] class] == [OngoingAuctionTableViewController class] || 
       [[self.viewControllers lastObject] class] == [CompleteAuctionTableViewController class]){
        
        return [self popToRootViewControllerAnimated:animated];
    } else {
        return [super popViewControllerAnimated:animated];
    }
}

@end
