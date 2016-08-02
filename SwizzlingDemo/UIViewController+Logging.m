//
//  UIViewController+Logging.m
//  SwizzlingDemo
//
//  Created by zhangchaojie on 16/8/2.
//  Copyright © 2016年 zhangchaojie. All rights reserved.
//

#import "UIViewController+Logging.h"
#import <objc/runtime.h>

@implementation UIViewController (Logging)


- (void)swizzled_viewDidAppear:(BOOL)animaled{
    
    //通过swizzling，这个方法与原始的viewDidAppear方法已经被交换了，所以调用这个方法，实际上是调用原始的viewDidAppear方法
    [self swizzled_viewDidAppear:animaled];
    
    NSLog(@"Run the method: swizzled_viewDidAppear");
}

- (void)swizzled_viewWillAppear:(BOOL)animaled{
    
    //通过swizzling，这个方法与原始的viewDidAppear方法已经被交换了，所以调用这个方法，实际上是调用原始的viewDidAppear方法
    [self swizzled_viewWillAppear:animaled];
    
    NSLog(@"Run the method: swizzled_viewWillAppear");
}

void swizzleMethod(Class class, SEL originalSelector, SEL newSelector){
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method newMethod = class_getInstanceMethod(class, newSelector);
    
    BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(newMethod), method_getTypeEncoding(newMethod));
    
    if (didAddMethod) {
        class_replaceMethod(class, newSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    }
    else{
        method_exchangeImplementations(originalMethod, newMethod);
    }
}

+ (void)load {
    swizzleMethod([self class], @selector(viewDidAppear:), @selector(swizzled_viewDidAppear:));
    swizzleMethod([self class], @selector(viewWillAppear:), @selector(swizzled_viewWillAppear:));
}

@end
