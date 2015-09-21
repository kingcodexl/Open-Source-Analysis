//
//  ViewController.m
//  88 - SX团购HD
//
//  Created by 董 尚先 on 15/2/3.
//  Copyright (c) 2015年 shangxianDante. All rights reserved.
//

/*
 * App Key：975791789
 * App Secret：5e4dcaf696394707b9a0139e40074ce9
 */

#import "ViewController.h"
#import "DPAPI.h"

@interface ViewController ()<DPRequestDelegate>
@property(nonatomic,strong) DPAPI *api;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    SXLog(@"---");
    DPAPI *api = [[DPAPI alloc]init];
    self.api = api;
    NSMutableDictionary *params1 = [NSMutableDictionary dictionary];
    params1[@"city"]= @"广州";
    
    [self.api request:@"v1/deal/find_deals" params:params1 success:^(id json) {
        SXLog(@"广州的请求成功");
    } failure:^(NSError *error) {
        SXLog(@"广州的请求失败");
    }];
    
    
    NSMutableDictionary *params2 = [NSMutableDictionary dictionary];
    params2[@"city"]= @"北京";
    
    [[DPAPI sharedInstance] request:@"v1/deal/find_deals" params:params2 success:^(id json) {
        SXLog(@"北京的请求成功");
    } failure:^(NSError *error) {
        SXLog(@"北京的请求失败");
    }];
    
   
    
}



@end
