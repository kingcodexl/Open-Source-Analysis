//
//  SXDropdownLeftCell.m
//  88 - SX团购HD
//
//  Created by 董 尚先 on 15/2/4.
//  Copyright (c) 2015年 shangxianDante. All rights reserved.
//

#import "SXDropdownLeftCell.h"

@implementation SXDropdownLeftCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{// $$$$$
    static NSString *leftID = @"leftCell";
    SXDropdownLeftCell *cell = [tableView dequeueReusableCellWithIdentifier:leftID];
    if (cell == nil) {
        cell = [[SXDropdownLeftCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:leftID];
        cell.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg_dropdown_leftpart"]];
        cell.selectedBackgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg_dropdown_left_selected"]];
    }
    return cell;
}

@end
