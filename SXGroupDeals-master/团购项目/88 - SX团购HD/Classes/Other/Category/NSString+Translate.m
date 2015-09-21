//
//  NSString+Translate.m
//  88 - SX团购HD
//
//  Created by 董 尚先 on 15/2/7.
//  Copyright (c) 2015年 shangxianDante. All rights reserved.
//

#import "NSString+Translate.h"

@implementation NSString (Translate)

- (instancetype)dealedPriceString
{
    NSString *newString = self;
    
    NSUInteger location = [newString rangeOfString:@"."].location;
    
    // 如果是98元 就直接返回，有小数才来
    if (location == NSNotFound) return newString;
    
    NSUInteger smallNumCount = newString.length - location -1;
    
    if (smallNumCount <= 2) return newString;
    
    // 如果是98.888888 就截取成98.88
    newString = [newString substringToIndex:location + 3];
    if (![newString hasSuffix:@"0"]) return newString;
    
    // 如果是89.90 就截取成89.9
    newString = [newString substringToIndex:newString.length - 1];
    
    return newString;
}

@end
