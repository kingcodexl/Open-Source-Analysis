//
//  SXTopBarItemView.h
//  88 - SX团购HD
//
//  Created by 董 尚先 on 15/2/4.
//  Copyright (c) 2015年 shangxianDante. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SXTopBarItemView : UIView


+ (instancetype)item;


- (void)setTitle:(NSString *)title;
- (void)setSubtitle:(NSString *)subtitle;
- (void)setIcon:(NSString *)imageName highIcon:(NSString *)highImageName;
- (void)addTarget:(id)targer action:(SEL)action;
@end
