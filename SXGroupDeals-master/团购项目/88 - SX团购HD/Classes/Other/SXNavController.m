//
//  SXNavController.m
//  88 - SX团购HD
//
//  Created by 董 尚先 on 15/2/4.
//  Copyright (c) 2015年 shangxianDante. All rights reserved.
//

#import "SXNavController.h"

@interface SXNavController ()

@end

@implementation SXNavController

+ (void)initialize
{
    // 设置导航栏的主题
    UINavigationBar *navBar = [UINavigationBar appearance];
    [navBar setBackgroundImage:[UIImage imageNamed:@"bg_navigationBar_normal"] forBarMetrics:UIBarMetricsDefault];
    
    // 设置导航栏上面item的文字属性
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    // 普通文字颜色
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSForegroundColorAttributeName] = SXColor(21, 188, 173); // 文字颜色
    [item setTitleTextAttributes:attrs forState:UIControlStateNormal];
    // 不可交互时的文字颜色
    NSMutableDictionary *disabledAttrs = [NSMutableDictionary dictionary];
    disabledAttrs[NSForegroundColorAttributeName] = SXARGBColor(0.5, 100, 100, 100); // 文字颜色
    [item setTitleTextAttributes:disabledAttrs forState:UIControlStateDisabled];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
