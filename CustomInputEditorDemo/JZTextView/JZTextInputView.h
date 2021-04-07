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

@protocol JZTextInputViewDelegate <NSObject>

//TODO: -  暂时这样处理 抽离后，再次进行优化处理

/// 输入文本的
/// @param textView  文本输入框
- (void)textViewDidChange:(PlaceholderTextView *_Nonnull )textView;

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

@end

NS_ASSUME_NONNULL_BEGIN

@interface JZTextInputView : UIView <JZTextInputViewProtocol, JZTextInputViewKeyboardProtocol>

@property(nonatomic,weak) id<JZTextInputViewDelegate> textInputViewDelegate;

@end
NS_ASSUME_NONNULL_END
