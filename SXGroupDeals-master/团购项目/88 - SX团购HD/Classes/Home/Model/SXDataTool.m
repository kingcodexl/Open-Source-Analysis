//
//  SXDataTool.m
//  88 - SX团购HD
//
//  Created by 董 尚先 on 15/2/4.
//  Copyright (c) 2015年 shangxianDante. All rights reserved.
//

#import "SXDataTool.h"
#import "MJExtension.h"
#import "SXCategory.h"
#import "SXSort.h"
#import "SXCity.h"
#import "SXCityGroup.h"

@implementation SXDataTool

/** 从plist文件加载排序信息 */
static NSArray *_sorts;
+ (NSArray *)sorts
{
    if (_sorts == nil) {
        _sorts = [SXSort objectArrayWithFilename:@"sorts.plist"]; // $$$$$
    }
    return _sorts;
    
}

/** 从plist文件加载分类信息 */
static NSArray *_categorys;
+ (NSArray *)categorys
{
    if (_categorys == nil) {
        _categorys = [SXCategory objectArrayWithFilename:@"categories.plist"];
    }
    return _categorys;
}

/** 从plist文件加载城市详细信息 */
static NSArray *_cities;
+ (NSArray *)cities
{
    if (_cities == nil) {
        _cities = [SXCity objectArrayWithFilename:@"cities.plist"];
    }
    return _cities;
}

/** 从plist文件加载城市组ABCD */
static NSArray *_cityGroups;
+ (NSArray *)cityGroups
{
    if (_cityGroups == nil) {
        _cityGroups = [SXCityGroup objectArrayWithFilename:@"cityGroups.plist"];
    }
    return _cityGroups;
}

/** 所有城市名字集合 */
static NSArray *_cityNames;
+ (NSArray *)cityNames
{
    if (_cityNames == nil) {
        NSArray *temArray = [self cityGroups];
        NSMutableArray *mutableArray = [NSMutableArray array];
        [temArray enumerateObjectsUsingBlock:^(SXCityGroup* obj, NSUInteger idx, BOOL *stop) {
            if (idx == 0) return ;
            // 把这个数组的元素加进来 而不是 把一个个数组加进来
            [mutableArray addObjectsFromArray:obj.cities]; // $$$$$
        }];
        _cityNames = mutableArray;
    }
    return _cityNames;
}

/**  根据城市名字 获得 城市模型 */
+ (SXCity *)cityWithName:(NSString *)name
{
    if (name.length == 0) return nil;
    
    return [[[self cities] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"name == %@",name]] firstObject]; // $$$$$

}

@end
