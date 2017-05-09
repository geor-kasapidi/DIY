//
//  N7AppDelegate.m
//  Example
//
//  Created by georgy.kasapidi on 08.05.17.
//  Copyright © 2017 N7. All rights reserved.
//

#import "N7AppDelegate.h"
#import "N7DemoObject.h"

@implementation N7AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    N7Injector *injector = [UIApplication sharedApplication].injector;

    N7DemoObject *obj = [N7DemoObject new];

    [injector registerInjectionTarget:obj];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [injector registerInjection:[NSURLSession sharedSession]];

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [injector registerInjection:[NSNotificationCenter defaultCenter]];

            __unused id _ = obj;
        });
    });

    return NO;
}

@end
