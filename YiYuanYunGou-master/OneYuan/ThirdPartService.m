//
//  ThirdPartService.m
//  OneYuan
//
//  Created by kingcodexl on 15/9/8.
//  Copyright (c) 2015年 Peter. All rights reserved.
//  在load方法中加载第三方库,如友盟，推送.模块和服务完全分开
//  比如定位也可以在这里设置

#import "ThirdPartService.h"
#import "MobClick.h"
#import "APService.h"
#import "MobClickSocialAnalytics.h"
#import "UMFeedback.h"
#import "UMRecorder.h"
@implementation ThirdPartService

+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [UMFeedback setAppkey:@""];
        [UMRecorder setVersion:1.0];
        [MobClick setAppVersion:@""];
        
        [APService setVersion:1.0];
        NSLog(@"第三方配置完成");
    });
}
@end
