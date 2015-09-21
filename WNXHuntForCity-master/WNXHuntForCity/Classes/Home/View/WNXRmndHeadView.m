//
//  WNXRmndHeadView.m
//  WNXHuntForCity
//  github:    https://github.com/ZhongTaoTian/WNXHuntForCity
//  项目讲解博客:http://www.jianshu.com/p/8b0d694d1c69
//  Created by MacBook on 15/7/2.
//  Copyright (c) 2015年 维尼的小熊. All rights reserved.
//  推荐tableView headView

#import "WNXRmndHeadView.h"
#import "UIColor+WNXColor.h"

//不对外暴露属性
@interface WNXRmndHeadView ()

//分类名
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

//数量
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;

@end

@implementation WNXRmndHeadView

//返回一个实例对象，注意并不是单例
+ (instancetype)headViewWith:(WNXHomeModel *)headModel
{
    WNXRmndHeadView *headView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;[[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil]lastObject];
    
    headView.headModel = headModel;
    
    return headView;
}

//分开写比较好，还是写这种吧
- (void)setHeadModel:(WNXHomeModel *)headModel
{
    _headMode = headModel;
    self.titleLabel.text = headModel.tag_name;
    self.subTitleLabel.text = headModel.section_count;
    self.backgroundColor = [UIColor colorWithHexString:headModel.color alpha:1];
}

@end
