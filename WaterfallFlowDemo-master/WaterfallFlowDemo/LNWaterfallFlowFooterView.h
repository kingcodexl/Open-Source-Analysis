//
//  LNWaterfallFlowFooterView.h
//  WaterfallFlowDemo
//
//  Created by Lining on 15/5/3.
//  Copyright (c) 2015年 Lining. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LNWaterfallFlowFooterView : UICollectionReusableView

// 指示器,需要暴露给外面
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;

@end
