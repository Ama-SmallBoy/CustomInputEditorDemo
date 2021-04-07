//
//  LifeCollectionView.h
//  UPOC_Teacher
//
//  Created by a on 2020/1/21.
//  Copyright © 2020 北京新东方教育科技(集团)有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    DeleteType,//删除操作
    AddImgType,//添加图片操作
    EnterShuffType,//进入轮播页面
} ActionType;

typedef void(^ActionBlock)(ActionType actionType,NSIndexPath* _Nullable indexPath);

NS_ASSUME_NONNULL_BEGIN

@interface JZPhotoFlowListView : UIView

@property(nonatomic, copy) NSArray * dataSource;
@property(nonatomic, copy) ActionBlock actionBlock;
@property(nonatomic, assign) BOOL isHiddenAddImage;

@end

NS_ASSUME_NONNULL_END
