//
//  UIBarButtonItem+Extension.h
//  88 - SX团购HD
//
//  Created by 董 尚先 on 15/2/4.
//  Copyright (c) 2015年 shangxianDante. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Extension)

/**
 *  通过设置一些属性返回一个item
 *
 *  @param image  普通状态下的图片名
 *  @param hImage 高亮状态下的图片名
 *  @param target 谁来监听事件
 *  @param action 调用什么方法
 *
 *  @return 返回item
 */
+ (instancetype)itemWithImage:(NSString *)image HightLightImage:(NSString *)hImage target:(id)target action:(SEL)action;

@end
