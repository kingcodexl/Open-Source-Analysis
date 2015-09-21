//
//  WNXNavigationController.m
//  WNXHuntForCity
//  github:    https://github.com/ZhongTaoTian/WNXHuntForCity
//  项目讲解博客:http://www.jianshu.com/p/8b0d694d1c69
//  Created by MacBook on 15/6/29.
//  Copyright (c) 2015年 维尼的小熊. All rights reserved.
//  基类导航控制器,定义了整个工程的UINavigationBar的主题

#import "WNXNavigationController.h"

@interface WNXNavigationController () <UIGestureRecognizerDelegate>

@end

@implementation WNXNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];

    //清空interactivePopGestureRecognizer的delegate可以恢复因替换导航条的back按钮失去系统默认手势
    self.interactivePopGestureRecognizer.delegate = nil;

    //禁止手势冲突
    self.interactivePopGestureRecognizer.enabled = NO;
    
    //在runtime中查到的系统tagert 和方法名 手动添加手势，调用系统的方法,这个警告看着不爽，我直接强制去掉了~
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self.interactivePopGestureRecognizer.delegate action:@selector(handleNavigationTransition:)];
#pragma clang diagnostic pop

    pan.delegate = self;
    
    [self.view addGestureRecognizer:pan];
}

/*!
 *  @author Kingcodexl, 15-08-10 17:08:15
 *
 *  @brief  Initializes the class before it receives its first message.
 */
+ (void)initialize
{
    //通过 appearance可以为之后加载的UINavgationBar加载统一的界面风格
    UINavigationBar *bar = [UINavigationBar appearanceWhenContainedIn:self, nil];
    [bar setBackgroundImage:[UIImage imageNamed:@"recomend_btn_gone"] forBarMetrics:UIBarMetricsDefault];
//  nc.navigationBar.translucent = NO;
    //去掉导航条的半透明
    bar.translucent = NO;

    //通过字典批量设置TitleText的属性
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSFontAttributeName] = [UIFont systemFontOfSize:20];
    dict[NSForegroundColorAttributeName] = [UIColor whiteColor];
    
    [bar setTitleTextAttributes:dict];
}

#pragma mark - 手势代理方法

// 是否开始触发手势，在这里做手势拦截
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    // 判断下当前控制器是否是跟控制器,判断当前的控制器是不是顶层控制器，如果是则可以触发手势。
    return (self.topViewController != [self.viewControllers firstObject]);
}

/*
 1、如果最终hit-test没有找到第一响应者，或者第一响应者没有处理该事件，则该事件会沿着响应者链向上回溯，如果UIWindow实例和UIApplication实例都不能处理该事件，则该事件会被丢弃；
 
 2、hitTest:withEvent:方法将会忽略隐藏(hidden=YES)的视图，禁止用户操作(userInteractionEnabled=YES)的视图，以及alpha级别小于0.01(alpha<0.01)的视图。如果一个子视图的区域超过父视图的bound区域(父视图的clipsToBounds 属性为NO，这样超过父视图bound区域的子视图内容也会显示)，那么正常情况下对子视图在父视图之外区域的触摸操作不会被识别,因为父视图的pointInside:withEvent:方法会返回NO,这样就不会继续向下遍历子视图了。当然，也可以重写pointInside:withEvent:方法来处理这种情况。
 
 3、我们可以重写hitTest:withEvent:来达到某些特定的目的，下面的链接就是一个有趣的应用举例，当然实际应用中很少用到这些。
 */
@end
