//
//  SXCollectionionViewController.m
//  88 - SX团购HD
//
//  Created by 董 尚先 on 15/2/8.
//  Copyright (c) 2015年 shangxianDante. All rights reserved.
//

#import "SXHistoryViewController.h"
#import "SXDealCell.h"
#import "SXDetailViewController.h"
#import "SXDealTool.h"
#import "UIView+AutoLayout.h"
#import "UIBarButtonItem+Extension.h"

@interface SXHistoryViewController ()
/** 显示的所有团购 */
@property (nonatomic, strong) NSMutableArray *deals;

/** 没有团购数据时显示的提醒图片 */
@property (nonatomic, weak) UIImageView *noDataView;

/** 左边的所有item */
@property (nonatomic, strong) UIBarButtonItem *backItem;
@property (nonatomic, strong) UIBarButtonItem *selectAllItem;
@property (nonatomic, strong) UIBarButtonItem *unselectAllItem;
@property (nonatomic, strong) UIBarButtonItem *deleteItem;

@end

static NSString *const SXEdit = @"编辑";
static NSString *const SXDone = @"完成";
// $$$$$
#define SXNavLeftText(text) [NSString stringWithFormat:@"   %@  ", text]
@implementation SXHistoryViewController
#pragma mark - 懒加载
- (UIBarButtonItem *)backItem
{
    if (!_backItem) {
        _backItem = [UIBarButtonItem itemWithImage:@"icon_back" HightLightImage:@"icon_back_highlighted" target:self action:@selector(back)];
    }
    return _backItem;
}
- (UIBarButtonItem *)selectAllItem
{
    if (!_selectAllItem) {
        _selectAllItem = [[UIBarButtonItem alloc] initWithTitle:SXNavLeftText(@"全选")  style:UIBarButtonItemStyleDone target:self action:@selector(selectAll)];
    }
    return _selectAllItem;
}
- (UIBarButtonItem *)unselectAllItem
{
    if (!_unselectAllItem) {
        _unselectAllItem = [[UIBarButtonItem alloc] initWithTitle:SXNavLeftText(@"全不选") style:UIBarButtonItemStyleDone target:self action:@selector(unselectAll)];
    }
    return _unselectAllItem;
}
- (UIBarButtonItem *)deleteItem
{
    if (!_deleteItem) {
        _deleteItem = [[UIBarButtonItem alloc] initWithTitle:SXNavLeftText(@"删除") style:UIBarButtonItemStyleDone target:self action:@selector(delete)];
        _deleteItem.enabled = NO;
    }
    return _deleteItem;
}

static NSString * const reuseIdentifier = @"deal";
- (UIImageView *)noDataView
{
    if (!_noDataView) {
        UIImageView *noDataView = [[UIImageView alloc] init];
        noDataView.image = [UIImage imageNamed:@"icon_collects_empty"];
        noDataView.contentMode = UIViewContentModeCenter;
        [self.view addSubview:noDataView];
        
        // 约束
        [noDataView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        
        // 赋值
        self.noDataView = noDataView;
    }
    return _noDataView;
}

- (NSMutableArray *)deals
{
    if (!_deals) {
        _deals = [[NSMutableArray alloc] init];
    }
    return _deals;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置导航栏内容
    [self setupNav];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"SXDealCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    self.collectionView.backgroundColor = SXColor(230, 230, 230);
    
    // 监听通知
    [SXNoteCenter addObserver:self selector:@selector(coverClick) name:SXCellCoverDidClickNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 重新刷新数据
    [self.deals removeAllObjects];
    [self.deals addObjectsFromArray:[SXDealTool historyDeals]];
    [self.collectionView reloadData];
    
    // 清空模型的状态
    for (SXDeal *deal in self.deals) {
        deal.editing = NO;
        deal.checked = NO;
    }
    
    
    // 控制右上角编辑能否交互
    self.navigationItem.rightBarButtonItem.enabled = (self.deals.count > 0);
    
    // 根据屏幕尺寸设置边距
    [self viewWillTransitionToSize:[UIScreen mainScreen].bounds.size withTransitionCoordinator:nil];
    
   
}

#pragma mark - 监听通知
- (void)coverClick
{
    NSUInteger count = [self.deals filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"checked == YES"]].count;
    if (count) {
        NSString *title = [NSString stringWithFormat:@"删除(%zd)", count];
        self.deleteItem.title = SXNavLeftText(title);
        self.deleteItem.enabled = YES;
    } else {
        self.deleteItem.title = SXNavLeftText(@"删除");
        self.deleteItem.enabled = NO;
    }
}

/**
 *  设置导航栏内容
 */
- (void)setupNav
{
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"icon_back" HightLightImage:@"icon_back_highlighted" target:self action:@selector(back)];
    
    self.title = @"浏览历史";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStyleDone target:self action:@selector(edit)];
}

- (void)edit
{
    NSString *title = self.navigationItem.rightBarButtonItem.title;
    if ([title isEqualToString:SXEdit]) { // 进入编辑模式
        self.navigationItem.rightBarButtonItem.title = SXDone;
        
        // 控制左边的（全选 全不选 删除）出现
        self.navigationItem.leftBarButtonItems = @[self.backItem, self.selectAllItem, self.unselectAllItem, self.deleteItem];
        
        // 让所有cell的蒙版出现
        //        SXDealCell *cell = (SXDealCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
        //        cell.editing = YES;
        for (SXDeal *deal in self.deals) {
            deal.editing = YES;
        }
        [self.collectionView reloadData];
    } else { // 结束编辑模式
        self.navigationItem.rightBarButtonItem.title = SXEdit;
        
        // 控制左边的（全选 全不选 删除）消失
        self.navigationItem.leftBarButtonItems = @[self.backItem];
        
        // 让所有cell的蒙版消失
        //        SXDealCell *cell = (SXDealCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
        //        cell.editing = NO;
        for (SXDeal *deal in self.deals) {
            deal.editing = NO;
            deal.checked = NO;
        }
        [self.collectionView reloadData];
    }
}

- (void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)selectAll
{
    for (SXDeal *deal in self.deals) {
        deal.checked = YES;
    }
    [self.collectionView reloadData];
    
    [self coverClick];
}

- (void)unselectAll
{
    for (SXDeal *deal in self.deals) {
        deal.checked = NO;
    }
    [self.collectionView reloadData];
    
    [self coverClick];
}

- (void)delete
{
    // 取出将要删除的团购数据
    NSArray *deletedDeals = [self.deals filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"checked == YES"]];
    
    // 取消收藏
    [SXDealTool removeHistoryDeals:deletedDeals];
    
    // 刷新数据
    [self.deals removeObjectsInArray:deletedDeals];
    [self.collectionView reloadData];
    
    // 刷新删除按钮
    [self coverClick];
}

#pragma mark - 监听屏幕旋转
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

#pragma mark - <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSUInteger count = self.deals.count;
    self.noDataView.hidden = (count > 0);
    return count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SXDealCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    cell.deal = self.deals[indexPath.item];
    
    return cell;
}

#pragma mark - <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SXDetailViewController *detailVc = [[SXDetailViewController alloc] init];
    detailVc.deal = self.deals[indexPath.item];
    [self presentViewController:detailVc animated:YES completion:nil];
}
@end
