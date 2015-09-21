//
//  SXCenterLineLabel.m
//  88 - SX团购HD
//
//  Created by 董 尚先 on 15/2/7.
//  Copyright (c) 2015年 shangxianDante. All rights reserved.
//

#import "SXCenterLineLabel.h"

@implementation SXCenterLineLabel

- (void)drawRect:(CGRect)rect
{
    // 调用super的目的，保留之前绘制的文字
    [super drawRect:rect];
    
    // 画矩形
    CGFloat x = 0 + rect.origin.x;
    CGFloat y = rect.size.height * 0.4 + rect.origin.y;
    CGFloat w = rect.size.width;
    CGFloat h = 1;
    UIRectFill(CGRectMake(x, y, w, h));
}

- (void)drawLine:(CGRect)rect
{
    // 最原始方法两点划线
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 1.起点
    CGFloat startX = 0;
    CGFloat startY = rect.size.height * 0.5;
    CGContextMoveToPoint(ctx, startX, startY);
    
    // 2.终点
    CGFloat endX = rect.size.width;
    CGFloat endY = startY;
    CGContextAddLineToPoint(ctx, endX, endY);
    
    // 3.绘图渲染
    CGContextStrokePath(ctx);
}


@end
