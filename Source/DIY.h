//
//  DIY.h
//
//  Created by georgy.kasapidi on 08.05.17.
//  Copyright © 2017 N7. All rights reserved.
//

#import <Foundation/Foundation.h>

@class N7Injector;
@protocol N7Injection;

@protocol N7InjectionTarget <NSObject>

@optional

- (void)dependenciesWereInjectedByInjector:(N7Injector *)injector;

- (void)injector:(N7Injector *)injector didInjectDependency:(id<N7Injection>)dependency;

@end

@protocol N7Injection <NSObject>

- (BOOL)injectSelfToTarget:(id<N7InjectionTarget>)injectionTarget;

@end

@interface N7Injector : NSObject <N7Injection>

- (void)registerInjection:(id)injection; // N7Injection
- (void)registerInjectionTarget:(id)target; // N7InjectionTarget

@end

#define n7_injection_impl(proto, setter) \
        - (BOOL)injectSelfToTarget:(id<N7InjectionTarget>)injectionTarget { \
            if ([injectionTarget conformsToProtocol:@protocol(proto)]) { \
                [(id)injectionTarget performSelector:@selector(setter) withObject:self]; \
                return YES; \
            } \
            return NO; \
        }

#define n7_injection_impl_category(cls, proto, setter) \
        @interface cls (N7Injection) <N7Injection> \
        @end \
        @implementation cls (N7Injection) \
        n7_injection_impl(proto, setter) \
        @end

#define n7_injection_class_usage(cls, getter) \
        @class cls; \
        @protocol cls##Usage <N7InjectionTarget> \
        @property (weak, nonatomic) cls<N7Injection> *getter; \
        @end

#define n7_injection_protocol_usage(proto, getter) \
        @protocol proto; \
        @protocol proto##Usage <N7InjectionTarget> \
        @property (weak, nonatomic) id<proto, N7Injection> *getter; \
        @end

n7_injection_class_usage(N7Injector, injector)
