//
//  SXDistrict.h
//  88 - SX团购HD
//
//  Created by 董 尚先 on 15/2/5.
//  Copyright (c) 2015年 shangxianDante. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SXDistrict : NSObject

/** 区域名称 */
@property (nonatomic, copy) NSString *name;
/** 这个区域的所有子区域 */
@property (nonatomic, strong) NSArray *subdistricts;

@end
