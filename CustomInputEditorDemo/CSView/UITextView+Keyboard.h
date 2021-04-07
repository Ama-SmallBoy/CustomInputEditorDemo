//
//  UITextView+Keyboard.h
//  CustomInputEditorDemo
//
//  Created by zhanggaotong on 2021/3/29.
//  Copyright © 2021 Xdf. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextView (Keyboard)

///键盘高度
@property(nonatomic, assign) CGFloat keyboardHeight;

///添加 监听
- (void)addKeyboardObserver;
///移除 监听
- (void)removeKeyboardObserver;

@end

NS_ASSUME_NONNULL_END
