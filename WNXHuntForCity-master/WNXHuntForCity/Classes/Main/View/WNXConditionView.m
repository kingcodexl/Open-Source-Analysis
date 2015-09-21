//
//  WNXConditionView.m
//  WNXHuntForCity
//  github:    https://github.com/ZhongTaoTian/WNXHuntForCity
//  项目讲解博客:http://www.jianshu.com/p/8b0d694d1c69
//  Created by MacBook on 15/7/7.
//  Copyright (c) 2015年 维尼的小熊. All rights reserved.
//  选择查询条件的View (分类，地区，排序，地图)

#import "WNXConditionView.h"
//没有高亮状态的按钮
#import "WNXMenuButton.h"

//选择查询条件的的初始透明度
static const CGFloat WNXConditionViewAlpha = 0.8;
//button切换的时间
static const CGFloat WNXConditionViewDuration = 0.1;

@interface WNXConditionView ()

//分割线，通过颜色取代
@property (nonatomic, strong) UIView        *line1;
@property (nonatomic, strong) UIView        *line2;
@property (nonatomic, strong) UIView        *line3;
/** 记录选中按钮 */
@property (nonatomic, weak  ) WNXMenuButton *selectedBtn;

/** 分类按钮 */
@property (nonatomic, strong) WNXMenuButton *classifyBtn;
/** 地区按钮 */
@property (nonatomic, strong) WNXMenuButton *areaBtn;
/** 排序按钮 */
@property (nonatomic, strong) WNXMenuButton *sortBtn;
/** 地图按钮 */
@property (nonatomic, strong) WNXMenuButton *mapBtn;
/** 底部的view用来添加按钮和前四个按钮的 为了区分开listBtn */
@property (nonatomic, strong) UIView        *bottomView;

/** 列表按钮，当bottomView隐藏时显示出来 和bottomView在同一个父控件中 */
@property (nonatomic, strong) WNXMenuButton *listBtn;

@end

@implementation WNXConditionView

#pragma mark - 控制器初始化
//最好在initWithFrame和awakeFromNib都进行初始化设置
//init初始化方法会调用initWithFrame，而initWithFrame不会调用init
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}

//从nib文件加载
- (void)awakeFromNib
{
    [self setUp];
}
#pragma mark -
#pragma mark 最好是把控件的创建、属性设置、位置设置分开。但是这里只把位置设置分开了
#pragma mark - 创建子控件
//初始化，创建子控件
- (void)setUp
{
    //需要注意层级的关系
    self.backgroundColor = [UIColor clearColor];
    self.layer.masksToBounds = YES;
    
    //最底部的View
    self.bottomView = [[UIView alloc] init];
    self.bottomView.backgroundColor = WNXColor(50, 50, 50);
    self.bottomView.alpha = WNXConditionViewAlpha;
    [self addSubview:self.bottomView];
    
    //列表按钮
    _listBtn = [WNXMenuButton buttonWithType:UIButtonTypeCustom];
    _listBtn.tag = WNXConditionButtonTypeList;
    self.listBtn.layer.masksToBounds = YES;
    [_listBtn setTitle:@"列表" forState:UIControlStateNormal];
    [_listBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_listBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_listBtn setBackgroundColor:WNXColor(50, 50, 50)];
    _listBtn.alpha = 0;
    [self addSubview:self.listBtn];
    
    self.classifyBtn = [WNXMenuButton buttonWithType:UIButtonTypeCustom];
    self.areaBtn = [WNXMenuButton buttonWithType:UIButtonTypeCustom];
    self.sortBtn = [WNXMenuButton buttonWithType:UIButtonTypeCustom];
    self.mapBtn = [WNXMenuButton buttonWithType:UIButtonTypeCustom];
    
    //添加子控件
    [self addBtnWith:self.classifyBtn tag:WNXConditionButtonTypeClassify title:@"分类"];
    [self addBtnWith:self.areaBtn tag:WNXConditionButtonTypeArea title:@"地区"];
    [self addBtnWith:self.sortBtn tag:WNXConditionButtonTypeSort title:@"排序"];
    [self addBtnWith:self.mapBtn tag:WNXConditionButtonTypeMap title:@"地图"];
    
    //添加分割线
    self.line1 = [[UIView alloc] init];
    [self addLineWith:self.line1];
    self.line2 = [[UIView alloc] init];
    [self addLineWith:self.line2];
    self.line3 = [[UIView alloc] init];
    [self addLineWith:self.line3];
}

#pragma mark  - 子控件布局
//布局子控件————————把子控件布局放到layoutSubviews方法中，统一设置便于管理。
- (void)layoutSubviews
{
    [super layoutSubviews];
    //设置view的属性
    CGFloat H = self.bounds.size.height;
    CGFloat W = self.bounds.size.width;
    
    //设置圆角，通过层设置不是一种很高效的方法。高效通过上下文来做
    CGFloat cornerRadius = (H > W ? W : H) * 0.1;
    self.layer.cornerRadius = cornerRadius;
    self.listBtn.layer.cornerRadius = cornerRadius;
    
    //布局子控件，联想到自定义cell的部分方式，一个依赖一个
    
    //宽度最好还加上边距
    CGFloat btnW = W / 4;
    CGFloat btnH = H;
    
    //分割线
    CGFloat lineH = H * 0.4;
    CGFloat lineY = H * 0.3;
    
    self.bottomView.frame = self.bounds;
    
    self.classifyBtn.frame = CGRectMake(0, 0, btnW, btnH);
    self.line1.frame = CGRectMake(btnW, lineY, 1, lineH);
    
    self.areaBtn.frame = CGRectMake(btnW, 0, btnW, btnH);
    self.line2.frame = CGRectMake(2 * btnW, lineY, 1, lineH);
    
    self.sortBtn.frame = CGRectMake(2 * btnW, 0, btnW, btnH);
    self.line3.frame = CGRectMake(3 * btnW, lineY, 1, lineH);
    
    self.mapBtn.frame = CGRectMake(3 * btnW, 0, btnW, btnH);
    
    self.listBtn.frame = self.mapBtn.frame;
}

#pragma mark - 添加控件的具体内容，如按钮的点击事件，分割线等
//添加btn
- (void)addBtnWith:(WNXMenuButton *)btn tag:(NSInteger)tag title:(NSString *)title
{
    btn.tag = tag;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"selectBtn"] forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.bottomView addSubview:btn];
}

//添加分割线
- (void)addLineWith:(UIView *)line
{
    line.backgroundColor = [UIColor grayColor];
    line.alpha = 0.8;
    [self.bottomView addSubview:line];
}

//按钮的各种点击事件
- (void)btnClick:(WNXMenuButton *)sender
{
    //点击不同按钮，隐藏对应的分割线
    if(sender.tag == WNXConditionButtonTypeClassify) {
        self.line1.hidden = YES;
        self.line2.hidden = NO;
        self.line3.hidden = NO;
    } else if (sender.tag == WNXConditionButtonTypeArea) {
        self.line1.hidden = YES;
        self.line2.hidden = YES;
        self.line3.hidden = NO;
    } else if (sender.tag == WNXConditionButtonTypeSort) {
        self.line1.hidden = NO;
        self.line2.hidden = YES;
        self.line3.hidden = YES;
    } else if (sender.tag == WNXConditionButtonTypeMap) {
        self.line1.hidden = NO;
        self.line2.hidden = NO;
        self.line3.hidden = NO;
    }
    
    if (sender.tag != WNXConditionButtonTypeMap && sender.tag != WNXConditionButtonTypeList) {
        
        //点击了不同的按钮
        if (self.selectedBtn != sender) {
            //通知代理 第一种情况 前面3个按钮替换选择
            if ([self.delegate respondsToSelector:@selector(conditionView:didButtonClickFrom:to:)]) {
                [self.delegate conditionView:self didButtonClickFrom:self.selectedBtn.tag to:sender.tag];
            }
            
            //设置按钮选中状态，选中之后颜色会自动加深
            //联想自定义按钮，通过enbale属性来确定。通过切换图片来加深按钮
            self.selectedBtn.selected = NO;
            sender.selected = YES;
            self.selectedBtn = sender;
            
        } else {
            
            //点击同一按钮，则取消选择
            self.selectedBtn.selected = NO;
            [self showAllLine];
            self.selectedBtn = nil;
            //通知代理 第二种情况  选择了同样的按钮,取消选中。类似于退出
            if ([self.delegate respondsToSelector:@selector(conditionViewCancelSelectButton:)]) {
                 [self.delegate conditionViewCancelSelectButton:self];
            }
           
        }
        
    } else if (sender.tag == WNXConditionButtonTypeMap) {//如果点击的是地图
        //通知代理 第三种情况 选择了地图按钮
        if ([self.delegate respondsToSelector:@selector(conditionViewdidSelectedMap:)]) {
            [self.delegate conditionViewdidSelectedMap:self];
        }
        
        //显示分割线
        [self showAllLine];
        
        //取消当前选择按钮选择状态
        self.selectedBtn.selected = NO;
        //清空临时按钮记录
        self.selectedBtn = nil;
        
        //隐藏view显示列表按钮
        [UIView animateWithDuration:WNXConditionViewDuration animations:^{
            //隐藏底部bottomView
            self.bottomView.alpha = 0;
            
            //显示列表按钮,这时候才显示
            self.listBtn.alpha = WNXConditionViewAlpha;
        }];
        
    } else {
        //通知代理 第四种情况 列表按钮被点击了
        if ([self.delegate respondsToSelector:@selector(conditionViewdidSelectedList:)]) {
            [self.delegate conditionViewdidSelectedList:self];
        }
        
        //隐藏列表按钮，显示其他按钮
        [UIView animateWithDuration:WNXConditionViewDuration animations:^{
            self.bottomView.alpha = WNXConditionViewAlpha;
            self.listBtn.alpha = 0;
            [self showAllLine];
        }];
    }
    
}

//回到初始状态，当退出模糊视图的时候
- (void)cancelSelectedAllButton
{
    self.selectedBtn.selected = NO;
    [self showAllLine];
}

- (void)showAllLine
{
    self.line1.hidden = NO;
    self.line2.hidden = NO;
    self.line3.hidden = NO;
}

@end
