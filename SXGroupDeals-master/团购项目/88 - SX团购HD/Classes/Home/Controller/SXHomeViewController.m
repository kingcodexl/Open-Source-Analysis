//
//  SXHomeViewController.m
//  88 - SX团购HD
//
//  Created by 董 尚先 on 15/2/4.
//  Copyright (c) 2015年 shangxianDante. All rights reserved.
//

#import "SXHomeViewController.h"
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
#import "SXSearchViewController.h"
#import "SXNavController.h"

@interface SXHomeViewController ()<AwesomeMenuDelegate>

/** 顶部分类选择按钮 */
@property(nonatomic,strong) UIBarButtonItem *categoryItem;

/** 顶部区域选择按钮 */
@property(nonatomic,strong) UIBarButtonItem *districtItem;

/** 顶部排序选择按钮 */
@property(nonatomic,strong) UIBarButtonItem *sortItem;

/** 当前城市模型（用于顶部） */
@property(nonatomic,strong) SXCity *currentCity;

/** 显示所有团购 */
@property (nonatomic, strong) NSMutableArray *deals;

/** 记录当前的排序 */
@property (nonatomic, strong) SXSort *currentSort;

/** 记录当前的区域名 */
@property(nonatomic,copy) NSString *currentRegionName;

/** 记录当前的分类名 */
@property(nonatomic,copy) NSString *currentCategoryName;

/** 记录正在发送的网络请求 */

@property (nonatomic, weak) DPRequest *currentRequest;

/** 返回结果 */
@property (nonatomic, strong) SXFindDealResult *result;

/** 记录当前页码 */
@property (nonatomic, assign) int currentPage;

/** 没有数据时的背景图 */
@property (nonatomic,weak) UIImageView *noDataView;

@end

@implementation SXHomeViewController

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

//    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // 从xib加载collectionCell
    [self.collectionView registerNib:[UINib nibWithNibName:@"SXDealCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier]; // $$$$$
    self.collectionView.backgroundColor = SXColor(230, 230, 230);
    
    // 设置导航栏左边和右边的按钮们
    [self setLeftItems];
    [self setRightItems];
    
    // 处理通知
    [self setNotes];
    
    // 增加刷新功能
    [self setRefresh];
    
    [self setupAwesomeMenu];
    
        self.collectionView.footerHidden = YES;

}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 在刚要出现时加载，便于后面的多次利用。viewDidLoad里就可以不写了；
    [self viewWillTransitionToSize:[UIScreen mainScreen].bounds.size withTransitionCoordinator:nil];
}

#pragma mark - ******************** 环形菜单
- (void)setupAwesomeMenu
{
    // 所有item的公共背景
    UIImage *itemBg = [UIImage imageNamed:@"bg_pathMenu_black_normal"];
    
    // 创建菜单item（按钮）
    // 1.个人信息
    AwesomeMenuItem *personalItem = [[AwesomeMenuItem alloc] initWithImage:itemBg highlightedImage:nil ContentImage:[UIImage imageNamed:@"icon_pathMenu_mine_normal"] highlightedContentImage:[UIImage imageNamed:@"icon_pathMenu_mine_highlighted"]];
    
    // 2.收藏
    AwesomeMenuItem *collectItem = [[AwesomeMenuItem alloc] initWithImage:itemBg highlightedImage:nil ContentImage:[UIImage imageNamed:@"icon_pathMenu_collect_normal"] highlightedContentImage:[UIImage imageNamed:@"icon_pathMenu_collect_highlighted"]];
    
    // 3.历史记录
    AwesomeMenuItem *historyItem = [[AwesomeMenuItem alloc] initWithImage:itemBg highlightedImage:nil ContentImage:[UIImage imageNamed:@"icon_pathMenu_scan_normal"] highlightedContentImage:[UIImage imageNamed:@"icon_pathMenu_scan_highlighted"]];
    
    // 4.更多
    AwesomeMenuItem *moreItem = [[AwesomeMenuItem alloc] initWithImage:itemBg highlightedImage:nil ContentImage:[UIImage imageNamed:@"icon_pathMenu_more_normal"] highlightedContentImage:[UIImage imageNamed:@"icon_pathMenu_more_highlighted"]];
    
    // 5.开始
    AwesomeMenuItem *startItem = [[AwesomeMenuItem alloc] initWithImage:[UIImage imageNamed:@"icon_pathMenu_background_normal"] highlightedImage:[UIImage imageNamed:@"icon_pathMenu_background_highlighted"] ContentImage:[UIImage imageNamed:@"icon_pathMenu_mainMine_normal"] highlightedContentImage:[UIImage imageNamed:@"icon_pathMenu_mainMine_highlighted"]];
    
    // 创建菜单
    NSArray *items = @[personalItem, collectItem, historyItem, moreItem];
    AwesomeMenu *menu = [[AwesomeMenu alloc] initWithFrame:CGRectZero startItem:startItem optionMenus:items];
    menu.delegate = self;
    menu.alpha = 0.5;
    [self.view addSubview:menu];
    
    // 设置菜单约束
    [menu autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [menu autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
    CGFloat menuWH = 250;
    [menu autoSetDimensionsToSize:CGSizeMake(menuWH, menuWH)];
    
    // 设置菜单信息
    CGFloat margin = 50;
    menu.menuWholeAngle = M_PI_2;
    menu.startPoint = CGPointMake(margin, menuWH - margin);
    menu.rotateAddButton = NO;
}

#pragma mark - ******************** AwesomeMenu
#pragma mark - <AwesomeMenuDelegate>
- (void)awesomeMenu:(AwesomeMenu *)menu didSelectIndex:(NSInteger)idx
{
    switch (idx) {
        case 0: // 个人
            break;
        case 1: { // 收藏
             SXCollectionViewController *collectVc = [[SXCollectionViewController alloc] initWithCollectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
        SXNavController *nav = [[SXNavController alloc] initWithRootViewController:collectVc];
            [self presentViewController:nav animated:YES completion:nil];
            break;
        }
        case 2: { // 收藏
            SXHistoryViewController *historyVc = [[SXHistoryViewController alloc] initWithCollectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
            SXNavController *nav = [[SXNavController alloc] initWithRootViewController:historyVc];
            [self presentViewController:nav animated:YES completion:nil];
            break;
        }
        case 3: // 更多
            break;
    }
    
    [self awesomeMenuWillAnimateClose:menu];
}

- (void)awesomeMenuWillAnimateOpen:(AwesomeMenu *)menu
{
    menu.contentImage = [UIImage imageNamed:@"icon_pathMenu_cross_normal"];
    menu.highlightedContentImage = [UIImage imageNamed:@"icon_pathMenu_cross_highlighted"];
    menu.alpha = 1.0;
}

- (void)awesomeMenuDidFinishAnimationOpen:(AwesomeMenu *)menu
{
    
}

- (void)awesomeMenuWillAnimateClose:(AwesomeMenu *)menu
{
    menu.contentImage = [UIImage imageNamed:@"icon_pathMenu_mainMine_normal"];
    menu.highlightedContentImage = [UIImage imageNamed:@"icon_pathMenu_mainMine_highlighted"];
    menu.alpha = 0.5;
}

- (void)awesomeMenuDidFinishAnimationClose:(AwesomeMenu *)menu
{
    
}


#pragma mark - ******************** 屏幕旋转
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
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

#pragma mark - ******************** 设置顶部按钮
- (void)setLeftItems
{
    // 左边美团按钮
    UIBarButtonItem *logoItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"icon_meituan_logo"] style:UIBarButtonItemStylePlain target:nil action:nil];
    
    SXTopBarItemView *categoryTopItem = [SXTopBarItemView item];
    [categoryTopItem setIcon:@"icon_category_-1" highIcon:@"icon_category_highlighted_-1"];
    categoryTopItem.title = @"全部分类";
    categoryTopItem.subtitle = nil;
    [categoryTopItem addTarget:self action:@selector(categoryClick)];
    self.categoryItem = [[UIBarButtonItem alloc]initWithCustomView:categoryTopItem];
    
    
    SXTopBarItemView *districtTopItem = [SXTopBarItemView item];
    [districtTopItem setIcon:@"icon_district" highIcon:@"icon_district_highlighted"];
    districtTopItem.title = @"北京 - 全部";
    districtTopItem.subtitle = nil;
    [districtTopItem addTarget:self action:@selector(districtClick)];
    self.districtItem = [[UIBarButtonItem alloc]initWithCustomView:districtTopItem];
    
    SXTopBarItemView *sortTopItem = [SXTopBarItemView item];
    [sortTopItem setIcon:@"icon_sort" highIcon:@"icon_sort_highlighted"];
    sortTopItem.title = @"排序";
    sortTopItem.subtitle = @"默认排序";
    [sortTopItem addTarget:self action:@selector(sortClick)];
    self.sortItem = [[UIBarButtonItem alloc]initWithCustomView:sortTopItem];
    
    self.navigationItem.leftBarButtonItems = @[logoItem,self.categoryItem,self.districtItem,self.sortItem];
}

- (void)setRightItems
{
    // 这里没有用工具类，而是给UIBarButtonItem写一个分类，为了是可读性更高 编程思想！
    UIBarButtonItem *searchItem = [UIBarButtonItem itemWithImage:@"icon_search" HightLightImage:@"icon_search_highlighted" target:self action:@selector(searchClick)];
    searchItem.customView.width = 50;
    UIBarButtonItem *mapItem = [UIBarButtonItem itemWithImage:@"icon_map" HightLightImage:@"icon_map_highlighted" target:self action:@selector(mapClick)];
    mapItem.customView.width = 50;
    self.navigationItem.rightBarButtonItems = @[mapItem,searchItem];
}

#pragma mark - ******************** 顶部按钮的点击事件

/** 搜索按钮点击 */
- (void)searchClick
{
    if (self.currentCity == nil) {
        [MBProgressHUD showError:@"请选择城市后再搜索"];
        return;
    }
    
    SXSearchViewController *searchVc = [[SXSearchViewController alloc] initWithCollectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
    searchVc.cityName = self.currentCity.name;
    SXNavController *nav = [[SXNavController alloc] initWithRootViewController:searchVc];
    [self presentViewController:nav animated:YES completion:nil];
}

/** 地图按钮点击 */
- (void)mapClick
{
    SXLog(@"mapItem--");
}

/** 分类按钮点击 */
- (void)categoryClick
{
    SXCategoryViewController *categoryVc = [[SXCategoryViewController alloc]init];
    categoryVc.modalPresentationStyle = UIModalPresentationPopover;
    categoryVc.popoverPresentationController.barButtonItem = self.categoryItem;
    [self presentViewController:categoryVc animated:YES completion:nil];
}

/** 区域按钮点击 */
- (void)districtClick
{
    SXDistrictViewController *districtVc = [[SXDistrictViewController alloc]init];
    districtVc.modalPresentationStyle = UIModalPresentationPopover;
    districtVc.districts = self.currentCity.districts;
    districtVc.popoverPresentationController.barButtonItem = self.districtItem;
    [self presentViewController:districtVc animated:YES completion:nil];
}

/** 排序按钮点击 */
- (void)sortClick
{
    SXSortViewController *sortVc = [[SXSortViewController alloc]init];
    sortVc.modalPresentationStyle = UIModalPresentationPopover;
    sortVc.popoverPresentationController.barButtonItem = self.sortItem;
    [self presentViewController:sortVc animated:YES completion:nil];
}

#pragma mark - ******************** 通知的处理

/** 用通知中心设置观察者 */
- (void)setNotes
{
    [SXNoteCenter addObserver:self selector:@selector(SortNotesCome:) name:SXSortDidChangeNotification object:nil];
    [SXNoteCenter addObserver:self selector:@selector(CategoryNotesCome:) name:SXCategoryDidChangeNotification object:nil];
    [SXNoteCenter addObserver:self selector:@selector(CityNotesCome:) name:SXCityDidChangeNotification object:nil];
    [SXNoteCenter addObserver:self selector:@selector(districtNotesCome:) name:SXDistrictDidChangeNotification object:nil];
}

/** 死亡配套使用 */
- (void)dealloc
{
    [SXNoteCenter removeObserver:self];
    [self.currentRequest disconnect];
}

/** 处理排序改变的通知 */
- (void)SortNotesCome:(NSNotification *)no
{
    SXTopBarItemView *top = (SXTopBarItemView *)self.sortItem.customView;
    top.subtitle = [no.userInfo[SXCurrentSortKey] label];
    self.currentSort = no.userInfo[SXCurrentSortKey];
    
    [self loadNewDeals];
}

/** 处理分类改变的通知 */
- (void)CategoryNotesCome:(NSNotification *)no
{
    SXTopBarItemView *top = (SXTopBarItemView *)self.categoryItem.customView;
    SXCategory *category = no.userInfo[SXCurrentCategoryKey];
    NSString *subtitleForIndex = category.subcategories[[no.userInfo[SXCurrentCategoryIndexKey] integerValue]];
    if (subtitleForIndex.length == 0) {
        top.subtitle = @"全部";
    }else{
        top.subtitle = subtitleForIndex;
    }
    top.title = [no.userInfo[SXCurrentCategoryKey] name];
    [top setIcon:category.icon highIcon:category.highlighted_icon];
    
    // 看子区域还有值么？没有就直接传自己
    self.currentCategoryName = (subtitleForIndex ? subtitleForIndex : category.name);
    if ([self.currentCategoryName isEqualToString:@"全部"]) {
        self.currentCategoryName = category.name;
    }else if ([self.currentCategoryName isEqualToString:@"全部分类"]){
        self.currentCategoryName = nil;
    }
    
    
    [self loadNewDeals];
}

/** 处理城市改变的通知 */
- (void)CityNotesCome:(NSNotification *)no
{
    // 更新导航栏顶部
    SXTopBarItemView *top = (SXTopBarItemView *)self.districtItem.customView;
    // 取出模型
    self.currentCity = no.userInfo[SXCurrentCityKey];
    top.title = [NSString stringWithFormat:@"%@ - 全部", self.currentCity.name];
    top.subtitle = nil;
    self.currentRegionName = nil;
    
    [self loadNewDeals];
}

/** 处理区域改变的通知 */
- (void)districtNotesCome:(NSNotification *)no
{
    // 更新导航栏顶部
    SXTopBarItemView *top = (SXTopBarItemView *)self.districtItem.customView;
    // 取出模型
    SXDistrict *district = no.userInfo[SXCurrentDistrictKey];
    int subdistrictIndex = [no.userInfo[SXCurrentSubdistrictIndexKey] intValue];
    NSString *subdistrict = district.subdistricts[subdistrictIndex];
    
    // 设置数据
    top.title = [NSString stringWithFormat:@"%@ - %@", self.currentCity.name, district.name];
    top.subtitle = subdistrict;
    
    self.currentRegionName = (subdistrict ? subdistrict : district.name);
    if ([self.currentRegionName isEqualToString:@"全部"]) {
        self.currentRegionName = (subdistrict ? district.name : nil);
    }
    
    [self loadNewDeals];
}

#pragma mark - ******************** 重新发送请求(下拉刷新新数据)

/** 设置上拉下啦刷新 */
- (void)setRefresh
{
    [self.collectionView addHeaderWithTarget:self action:@selector(loadNewDeals)];
    [self.collectionView addFooterWithTarget:self action:@selector(loadMoreDeals)];
    
    self.currentCity = [SXDataTool cityWithName:@"北京"];
    [self.collectionView headerBeginRefreshing];
    

}

- (void)loadNewDeals
{
    // 如果当前的城市为空就不发送请求
    if (self.currentCity == nil) return;
    
    [self.currentRequest disconnect];
    [self.collectionView footerEndRefreshing];
    
    // 设置参数字典
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    // 城市是发请求的必要参数
    params[@"city"] = self.currentCity.name;
//    params[@"limit"] = @(5);
    
    // 看看当前区域，分类，排序 是否有值，有值就赋值给字典
    if (self.currentRegionName) params[@"region"] = self.currentRegionName;
    if (self.currentCategoryName) params[@"category"] = self.currentCategoryName;
    if (self.currentSort) params[@"sort"] = @(self.currentSort.value);
    
    // 发请求
    self.currentRequest = [[DPAPI sharedInstance] request:@"v1/deal/find_deals" params:params success:^(id json) {
        self.result = [SXFindDealResult objectWithKeyValues:json];// $$$$$
        SXLog(@"成功");
        
        // 清空上一次的数据
        [self.deals removeAllObjects];
        // 添加这一次的数据
        [self.deals addObjectsFromArray:self.result.deals];
        // 刷新表格
        [self.collectionView reloadData];
        
        // 结束刷新
        [self.collectionView headerEndRefreshing];
        
        [self.collectionView setContentOffset:CGPointMake(0, -64) animated:YES];
        
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"网络繁忙，请重买个手机"];
        
        // 结束刷新
        [self.collectionView headerEndRefreshing];
    }];
}

#pragma mark - ******************** 上拉刷多旧数据
- (void)loadMoreDeals
{
    // 如果当前的城市为空就不发送请求
    if (self.currentCity == nil) return;
    
    [self.currentRequest disconnect]; // $$$$$
    [self.collectionView headerEndRefreshing];
    
    int tempPage = self.currentPage; // $$$$$
    tempPage++;
    
    // 设置参数字典
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    // 城市是发请求的必要参数
    params[@"city"] = self.currentCity.name;
    //    params[@"limit"] = @(5);
    
    // 看看当前区域，分类，排序 是否有值，有值就赋值给字典
    if (self.currentRegionName) params[@"region"] = self.currentRegionName;
    if (self.currentCategoryName) params[@"category"] = self.currentCategoryName;
    if (self.currentSort) params[@"sort"] = @(self.currentSort.value);
    
    // 页码
    params[@"page"] = @(tempPage);
    
    // 发请求
    self.currentRequest = [[DPAPI sharedInstance] request:@"v1/deal/find_deals" params:params success:^(id json) {
        self.result = [SXFindDealResult objectWithKeyValues:json];// $$$$$
        SXLog(@"成功");
        
        // 添加这一次的数据
        [self.deals addObjectsFromArray:self.result.deals];
        // 刷新表格
        [self.collectionView reloadData];
        
        // 结束刷新
        [self.collectionView footerEndRefreshing];
        
        self.currentPage = tempPage;
        
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"网络繁忙，请重买个手机"];
        
        // 结束刷新
        [self.collectionView footerEndRefreshing];
    }];

}

#pragma mark - ******************** collectionView的数据源方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSUInteger count = self.deals.count;
    
    
    // 当遇到加载数量和和总数相等时 隐藏
    self.collectionView.footerHidden = (count == self.result.total_count);
    
    NSLog(@"%zd,%zd",self.deals.count,self.result.total_count);
    
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
