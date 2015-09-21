//
//  SXDetailViewController.m
//  88 - SX团购HD
//
//  Created by 董 尚先 on 15/2/7.
//  Copyright (c) 2015年 shangxianDante. All rights reserved.
//

#import "SXDetailViewController.h"
#import "SXDeal.h"
#import "UIView+AutoLayout.h"
#import "UIImageView+WebCache.h"
#import "DPAPI.h"
#import "MBProgressHUD+MJ.h"
#import "SXFindDealResult.h"
#import "MJExtension.h"
#import "SXDealTool.h"

@interface SXDetailViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (weak, nonatomic) IBOutlet UIView *leftView;
@property (nonatomic, weak) UIActivityIndicatorView *loadingView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *listPriceLabel;
@property (weak, nonatomic) IBOutlet UIButton *leftTimeButton;
@property (weak, nonatomic) IBOutlet UIButton *soldNumberButton;
@property (weak, nonatomic) IBOutlet UIButton *anyTimeRefuntableButton;
@property (weak, nonatomic) IBOutlet UIButton *expiresRefuntableButton;
@property (weak, nonatomic) IBOutlet UIButton *starBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutWidth;
@end

@implementation SXDetailViewController
- (IBAction)collect:(UIButton *)btn {
    if ([btn isSelected]) {
        [SXDealTool uncollect:self.deal];
    }else{
        [SXDealTool collect:self.deal];
    }
    
    btn.selected = !btn.isSelected;
}

#pragma mark - ******************** 懒加载
- (UIActivityIndicatorView *)loadingView
{
    if (!_loadingView) {
        UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [self.webView addSubview:loadingView];
        
        // 居中
        [loadingView autoCenterInSuperview];
        self.loadingView = loadingView;
    }
    return _loadingView;
}

- (IBAction)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setLeftView];
    [self setRightView];
    
    // 添加这个团购到访问记录
    [SXDealTool addHistoryDeal:self.deal];
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [self viewWillTransitionToSize:[UIScreen mainScreen].bounds.size withTransitionCoordinator:nil];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    if (size.width < SXScreenMaxWH){
        self.layoutWidth.constant = 300;
    }else{
        self.layoutWidth.constant = 400;
    }
}

- (void)setLeftView
{
    // 星星是否有
    self.starBtn.selected = [SXDealTool isCollected:self.deal];
    // 图片
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.deal.image_url] placeholderImage:[UIImage imageNamed:@"placeholder_deal"]];
    // 标题
    self.titleLabel.text = self.deal.title;
    // 描述
    self.descLabel.text = self.deal.desc;
    // 原价
    self.listPriceLabel.text = [NSString stringWithFormat:@"￥%@", self.deal.list_price];
    // 现价
    self.currentPriceLabel.text = [NSString stringWithFormat:@"￥%@", self.deal.current_price];
    // 购买数
    [self.soldNumberButton setTitle:[NSString stringWithFormat:@"已售出%d", self.deal.purchase_count] forState:UIControlStateNormal];
    
    // 获得过期时间
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    NSDate *dead = [fmt dateFromString:self.deal.purchase_deadline];
    // 增加一天的过期时间
    dead = [dead dateByAddingTimeInterval:24 * 60 * 60];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitDay | NSCalendarUnitHour |NSCalendarUnitMinute;
    NSDateComponents *cmps = [calendar components:unit fromDate:[NSDate date] toDate:dead options:kNilOptions];
    // 设置剩余时间
    [self.leftTimeButton setTitle:[NSString stringWithFormat:@"剩余%d天%d时%d分", cmps.day, cmps.hour, cmps.minute] forState:UIControlStateNormal];
    NSLog(@"%@",self.leftTimeButton.titleLabel.text);
    
    // 设置剩余时间
    if (cmps.day >= 30) {
        [self.leftTimeButton setTitle:@"未来1个月内有效" forState:UIControlStateNormal];
    } else {
        [self.leftTimeButton setTitle:[NSString stringWithFormat:@"剩余%d天%d时%d分", cmps.day, cmps.hour, cmps.minute] forState:UIControlStateNormal];
    }
    
    // 发送请求给服务器获得更详细的团购信息
    NSDictionary *params = @{@"deal_id" : self.deal.deal_id};
    [[DPAPI sharedInstance] request:@"v1/deal/get_single_deal" params:params success:^(id json) {
        SXFindDealResult *result = [SXFindDealResult objectWithKeyValues:json];
        self.deal = [result.deals lastObject];
        
        self.anyTimeRefuntableButton.selected = self.deal.is_refundable;
        self.expiresRefuntableButton.selected = self.deal.is_refundable;
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"找不到指定的团购信息"];
    }];
    
}

- (void)setRightView
{
    self.webView.scrollView.contentInset = UIEdgeInsetsMake(20, 0, 10, 0);
    
    // 开始转圈圈
    [self.loadingView startAnimating];
    
    // 隐藏
    self.webView.scrollView.hidden = YES;
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.deal.deal_h5_url]]];
}

#pragma mark - ******************** 设置当前设备支持哪几个方向
//- (NSUInteger)supportedInterfaceOrientations
//{
//    //    if (self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
//    // 这两个不一样要分清
//    //    }
//    return UIInterfaceOrientationMaskLandscapeLeft;
//}

//- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType //受否允许他发请求
//{
//    return YES;
//}

#pragma mark - ******************** webView加载完成
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *ID = [self.deal.deal_id substringFromIndex:2];
    NSString *lastUrl = webView.request.URL.absoluteString;
    if (![lastUrl hasSuffix:ID]) {// $$$$$
        // 截取id
        NSString *url = [NSString stringWithFormat:@"http://lite.m.dianping.com/group/deal/moreinfo/%@", ID];
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    }else {
        // 加载详情完毕
        // 执行JS删掉不需要的节点
        NSString *js = @"document.getElementsByTagName('header')[0].remove();"
        "document.getElementsByClassName('cost-box')[0].remove();"
        "document.getElementsByClassName('buy-now')[0].remove();";
        [webView stringByEvaluatingJavaScriptFromString:js];
        
        [self.loadingView stopAnimating];
        
        self.webView.scrollView.hidden = NO;
    }
}

@end
