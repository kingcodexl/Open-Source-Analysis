//
//  SXDropdownRightCell.m
//  88 - SX团购HD
//
//  Created by 董 尚先 on 15/2/4.
//  Copyright (c) 2015年 shangxianDante. All rights reserved.
//

#import "SXDropdownRightCell.h"

@implementation SXDropdownRightCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{// $$$$$
    static NSString *rightID = @"rightCell";
    SXDropdownRightCell *cell = [tableView dequeueReusableCellWithIdentifier:rightID];
    if (cell == nil) {
        cell = [[SXDropdownRightCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:rightID];
        cell.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg_dropdown_rightpart"]];
        cell.selectedBackgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg_dropdown_right_selected"]];
    }
    return cell;
}
@end
