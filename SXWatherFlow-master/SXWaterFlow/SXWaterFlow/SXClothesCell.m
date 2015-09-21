//
//  SXClothesCell.m
//  SXWaterFlow
//
//  Created by 董 尚先 on 15/3/21.
//  Copyright (c) 2015年 shangxianDante. All rights reserved.
//

#import "SXClothesCell.h"
#import "SXModels.h"
#import <UIImageView+WebCache.h>

@interface SXClothesCell()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@end

@implementation SXClothesCell

- (void)awakeFromNib{
    self.imageView.layer.cornerRadius = 10;
    self.imageView.clipsToBounds = YES;
    
    self.priceLabel.layer.cornerRadius = 10;
    self.priceLabel.clipsToBounds = YES;
}

- (void)setModel:(SXModels *)model
{  _model = model;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:[UIImage imageNamed:@"loading"]];
    self.priceLabel.text = model.price;
    
}

@end
