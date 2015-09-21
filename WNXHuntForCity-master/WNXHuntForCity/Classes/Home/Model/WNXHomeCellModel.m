//
//  WNXHomeCellModel.m
//  WNXHuntForCity
//  github:    https://github.com/ZhongTaoTian/WNXHuntForCity
//  项目讲解博客:http://www.jianshu.com/p/8b0d694d1c69
//  Created by MacBook on 15/7/20.
//  Copyright (c) 2015年 维尼的小熊. All rights reserved.
//  首页cell的模型

#import "WNXHomeCellModel.h"
#import <MJExtension.h>

@implementation WNXHomeCellModel

+ (instancetype)cellModelWithDict:(NSDictionary *)dict
{
    WNXHomeCellModel *model = [[self alloc] init];
    
    //通过MJExtension分类实现，将读取的字典给属性赋值。
    //直接通过对象赋值，不用一个一个的赋值
    [model setKeyValues:dict];
    return model;
}

@end
