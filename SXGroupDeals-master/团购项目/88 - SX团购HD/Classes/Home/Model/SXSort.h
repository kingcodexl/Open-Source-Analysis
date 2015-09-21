//
//  SXSort.h
//  88 - SX团购HD
//
//  Created by 董 尚先 on 15/2/4.
//  Copyright (c) 2015年 shangxianDante. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SXSort : NSObject
/** 文字描述 */
@property (nonatomic, copy) NSString *label;
/** 这个排序具体的值（将来发给服务器） */
@property (nonatomic, assign) int value;
@end
