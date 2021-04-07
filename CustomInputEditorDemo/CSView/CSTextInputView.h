//
//  CSTextInputView.h
//  UPOC_Teacher
//
//  Created by a on 2020/1/21.
//  Copyright © 2020 北京新东方教育科技(集团)有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSToolBarView.h"
#import "PlaceholderTextView.h"

@protocol JZTextInputViewDelegate <NSObject>

//TODO: -  暂时这样处理 抽离后，再次进行优化处理
- (void)textViewDidChange:(PlaceholderTextView *_Nonnull )textView;
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

@interface CSTextInputView : UIView <JZTextInputViewProtocol, JZTextInputViewKeyboardProtocol>

@property(nonatomic,weak) id<JZTextInputViewDelegate> textInputViewDelegate;

@end

NS_ASSUME_NONNULL_END
