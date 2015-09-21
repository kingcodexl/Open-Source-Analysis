//
//  SXDealTool.h
//  88 - SX团购HD
//
//  Created by 董 尚先 on 15/2/8.
//  Copyright (c) 2015年 shangxianDante. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SXDeal;
@interface SXDealTool : NSObject


+ (NSArray *)collectedDeals;

+ (BOOL)isCollected:(SXDeal *)deal;

+ (void)collect:(SXDeal *)deal;

+ (void)uncollect:(SXDeal *)deal;

+ (void)uncollectDeals:(NSArray *)deals;


+ (NSArray *)historyDeals;
+ (void)addHistoryDeal:(SXDeal *)deal;
+ (void)removeHistoryDeal:(SXDeal *)deal;
+ (void)removeHistoryDeals:(NSArray *)deals;
@end
