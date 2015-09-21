//
//  SXCityGroup.h
//  88 - SX团购HD
//
//  Created by 董 尚先 on 15/2/5.
//  Copyright (c) 2015年 shangxianDante. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SXCityGroup : NSObject
/** 这组的名称 */
@property (nonatomic, copy) NSString *title;
/** 这组的城市名称 */
@property (nonatomic, strong) NSArray *cities;
@end
