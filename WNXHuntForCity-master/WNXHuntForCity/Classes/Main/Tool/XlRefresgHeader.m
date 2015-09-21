//
//  WNXRefresgHeader.m
//  WNXHuntForCity
//  github:    https://github.com/ZhongTaoTian/WNXHuntForCity
//  项目讲解博客:http://www.jianshu.com/p/8b0d694d1c69
//  Created by MacBook on 15/7/13.
//  Copyright (c) 2015年 维尼的小熊. All rights reserved.

#import "XlRefresgHeader.h"
#import "UIImage+Size.h"

@implementation XlRefresgHeader

#pragma mark - 重写方法
#pragma mark 基本设置
- (void)prepare
{
    [super prepare];
    /*
    // 设置普通状态的动画图片
    NSMutableArray *idleImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=50; i++) {
        NSString *imageName = [NSString stringWithFormat:@"loading_0%02zd", i];
        UIImage *image = [UIImage imageNamed:imageName];
        UIImage *newImage = [image imageByScalingToSize:CGSizeMake(40, 40)];
        [idleImages addObject:newImage];
    }
    [self setImages:idleImages forState:MJRefreshStateIdle];
    
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (NSUInteger i = 50; i<=50; i++) {
        NSString *imageName = [NSString stringWithFormat:@"loading_0%02zd", i];
        UIImage *image = [UIImage imageNamed:imageName];
        UIImage *newImage = [image imageByScalingToSize:CGSizeMake(40, 40)];
        [refreshingImages addObject:newImage];
    }
    [self setImages:refreshingImages forState:MJRefreshStatePulling];
    
    
    NSMutableArray *startImages = [NSMutableArray array];
    for (NSUInteger i = 80; i <= 95; i++) {
        NSString *imageName = [NSString stringWithFormat:@"loading_0%02zd", i];
        UIImage *image = [UIImage imageNamed:imageName];
        UIImage *newImage = [image imageByScalingToSize:CGSizeMake(40, 40)];
        [startImages addObject:newImage];
    }
    // 设置正在刷新状态的动画图片
    [self setImages:startImages forState:MJRefreshStateRefreshing];
    */
    
    [self rotateStartWith:0 end:50 state:MJRefreshStateIdle];
    [self rotateStartWith:50 end:50 state:MJRefreshStatePulling];
    [self rotateStartWith:80 end:95 state:MJRefreshStateRefreshing];
}

//重构
- (void)rotateStartWith:(NSUInteger) start end:(NSUInteger)end state:(MJRefreshState)state{
    NSMutableArray *imageArray = [NSMutableArray array];
    for (NSUInteger i = start; i <= end; i++) {
        NSString *imageName = [NSString stringWithFormat:@"loading_0%02zd",i];
        UIImage *image = [UIImage imageNamed:imageName];
        image = [image imageByScalingToSize:CGSizeMake(50, 50)];
        [imageArray addObject:image];
    }
    
    [self setImages:imageArray forState:state];
}


- (void)Xlprepare{
    [super prepare];
    NSUInteger idleLine = (NSUInteger )50;
    NSUInteger refreshLine = (NSUInteger )80;
    NSUInteger startLine = (NSUInteger )95;
    
    NSMutableArray *idleImages = [NSMutableArray array];
    for (NSUInteger  i = 0; i < idleLine; i++) {
        UIImage *image = [UIImage imageNamed:@""];
        [idleImages addObject:image];
    }
    
    [self setImages:idleImages forState:MJRefreshStateIdle];
    
    NSMutableArray *refresh = [NSMutableArray array];
    for (NSUInteger i = 0; i < refreshLine; i++) {
        UIImage *image = [UIImage imageNamed:@""];
        [refresh addObject:image];
    }
    [self setImages:refresh forState:MJRefreshStatePulling];
    
    NSMutableArray *start = [NSMutableArray array];
    for (NSUInteger i = 0; i < startLine; i++) {
        UIImage *image = [UIImage imageNamed:@""];
        [start addObject:image];
    }
    [self setImages:start forState:MJRefreshStateRefreshing];
    
}

@end
