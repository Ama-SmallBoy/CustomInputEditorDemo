//
//  UITextView+Keyboard.m
//  CustomInputEditorDemo
//
//  Created by zhanggaotong on 2021/3/29.
//  Copyright © 2021 Xdf. All rights reserved.
//

#import "UITextView+Keyboard.h"
#import <objc/runtime.h>

static NSString *keyboardHeightKey = @"keyboardHeightKey";

@interface UITextView ()

@end

@implementation UITextView (Keyboard)

@dynamic keyboardHeight;

- (void)dealloc {
    [self removeKeyboardObserver];
}

- (void)removeKeyboardObserver {

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didShowKeyboardNotification:) name:UITextViewTextDidChangeNotification object:nil];
    
}

- (void)addKeyboardObserver {

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didShowKeyboardNotification:) name:UIKeyboardWillShowNotification object:nil];
}

//展示
- (void)didShowKeyboardNotification:(NSNotification *)notifation {
    CGRect keyBoardRect=[notifation.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat deltaY = keyBoardRect.size.height;
    [UIView animateWithDuration:[notifation.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        //键盘 + ToolBarHeight + SafeAreaTopHeight 的高度
        self.keyboardHeight = deltaY + SafeAreaTopHeight;
    }];
}

#pragma mark - 动态添加属性
- (CGFloat)keyboardHeight {
    return [objc_getAssociatedObject(self, &keyboardHeightKey) floatValue];
}

- (void)setKeyboardHeight:(CGFloat)keyboardHeight {
    objc_setAssociatedObject(self, &keyboardHeightKey, @(keyboardHeight), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
