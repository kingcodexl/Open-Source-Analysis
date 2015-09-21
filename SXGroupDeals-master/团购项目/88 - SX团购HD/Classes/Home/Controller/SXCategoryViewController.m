//
//  SXCategoryViewController.m
//  88 - SX团购HD
//
//  Created by 董 尚先 on 15/2/4.
//  Copyright (c) 2015年 shangxianDante. All rights reserved.
//

#import "SXCategoryViewController.h"
#import "SXDataTool.h"
#import "SXCategory.h"
#import "SXDropdownLeftCell.h"
#import "SXDropdownRightCell.h"

@interface SXCategoryViewController ()<UITableViewDataSource,UITableViewDelegate>

/** 左边的tbv */
@property (weak, nonatomic) IBOutlet UITableView *leftTableView;
/** 右边的tbv */
@property (weak, nonatomic) IBOutlet UITableView *rightTableView;

@end

@implementation SXCategoryViewController

#pragma mark - ******************** 首次加载
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置tbv的样式
    CGFloat rowHeight = 44;
    self.leftTableView.rowHeight = rowHeight;
    self.rightTableView.rowHeight = rowHeight;
    self.leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 自己弹出时的大小
    self.preferredContentSize = CGSizeMake(400, rowHeight * [SXDataTool categorys].count);
    
//    NSIndexPath *path = [NSIndexPath indexPathForRow:2 inSection:0];
//    [self tableView:self.leftTableView didSelectRowAtIndexPath:path];
}


#pragma mark - ******************** 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.leftTableView) {
        return [SXDataTool categorys].count;
    }else{
        NSInteger leftSelectedRow = [self.leftTableView indexPathForSelectedRow].row;
        
        // 获取左边tbv点击的行数索引，得到右边该返回多少行
        SXCategory *category = [SXDataTool categorys][leftSelectedRow];
        return category.subcategories.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if (tableView == self.leftTableView) {
        
        // 取出模型
        SXCategory *category = [SXDataTool categorys][indexPath.row];
        
        // 设置cell的各种属性
        cell = [SXDropdownLeftCell cellWithTableView:tableView];
        cell.textLabel.text = category.name;
        
        // 三目运算符 判断右边的小尖尖要不要显示
        cell.accessoryType =  category.subcategories.count ? UITableViewCellAccessoryDisclosureIndicator:UITableViewCellAccessoryNone;
        cell.imageView.image = [UIImage imageNamed:category.small_icon];
        cell.imageView.highlightedImage = [UIImage imageNamed:category.small_highlighted_icon];
        
    }else{
        cell = [SXDropdownRightCell cellWithTableView:tableView];
        NSInteger leftSelectedRow = [self.leftTableView indexPathForSelectedRow].row;
        SXCategory *category = [SXDataTool categorys][leftSelectedRow];
        cell.textLabel.text = category.subcategories[indexPath.row];
    }
    
    return cell;
}

#pragma mark - ******************** 代理方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.leftTableView) {
        
        // 点击了左边就刷新右边
        [self.rightTableView reloadData];
        SXCategory *category = [SXDataTool categorys][indexPath.row];
        if (category.subcategories.count <1) {
            // 发通知
            [self postNote:category andIndex:nil];
        }
        
    }else{
        NSInteger leftSelectedRow = [self.leftTableView indexPathForSelectedRow].row;
        SXCategory *category = [SXDataTool categorys][leftSelectedRow];
        [self postNote:category andIndex:@(indexPath.row)];
    }
    
}

#pragma mark - ******************** 发通知
- (void)postNote:(SXCategory *)category andIndex:(id)index{
    [self dismissViewControllerAnimated:YES completion:nil];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[SXCurrentCategoryKey] = category;
    // 判断下右边tbv有点击么？ 有才传值 避免字典里传入nil崩
    if (index) {
        params[SXCurrentCategoryIndexKey] = index;
    }
    [SXNoteCenter postNotificationName:SXCategoryDidChangeNotification object:nil userInfo:params];
}


@end
