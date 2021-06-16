//
//  JZTextInputView.h
//  CustomInputEditorDemo
//
//  Created by zhanggaotong on 2021/3/30.
//  Copyright © 2021 Xdf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSToolBarView.h"
#import "PlaceholderTextView.h"

@class JZTextInputView;

@protocol JZTextInputViewDelegate <NSObject>

/// 输入文本的
/// @param textView  文本输入框
/// @param isNeeded  是否需要更新高度
- (void)textViewDidChange:(JZTextInputView *_Nonnull )textView refreshHeightIfNeeded:(BOOL)isNeeded;

/// 点击ToolbarItem的动作
/// @param inputType item 类型
- (void)didClickInputType:(InputType)inputType;

@end

@protocol JZTextInputViewKeyboardProtocol <NSObject>
///键盘高度
@property(nonatomic, assign, readonly) CGFloat keyboardHeight;

@end

@protocol JZTextInputViewProtocol <NSObject>

///是否正处于 编辑状态
@property(nonatomic, assign, getter=isEditting) BOOL editting;
///是否可滚动
@property(nonatomic, assign, getter=isScrollEnabled) BOOL scrollEnabled;
///设置默认
@property(nonatomic, copy) NSString * _Nullable defaultText;
///获取text
@property(nonatomic, copy) NSString * _Nullable text;
///获取Height
@property(nonatomic, readonly, assign) CGFloat height;



@end

NS_ASSUME_NONNULL_BEGIN

@interface JZTextInputView : UIView <JZTextInputViewProtocol, JZTextInputViewKeyboardProtocol>

@property(nonatomic,weak) id<JZTextInputViewDelegate> textInputViewDelegate;

@end
NS_ASSUME_NONNULL_END
