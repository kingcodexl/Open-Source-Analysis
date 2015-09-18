//
//  JSDropDownMenu.h
//  JSDropDownMenu
//
//  Created by Jsfu on 15-1-12.
//  Copyright (c) 2015年 jsfu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ENUM_INDEXTYPE){
    LEFTTYPE,
    RIGTHTYPE,
};
@interface JSIndexPath : NSObject
/**
 *  列
 */
@property (nonatomic, assign) NSInteger column;

@property (nonatomic, assign) ENUM_INDEXTYPE leftOrright;
/**
 *  记录当前是左还是右
 */
// 0 左边   1 右边
@property (nonatomic, assign) NSInteger leftOrRight;
// 左边行
@property (nonatomic, assign) NSInteger leftRow;
// 右边行
@property (nonatomic, assign) NSInteger row;

- (instancetype)initWithColumn:(NSInteger)column leftOrRight:(NSInteger)leftOrRight leftRow:(NSInteger)leftRow row:(NSInteger)row;
+ (instancetype)indexPathWithCol:(NSInteger)col leftOrRight:(NSInteger)leftOrRight leftRow:(NSInteger)leftRow row:(NSInteger)row;

@end

#pragma mark - 代理声明，这些声明是为了让这些操作在外部实现。类比tableview的代理设计

#pragma mark - data source protocol
@class JSDropDownMenu;
/**
 * 菜单数据源协议
 */
@protocol JSDropDownMenuDataSource <NSObject>

@required
/**
 * 一共多少行
 */
- (NSInteger)menu:(JSDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column leftOrRight:(NSInteger)leftOrRight leftRow:(NSInteger)leftRow;
/**
 * 行内容
 */
- (NSString *)menu:(JSDropDownMenu *)menu titleForRowAtIndexPath:(JSIndexPath *)indexPath;
/**
 * 列内容
 */
- (NSString *)menu:(JSDropDownMenu *)menu titleForColumn:(NSInteger)column;

/**
 * 表视图显示时，左边表显示比例
 */
- (CGFloat)widthRatioOfLeftColumn:(NSInteger)column;

/**
 * 表视图显示时，是否需要两个表显示
 */
- (BOOL)haveRightTableViewInColumn:(NSInteger)column;

/**
 * 返回当前菜单左边表选中行
 */
- (NSInteger)currentLeftSelectedRow:(NSInteger)column;

@optional
//default value is 1
- (NSInteger)numberOfColumnsInMenu:(JSDropDownMenu *)menu;

/**
 * 是否需要显示为UICollectionView 默认为否
 */
- (BOOL)displayByCollectionViewInColumn:(NSInteger)column;

@end

#pragma mark - delegate
@protocol JSDropDownMenuDelegate <NSObject>
@optional
- (void)menu:(JSDropDownMenu *)menu didSelectRowAtIndexPath:(JSIndexPath *)indexPath;
@end

#pragma mark - interface
@interface JSDropDownMenu : UIView <UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) id <JSDropDownMenuDataSource> dataSource;
@property (nonatomic, weak) id <JSDropDownMenuDelegate> delegate;

@property (nonatomic, strong) UIColor *indicatorColor;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIColor *separatorColor;
/**
 *  the width of menu will be set to screen width defaultly
 *
 *  @param origin the origin of this view's frame
 *  @param height menu's height
 *
 *  @return menu
 */
- (instancetype)initWithOrigin:(CGPoint)origin andHeight:(CGFloat)height;

#warning 不需要，因为在代理中已经有这个方法
// 每一列显示的字符
//- (NSString *)titleForRowAtIndexPath:(JSIndexPath *)indexPath;

@end
