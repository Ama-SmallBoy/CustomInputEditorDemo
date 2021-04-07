//
//  LifeCollectionCell.h
//  UPOC_Teacher
//
//  Created by a on 2020/1/21.
//  Copyright © 2020 北京新东方教育科技(集团)有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JZPhotoFlowListModelProtocol.h"

@class JZPhotoFlowListItemCell;

NS_ASSUME_NONNULL_BEGIN

@protocol JZPhotoFlowListItemCellDelegate <NSObject>

@optional

- (void)deletePhotoWithPhotoFlowListItemCell:(JZPhotoFlowListItemCell *)cell;

@end

@interface JZPhotoFlowListItemCell : UICollectionViewCell

@property (nonatomic, weak) id<JZPhotoFlowListItemCellDelegate> delegate;
@property (nonatomic, strong) id<JZPhotoFlowListModelProtocol> itemModel;

@end

NS_ASSUME_NONNULL_END
