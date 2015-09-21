//
//  SXSearchViewController.m
//  88 - SX团购HD
//
//  Created by 董 尚先 on 15/2/4.
//  Copyright (c) 2015年 shangxianDante. All rights reserved.
//

#import "SXSearchViewController.h"
#import "UIBarButtonItem+Extension.h"
#import "UIView+Frame.h"
#import "SXTopBarItemView.h"
#import "SXCategoryViewController.h"
#import "SXDistrictViewController.h"
#import "SXSortViewController.h"
#import "SXSort.h"
#import "SXCity.h"
#import "SXCategory.h"
#import "SXDistrict.h"
#import "DPAPI.h"
#import "SXFindDealResult.h"
#import "SXDealCell.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "MBProgressHUD+MJ.h"
#import "UIView+AutoLayout.h"
#import "SXDataTool.h"
#import "SXDetailViewController.h"
#import "AwesomeMenu.h"
#import "SXCollectionViewController.h"
#import "SXHistoryViewController.h"
#import "SXNavController.h"

@interface SXSearchViewController ()<UISearchBarDelegate>


/** 当前城市模型（用于顶部） */
@property(nonatomic,strong) SXCity *currentCity;

/** 显示所有团购 */
@property (nonatomic, strong) NSMutableArray *deals;


@property (nonatomic, weak) UISearchBar *searchBar;

/** 返回结果 */
@property (nonatomic, strong) SXFindDealResult *result;

/** 记录正在发送的网络请求 */

@property (nonatomic, weak) DPRequest *currentRequest;

/** 记录当前页码 */
@property (nonatomic, assign) int currentPage;

/** 没有数据时的背景图 */
@property (nonatomic,weak) UIImageView *noDataView;

@end

@implementation SXSearchViewController

// 全局属性
static NSString * const reuseIdentifier = @"deal";

#pragma mark - ******************** 懒加载
- (NSMutableArray *)deals
{
    if (!_deals) {
        _deals = [[NSMutableArray alloc] init];
    }
    return _deals;
}

- (UIImageView *)noDataView
{
    if (!_noDataView) {
        UIImageView *noDataView = [[UIImageView alloc]init];
        noDataView.image =[UIImage imageNamed:@"icon_deals_empty"];
        noDataView.contentMode = UIViewContentModeCenter;
        [self.view addSubview:noDataView];
        [noDataView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        _noDataView = noDataView;
    }
    return _noDataView;
}

#pragma mark - ******************** 首次加载
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 从xib加载collectionCell
    [self.collectionView registerNib:[UINib nibWithNibName:@"SXDealCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier]; // $$$$$
    self.collectionView.backgroundColor = SXColor(230, 230, 230);
    
    [self setNav];
    
    // 增加刷新功能
    [self setRefresh];
    
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 在刚要出现时加载，便于后面的多次利用。viewDidLoad里就可以不写了；
    [self viewWillTransitionToSize:[UIScreen mainScreen].bounds.size withTransitionCoordinator:nil];
}



#pragma mark - ******************** 屏幕旋转
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
    layout.itemSize = CGSizeMake(305, 305);
    CGFloat screenW = size.width;
    // 根据屏幕尺寸决定每行的列数
    int cols = (screenW == SXScreenMaxWH) ? 3 : 2;
    // 一行之中所有cell的总宽度
    CGFloat allCellW = cols * layout.itemSize.width;
    // cell之间间距
    CGFloat xMargin = (screenW - allCellW)/ (cols + 1);
    CGFloat yMargin = (cols == 3) ? xMargin : 30;
    // 周边的间距
    layout.sectionInset = UIEdgeInsetsMake(yMargin, xMargin, yMargin, xMargin);
    // 每一行中每个cell之间的间距
    layout.minimumInteritemSpacing = xMargin;
    // 每一行之间的间距
    layout.minimumLineSpacing = yMargin;
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark - ******************** 设置顶部按钮
- (void)setNav{
    // 1.返回
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"icon_back" HightLightImage:@"icon_back_highlighted" target:self action:@selector(back)];
    
    // 2.搜索框
    
    UIView *titleView = [[UIView alloc] init];
    titleView.width = 250;
    titleView.height = 35;
    self.navigationItem.titleView = titleView;
    
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    searchBar.frame = titleView.bounds;
    searchBar.backgroundImage = [UIImage imageNamed:@"bg_login_textfield"];
    searchBar.delegate = self;
    [titleView addSubview:searchBar];
    self.searchBar = searchBar;


}

- (void)dealloc
{
    // 清除正在发送的请求
    [self.currentRequest disconnect];
}

#pragma mark - 导航栏事件处理
- (void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - ******************** 重新发送请求(下拉刷新新数据)

/** 设置上拉下啦刷新 */
- (void)setRefresh
{
    [self.collectionView addFooterWithTarget:self action:@selector(loadMoreDeals)];
    self.collectionView.footerHidden = YES;
}

#pragma mark - <searchBarDelegate>
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    // 添加遮盖
    //    [MBProgressHUD showMessage:@"哥正在帮你搜索团购..." toView:self.view];
    [MBProgressHUD showMessage:@"哥正在帮你搜索团购..."];
    
    self.currentPage = 0;
    
    [self.view endEditing:YES];
    
    [self loadMoreDeals];
}



#pragma mark - ******************** 上拉刷多旧数据
- (void)loadMoreDeals
{
    
    [self.currentRequest disconnect]; // $$$$$
    
    int tempPage = self.currentPage; // $$$$$
    tempPage++;
    
    // 设置参数字典
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    // 城市是发请求的必要参数
    params[@"city"] = self.cityName;
    //    params[@"limit"] = @(5);
    // 搜索条件
    params[@"keyword"] = self.searchBar.text;
    // 页码
    params[@"page"] = @(tempPage);
    
    // 发请求
    self.currentRequest = [[DPAPI sharedInstance] request:@"v1/deal/find_deals" params:params success:^(id json) {
        SXFindDealResult *result = [SXFindDealResult objectWithKeyValues:json];// $$$$$
        SXLog(@"成功");
        
        // 如果是第一页的数据。清除掉以前的数据
        if (tempPage == 1) {
            [self.deals removeAllObjects];
        }
        // 添加这一次的数据
        [self.deals addObjectsFromArray:result.deals];
        // 刷新表格
        [self.collectionView reloadData];
        
        // 结束刷新
        [self.collectionView footerEndRefreshing];
        
        
        [MBProgressHUD hideHUD];
        
        self.currentPage = tempPage;
        
        if (tempPage == 1 && self.deals.count) {
            // 让表格滚动到最前面
            //            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
            [self.collectionView setContentOffset:CGPointZero animated:YES];
        } // $$$$$

        
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"网络繁忙，请重买个手机"];
        
        // 结束刷新
        [self.collectionView footerEndRefreshing];
        
        [MBProgressHUD hideHUD];

    }];
    
}

#pragma mark - ******************** collectionView的数据源方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSUInteger count = self.deals.count;
    
    // 当遇到加载数量和和总数相等时 隐藏
    self.collectionView.footerHidden = (count == self.result.total_count);
    
    // 当背景没有值时显示出来背景图
    self.noDataView.hidden = (count > 0);
    
    return count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    // 建立
    SXDealCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    // 取出
    SXDeal *deal = self.deals[indexPath.item];
    // 传值
    cell.deal = deal;
    // 返回
    return cell;
}

#pragma mark - ******************** collectionView代理方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 建个详情控制器 传递模型之后弹出
    SXDetailViewController *detailVc = [[SXDetailViewController alloc]init];
    detailVc.deal = self.deals[indexPath.item];
    [self presentViewController:detailVc animated:YES completion:nil];
}

@end
