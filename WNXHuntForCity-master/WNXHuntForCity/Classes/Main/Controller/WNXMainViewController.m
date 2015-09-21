//
//  WNXMainViewController.m
//  WNXHuntForCity
//  github:    https://github.com/ZhongTaoTian/WNXHuntForCity
//  项目讲解博客:http://www.jianshu.com/p/8b0d694d1c69
//  Created by MacBook on 15/6/28.
//  Copyright (c) 2015年 维尼的小熊. All rights reserved.
//

#import "WNXMainViewController.h"           //主控制器
#import "WNXLeftMenuView.h"                 //左侧拉菜单
#import "WNXHomeViewController.h"           //主页控制器
#import "WNXNavigationController.h"         //自定义导航控制器
#import "WNXFoundViewController.h"          //搜索控制器
#import "WNXUserViewController.h"           //用户信息控制器
#import "WNXCollectionViewController.h"     //收藏控制器
#import "WNXBeenViewController.h"           //去过控制器
#import "WNXMessageViewController.h"        //消息控制器
#import "WNXSetingViewController.h"         //设置控制器


@interface WNXMainViewController () <WNXLeftMenuViewDelegate, UIGestureRecognizerDelegate>

//记录当前显示的控制器，用于添加手势拖拽
@property (nonatomic, weak) WNXViewController *showViewController;

//左边按钮的view
@property (nonatomic, weak) WNXLeftMenuView *leftMenuView;

@end

@implementation WNXMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //添加子控制器，
    NSArray *classNames = @[@"WNXHomeViewController", @"WNXFoundViewController", @"WNXUserViewController", @"WNXCollectionViewController", @"WNXBeenViewController", @"WNXMessageViewController", @"WNXSetingViewController"];
    
    for (NSString *className in classNames) {
        //这个方法不错，直接从字符串中得到类对象-----kingcode
        UIViewController *vc = (UIViewController *)[[NSClassFromString(className) alloc] init];
        WNXNavigationController *nc = [[WNXNavigationController alloc] initWithRootViewController:vc];
        nc.view.layer.shadowColor = [UIColor blackColor].CGColor;
        nc.view.layer.shadowOffset = CGSizeMake(-3.5, 0);
        nc.view.layer.shadowOpacity = 0.2;
        
        [self addChildViewController:nc];
    }
    
    
    
    //创建左边View，添加约束，通过nib文件加载设置代理。
    WNXLeftMenuView *view = [[NSBundle mainBundle] loadNibNamed:@"WNXLeftMenuView" owner:nil options:nil].lastObject;
    
    view.delegate = self;
    
    [self.view insertSubview:view atIndex:1];

    //使用masonry进行布局，添加约束。
    [view makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.view.top).offset(40);
        make.bottom.equalTo(self.view.bottom).offset(-20);
        make.width.equalTo(self.view.width).multipliedBy(0.8);
    }];
    self.leftMenuView = view;
    
    //添加手势
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    pan.delegate = self;
    [self.view addGestureRecognizer:pan];
}

- (void)configSubview:(NSArray *)array {
    //创建子控制器
    for (NSString *str in array) {
        UIViewController *viewController = [[NSClassFromString(str) alloc]init];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:viewController];
        
        [self addChildViewController:nav];
    }
    
    //创建左控制器
    WNXLeftMenuView *leftMenuView = [[[NSBundle mainBundle]loadNibNamed:@"WNXLeftMenu" owner:nil options:nil]lastObject];
    leftMenuView.delegate = self;
    [self.view insertSubview:leftMenuView atIndex:1];
    //进行布局
    [leftMenuView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.left);
        make.top.equalTo(self.view.top).offset(20);
        make.bottom.equalTo(self.view.bottom);
        make.width.equalTo(self.view.width);
    }];
    //添加进view
    self.leftMenuView = leftMenuView;
    
    
    //添加手势
    UIPanGestureRecognizer *panGesutre = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
    panGesutre.delegate = self;
    [self.view addGestureRecognizer:panGesutre];
    
    
}

#pragma mark -  难点其实就是这里
#pragma mark - 手势
//拖拽Action，稍微有点技术难度，把这里理清楚
- (void)pan:(UIPanGestureRecognizer *)pan
{
    //得到手势
    CGFloat moveX = [pan translationInView:self.view].x;
    
    //基本缩放的最终比例值
    CGFloat zoomScale = (WNXAppHeight - WNXScaleTopMargin * 2) / WNXAppHeight;
    
    //X最终偏移距离-阀值
    CGFloat maxMoveX = WNXAppWidth - WNXAppWidth * WNXZoomScaleRight;

    //没有缩放时，允许缩放
    if (self.showViewController.isScale == NO) {
        //在允许滑动的范围内
        if (moveX <= maxMoveX + 5 && moveX >= 0) {
            
            //获取X偏移XY缩放的比例
            CGFloat scaleXY = 1 - moveX / maxMoveX * WNXZoomScaleRight;
            
            //x,y移动，y轴变换一次
            CGAffineTransform transform = CGAffineTransformMakeScale(scaleXY, scaleXY);
            
            //移动当前显示的导航控制器，知道为什么不用这个了，因为要实现连续的移动，CGAffineTransformMakeTranslation是以最初位置为中心。所以不能实现在拖拽的时候移动。那么就可以用CGAffineTransformTranslate实现。他是以上一个translat为中心。这样就可以实现。边拖拽边缩放。
            //self.showViewController.navigationController.view.transform = CGAffineTransformMakeTranslation(scaleXY, scaleXY);
            
            //这种效果比较好，没有卡顿，设置x的值为多少时才变换,一个神奇的东西
            self.showViewController.navigationController.view.transform = CGAffineTransformTranslate(transform,moveX / scaleXY ,0);
        }
        
        
        //当手势停止的时候,判断X轴的移动距离，停靠
        //判断手势状态
        if (pan.state == UIGestureRecognizerStateEnded) {
            //计算剩余停靠时间
            if (moveX >= maxMoveX / 2) {
                //延迟控制变换的速度
                CGFloat duration = 0.5 * (maxMoveX - moveX)/maxMoveX > 0 ? 0.5 * (maxMoveX - moveX)/maxMoveX : -(0.5 * (maxMoveX - moveX)/maxMoveX);
                if (duration <= 0.1) duration = 0.1;
                
                //直接停靠到停止的位置
                [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                    //直接移动到最初的位置。，注意缩放遍历
                    CGAffineTransform tt = CGAffineTransformMakeScale(zoomScale, zoomScale);
                    //保持y轴不变
                    self.showViewController.navigationController.view.transform = CGAffineTransformTranslate(tt, maxMoveX , 0);
                    
                } completion:^(BOOL finished) {
                    //将状态改为已经缩放
                    self.showViewController.isScale = YES;
                    
                    
                    //手动点击按钮添加遮盖，发送view移动
                    [self.showViewController rightClick];
                }];
                
            } else  {
                
                //X轴移动不够一半 回到原位,不是缩放状态
                [UIView animateWithDuration:0.2 animations:^{
                    //回到最初的位置
                    self.showViewController.navigationController.view.transform = CGAffineTransformIdentity;
                    
                } completion:^(BOOL finished) {
                    
                    self.showViewController.isScale = NO;
                }];
            }
        }
    }
    else if (self.showViewController.isScale == YES) {
        //已经缩放的情况下
        
        //计算比例
        CGFloat scaleXY = zoomScale - moveX / maxMoveX * WNXZoomScaleRight;
        
        //向左拖动的过程中只要小于5，则直接变换
        if (moveX <= 5) {
                        
            CGAffineTransform transform = CGAffineTransformMakeScale(scaleXY, scaleXY);
            
            self.showViewController.navigationController.view.transform = CGAffineTransformTranslate(transform, (moveX + maxMoveX), 0);
        }
        
        //当手势停止的时候,判断X轴的移动距离，停靠
        if (pan.state == UIGestureRecognizerStateEnded) {
            
            //计算剩余停靠时间，处理向左移动
            if (-moveX >= maxMoveX / 2) {
                //延迟控制变换的速度
                CGFloat duration = 0.5 * (maxMoveX + moveX)/maxMoveX > 0 ? 0.5 * (maxMoveX + moveX)/maxMoveX : -(0.5 * (maxMoveX + moveX)/maxMoveX);
                if (duration <= 0.1) duration = 0.1;
                //直接停靠到停止的位置，用线性动画
                /*
                 typedef NS_OPTIONS(NSUInteger, UIViewAnimationOptions) {
                 UIViewAnimationOptionLayoutSubviews            = 1 <<  0,
                 UIViewAnimationOptionAllowUserInteraction      = 1 <<  1, // turn on user interaction while animating
                 UIViewAnimationOptionBeginFromCurrentState     = 1 <<  2, // start all views from current value, not initial value
                 UIViewAnimationOptionRepeat                    = 1 <<  3, // repeat animation indefinitely
                 UIViewAnimationOptionAutoreverse               = 1 <<  4, // if repeat, run animation back and forth
                 UIViewAnimationOptionOverrideInheritedDuration = 1 <<  5, // ignore nested duration
                 UIViewAnimationOptionOverrideInheritedCurve    = 1 <<  6, // ignore nested curve
                 UIViewAnimationOptionAllowAnimatedContent      = 1 <<  7, // animate contents (applies to transitions only)
                 UIViewAnimationOptionShowHideTransitionViews   = 1 <<  8, // flip to/from hidden state instead of adding/removing
                 UIViewAnimationOptionOverrideInheritedOptions  = 1 <<  9, // do not inherit any options or animation type
                 
                 UIViewAnimationOptionCurveEaseInOut            = 0 << 16, // default
                 UIViewAnimationOptionCurveEaseIn               = 1 << 16,
                 UIViewAnimationOptionCurveEaseOut              = 2 << 16,
                 UIViewAnimationOptionCurveLinear               = 3 << 16,
                 
                 UIViewAnimationOptionTransitionNone            = 0 << 20, // default
                 UIViewAnimationOptionTransitionFlipFromLeft    = 1 << 20,
                 UIViewAnimationOptionTransitionFlipFromRight   = 2 << 20,
                 UIViewAnimationOptionTransitionCurlUp          = 3 << 20,
                 UIViewAnimationOptionTransitionCurlDown        = 4 << 20,
                 UIViewAnimationOptionTransitionCrossDissolve   = 5 << 20,
                 UIViewAnimationOptionTransitionFlipFromTop     = 6 << 20,
                 UIViewAnimationOptionTransitionFlipFromBottom  = 7 << 20,
                 } NS_ENUM_AVAILABLE_IOS(4_0);
                 */
                [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{

                    self.showViewController.navigationController.view.transform = CGAffineTransformIdentity;
                    
                } completion:^(BOOL finished) {
                    //将状态改为已经缩放
                    self.showViewController.isScale = NO;
                    //手动点击按钮添加遮盖
                    [self.showViewController coverClick];
                }];
                
            } else {//X轴移动不够一半 回到原位,不是缩放状态
                
                [UIView animateWithDuration:0.2 animations:^{
                    
                    CGAffineTransform tt = CGAffineTransformMakeScale(zoomScale, zoomScale);
                    self.showViewController.navigationController.view.transform = CGAffineTransformTranslate(tt, maxMoveX, 0);
                    
                } completion:^(BOOL finished) {
                    
                    self.showViewController.isScale = YES;
                    
                }];
            }
        }
    }
    
}


#pragma mark - WNXLeftMenuViewDelegate 左视图按钮点击事件
- (void)leftMenuViewButtonClcikFrom:(WNXleftButtonType)fromIndex to:(WNXleftButtonType)toIndex
{
    
    if (toIndex == WNXleftButtonTypeSina || toIndex == WNXleftButtonTypeWeiXin) {
#warning 三方登陆
        //登陆成功隐藏2个按钮，修改iconBtn的头像和名字
        //显示去去过和收藏
        return;
    }
    
    //以下的其实是在模仿tabviewcontroller的内部实现。
    
    //暂时先做没有登陆的情况的点击
    WNXNavigationController *newNC = self.childViewControllers[toIndex];
    //取出新控制器的view
    if (toIndex == WNXleftButtonTypeIcon) {
        newNC = self.childViewControllers[fromIndex];
    }
    
    //移除旧的控制器view
    WNXNavigationController *oldNC = self.childViewControllers[fromIndex];
    [oldNC.view removeFromSuperview];
    
    //添加新的控制器view
    [self.view addSubview:newNC.view];
    
    //新控制器赋值新的位置
    newNC.view.transform = oldNC.view.transform;
    
    //取出导航控制器的索引为0的视图控制器
    self.showViewController = newNC.childViewControllers[0];
    
    //解决点击按钮leftViewCictyBtn选中BUG
    self.showViewController.coverDidRomove = ^{
        [self.leftMenuView coverIsRemove];
    };

    //自动点击遮盖btn
    //没如下代码出现不能自动弹出新视图
    [self.showViewController coverClick];

}



@end
