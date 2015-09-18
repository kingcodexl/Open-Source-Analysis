//
//  LNWaterfallFlowLayout.m
//  WaterfallFlowDemo
//
//  Created by Lining on 15/5/3.
//  Copyright (c) 2015年 Lining. All rights reserved.
//

#import "LNWaterfallFlowLayout.h"
#import "LNGood.h"

@interface LNWaterfallFlowLayout ()
// 所有item的属性的数组,用于布局
@property (nonatomic, strong) NSArray *layoutAttributesArray;

@end

@implementation LNWaterfallFlowLayout
/**
 *  布局准备方法 当collectionView的布局发生变化时 会被调用
 *  通常是做布局的准备工作 itemSize.....
 *  ---》》UICollectionView 的 contentSize 是根据 itemSize 动态计算出来的
 *  在这里进行布局，首先确定item的宽度，然后根据宽度，总共的item个数，列数，计算出布局。
 *  每一次刷新都会调用来进行重新的布局
 * Tells the layout object to update the current layout
 */
- (void)prepareLayout {
    // 根据列数 计算item的宽度 宽度是一样的
    CGFloat contentWidth = self.collectionView.bounds.size.width - self.sectionInset.left - self.sectionInset.right;
    
    //可以先确定宽度，再去确定边距。这里是先确定了
    CGFloat marginX = self.minimumInteritemSpacing;
    
    CGFloat itemWidth = (contentWidth - marginX * (self.columnCount - 1)) / self.columnCount ;
    //设置item间的间距
//    self.minimumLineSpacing = 20;
//    self.minimumInteritemSpacing = 20;
    
    // 计算布局属性
    [self computeAttributesWithItemWidth:itemWidth];
}

/**
 *  根据itemWidth计算布局属性，根据宽度，item个数和列数，计算
 *  列高：                     列总数：
 */
- (void)computeAttributesWithItemWidth:(CGFloat)itemWidth {
    
    // -----》》》》无论怎么样都要计算每一列的高度
    // 定义一个列高数组 记录每一列的总高度
    CGFloat columnHeight[self.columnCount];
    
    // 定义一个记录每一列的总item个数的数组
    NSInteger columnItemCount[self.columnCount];
    
    // 初始化 列高和每一列的item
    for (int i = 0; i < self.columnCount; i++) {
        
        columnHeight[i] = self.sectionInset.top;
        columnItemCount[i] = 0;
        
    }
    
    // 遍历 goodsList 数组计算相关的属性。初始值index为 0
    NSInteger index = 0;
    // 保存每一个item的布局情况的数组，最后赋值给实例变量
    NSMutableArray *attributesArray = [NSMutableArray arrayWithCapacity:self.goodsList.count];
//确定每一个item的frame，遍历goodsList，
    for (LNGood *good in self.goodsList) {
        
        // 建立布局属性，默认只有一个sectoin
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
        NSIndexPath *indexpath = [NSIndexPath indexPathForItem:index inSection:0];
        // 每一个item的布局属性
        UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        
        UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexpath];
        
        for (int i =0; i < self.columnCount; i++) {
            NSLog(@"前 %f",columnHeight[i]);
        }
        // 找出最短列号
        NSInteger column = [self shortestColumn:columnHeight];
        
        for (int i =0; i < self.columnCount; i++) {
            NSLog(@"后 %f",columnHeight[i]);
        }
        
        // 数据追加在最短列
        columnItemCount[column]++;
        
        // 批量的设置
        // X值
        CGFloat itemX = (itemWidth + self.minimumInteritemSpacing) * column + self.sectionInset.left;
        NSLog(@"section left %f",self.sectionInset.left);
        NSLog(@"minimumspacingrow  %f minspacing lin %f",self.minimumInteritemSpacing,self.minimumLineSpacing);
        
        // Y值 取出第几列的高度，colum最短的列号
        CGFloat itemY = columnHeight[column];
        
        
        // 等比例缩放 计算item的高度--->>等比缩放的技巧
        CGFloat itemH = good.h * itemWidth / good.w;
        
        // 设置frame
        attributes.frame = CGRectMake(itemX, itemY, itemWidth, itemH);
#warning 添加到属性数组中
        [attributesArray addObject:attributes];
    
#warning 在最后累加高度
        // 累加列高
        columnHeight[column] += itemH + self.minimumLineSpacing;
#warning index记得++
        index++;
    }
#warning 后续的处理
    // 找出最高列列号
    NSInteger column = [self highestColumn:columnHeight];
    
    // 根据最高列设置itemSize 使用总高度的平均值
    //CGFloat itemH = (columnHeight[column] - self.minimumLineSpacing * columnItemCount[column]) / columnItemCount[column];
    /**
     *If the delegate does not implement the collectionView:layout:sizeForItemAtIndexPath: method, the flow layout uses the value in this property to set the size of each cell. This results in cells that all have the same size.
     */
    
    //统一设置item的大小，但是前面for循环中的设置不会被覆盖，因为是结构体，需要三步走
    //self.itemSize = CGSizeMake(itemWidth, itemH);
    
    // 添加页脚属性
    NSIndexPath *footerIndexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    
    //页脚设置
    UICollectionViewLayoutAttributes *footerAttr = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter withIndexPath:footerIndexPath];
    
    footerAttr.frame = CGRectMake(0, columnHeight[column], self.collectionView.bounds.size.width, 50);
    
    // 页脚属性最后添加
    [attributesArray addObject:footerAttr];
    
    // 给属性数组设置数值
    self.layoutAttributesArray = attributesArray.copy;
}

#pragma mark - 计算最短列号和，最高列号
/**
 *  找出columnHeight数组中最短列号 追加数据的时候追加在最短列中
 */
- (NSInteger)shortestColumn:(CGFloat *)columnHeight {
    
    CGFloat max = CGFLOAT_MAX;
    
    NSInteger column = 0;
    for (int i = 0; i < self.columnCount; i++) {
        if (columnHeight[i] < max) {
            max = columnHeight[i];
            column = i;
        }
    }
    return column;
}

                        
/**
 *  找出columnHeight数组中最高列号
 */
- (NSInteger)highestColumn:(CGFloat *)columnHeight {
    CGFloat min = 0;
    NSInteger column = 0;
    for (int i = 0; i < self.columnCount; i++) {
        if (columnHeight[i] > min) {
            min = columnHeight[i];
            column = i;
        }
    }
    return column;
}


/**
 *  跟踪效果：当到达要显示的区域时 会计算所有显示item的属性
 *           一旦计算完成 所有的属性会被缓存 不会再次计算
 *  @return 返回布局属性(UICollectionViewLayoutAttributes)数组
 */
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    // 直接返回计算好的布局属性数组
    return self.layoutAttributesArray;
}


@end
