//
//  WNXHeadCollectionReusableView.m
//  WNXHuntForCity
//
//  Created by MacBook on 15/7/7.
//  Copyright (c) 2015年 维尼的小熊. All rights reserved.
//  UICollectionView的headView

#import "WNXHeadCollectionReusableView.h"

@implementation WNXHeadCollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self setUI];
    }
    
    return self;
}

#pragma mark - 设置子控件
- (void)setUI{
    
    self.textLabel = [[UILabel alloc] init];
    self.lineView = [[UIView alloc] init];
    
    [self configUIData];
    [self configUIAdd];
}

//布局
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.textLabel.frame = self.bounds;
    
    self.lineView.frame = CGRectMake(40, 0, self.bounds.size.width - 80, 1);
}

//设置控件的属性
- (void)configUIData{
    
    self.textLabel.textColor = [UIColor grayColor];
    self.textLabel.font = [UIFont systemFontOfSize:20];
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    
    self.lineView.hidden = YES;
    self.lineView.backgroundColor = [UIColor lightGrayColor];
    self.lineView.alpha = 0.2;
    
}

//添加子视图
-(void)configUIAdd{
    
    [self addSubview:self.textLabel];
    
    [self addSubview:self.lineView];
    
}
@end
