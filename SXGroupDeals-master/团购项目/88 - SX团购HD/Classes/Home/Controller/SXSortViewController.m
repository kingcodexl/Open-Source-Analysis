//
//  SXSortViewController.m
//  88 - SX团购HD
//
//  Created by 董 尚先 on 15/2/4.
//  Copyright (c) 2015年 shangxianDante. All rights reserved.
//

#import "SXSortViewController.h"
#import "SXSort.h"
#import "SXDataTool.h"

@interface SXSortViewController ()

@end

@implementation SXSortViewController

#pragma mark - ******************** 首次加载
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setButton];
    
    UIButton *lastButton = [self.view.subviews lastObject];
    CGFloat y = CGRectGetMaxY(lastButton.frame) + 10;
    // 设置自己弹出时的尺寸大小
    self.preferredContentSize = CGSizeMake(130, y); // $$$$$
}

#pragma mark - ******************** 设置按钮
- (void)setButton
{
    NSArray *sorts = [SXDataTool sorts];
    
    for (int i = 0; i < sorts.count; i++) {
        UIButton *btn = [[UIButton alloc]init];
        btn.tag = i;
        CGFloat btnW = 100;
        CGFloat btnH = 30;
        CGFloat btnMargin = 15;
        CGFloat btnX = btnMargin;
        CGFloat btnY = i * (btnMargin + btnH) + btnMargin;
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
//        btn.titleLabel.text = [sorts[i] label];
        [btn setTitle:[sorts[i] label] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [btn setBackgroundImage:[UIImage imageNamed:@"btn_filter_normal"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"btn_filter_selected"] forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:btn];
    }
    
}

#pragma mark - ******************** 按钮点击
- (void)btnClick:(UIButton *)btn
{
    // 发出通知
    NSDictionary *params = @{SXCurrentSortKey : [SXDataTool sorts][btn.tag]};
    [SXNoteCenter postNotificationName:SXSortDidChangeNotification object:nil userInfo:params];
    // 自己消失
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
