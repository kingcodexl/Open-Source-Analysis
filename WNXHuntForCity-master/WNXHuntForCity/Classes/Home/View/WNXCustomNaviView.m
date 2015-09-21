//
//  WNXCustomNaviView.m
//  WNXHuntForCity
//  github:    https://github.com/ZhongTaoTian/WNXHuntForCity
//  项目讲解博客:http://www.jianshu.com/p/8b0d694d1c69 
//  Created by MacBook on 15/7/6.
//  Copyright (c) 2015年 维尼的小熊. All rights reserved.
//  自定义导航条

#import "WNXCustomNaviView.h"
#import "WNXDoubleTextView.h"

@interface WNXCustomNaviView()

/** 导航条titileView */
@property (nonatomic, strong) WNXDoubleTextView *titleview;
/** 返回按钮 */
@property (nonatomic, strong) UIButton *backBtn;
/** 分享按钮 */
@property (nonatomic, strong) UIButton *sharedBtn;

@end

@implementation WNXCustomNaviView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setUI];
    }
    
    return self;
}

- (void)setUI{
    //添加返回按钮
    self.backBtn = [[UIButton alloc] init];
    [self.backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [self.backBtn addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.backBtn];
    
    //添加分享按钮
    self.sharedBtn = [[UIButton alloc] init];
    [_sharedBtn setImage:[UIImage imageNamed:@"btn_share_normal"] forState:UIControlStateNormal];
    [_sharedBtn addTarget:self action:@selector(sharedClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_sharedBtn];
    
    //设置导航条的titleView
    self.titleview = [[WNXDoubleTextView alloc] init];
    [self addSubview:_titleview];
}

#pragma mark -  在这里进行总体的布局
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat w = self.bounds.size.width;
    CGFloat h = self.bounds.size.height;
    
    self.backBtn.frame = CGRectMake(10, 27, 25, 25);
    self.sharedBtn.frame = CGRectMake(w - 34, 31, 24, 18);
    
    CGFloat titleW = w * 0.7;
    CGFloat titleX = (w - titleW) / 2;
    //在这里设置大小
    self.titleview.frame = CGRectMake(titleX, h * 0.25, titleW, h * 0.8);
}

//在设置model的时候，就把相关的控件需要显示的数据填充上去。这里的控件是需要model数据的
- (void)setHeadModel:(WNXHomeModel *)headModel
{
    _headModel = headModel;
    self.backgroundColor = [UIColor colorWithHexString:headModel.color alpha:1];
    
    [self.titleview setTitle:headModel.tag_name subTitle:headModel.section_count];
}

#pragma mark - 按钮点击 通知代理
- (void)backClick:(UIButton *)sender
{
    if([self.delegate respondsToSelector:@selector(customNaviViewBackButtonClick:)]){
        [self.delegate customNaviViewBackButtonClick:sender];
    }
}

- (void)sharedClick:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(customNaviViewSharedButtonClick:)]) {
        [self.delegate customNaviViewSharedButtonClick:sender];
    }

}

#pragma mark - 类方法，返回对象
+ (instancetype)customNavViewInitWithframe:(CGRect)frame model:(WNXHomeModel*)model{
    WNXCustomNaviView *navView = [[WNXCustomNaviView alloc]initWithFrame:frame];
    navView.headModel = model;
    return navView;
}
@end
