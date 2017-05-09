//
//  N7DemoObject.m
//  Example
//
//  Created by georgy.kasapidi on 08.05.17.
//  Copyright © 2017 N7. All rights reserved.
//

#import "N7DemoObject.h"

@implementation N7DemoObject

@synthesize injector = _injector;
@synthesize urlSession = _urlSession;
@synthesize notificationCenter = _notificationCenter;

- (void)injector:(N7Injector *)injector didInjectDependency:(id<N7Injection>)dependency {
    NSLog(@"%@%@", NSStringFromSelector(_cmd), dependency);
}

- (void)dependenciesWereInjectedByInjector:(N7Injector *)injector {
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

@end
