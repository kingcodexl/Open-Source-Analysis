//
//  WNXRmndCell.h
//  WNXHuntForCity
//
//  Created by MacBook on 15/7/2.
//  Copyright (c) 2015年 维尼的小熊. All rights reserved.
//  由于是固定大小，所以通过xib创建。

#import <UIKit/UIKit.h>
#import "WNXHomeCellModel.h"

@interface WNXRmndCell : UITableViewCell

/** cell的模型 */
@property (nonatomic, strong) WNXHomeCellModel *model;

/**
 自定义cell，这样实例化方法比较常用
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView model:(WNXHomeCellModel *)model;

@end
