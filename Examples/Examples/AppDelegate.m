//
//  AppDelegate.m
//  Examples
//
//  Created by Ben Guo on 10/1/14.
//  Copyright (c) 2015 Sum Labs. All rights reserved.
//

#import "AppDelegate.h"
#import "TableViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    TableViewController *tvc = [[TableViewController alloc] initWithStyle:UITableViewStylePlain];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:tvc];
    self.window.rootViewController = nc;
    [self.window makeKeyAndVisible];
    return YES;
}

@end
