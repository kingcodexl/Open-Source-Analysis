//
//  SXClothesViewController.m
//  SXWaterFlow
//
//  Created by 董 尚先 on 15/3/21.
//  Copyright (c) 2015年 shangxianDante. All rights reserved.
//

#import "SXClothesViewController.h"
#import "SXWaterflowLayout.h"
#import "SXModels.h"
#import "SXClothesCell.h"
#import <MJExtension.h>
#import <MJRefresh.h>

@interface SXClothesViewController () <SXWaterflowLayoutDelegate>
@property (nonatomic, strong) NSMutableArray *allClothes;
@end

@implementation SXClothesViewController

- (NSMutableArray *)allClothes
{
    if (!_allClothes) {
        _allClothes = [[NSMutableArray alloc] init];
    }
    return _allClothes;
}

static NSString * const reuseIdentifier = @"clothes";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // 切换布局
    SXWaterflowLayout *layout = [[SXWaterflowLayout alloc] init];
    layout.delegate = self;
    self.collectionView.collectionViewLayout = layout;
    self.collectionView.backgroundColor = [UIColor blackColor];
    
    __weak typeof(self) weakSelf = self;
    
    // 添加刷新功能
    [self.collectionView addLegendHeaderWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 发送请求给服务器（加载数据，这里用的是plist假数据）
            NSArray *clothesArray = [SXModels objectArrayWithFilename:@"clothes.plist"];
            [weakSelf.allClothes insertObjects:clothesArray atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, clothesArray.count)]];
            [weakSelf.collectionView reloadData];
            
            // 结束刷新
            [weakSelf.collectionView.header endRefreshing];
        });
    }];
//    self.collectionView.header.updatedTimeHidden = YES;
//    self.collectionView.header.textColor = [UIColor blackColor];
    
    [self.collectionView addLegendFooterWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 发送请求给服务器（加载数据，这里用的是plist假数据）
            NSArray *clothesArray = [SXModels objectArrayWithFilename:@"clothes.plist"];
            [weakSelf.allClothes addObjectsFromArray:clothesArray];
            [weakSelf.collectionView reloadData];
            
            if (weakSelf.allClothes.count >= 150) {
                // 全部数据已经加载完毕
                [weakSelf.collectionView.footer noticeNoMoreData];
                //                [weakSelf.collectionView.footer resetNoMoreData];
            } else {
                // 结束刷新
                [weakSelf.collectionView.footer endRefreshing];
            }
        });
    }];
    self.collectionView.footer.automaticallyRefresh = YES;
    self.collectionView.footer.hidden = YES;
}

#pragma mark - <SXWaterflowLayoutDelegate>
- (CGFloat)waterflowLayout:(SXWaterflowLayout *)layout heightForItemAtIndexPath:(NSIndexPath *)indexPath withItemWidth:(CGFloat)width {
    SXModels *model = self.allClothes[indexPath.item];
    return model.h * width / model.w;
}

- (NSUInteger)columnsCountInWaterflowLayout:(SXWaterflowLayout *)layout
{
    return 3;
}

#pragma mark <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    self.collectionView.footer.hidden = (self.allClothes.count == 0);
    return self.allClothes.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SXClothesCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.model = self.allClothes[indexPath.item];
    return cell;
}

@end
