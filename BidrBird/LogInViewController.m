//
//  ViewController.m
//  BidrBird
//
//  Created by Zachary Glazer on 11/20/14.
//  Copyright (c) 2014 Zachary Glazer. All rights reserved.
//

#import "LogInViewController.h"

@interface LogInViewController ()

@end

@implementation LogInViewController

- (void)viewDidLoad {
   [super viewDidLoad];
   
   //[ConstraintManager setHorDistancePercent:.5 forView:self.loginButton inView:self.view];
   //[ConstraintManager setVertDistancePercent:.5 forView:self.loginButton inView:self.view];
   
   // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
   [super didReceiveMemoryWarning];
   // Dispose of any resources that can be recreated.
}

- (IBAction)logIn:(id)sender {
    if (self.emailTextField.text.length > 0 && self.passwordTextField.text.length > 0) {
        NSString *post = [NSString stringWithFormat:@"email=%@&password=%@", self.emailTextField.text, self.passwordTextField.text];
        
        UIActivityIndicatorView  *spinner = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [spinner setCenter:self.view.center];
        [spinner setColor:[UIColor whiteColor]];
        spinner.tag  = 1;
        [self.view addSubview:spinner];
        [spinner startAnimating];
        self.loadingView.hidden = false;
        [self dismissKeyboard:self];
        
        [HTTPRequest POST:post toExtension:@"auth/login/" delegate:self];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Missing Info" message:@"Please fill in all the boxes." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
    
    
    
//    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"navContoller"];
//    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
//    [self presentViewController:vc animated:YES completion:NULL];
}

- (IBAction)dismissKeyboard:(id)sender {
    [self.emailTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
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
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Something went wrong" message:@"Please try again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    
    if (responseData != nil) {
        [responseData setData:nil];
    }
}

// This method is used to process the data after connection has made successfully.
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSString *token;
    
    NSLog(@"Finished Loading");
    
    UIActivityIndicatorView *spinner = (UIActivityIndicatorView *)[self.view viewWithTag:1];
    [spinner stopAnimating];
    [spinner removeFromSuperview];
    self.loadingView.hidden = true;
    
    NSString* jsonString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:nil];
    NSLog(@"jsonString: %@", jsonString);
    if ([jsonDict objectForKey:@"auth_token"] != nil) {
        token = [jsonDict objectForKey:@"auth_token"];
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"navContoller"];
        ((NavigationController *) vc).userSessionInfo = [[UserSessionInfo alloc] init];
        ((NavigationController *) vc).userSessionInfo.auth_token = token;
        [HTTPRequest GET:@"" toExtension:@"auth/me/" withAuthToken:token delegate:vc];
        vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self presentViewController:vc animated:YES completion:NULL];
        NSLog(@"auth_token: %@", token);
    } else if([jsonDict objectForKey:@"non_field_errors"] != nil || [jsonDict objectForKey:@"email"] != nil) {
        NSString *errorString = [((NSArray*)[jsonDict objectForKey:@"non_field_errors"]) objectAtIndex:0];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid email or password" message:@"Unable to login with provided credentials" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Forgot password", nil];
        [alert show];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Server Error" message:@"There was a server error. Please try again later" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    
    [responseData setData:nil];
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    //dont do anything
}

@end
