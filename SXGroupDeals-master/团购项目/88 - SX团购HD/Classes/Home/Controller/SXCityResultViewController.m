//
//  SXCityResultViewController.m
//  88 - SX团购HD
//
//  Created by 董 尚先 on 15/2/5.
//  Copyright (c) 2015年 shangxianDante. All rights reserved.
//

#import "SXCityResultViewController.h"
#import "SXDataTool.h"
#import "SXCity.h"

@interface SXCityResultViewController ()

/** 结果城市的模型数组（弃用） */
@property(nonatomic,strong) NSArray *resultCities;

@end

@implementation SXCityResultViewController

//- (NSMutableArray *)resultCities
//{
//    if (_resultCities == nil) {
//        _resultCities = [[NSMutableArray alloc]init];
//    }
//    return _resultCities;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - ******************** 重写set方法
- (void)setSearchText:(NSString *)searchText
{
    if (searchText.length == 0) return;
    
    _searchText = [searchText copy];
    
    // 把搜索框里的字变成小写，便于和后面比对
    searchText = searchText.lowercaseString; // $$$$$
    
    NSArray *cities = [SXDataTool cities];

//    for (SXCity *city in cities) {
//        if ([city.name containsString:searchText]) {
//            [self.resultCities addObject:city.name];
//        }else if ([city.pinYin containsString:searchText]){
//            [self.resultCities addObject:city.name];
//        }else if([city.pinYinHead containsString:searchText]){
//            [self.resultCities addObject:city.name];
//        }
//    }
    
    // 创建过滤条件
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name contains %@ or pinYin contains %@ or pinYinHead contains %@", searchText, searchText, searchText];// $$$$$
    self.resultCities = [cities filteredArrayUsingPredicate:predicate];
    
    [self.tableView reloadData];
}

#pragma mark - ******************** tbv的数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.resultCities.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"city";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    // 设置城市名称
    SXCity *city = self.resultCities[indexPath.row];
    cell.textLabel.text = city.name;
    
    return cell;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [NSString stringWithFormat:@"共有%zd个搜索结果", self.resultCities.count];
}

#pragma mark - ******************** tbv代理方法点击触发
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 销毁
    [self dismissViewControllerAnimated:YES completion:nil];
    
    // 取出城市模型
    SXCity *city = self.resultCities[indexPath.row];
    
    // 发出通知
    NSDictionary *userInfo = @{SXCurrentCityKey  : city};
    [SXNoteCenter postNotificationName:SXCityDidChangeNotification object:nil userInfo:userInfo];
}


@end
