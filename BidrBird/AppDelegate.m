//
//  AppDelegate.m
//  BidrBird
//
//  Created by Zachary Glazer on 11/20/14.
//  Copyright (c) 2014 Zachary Glazer. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {        
        UIUserNotificationSettings *settings =
        [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert |
         UIUserNotificationTypeBadge |
         UIUserNotificationTypeSound
                                          categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         UIRemoteNotificationTypeAlert |
         UIRemoteNotificationTypeBadge |
         UIRemoteNotificationTypeSound];
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
   // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
   // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
   // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
   // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
   // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
   // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
   // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *token = [deviceToken description];
    token = [token stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    self.deviceToken = token;
    NSLog(@"Did Register for Remote Notifications with Device Token (%@)", deviceToken);
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"Did Fail to Register for Remote Notifications");
    NSLog(@"%@, %@", error, error.localizedDescription);
}

//- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
//    NSLog(@"Did Receive Remote Notification, fetch completeion handler");
//}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"Did Receive Remote Notification");
//    if ([application applicationState] == UIApplicationStateInactive) {
//        
//    } else if ([application applicationState] == UIApplicationStateBackground) {
//        
//    } else if ([application applicationState] == UIApplicationStateActive) {
//        
//    }
    NSString *displayName = [userInfo objectForKey:@"display_name"];
    NSString *itemName = [userInfo objectForKey:@"item_name"];
    int amount = [(NSNumber *)[userInfo objectForKey:@"amount"] intValue];
    int itemID = [(NSNumber *)[userInfo objectForKey:@"item_id"] intValue];
    int aucitonID = [(NSNumber *)[userInfo objectForKey:@"auct_id"] intValue];
                  
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"You've been outbid!" message:[NSString stringWithFormat:@"%@ outbid you on the item \"%@\" with a bid of $%d.", displayName, itemName, amount] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

@end
