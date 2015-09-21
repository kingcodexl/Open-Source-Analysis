//
//  WNXRenderBlurView.h
//  WNXHuntForCity
//
//  Created by MacBook on 15/7/16.
//  Copyright (c) 2015年 维尼的小熊. All rights reserved.
//  模糊的View

#import <UIKit/UIKit.h>

@class WNXRenderBlurView;

//定义渲染模糊视图的代理
@protocol WNXRenderBlurViewDelegate <NSObject>

- (void)renderBlurView:(WNXRenderBlurView *)view didSelectedCellWithTitle:(NSString *)title;

- (void)renderBlurViewCancelBtnClick:(WNXRenderBlurView *)view;

@end

@interface WNXRenderBlurView : UIImageView

+ (instancetype)renderBlurViewWithImage:(UIImage *)image;

@property (nonatomic, weak) id <WNXRenderBlurViewDelegate> delegate;

- (void)hideBlurView;

@end
