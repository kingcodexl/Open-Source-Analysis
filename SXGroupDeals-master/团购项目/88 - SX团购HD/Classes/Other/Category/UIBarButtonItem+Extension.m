//
//  UIBarButtonItem+Extension.m
//  88 - SX团购HD
//
//  Created by 董 尚先 on 15/2/4.
//  Copyright (c) 2015年 shangxianDante. All rights reserved.
//

#import "UIBarButtonItem+Extension.h"

@implementation UIBarButtonItem (Extension)

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
+ (instancetype)itemWithImage:(NSString *)image HightLightImage:(NSString *)hImage target:(id)target action:(SEL)action
{
    UIButton *button = [[UIButton alloc]init];
    [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:hImage] forState:UIControlStateHighlighted];
[button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside]; // $$$$$
    // 结构体也可以这么赋值 大括号再强转
    // 这里没有用别的框架的原因是为了 让自己没有依赖拖过去就能用
    button.frame = (CGRect){CGPointZero,button.currentImage.size}; // $$$$$
    
    return [[self alloc]initWithCustomView:button];
    
}

@end
