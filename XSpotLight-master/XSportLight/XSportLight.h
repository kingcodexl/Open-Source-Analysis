//
//  XSportLight.h
//  XSportLight
//
//  Created by xlx on 15/8/22.
//  Copyright (c) 2015年 xlx. All rights reserved.
//  高亮视图控制器

#import <UIKit/UIKit.h>
#import "EMHint.h"

@class XSportLight;
// 声明协议
@protocol XSportLightDelegate <NSObject>
// 可选
@optional
- (void)XSportLightClicked:(NSInteger)index;

@end

@interface XSportLight : UIViewController<EMHintDelegate>
{
    /**
     *  实体类
     */
    EMHint *modalState;
}

@property (nonatomic, strong) NSArray *messageArray;
@property (nonatomic, strong) NSArray *rectArray;
@property (nonatomic, weak  ) id<XSportLightDelegate> delegate;

@end
