//
//  WNXSelectCityView.m
//  WNXHuntForCity
//  github:    https://github.com/ZhongTaoTian/WNXHuntForCity
//  项目讲解博客:http://www.jianshu.com/p/8b0d694d1c69
//  Created by MacBook on 15/6/30.
//  Copyright (c) 2015年 维尼的小熊. All rights reserved.
//

#import "WNXSelectCityView.h"
#import "WNXCityButton.h"
#import "WNXMenuButton.h"

#define WNXAnimateWithDuration 0.3

@interface WNXSelectCityView ()

//定义三个按钮
@property (nonatomic, strong) WNXMenuButton *fristBtn;
@property (nonatomic, strong) WNXMenuButton *secondBtn;
@property (nonatomic, strong) WNXMenuButton *thirdBtn;

//记录城市顺序数组
@property (nonatomic, strong) NSArray *ciciyNames;

@end

@implementation WNXSelectCityView

#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    
    return self;
}

- (void)awakeFromNib
{
    [self setUp];
}

#pragma mark - 创建button
- (void)setUp
{
    self.alpha = 0;
    
    _fristBtn = [WNXMenuButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:self.fristBtn];
    
    _secondBtn = [WNXMenuButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:_secondBtn];
    
    _thirdBtn = [WNXMenuButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:_thirdBtn];
}

#pragma mark - 类方法初始化,传入button（由xib创建）,得到具体的frame
+ (instancetype)selectCityViewWithCictyButton:(WNXCityButton *)cicytBtn
{
    //调用实例方法初始化，高度是4个
    WNXSelectCityView *view = [[self alloc] initWithFrame:CGRectMake(cicytBtn.frame.origin.x,
                                                                     cicytBtn.frame.origin.y,
                                                                     cicytBtn.bounds.size.width,
                                                                     cicytBtn.bounds.size.height * 4)];
    //配置城市按钮
    NSMutableArray *cictys = [NSMutableArray arrayWithArray:@[@"北京", @"上海", @"广州", @"深圳"]];

    //获得选中城市的title
    NSString *nowCicyt = [cicytBtn titleForState:UIControlStateNormal];
    
    //遍历数组，根据选中的button，交换对应在数组中的城市索引
    for (int i = 0; i < cictys.count; i++) {
        if ([cictys[i] isEqualToString:nowCicyt]) {
            
            [cictys exchangeObjectAtIndex:i withObjectAtIndex:0];
            break;
        }
    }
    
    //剪裁掉超出的部分
    view.layer.masksToBounds = YES;
    
    //设置圆角
    view.layer.cornerRadius = cicytBtn.layer.cornerRadius;
    view.backgroundColor = cicytBtn.backgroundColor;
    
    //给数据赋值
    view.ciciyNames = cictys;
    
    return view;
}

#pragma mark - 最好在这里进行frame计算 , 这里只适合一个一个布局。控件不能通过循环
- (void)layoutSubviews{
    [super layoutSubviews];
    /*
    //相同部分
    CGFloat W = self.bounds.size.width;
    CGFloat H = self.bounds.size.height / _ciciyNames.count;
    CGFloat X = 0;
    
    CGFloat margin = W * 0.15;
    CGFloat lineW = W - 2 * margin;
    CGFloat lineH = 1;
    
    self.fristBtn.frame = CGRectMake(X, 0, W, H);
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(margin, CGRectGetMaxY(self.fristBtn.frame), lineW, lineH)];
    
    CGFloat secondBtnY = CGRectGetMaxY(lineView.frame) + margin;
    self.secondBtn.frame = CGRectMake(X, secondBtnY, W, H);
    
    UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake(margin, CGRectGetMaxY(self.secondBtn.frame) + margin, lineW, H)];
    CGFloat thirdBtnY = CGRectGetMaxY(lineView2.frame) + margin;
    self.thirdBtn.frame = CGRectMake(X, thirdBtnY, W, H);
    
    [self addSubview:lineView];
    [self addSubview:lineView2];
    */
}

#pragma mark - 懒加载，给数组赋值的时候，设置button
- (void)setCiciyNames:(NSArray *)ciciyNames
{
    _ciciyNames = ciciyNames;
    
    for (int i = 1; i < ciciyNames.count; i++) {
        //注意这里的i-1 索引是从0开始的，参数从之前创建的button中，取出
        [self setButton:self.subviews[i-1] index:i];
    }
}

#pragma mark  - 整体布局，不再layoutsubvie中进行布局
//设置view内部按钮位置，根据传入的index，其实就是类似于索引来确定位置
- (void)setButton:(WNXMenuButton *)btn index:(int)index
{
    CGFloat btnW = self.bounds.size.width;
    //flow类型
    CGFloat btnH = self.bounds.size.height / _ciciyNames.count;
    CGFloat btnX = 0;
    CGFloat btnFY = btnH;

    //添加按钮之间的白线间隔
    CGFloat margin = btnW * 0.15;
    UIView *whiteLine = [[UIView alloc] initWithFrame:CGRectMake(btnX + margin,index * btnFY, btnW - 2 * margin, 1)];
    whiteLine.backgroundColor = [UIColor whiteColor];
    whiteLine.alpha = 0.3;
    [self addSubview:whiteLine];
    
    btn.frame = CGRectMake(btnX,index * btnFY, btnW, btnH);
    btn.backgroundColor = self.backgroundColor;
    [btn setTitle:_ciciyNames[index] forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
}

//将selectView添加到superview
- (void)showSelectViewToView:(UIView *)superView belowSubview:(UIView *)belowSubview
{
    [superView insertSubview:self belowSubview:belowSubview];
    
    [UIView animateWithDuration:WNXAnimateWithDuration animations:^{
        self.alpha = 0.75;
    }];
}

//移除selectView，通过设置透明度来达到隐藏的效果。添加渐变动画的效果。
- (void)hideSelectView
{
    [UIView animateWithDuration:WNXAnimateWithDuration animations:^{
        
        self.alpha = 0.0;
        
    } completion:^(BOOL finished) {
        //完成之后从父视图上移除
        [self removeFromSuperview];
        
    }];
}

//selectView内部按钮点击事件
- (void)btnClick:(WNXMenuButton *)sender
{
    //这里有点命名不规范，这是一个block，如果不为空，则调用
    if (self.changeCictyName) {
        //调用block，改变选择城市名称
        self.changeCictyName([sender titleForState:UIControlStateNormal]);
    }
}

@end
