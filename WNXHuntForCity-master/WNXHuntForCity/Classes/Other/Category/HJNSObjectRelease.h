//
//  HJNSObjectRelease.h
//  HJNSObjectRelease
//
//  Created by Haijiao on 14-10-13.
//  Copyright (c) 2014年 olinone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HJNSObjectRelease : NSObject


/**
 *  进行方法偷换，Swillize
 */
+ (void)createReleaseObserver;


/**
 *  如果有打印内容则为内存泄露
 */
+ (void)sendReleaseNotice;

@end
