//
//  ViewController.m
//  BidrBird
//
//  Created by Zachary Glazer on 11/20/14.
//  Copyright (c) 2014 Zachary Glazer. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

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
        
        [HTTPRequest POST:post toExtension:@"login" delegate:self];
    }
    
    
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"navContoller"];
    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:vc animated:YES completion:NULL];
}

- (IBAction)dismissKeyboard:(id)sender {
    [self.emailTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
}

// This method is used to receive the data which we get using post method.
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData*)data {
    NSString *token;
    
    NSLog(@"Received Data!");
    NSString* jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    NSLog(@"jsonString: %@", jsonString);
    NSObject* thing = [jsonDict objectForKey:@"email"];
    NSObject* thing2 = [jsonDict objectForKey:@"none"];
    if ([jsonDict objectForKey:@"token"] != nil) {
        token = [jsonDict objectForKey:@"token"];
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"navContoller"];
        vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self presentViewController:vc animated:YES completion:NULL];
        //[self presentViewController:[[NavigationController alloc] init] animated:TRUE completion:nil];
        NSLog(@"token: %@", token);
    } else if([jsonDict objectForKey:@"non_field_errors"] != nil) {
        NSString *errorString = [((NSArray*)[jsonDict objectForKey:@"non_field_errors"]) objectAtIndex:0];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid email or password" message:errorString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Forgot password", nil];
        [alert show];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Server Error" message:@"There was a server error. Please try again later" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
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
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    //dont do anything
}

@end
