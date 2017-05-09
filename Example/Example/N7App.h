//
//  N7App.h
//  Example
//
//  Created by georgy.kasapidi on 08.05.17.
//  Copyright © 2017 N7. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface N7App : UIApplication
@end

@interface UIApplication (N7App)

@property (nonatomic, readonly) N7Injector *injector;

@end
