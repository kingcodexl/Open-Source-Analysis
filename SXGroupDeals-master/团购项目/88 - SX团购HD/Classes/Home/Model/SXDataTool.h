//
//  SXDataTool.h
//  88 - SX团购HD
//
//  Created by 董 尚先 on 15/2/4.
//  Copyright (c) 2015年 shangxianDante. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SXCity;

@interface SXDataTool : NSObject


/** 从plist文件加载排序信息 */
+ (NSArray *)sorts;

/** 从plist文件加载分类信息 */
+ (NSArray *)categorys;

/** 从plist文件加载城市详细信息 */
+ (NSArray *)cities;

/** 从plist文件加载城市组ABCD */
+ (NSArray *)cityGroups;

/** 所有城市名字集合 */
+ (NSArray *)cityNames;

/**  根据城市名字 获得 城市模型 */
+ (SXCity *)cityWithName:(NSString *)name;
@end
