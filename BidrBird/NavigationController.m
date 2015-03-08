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

// This method is used to receive the data which we get using post method.
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData*)data {
    NSString *token;
    
    NSLog(@"Received Data!");
    NSString* jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    NSLog(@"jsonString: %@", jsonString);
    if ([jsonDict objectForKey:@"name"]) {
        self.user_name = [jsonDict objectForKey:@"name"];
    }
    if ([jsonDict objectForKey:@"phone_number"]) {
        self.user_phone_number = [jsonDict objectForKey:@"phone_number"];
    }
    if ([jsonDict objectForKey:@"id"]) {
        self.user_id = [NSString stringWithFormat:@"%@", [jsonDict objectForKey:@"id"]];
    }
    if ([jsonDict objectForKey:@"email"]) {
        self.user_email = [jsonDict objectForKey:@"email"];
    }
}

// This method receives the error report in case of connection is not made to server.
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"FAIL");
    NSLog([error description]);
}

// This method is used to process the data after connection has made successfully.
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"Finished Loading");
    NSString *extension = [NSString stringWithFormat:@"users/%@/get-auctions-participating-in/", self.user_id];
    
    [HTTPRequest GET:@"" toExtension:extension withAuthToken:self.auth_token delegate:[self topViewController]];
}

@end
