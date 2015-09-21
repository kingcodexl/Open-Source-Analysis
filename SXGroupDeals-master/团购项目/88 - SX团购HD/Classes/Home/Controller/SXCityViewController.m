//
//  SXCityViewController.m
//  88 - SX团购HD
//
//  Created by 董 尚先 on 15/2/5.
//  Copyright (c) 2015年 shangxianDante. All rights reserved.
//

#import "SXCityViewController.h"
#import "UIBarButtonItem+Extension.h"
#import "SXDataTool.h"
#import "SXCityGroup.h"
#import "SXCityResultViewController.h"
#import "UIView+AutoLayout.h"

@interface SXCityViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
/** 下面的城市列表tbv */
@property (weak, nonatomic) IBOutlet UITableView *cityTableView;

/** 蒙版 */
@property (weak, nonatomic) IBOutlet UIButton *cover;

/** 搜索时显示的结果tbv */
@property(nonatomic,strong) SXCityResultViewController *cityResultVc;

/** 搜索框 */
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation SXCityViewController

#pragma mark - ******************** 懒加载
- (SXCityResultViewController *)cityResultVc
{
    if (!_cityResultVc) {
        SXCityResultViewController *cityResultVc = [[SXCityResultViewController alloc] init];
        [self addChildViewController:cityResultVc];
        [self.view addSubview:cityResultVc.view];
        
        // 给结果tbv设置约束 顶部和自己的城市列表tbv同高 防止盖住搜索框
        [cityResultVc.view autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        [cityResultVc.view autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.cityTableView];
        
        self.cityResultVc = cityResultVc;
    }
    return _cityResultVc;
}

#pragma mark - ******************** 首次加载
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 给title设置一个值默认就是给控制器设置名字也给导航栏设置名字
    self.title = @"切换城市";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"btn_navigation_close" HightLightImage:@"btn_navigation_close_hl" target:self action:@selector(close)];
    
    // 索引条颜色
    self.cityTableView.sectionIndexColor = [UIColor blackColor];
    
    // 给蒙版绑定点击事件 直接调用搜索框的取消响应者方法，不用再弄方法
    [self.cover addTarget:self.searchBar action:@selector(resignFirstResponder) forControlEvents:UIControlEventTouchUpInside];// $$$$$
}

/** 给导航栏的左边叉叉绑定，一点就自杀 */
- (void)close
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - ******************** tbv的数据源方法

/** 返回多少组 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [SXDataTool cityGroups].count;
}

/** 每组多少行 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    SXCityGroup *cityGroup = [SXDataTool cityGroups][section];
    return cityGroup.cities.count;
}

/** 每行返回什么数据 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* ID = @"city";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    SXCityGroup *cityGroup = [SXDataTool cityGroups][indexPath.section];
    cell.textLabel.text = cityGroup.cities[indexPath.row];
    
    return cell;
}

/** 每组的头部显示什么 */
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    SXCityGroup *cityGroup = [SXDataTool cityGroups][section];
    return cityGroup.title;
}

/** 添加索引条 */
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    // 用KVC的keyPath 一次取出需要的数组
   return [[SXDataTool cityGroups] valueForKeyPath:@"title"]; // $$$$$
}

#pragma mark - ******************** tbv的代理方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 销毁
    [self dismissViewControllerAnimated:YES completion:nil];
    
    // 取出城市名字
    SXCityGroup *cityGroup = [SXDataTool cityGroups][indexPath.section];
    NSString *cityName = cityGroup.cities[indexPath.row];
    
    // 根据城市名字 获得 城市模型
    SXCity *city = [SXDataTool cityWithName:cityName];
    
    // 发出通知
    NSDictionary *userInfo = @{SXCurrentCityKey : city};
    [SXNoteCenter postNotificationName:SXCityDidChangeNotification object:nil userInfo:userInfo];
}


#pragma mark - ******************** 搜索框的代理方法

/** 搜索框开始编辑 */
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    
    // 1.让搜索框背景变为绿色
    searchBar.backgroundImage = [UIImage imageNamed:@"bg_login_textfield_hl"];
    // 2.出现cancel按钮
    [searchBar setShowsCancelButton:YES animated:YES]; // $$$$$
    // 3.导航条消失（通过动画向上消失）
    [self.navigationController setNavigationBarHidden:YES animated:YES]; // $$$$$
    // 4.添加蒙版
    self.cover.hidden = NO;
    
    
}

/** 搜索框结束编辑 */
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    // 1.让搜索框背景变为灰色
    searchBar.backgroundImage = [UIImage imageNamed:@"bg_login_textfield"];
    // 2.隐藏cancel按钮
    [searchBar setShowsCancelButton:NO animated:YES];
    // 3.导航条出现（通过动画向下出现）
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    // 4.移除蒙版
    self.cover.hidden = YES;
    // 5.清空搜索框文字
    searchBar.text = nil;
    // 6.隐藏搜索结果控制器
    self.cityResultVc.view.hidden = YES;
}

/** 点击了搜索框里面的取消按钮触发 */
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar endEditing:YES];
}

/** 搜索框里的文字改变 */
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    self.cityResultVc.view.hidden = (searchText.length == 0);
    self.cityResultVc.searchText = searchText;
}


@end
