//
//  SXFindDealResult.h
//  88 - SX团购HD
//
//  Created by 董 尚先 on 15/2/5.
//  Copyright (c) 2015年 shangxianDante. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SXFindDealResult : NSObject

/** 所有团购总数 */
@property (nonatomic, assign) int total_count;
/** 本次团购数据（里面都是HMDeal模型） */
@property (nonatomic, strong) NSArray *deals;

@end
