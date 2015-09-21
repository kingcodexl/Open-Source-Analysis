//  WNXShowViewController.m
//  WNXHuntForCity
//  github:    https://github.com/ZhongTaoTian/WNXHuntForCity
//  项目讲解博客:http://www.jianshu.com/p/8b0d694d1c69
//  Created by MacBook on 15/7/2.
//  Copyright (c) 2015年 维尼的小熊. All rights reserved.

//  ViewController的基类,封装了返回按钮,选择View,tableView

#import "WNXShowViewController.h"
#import "WNXRmndCell.h"
#import "WNXConditionView.h"
#import "WNXDetailViewController.h"
#import <MJRefresh.h>
#import "XlRefresgHeader.h"
#import "WNXRenderBlurView.h"
#import "UIImage+Size.h"
#import "WNXHomeCellModel.h"

@interface WNXShowViewController ()<UITableViewDataSource, UITableViewDelegate, WNXConditionViewDelegate, WNXRenderBlurViewDelegate>

/** 数据源 用可变数组保存*/
@property (nonatomic, strong) NSMutableArray *datas;

@end

@implementation WNXShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化UI
    [self setUpUI];
    
    //设置上拉刷新
    [self setHeadRefresh];
}


//懒加载数据
- (NSMutableArray *)datas
{
    //其实这些都是常规做法
    if (_datas == nil) {
        _datas = [NSMutableArray array];
        //从硬盘文件中加载
        NSArray *arr = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"CellDatas" ofType:@"plist"]];
        
        for (NSDictionary *dict in arr) {
            WNXHomeCellModel *model = [WNXHomeCellModel cellModelWithDict:dict];
            [_datas addObject:model];
        }
    }
    return _datas;
}

//设置头部刷新
- (void)setHeadRefresh
{
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    // 色孩纸自定义的刷新头部
    XlRefresgHeader *header = [XlRefresgHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
#pragma mark - 通过切换图片的方式，达到刷新动画的效果，首先需要隐藏默认的控件
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    
    // 隐藏状态
    header.stateLabel.hidden = YES;
    
    // 马上进入刷新状态，首次获取数据
    [header beginRefreshing];
    
    // 设置header，最终在这里将头部刷新管理到tableview。
    self.tableView.header = header;
}

//下拉加载数据
- (void)loadNewData
{
#pragma mark - GCD实现延迟调用，注意是异步调用。
    
    //模拟1秒后刷新表格UI，GCD实现延迟调用，注意是异步调用。
    //区别另一个延迟调用[self performSelector:<#(SEL)#> withObject:<#(id)#> afterDelay:<#(NSTimeInterval)#>],实现的是当前线程中延迟调用。而GCD的是异步延迟调用
    //如下：This function waits until the specified time and then asynchronously adds block to the specified queue.
    //默认是在主队列中延迟调用
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 拿到当前的下拉刷新控件，结束刷新状态
        [self.tableView.header endRefreshing];
    });
    
    
}


#pragma mark - 初始化子视图
//由于不是视图view，所以没有layoutsubview。则在创建控件的时候完成创建，赋值，位置确定其实也可以分开做
//其实也可以分开做
- (void)setUpUI
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    //解决修改了backButton会导致没有手势滑动返回的问题
    UIButton *rightItemButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightItemButton setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    rightItemButton.contentMode = UIViewContentModeCenter;
    rightItemButton.frame = CGRectMake(0, 0, 25, 25);
    [rightItemButton addTarget:self action:@selector(leftItemClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightItemButton];
    
    //添加tableView,由于是纯代码创建所以需要自己创建tableview
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WNXAppWidth, WNXAppHeight)
                                                  style:UITableViewStylePlain];
    //设置数据源代理，和处理方法代理
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    //隐藏分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //将tableview添加到子视图中
    [self.view addSubview:self.tableView];
    
    
    //添加顶部条件选择view
    self.conditionView = [[WNXConditionView alloc] init];
    
    //这里值得注意，通过比例来设置视图的位置。定义一个宏变量，然后通过取比例。就可以完成一般的适配
    CGFloat conditionViewW = WNXAppWidth * 0.9;
    CGFloat conditionViewH = conditionViewW * 0.13;
    CGFloat conditionViewX = WNXAppWidth * 0.05;
    CGFloat conditionViewY = 10;
    
    self.conditionView.frame = CGRectMake(conditionViewX, conditionViewY, conditionViewW, conditionViewH);
    self.conditionView.delegate = self;
    [self.view addSubview:self.conditionView];
    
    
    //初始化地图
    self.mapVC = [[WNXMapViewController alloc] init];
    [self addChildViewController:self.mapVC];
    [self.view insertSubview:self.mapVC.view belowSubview:self.conditionView];
    //隐藏地图
    self.mapVC.view.alpha = 0;
    self.mapVC.view.hidden = YES;
}

- (void)configSubviewData{
    
}
- (void)configSubviewFrame{
    
}
//返回上个控制器
- (void)leftItemClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WNXHomeCellModel *model = self.datas[indexPath.row];
    WNXRmndCell *cell = [WNXRmndCell cellWithTableView:self.tableView model:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return WNXRnmdCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //推出详情页 将对应的模型取出并传到详情页的模型里
    WNXDetailViewController *detail = [[WNXDetailViewController alloc] init];
    [self.navigationController pushViewController:detail animated:YES];
}

#pragma mark - WNXConditionViewDelegate
- (void)conditionView:(WNXConditionView *)view didButtonClickFrom:(WNXConditionButtonType)from to:(WNXConditionButtonType)to
{
    //    //渲染当前的tableView的图片,并且模糊
    if (self.blurImageView == nil) {
        
        //先对当前的tableview截图，然后再传入WNXRenderBlurView中进行模糊处理。
        self.blurImageView = [WNXRenderBlurView renderBlurViewWithImage:[UIImage imageWithCaputureView:self.tableView]];
        self.blurImageView.delegate = self;
        
        CGFloat blurY = self.view.bounds.size.height == WNXAppHeight ? 64 : 0;
        
        self.blurImageView.frame = CGRectMake(0, blurY, WNXAppWidth, WNXAppHeight - 64);
        
        //设置模糊效果，将模糊的视图插入到当前视图下方
        [self.view insertSubview:self.blurImageView belowSubview:self.conditionView];
        
        [UIView animateWithDuration:0.3 animations:^{
            self.blurImageView.alpha = 1.0;
        }];
    } else {
        
    }
    
   
}

- (void)conditionViewdidSelectedMap:(WNXConditionView *)view
{
    [self hideBlurView];
    
    self.mapVC.view.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.mapVC.view.alpha = 1.0;
    }];
}

- (void)conditionViewdidSelectedList:(WNXConditionView *)view
{
    [UIView animateWithDuration:0.3 animations:^{
        self.mapVC.view.alpha = 0;
    } completion:^(BOOL finished) {
        self.mapVC.view.hidden = YES;
    }];
}


- (void)conditionViewCancelSelectButton:(WNXConditionView *)view
{
    [self hideBlurView];
}

#pragma mark - 代理调用本地方法
//隐藏模糊的view
- (void)hideBlurView
{
    [self.blurImageView hideBlurView];
    self.blurImageView = nil;
}

//重新定义导航条的状态
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"recomend_btn_gone"] forBarMetrics:UIBarMetricsDefault];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y < 0) {
        [UIView animateWithDuration:0.2 animations:^{
            self.conditionView.alpha = 0;
        }];
    } else {
        [UIView animateWithDuration:0.2 animations:^{
            self.conditionView.alpha = 1;
        }];
    }
}

#pragma mark - WNXRenderBlurViewDelegate
//点击了X号
- (void)renderBlurViewCancelBtnClick:(WNXRenderBlurView *)view
{
    [self.conditionView cancelSelectedAllButton];
    self.blurImageView = nil;
}

//选择了按钮
- (void)renderBlurView:(WNXRenderBlurView *)view didSelectedCellWithTitle:(NSString *)title
{
    [self.tableView.header beginRefreshing];
    self.blurImageView = nil;
    [self.conditionView cancelSelectedAllButton];
}

@end
