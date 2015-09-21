//
//  SXCity.h
//  88 - SX团购HD
//
//  Created by 董 尚先 on 15/2/5.
//  Copyright (c) 2015年 shangxianDante. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SXCity : NSObject

/** 城市名称 */
@property (nonatomic, copy) NSString *name;
/** 城市名称的拼音 */
@property (nonatomic, copy) NSString *pinYin;
/** 城市名称的拼音声母 */
@property (nonatomic, copy) NSString *pinYinHead;

/** 这个城市的所有区域（里面都是HMDistrict模型） */
@property (nonatomic, strong) NSArray *districts;

@end
