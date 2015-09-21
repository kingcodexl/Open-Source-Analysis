//
//  WNXRmndCell.m
//  WNXHuntForCity
//  github:    https://github.com/ZhongTaoTian/WNXHuntForCity
//  项目讲解博客:http://www.jianshu.com/p/8b0d694d1c69
//  Created by MacBook on 15/7/2.
//  Copyright (c) 2015年 维尼的小熊. All rights reserved.
//  推荐cell

#import "WNXRmndCell.h"
#import <UIImageView+WebCache.h>

@interface WNXRmndCell()

@property (weak, nonatomic) IBOutlet UIImageView *backImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *adressLabel;
@property (weak, nonatomic) IBOutlet UILabel *praiseLabel;

@end

@implementation WNXRmndCell

//从xib加载，调用方法，在这里进行一些设置
- (void)awakeFromNib {
    self.backgroundColor = WNXColor(51, 52, 53);
    //取消选中的样式
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}



+ (instancetype)cellWithTableView:(UITableView *)tableView model:(WNXHomeCellModel *)model
{
    static NSString *ID = @"rmndCell";
    //一种老的创建cell的方式
    WNXRmndCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        
        //从nib文件加载,小细节，这里通过NSStringFromClass([WNXRmndCell class]得到字符串，而不是手动写
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([WNXRmndCell class]) owner:nil options:nil] lastObject];
        //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    cell.model = model;
    return cell;
}


- (void)setModel:(WNXHomeCellModel *)model{
    _model = model;
    //给cell添加图片
    [self.backImageView sd_setImageWithURL:[NSURL URLWithString:model.imageURL] placeholderImage:[UIImage imageNamed:@"EXP_likeList_backImage6"]];
    
    self.nameLabel.text = model.section_title;
    self.adressLabel.text = model.poi_name;
    self.praiseLabel.text = model.fav_count;
    
}

@end
