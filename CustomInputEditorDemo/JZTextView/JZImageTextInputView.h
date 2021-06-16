//
//  JZImageTextInputView.h
//  CustomInputEditorDemo
//
//  Created by zhanggaotong on 2021/3/30.
//  Copyright © 2021 Xdf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JZPhotoFlowListView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol JZImageTextInputViewDataSoure <NSObject>

- (NSArray <id<JZPhotoFlowListModelProtocol>> *)photoFlowListViewDataSource;

@end

@protocol JZImageTextInputViewDelegate <NSObject>

///点击事件
- (void)photoFlowListView:(JZPhotoFlowListView *)photoFlowListView didSelectItemAtIndex:(NSUInteger)index;
///添加图片
- (void)photoFlowListViewAddPhoto:(JZPhotoFlowListView *)photoFlowListView;
///删除图片
- (void)photoFlowListView:(JZPhotoFlowListView *)photoFlowListView didDeleteItemAtIndex:(NSUInteger)index;

@end

@interface JZImageTextInputView : UIView

@end

NS_ASSUME_NONNULL_END
