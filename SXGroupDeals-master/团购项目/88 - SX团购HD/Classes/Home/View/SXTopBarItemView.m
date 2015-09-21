//
//  SXTopBarItemView.m
//  88 - SX团购HD
//
//  Created by 董 尚先 on 15/2/4.
//  Copyright (c) 2015年 shangxianDante. All rights reserved.
//

#import "SXTopBarItemView.h"


@interface SXTopBarItemView ()
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblSubtitle;
@property (weak, nonatomic) IBOutlet UIButton *btnIcon;

@end
@implementation SXTopBarItemView

/** 通过xib加载快速返回一个item */
+ (instancetype)item
{
    return [[[NSBundle mainBundle] loadNibNamed:@"SXTopBarItemView" owner:nil options:nil] firstObject];
}

- (void)awakeFromNib
{
    // 把系统默认的自动伸缩给关闭
    self.autoresizingMask = UIViewAutoresizingNone;
}

#pragma mark - ******************** 三个个set方法
- (void)setTitle:(NSString *)title
{
    self.lblTitle.text = title;
}
- (void)setSubtitle:(NSString *)subtitle
{
    self.lblSubtitle.text = subtitle;
}

- (void)setIcon:(NSString *)imageName highIcon:(NSString *)highImageName
{
    [self.btnIcon setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [self.btnIcon setImage:[UIImage imageNamed:highImageName] forState:UIControlStateHighlighted];
}

/** 从外面设置点击事件 其实是button的，但一包装搞的好像是给view绑定了似得 */
- (void)addTarget:(id)targer action:(SEL)action // $$$$$
{
    [self.btnIcon addTarget:targer action:action forControlEvents:UIControlEventTouchUpInside];
}
@end
