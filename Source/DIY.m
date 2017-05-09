//
//  DIY.m
//
//  Created by georgy.kasapidi on 08.05.17.
//  Copyright © 2017 N7. All rights reserved.
//

#import <objc/runtime.h>

#import "DIY.h"

@interface N7Injector ()

@property (strong, nonatomic) NSHashTable<id<N7Injection>> *injections;
@property (strong, nonatomic) NSHashTable<id<N7InjectionTarget>> *injectionTargets;

@end

@implementation N7Injector

n7_injection_impl(N7InjectorUsage, setInjector:)

- (instancetype)init {
    self = [super init];

    if (self != nil) {
        _injections = [NSHashTable weakObjectsHashTable];
        _injectionTargets = [NSHashTable weakObjectsHashTable];

        [_injections addObject:self];
    }

    return self;
}

- (NSString *)debugDescription {
    @synchronized (self) {
        return [NSString stringWithFormat:@"Injections: %@Targets: %@", self.injections.allObjects, self.injectionTargets.allObjects];
    }
}

#pragma mark -

- (void)registerInjection:(id<N7Injection>)injection {
    NSParameterAssert([injection conformsToProtocol:@protocol(N7Injection)]);

    @synchronized (self) {
        if ([self.injections containsObject:injection]) {
            return;
        }

        [self.injections addObject:injection];

        for (id<N7InjectionTarget> target in self.injectionTargets.allObjects) {
            if (![injection injectSelfToTarget:target]) {
                continue;
            }

            if ([target respondsToSelector:@selector(injector:didInjectDependency:)]) {
                [target injector:self didInjectDependency:injection];
            }

            if (![self __dependenciesWereInjectedToTarget:target]) {
                continue;
            }

            [self.injectionTargets removeObject:target];

            if ([target respondsToSelector:@selector(dependenciesWereInjectedByInjector:)]) {
                [target dependenciesWereInjectedByInjector:self];
            }
        }
    }
}

- (void)registerInjectionTarget:(id)target {
    NSParameterAssert([target conformsToProtocol:@protocol(N7InjectionTarget)]);

    @synchronized (self) {
        if ([self.injectionTargets containsObject:target]) {
            return;
        }

        for (id<N7Injection> injection in self.injections.allObjects) {
            if (![injection injectSelfToTarget:target]) {
                continue;
            }

            if ([target respondsToSelector:@selector(injector:didInjectDependency:)]) {
                [target injector:self didInjectDependency:injection];
            }
        }

        if (![self __dependenciesWereInjectedToTarget:target]) {
            [self.injectionTargets addObject:target];

            return;
        }

        if ([target respondsToSelector:@selector(dependenciesWereInjectedByInjector:)]) {
            [target dependenciesWereInjectedByInjector:self];
        }
    }
}

#pragma mark -

- (BOOL)__dependenciesWereInjectedToTarget:(id)obj {
    NSString *protoName = NSStringFromProtocol(@protocol(N7Injection));

    Class cls = [obj class];

    while (cls != Nil && cls != [NSObject class]) {
        uint propCount = 0;
        objc_property_t *props = class_copyPropertyList(cls, &propCount);

        for (uint i = 0; i < propCount; ++i) {
            objc_property_t prop = props[i];

            NSString *propAttrs = [NSString stringWithUTF8String:property_getAttributes(prop)];

            if ([propAttrs rangeOfString:protoName].location != NSNotFound) {
                NSString *propName = [NSString stringWithUTF8String:property_getName(prop)];

                if (![obj valueForKey:propName]) {
                    free(props);

                    return NO;
                }
            }
        }

        free(props);

        cls = class_getSuperclass(cls);
    }
    
    return YES;
}

@end
