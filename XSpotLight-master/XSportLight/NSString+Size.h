//
//  NSString+Size.h
//  SianWeibo
//
//  Created by kingcodexl on 15/9/3.
//  Copyright (c) 2015年 KingcodeXL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NSString (Size)

/**
 *  获取字符串的CGSize
 *
 *  @param font 字体
 *
 *  @return 大小
 */
- (CGSize)testSizeWithFont:(UIFont *)font;

/*
 *  获取字符串的CGSize
 *
 *  @param font          字体
 *  @param size          字符串最大的CGSize,高度和长度
 *  @param lineBreakMode 长短不够情况下如何处理，一共有五种方式
 *
 *  @return <#return value description#>
 */
- (CGSize)textSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode;

@end
