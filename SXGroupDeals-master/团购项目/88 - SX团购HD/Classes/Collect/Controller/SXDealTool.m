//
//  SXDealTool.m
//  88 - SX团购HD
//
//  Created by 董 尚先 on 15/2/8.
//  Copyright (c) 2015年 shangxianDante. All rights reserved.
//

#import "SXDealTool.h"
#import "SXDeal.h"

static int const SXMaxHistoryDealsCount = 9;
// $$$$$
#define SXcollectSaveFile [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,  NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"collectDeals.data"]

#define SXhistorySaveFile [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,  NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"historyDeals.data"]
@implementation SXDealTool

static NSMutableArray *_collectedDeals;
static NSMutableArray *_historyDeals;

+ (void)initialize
{
    _collectedDeals = [NSKeyedUnarchiver unarchiveObjectWithFile:SXcollectSaveFile];
    if (_collectedDeals == nil) {
        _collectedDeals = [NSMutableArray array];
    }
    
    // 从文件中读取之前访问的团购
    _historyDeals = [NSKeyedUnarchiver unarchiveObjectWithFile:SXhistorySaveFile];
    if (_historyDeals == nil) {
        _historyDeals = [NSMutableArray array];
    }
}

+ (NSArray *)collectedDeals
{
    return _collectedDeals;
}

#warning 怎么保存了？
+ (BOOL)isCollected:(SXDeal *)deal
{
    return [_collectedDeals containsObject:deal]; // $$$$$
}

+ (void)collect:(SXDeal *)deal{
    [_collectedDeals insertObject:deal atIndex:0]; // $$$$$
    [NSKeyedArchiver archiveRootObject:_collectedDeals toFile:SXcollectSaveFile];
    
}

+ (void)uncollect:(SXDeal *)deal{
    [_collectedDeals removeObject:deal];
    [NSKeyedArchiver archiveRootObject:_collectedDeals toFile:SXcollectSaveFile];
}

/** 批量删除 */
+ (void)uncollectDeals:(NSArray *)deals
{
    [_collectedDeals removeObjectsInArray:deals];
    [NSKeyedArchiver archiveRootObject:_collectedDeals toFile:SXcollectSaveFile];
}

#pragma mark - 历史记录
/**
 *  返回用户访问的所有团购
 */
+ (NSArray *)historyDeals
{
    return _historyDeals;
}

/**
 *  添加一个最近访问团购
 */
+ (void)addHistoryDeal:(SXDeal *)deal
{
    // 添加
    [_historyDeals removeObject:deal];
    [_historyDeals insertObject:deal atIndex:0];
    
    // 删除最后一个团购
    if (_historyDeals.count > SXMaxHistoryDealsCount) {
        [_historyDeals removeLastObject];
    }
    
    [NSKeyedArchiver archiveRootObject:_historyDeals toFile:SXhistorySaveFile];
}

/**
 *  删除最近访问的团购
 */
+ (void)removeHistoryDeal:(SXDeal *)deal
{
    [_historyDeals removeObject:deal];
    [NSKeyedArchiver archiveRootObject:_historyDeals toFile:SXhistorySaveFile];
}

+ (void)removeHistoryDeals:(NSArray *)deals
{
    [_historyDeals removeObjectsInArray:deals];
    [NSKeyedArchiver archiveRootObject:_historyDeals toFile:SXhistorySaveFile];
}

@end
