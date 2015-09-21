//
//  SXCity.m
//  88 - SX团购HD
//
//  Created by 董 尚先 on 15/2/5.
//  Copyright (c) 2015年 shangxianDante. All rights reserved.
//

#import "SXCity.h"
#import "MJExtension.h"
#import "SXDistrict.h"

@implementation SXCity

+ (NSDictionary *)objectClassInArray
{
    return @{@"districts" : [SXDistrict class]};
}

@end
