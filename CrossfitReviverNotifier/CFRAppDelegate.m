//
//  CFRAppDelegate.m
//  CrossfitReviverNotifier
//
//  Created by Matt Chowning on 3/20/14.
//  Copyright (c) 2014 Matt Chowning. All rights reserved.
//

#import "CFRAppDelegate.h"
#import "CFRUpdater.h"
#import "CFRMainTableViewController.h"

@implementation CFRAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    CFRMainTableViewController *tableController = [[CFRMainTableViewController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:tableController];
    self.window.rootViewController = navController;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    [[UIApplication sharedApplication]
                setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    
    
    return YES;
}

-(void)application:(UIApplication *)application
        performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    NSLog(@"Background fetch initiated");
    
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.alertBody = @"Background fetch method called";
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    
    completionHandler(UIBackgroundFetchResultNoData);
}

@end
