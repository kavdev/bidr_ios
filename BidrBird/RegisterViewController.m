//
//  RegisterViewController.m
//  BidrBird
//
//  Created by Zachary Glazer on 12/2/14.
//  Copyright (c) 2014 Zachary Glazer. All rights reserved.
//

#import "RegisterViewController.h"

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.nameTextField addTarget:self action:@selector(textFieldTouched:) forControlEvents:UIControlEventEditingDidBegin];
    [self.emailTextField addTarget:self action:@selector(textFieldTouched:) forControlEvents:UIControlEventEditingDidBegin];
    [self.phoneNumberTextField addTarget:self action:@selector(textFieldTouched:) forControlEvents:UIControlEventEditingDidBegin];
    [self.passwordTextField addTarget:self action:@selector(textFieldTouched:) forControlEvents:UIControlEventEditingDidBegin];
    [self.confirmPasswordTextField addTarget:self action:@selector(textFieldTouched:) forControlEvents:UIControlEventEditingDidBegin];
    [self.scrollView setContentSize:CGSizeMake(320, 435)];
    
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

- (IBAction)goToLogIn:(id)sender {
   [self dismissViewControllerAnimated:TRUE completion:nil];
}

- (IBAction)registerNewUser:(id)sender {
    if (self.nameTextField.text.length > 0 && self.emailTextField.text.length > 0 && self.phoneNumberTextField.text.length > 0 && self.passwordTextField.text.length > 0 && self.confirmPasswordTextField.text.length > 0) {
        if ([self.passwordTextField.text isEqualToString:self.confirmPasswordTextField.text]) {
            
            NSString *post = [NSString stringWithFormat:@"name=%@&email=%@&phone_number=%@&password=%@", self.nameTextField.text, self.emailTextField.text, self.phoneNumberTextField.text, self.passwordTextField.text];
            
            [HTTPRequest POST:post toExtension:@"register" delegate:self];
        }
    }
}

- (IBAction)dismissKeyboard:(id)sender {
    [self.nameTextField resignFirstResponder];
    [self.emailTextField resignFirstResponder];
    [self.phoneNumberTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    [self.confirmPasswordTextField resignFirstResponder];
}

// This method is used to receive the data which we get using post method.
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData*)data {
    //NSString *token;
    
    NSLog(@"Received Data!");
    NSString* jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    NSLog(@"jsonString: %@", jsonString);
    
    if ([jsonDict objectForKey:@"token"] != nil) {
        self.token = [jsonDict objectForKey:@"token"];
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"navContoller"];
        vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self presentViewController:vc animated:YES completion:NULL];
        NSLog(@"token: %@", self.token);
    } else if ([jsonDict objectForKey:@"email"] != nil) {
        if ([((NSString *)[((NSArray*)[jsonDict objectForKey:@"email"]) objectAtIndex:0]) isEqualToString:@"This field must be unique."]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Email already in use" message:@"There is already an account using this email address.  Please use a different email address." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            NSLog(@"OOPS");
        }
    } else if ([jsonDict objectForKey:@"phone_number"] != nil) {
        if ([((NSString *)[((NSArray*)[jsonDict objectForKey:@"phone_number"]) objectAtIndex:0]) isEqualToString:@"The phone number entered is not valid."]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Phone Number not valid" message:@"Please enter a valid phone number." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            NSLog(@"OOPS");
        }
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Server Error" message:@"There was a server error. Please try again later" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        NSLog(@"OOPS");
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

- (void) textFieldTouched:(UITextField *) sender {
//    CGPoint pt;
//    CGRect rc = [sender bounds];
//    rc = [sender convertRect:rc toView:self.scrollView];
//    pt = rc.origin;
//    pt.x = self.scrollView.contentOffset.x;
//    //pt.y -= 60;
//    //pt.y -= 40 - pow(self.scrollView.zoomScale, 3.1371) * 15;
//    pt.y -= 100;
//    [self.scrollView setContentOffset:pt animated:YES];
}

@end
