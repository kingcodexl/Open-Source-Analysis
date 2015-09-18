//
//  LNWaterfallFlowCell.m
//  WaterfallFlowDemo
//
//  Created by Lining on 15/5/3.
//  Copyright (c) 2015年 Lining. All rights reserved.
//

#import "LNWaterfallFlowCell.h"
#import "LNGood.h"
#import "UIImageView+WebCache.h"

@interface LNWaterfallFlowCell ()
//私有，不向外界暴露
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *priceView;

@end

@implementation LNWaterfallFlowCell

//深拷贝，浅拷贝联系
- (id)copyWithZone:(NSZone *)zone{
    LNWaterfallFlowCell *cell = [[LNWaterfallFlowCell allocWithZone:zone]init];
    cell.iconView = self.iconView;
    cell.priceView = self.priceView;
    return cell;
}

//重写set方法，在赋值的时候给控件属性赋值
- (void)setGood1:(LNGood *)good {
    _good = good;
    NSURL *url = [NSURL URLWithString:good.img];
    [self.iconView sd_setImageWithURL:url];
    self.priceView.text = good.price;
    
}

- (void)setGood:(LNGood *)good{
    if (_good != good) {
        _good = good;
        NSURL *url = [NSURL URLWithString:good.img];
        [self.iconView sd_setImageWithURL:url];
        self.priceView.text = good.price;
    }
}
@end
