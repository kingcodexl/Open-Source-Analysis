//
//  WNXFoundCollectionViewCell.m
//  WNXHuntForCity
//
//  Created by MacBook on 15/7/7.
//  Copyright (c) 2015年 维尼的小熊. All rights reserved.
//  自定义UICollectionViewCell
/** 这个cell内部控件需要说明一下，其实一个自定义button就可以搞定，重新下btn内部的imageView和label的位置
    并且，定义textLabel的字体属性为NSAttributedString,就能实现2行文字和不一样的文字大小以及文字颜色，不过这里没采用。。
 */

#import "WNXFoundCollectionViewCell.h"

@interface WNXFoundCollectionViewCell ()

/** 图片按钮 */
@property (weak, nonatomic) IBOutlet UIButton *iconButton;
/** 大标题 */
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
/** 小标题 */
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;

@end

@implementation WNXFoundCollectionViewCell

+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *)indexPath
{
    //区别和tablecell的不同，这里不用判断是否为空，如果为空，因为已经注册了cell。所以系统会自动创建
    //取出cell，如果复用队列为空，系统自动创建WNXFoundCollectionViewCell
    WNXFoundCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"iconCell" forIndexPath:indexPath];

    return cell;
}


- (void)awakeFromNib
{
    //这里的点击事件可以为什么不直接用xib的方式创建了。为了区分xib和代码，让他们的指责分清。约定xib只负责创建控件，代码赋值其基本属性和事件。
    //给按钮添加点击事件，按钮完全拦截整个cell的点击事件
    [self.iconButton addTarget:self action:@selector(iconButtonClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)iconButtonClick:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(foundCollectionViewCell:)]) {
        [self.delegate foundCollectionViewCell:self];
    }
}

#pragma mark - 事件拦截
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    /*  拦截事件响应者，不论触发了cell中的哪个控件都交给iconButton来响应 */
    // 1.判断当前控件能否接收事件
    if (self.userInteractionEnabled == NO || self.hidden == YES || self.alpha <= 0.01) return nil;
    
    // 2. 判断点在不在当前控件
    if ([self pointInside:point withEvent:event] == NO) return nil;
    
    return self.iconButton;
}

//重写模型的set方法，由于不是手动创建，所以不用设置frame，只需要设置显示的内容
- (void)setFoundModel:(WNXFoundCellModel *)foundModel
{
    _foundModel = foundModel;
   
    [self.iconButton setImage:[UIImage imageNamed:foundModel.icon] forState:UIControlStateNormal];
    self.titleLabel.text = foundModel.title;
    self.subTitleLabel.text = foundModel.subTitle;
}


@end
