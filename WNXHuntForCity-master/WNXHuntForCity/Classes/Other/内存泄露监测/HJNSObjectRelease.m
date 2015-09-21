//
//  HJNSObjectRelease.h
//  HJNSObjectRelease
//
//  Created by Haijiao on 14-10-13.
//  Copyright (c) 2014年 olinone. All rights reserved.
//

#import "HJNSObjectRelease.h"
#import <UIKit/UIKit.h>
#import <objc/runtime.h>

static NSString * HJNSObjectNoticeName = @"HJNSObjectNoticeName";

//将当期类纳入内存监测泄露的监测的数组
static NSMutableArray * HJNSObjectArray;

@implementation NSObject (HJRelease)

//用于替换HJInit
- (instancetype)HJInit
{
    //增加观察者，当期类
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(HJReceiveReleaseNotice) name:HJNSObjectNoticeName object:nil];
    //偷换之后，这里其实是调用原理的[self init]方法
    return [self HJInit];
}


//接收到通知的处理方法，如点击监测按钮等
- (void)HJReceiveReleaseNotice
{
    //移除贯观察者，当期类
    [self HJRemoveObserver];
    //得到当期类的字符串
    NSString * strClass = NSStringFromClass([self class]);
    
    //返回当期类是否为动态加载
    if ([NSBundle bundleForClass:[self class]] != [NSBundle mainBundle]) {
        //判断是否为view类型，如果不是则返回
        if (![self isKindOfClass:[UIView class]]) {
            return;
        } else {
            UIView * superView = [(UIView *)self superview];
            //如果父视图为空则返回，只对view进行监测
            if (!superView) {
                return;
            }
            BOOL isCustomBundle = NO;
            do {
                isCustomBundle |= [NSBundle bundleForClass:[superView class]] == [NSBundle mainBundle];
                strClass = [strClass stringByAppendingFormat:@"->%@", NSStringFromClass([superView class])];
                superView = [superView superview];
            } while (superView && ![superView isMemberOfClass:[UIView class]]);
            
            if (!isCustomBundle) {
                return;
            }
        }
    }
    
    //如果监测数组不包含此对象，则将其增加到监测数组中
    if (![HJNSObjectArray containsObject:strClass]) {
        [HJNSObjectArray addObject:strClass];
    }
}

//用于和HJDealloc交换的方法
- (void)HJDealloc
{
    [self HJRemoveObserver];
    [self HJDealloc];
}

//移除通知
- (void)HJRemoveObserver
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:HJNSObjectNoticeName object:nil];
}

@end

@implementation HJNSObjectRelease

//方法偷换Swillize
+ (void)createReleaseObserver
{
#ifdef DEBUG
#if !__has_feature(objc_arc)
    
    Method ori_Method =  class_getInstanceMethod([NSObject class], @selector(init));
    Method HJ_Method = class_getInstanceMethod([NSObject class], @selector(HJInit));
    method_exchangeImplementations(ori_Method, HJ_Method);
    
    ori_Method =  class_getInstanceMethod([NSObject class], @selector(dealloc));
    HJ_Method = class_getInstanceMethod([NSObject class], @selector(HJDealloc));
    method_exchangeImplementations(ori_Method, HJ_Method);
    
#endif
#endif
}

//发送释放通知，如果有打印内容则为内存泄露
+ (void)sendReleaseNotice
{
#ifdef DEBUG
#if !__has_feature(objc_arc)
    
    @autoreleasepool {
        HJNSObjectArray = [NSMutableArray array];
        [[NSNotificationCenter defaultCenter] postNotificationName:HJNSObjectNoticeName object:nil];
        //在打印之前会先调用通知的处理方法。
        NSLog(@"HJNSObjectLeak: %@", HJNSObjectArray);
        [HJNSObjectArray removeAllObjects];
    }
    
#endif
#endif
}

@end
