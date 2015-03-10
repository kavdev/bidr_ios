//
//  ViewController.h
//  BidrBird
//
//  Created by Zachary Glazer on 11/20/14.
//  Copyright (c) 2014 Zachary Glazer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConstraintManager.h"
#import "NavigationController.h"
#import "HTTPRequest.h"

@interface LogInViewController : UIViewController <NSURLConnectionDelegate, NSURLConnectionDataDelegate, UIPopoverControllerDelegate> {
    NSMutableData *responseData;
}

//@property (strong, nonatomic) IBOutlet UIButton *loginButton;
//@property (strong, nonatomic) IBOutlet NSLayoutConstraint *loginHor;
//@property (strong, nonatomic) IBOutlet NSLayoutConstraint *loginVert;
@property (strong, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;

- (IBAction)logIn:(id)sender;
- (IBAction)dismissKeyboard:(id)sender;

@end

