//
//  AppDelegate.m
//  SGPhotoBrowserDemo
//
//  Created by soulghost on 28/7/2016.
//  Copyright © 2016 soulghost. All rights reserved.
//

#import "AppDelegate.h"
#import "MyBrowserViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [MyBrowserViewController new];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
