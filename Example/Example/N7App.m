//
//  N7App.m
//  Example
//
//  Created by georgy.kasapidi on 08.05.17.
//  Copyright © 2017 N7. All rights reserved.
//

#import "N7App.h"

@interface N7App ()

@property (strong, nonatomic) N7Injector *injector;

@end

@implementation N7App

- (instancetype)init {
    self = [super init];

    if (self != nil) {
        _injector = [N7Injector new];
    }

    return self;
}

@end
