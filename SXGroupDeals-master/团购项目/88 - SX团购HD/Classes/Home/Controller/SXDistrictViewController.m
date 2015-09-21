//
//  SXDistrictViewController.m
//  88 - SX团购HD
//
//  Created by 董 尚先 on 15/2/5.
//  Copyright (c) 2015年 shangxianDante. All rights reserved.
//

#import "SXDistrictViewController.h"
#import "SXCityViewController.h"
#import "SXNavController.h"
#import "SXDistrict.h"
#import "SXDropdownLeftCell.h"
#import "SXDropdownRightCell.h"

@interface SXDistrictViewController ()
/** 左边的tbv */
@property (weak, nonatomic) IBOutlet UITableView *leftTableView;
/** 右边的tbv */
@property (weak, nonatomic) IBOutlet UITableView *rightTableView;
@end

@implementation SXDistrictViewController

#pragma mark - ******************** 点击切换城市按钮
- (IBAction)cityBtnChange {
    [self dismissViewControllerAnimated:YES completion:nil];
    
    // 创建城市控制器，并用导航控制器包装好
    SXCityViewController *cityVc = [[SXCityViewController alloc]init];
    SXNavController *nav = [[SXNavController alloc]initWithRootViewController:cityVc];
    
    // 设置自己弹出时的样式
    nav.modalPresentationStyle = UIModalPresentationFormSheet; // $$$$$
    
    // 取到当前的根控制器 用他来弹出 因为自己马上就要死了
    UIViewController *rootVc = [UIApplication sharedApplication].keyWindow.rootViewController; // $$$$$
    [rootVc presentViewController:nav animated:YES completion:nil];
}

#pragma mark - ******************** 首次加载
- (void)viewDidLoad {
    [super viewDidLoad];
    CGFloat rowHeight = 40;
    self.leftTableView.rowHeight = rowHeight;
    self.rightTableView.rowHeight = rowHeight;
    self.preferredContentSize = CGSizeMake(400, 400);
}

#pragma mark - ******************** 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.leftTableView) { // 左边
        return self.districts.count;
    } else { // 右边
        // 左边表格选中的行号
        NSInteger leftSelectedRow = [self.leftTableView indexPathForSelectedRow].row;
        SXDistrict *district = self.districts[leftSelectedRow];
        return district.subdistricts.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    if (tableView == self.leftTableView) { // 左边
        cell = [SXDropdownLeftCell cellWithTableView:tableView];
        
        SXDistrict *district = self.districts[indexPath.row];
        cell.textLabel.text = district.name;
        cell.accessoryType = district.subdistricts.count ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
    } else { // 右边
        cell = [SXDropdownRightCell cellWithTableView:tableView];
        
        // 左边表格选中的行号
        NSInteger leftSelectedRow = [self.leftTableView indexPathForSelectedRow].row;
        SXDistrict *district = self.districts[leftSelectedRow];
        cell.textLabel.text = district.subdistricts[indexPath.row];
    }
    return cell;
}

#pragma mark - ******************** 代理方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.leftTableView) { // 左边
        // 刷新右边
        [self.rightTableView reloadData];
        
        // 如果这个区域没有子区域，得发送通知
        SXDistrict *district = self.districts[indexPath.row];
        if (district.subdistricts.count == 0) { // 得发送通知
            [self postNote:district subdistrictIndex:nil];
        }
    } else { // 右边
        // 发送通知
        NSInteger leftSelectedRow = [self.leftTableView indexPathForSelectedRow].row;
        SXDistrict *district = self.districts[leftSelectedRow];
        [self postNote:district subdistrictIndex:@(indexPath.row)];
    }
}

#pragma mark - ******************** 私有方法发通知
- (void)postNote:(SXDistrict *)district subdistrictIndex:(id)subdistrictIndex
{
    // 1.销毁当前控制器
    [self dismissViewControllerAnimated:YES completion:nil];
    
    // 2.发送通知
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    userInfo[SXCurrentDistrictKey] = district;
    if (subdistrictIndex) {
        userInfo[SXCurrentSubdistrictIndexKey] = subdistrictIndex;
    }
    [SXNoteCenter postNotificationName:SXDistrictDidChangeNotification object:nil userInfo:userInfo];
}


@end
