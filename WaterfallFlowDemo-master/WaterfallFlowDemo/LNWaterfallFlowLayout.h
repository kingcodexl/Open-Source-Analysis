//
//  LNWaterfallFlowLayout.h
//  WaterfallFlowDemo
//
//  Created by Lining on 15/5/3.
//  Copyright (c) 2015年 Lining. All rights reserved.
//  collectoinview 布局

#import <UIKit/UIKit.h>

@interface LNWaterfallFlowLayout : UICollectionViewFlowLayout

// 总列数
@property (nonatomic, assign) NSInteger columnCount;

// 商品数据数组  -》提供的是每个Item的高度和宽带。具体的x和y可以通过计算获得
@property (nonatomic, strong) NSArray *goodsList;

@end