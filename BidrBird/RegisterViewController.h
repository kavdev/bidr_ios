//
//  RegisterViewController.h
//  BidrBird
//
//  Created by Zachary Glazer on 12/2/14.
//  Copyright (c) 2014 Zachary Glazer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTTPRequest.h"
#import "NavigationController.h"

@interface RegisterViewController : UIViewController <NSURLConnectionDelegate, NSURLConnectionDataDelegate, UIPopoverControllerDelegate, UIScrollViewDelegate> {
    NSMutableData *responseData;
}

@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UITextField *confirmPasswordTextField;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic) NSString *token;
@property (strong, nonatomic) IBOutlet UIView *loadingView;
@property (weak, nonatomic) UITextField *activeField;
@property (strong, nonatomic) IBOutlet UITextField *displayNameTextField;

- (IBAction)goToLogIn:(id)sender;
- (IBAction)registerNewUser:(id)sender;
- (IBAction)dismissKeyboard:(id)sender;
- (IBAction)textFieldDidBeginEditing:(UITextField *)sender;
- (IBAction)textFieldDidEndEditing:(UITextField *)sender;


@end
