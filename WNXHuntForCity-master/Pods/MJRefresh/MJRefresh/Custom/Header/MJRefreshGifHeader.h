//
//  MJRefreshGifHeader.h
//  MJRefreshExample
//
//  Created by MJ Lee on 15/4/24.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import "MJRefreshStateHeader.h"

@interface MJRefreshGifHeader : MJRefreshStateHeader

/** 设置state状态下的动画图片images 动画持续时间duration*/
- (void)setImages:(NSArray *)images duration:(NSTimeInterval)duration forState:(MJRefreshState)state;

/*!
 *  @author Kingcodexl, 15-08-12 10:08:58
 *
 *  @brief  为刷新状态设置加载图片
 *
 *  @param images 图片数组
 *  @param state  刷新的状态
 */
- (void)setImages:(NSArray *)images forState:(MJRefreshState)state;

@end
