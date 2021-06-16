//
//  LifeCollectionView.h
//  UPOC_Teacher
//
//  Created by a on 2020/1/21.
//  Copyright © 2020 星梦. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JZPhotoFlowListModelProtocol.h"

@class JZPhotoFlowListView;

NS_ASSUME_NONNULL_BEGIN

@protocol JZPhotoFlowListViewDelegate <NSObject>

@optional
///点击事件
- (void)photoFlowListView:(JZPhotoFlowListView *)photoFlowListView didSelectItemAtIndex:(NSUInteger)index;
///添加图片
- (void)photoFlowListViewAddPhoto:(JZPhotoFlowListView *)photoFlowListView;
///删除图片
- (void)photoFlowListView:(JZPhotoFlowListView *)photoFlowListView didDeleteItemAtIndex:(NSUInteger)index;
///加载数据后更新布局
- (void)photoFlowListViewLayoutDidUpdate:(JZPhotoFlowListView *)listView;

@end

@protocol JZPhotoFlowListViewDataSource <NSObject>

- (NSArray <id<JZPhotoFlowListModelProtocol>> *)photoFlowListViewDataSource;

@end

@interface JZPhotoFlowListView : UIView

/// 最大支持图片数量，默认9张
@property (nonatomic, assign) NSUInteger maxPhotoLimit;
/// delegate
@property (nonatomic, weak) id<JZPhotoFlowListViewDelegate> delegate;
/// dataSource
@property (nonatomic, weak) id<JZPhotoFlowListViewDataSource> dataSource;

- (void)reloadData;

@property (nonatomic, assign, readonly) CGFloat listViewHeight;

@end

NS_ASSUME_NONNULL_END
