//
//  UIViewController+AOP.m
//  OneYuan
//
//  Created by kingcodexl on 15/9/8.
//  Copyright (c) 2015年 Peter. All rights reserved.
//
#warning  运行时 改变一下方法 做一些切面编程比如 统计 等等
// 黑魔法也非万能.像我们在导航控制器要封装手势 统一管理左侧返回按钮 ?这些东西 还是继承来得好

#import "UIViewController+AOP.h"
#import <objc/runtime.h>

#define GLOBAL_NAVIGATION_BAR_TIN_COLOR [UIColor redColor]
@implementation UIViewController (AOP)

+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        swizzleMethod([self class], @selector(viewDidAppear:), @selector(aop_viewDidAppear:));
        swizzleMethod([self class], @selector(viewWillAppear:), @selector(aop_viewWillAppear:));
        swizzleMethod([self class], @selector(viewWillDisappear:), @selector(aop_viewWillAppear:));
        swizzleMethod([self class], @selector(viewDidDisappear:), @selector(aop_viewWillDisappear:));
    });
}

/**
 *  黑魔法
 *
 *  @param class            作用的类
 *  @param originalSelector 原始选择器
 *  @param swizzledSelector 新选择器
 */
void swizzleMethod(Class class, SEL originalSelector, SEL swizzledSelector)   {
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    //将原始选择器指向新的执行，并添加
    BOOL didAddMethod =class_addMethod(class,
                                       originalSelector,
                                       method_getImplementation(swizzledMethod),
                                       method_getTypeEncoding(swizzledMethod));
    if (didAddMethod) {
        //将新选择器指向原始的执行
        class_replaceMethod(class,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
    
}

#pragma mark  - 需要偷换的方法
- (void)aop_viewDidAppear:(BOOL)animated {
    
    [self aop_viewDidAppear:animated];
}

-(void)aop_viewWillAppear:(BOOL)animated {
    
    [self aop_viewWillAppear:animated];
#ifndef DEBUG 如果在调试中
    [MobClick beginLogPageView:NSStringFromClass([self class])];
#endif
    
}

-(void)aop_viewWillDisappear:(BOOL)animated {
    
    [self aop_viewWillDisappear:animated];
#ifndef DEBUG
    [MobClick endLogPageView:NSStringFromClass([self class])];
#endif
    
}
- (void)aop_viewDidLoad {
    
    [self aop_viewDidLoad];if ([self isKindOfClass:[UINavigationController class]]) {    UINavigationController *nav = (UINavigationController *)self;
        nav.navigationBar.translucent = NO;
        nav.navigationBar.barTintColor = GLOBAL_NAVIGATION_BAR_TIN_COLOR;
        nav.navigationBar.tintColor = [UIColor whiteColor];
        
        NSDictionary *titleAtt = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
        [[UINavigationBar appearance] setTitleTextAttributes:titleAtt];
        [[UIBarButtonItem appearance]setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)

                                                            forBarMetrics:UIBarMetricsDefault];
    }//    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
}
@end
