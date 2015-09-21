//
//  SXFindDealResult.m
//  88 - SX团购HD
//
//  Created by 董 尚先 on 15/2/5.
//  Copyright (c) 2015年 shangxianDante. All rights reserved.
//

#import "SXFindDealResult.h"
#import "SXDeal.h"

@implementation SXFindDealResult

// 为了性能更好，把前面模型里的数组对象deals 指定成这个SXDeal类
+ (NSDictionary *)objectClassInArray // $$$$$
{
    return @{@"deals" : [SXDeal class]};
}

@end
