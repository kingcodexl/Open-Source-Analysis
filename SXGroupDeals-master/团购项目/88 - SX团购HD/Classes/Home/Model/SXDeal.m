//
//  SXDeal.m
//  88 - SX团购HD
//
//  Created by 董 尚先 on 15/2/5.
//  Copyright (c) 2015年 shangxianDante. All rights reserved.
//

#import "SXDeal.h"
#import "NSString+Translate.h"
#import "MJExtension.h"

@implementation SXDeal

// 因为出现了关键字重复，把模型里的desc指定成plist里的description
+ (NSDictionary *)replacedKeyFromPropertyName   // $$$$$
{
    return @{@"desc" : @"description",
              @"is_refundable" : @"restrictions.is_refundable"};
}

- (void)setList_price:(NSString *)list_price
{
    _list_price = list_price.dealedPriceString;
}

- (void)setCurrent_price:(NSString *)current_price
{
    _current_price = current_price.dealedPriceString;
}

- (BOOL)isEqual:(SXDeal *)other
{
    return [self.deal_id isEqualToString:other.deal_id];
}


/** 归档一句完事 */
MJCodingImplementation

@end
