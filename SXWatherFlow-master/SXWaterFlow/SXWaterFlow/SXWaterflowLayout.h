//
//  SXWaterflowLayout.h
//  SXWaterFlow
//
//  Created by 董 尚先 on 15/3/21.
//  Copyright (c) 2015年 shangxianDante. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SXWaterflowLayout;

@protocol SXWaterflowLayoutDelegate <NSObject>
@required
/**
 * 返回indexPath位置cell的高度
 */
- (CGFloat)waterflowLayout:(SXWaterflowLayout *)layout heightForItemAtIndexPath:(NSIndexPath *)indexPath withItemWidth:(CGFloat)width;

@optional
- (CGFloat)rowMarginInWaterflowLayout:(SXWaterflowLayout *)layout;
- (CGFloat)columnMarginInWaterflowLayout:(SXWaterflowLayout *)layout;
- (NSUInteger)columnsCountInWaterflowLayout:(SXWaterflowLayout *)layout;
- (UIEdgeInsets)insetsInWaterflowLayout:(SXWaterflowLayout *)layout;
@end

@interface SXWaterflowLayout : UICollectionViewLayout
@property (nonatomic, weak) id<SXWaterflowLayoutDelegate> delegate;
@end
