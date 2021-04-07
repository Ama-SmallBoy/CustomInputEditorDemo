//
//  JZTextInputView.m
//  CustomInputEditorDemo
//
//  Created by zhanggaotong on 2021/3/30.
//  Copyright © 2021 Xdf. All rights reserved.
//

#import "JZTextInputView.h"

#define kMaxLength 500
#define ToolBarHeight 40

@interface JZTextInputView () <CSToolBarViewDelegate, UITextViewDelegate>

@property(nonatomic, strong) PlaceholderTextView *placeholderTextView;
@property(nonatomic, strong) UILabel *tipLabel;
@property(nonatomic, strong) CSToolBarView *toolBarView;
@property(nonatomic, assign, readwrite) CGFloat keyboardHeight;

@end

@implementation JZTextInputView

@synthesize editting = _editting;
@synthesize scrollEnabled = _scrollEnabled;
@synthesize keyboardHeight = _keyboardHeight;
@synthesize defaultText = _defaultText;
@synthesize text = _text;

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setDefaultUI];
        [self addObserver];
    }
    return self;
}

#pragma mark - 默认样式
//设置默认UI
- (void)setDefaultUI {

    [self addSubview:self.tipLabel];
    [self addSubview:self.placeholderTextView];
    
    //文字布局：
    [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.right.equalTo(self).offset(-9.0);
        make.height.equalTo(@20);// 30 高度
    }];
    
    [_placeholderTextView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_tipLabel.mas_top).offset(0);
        make.right.equalTo(self).offset(0);
        make.left.equalTo(self).offset(0);
        make.top.equalTo(self).offset(0);
    }];
}

- (void)addObserver {
    //展示 键盘
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didShowKeyboardNotification:) name:UIKeyboardWillShowNotification object:nil];
}


- (void)textViewDidChange:(UITextView *)textView {
    //获取正在输入的textView
    PlaceholderTextView *placeholderTextView = (PlaceholderTextView *)textView;
    NSString *toBeString = placeholderTextView.text;
    //获取高亮部分
    UITextRange *selectedRange = [placeholderTextView markedTextRange];
    UITextPosition *position = [placeholderTextView positionFromPosition:selectedRange.start offset:0];
    if (!position || !selectedRange) {
        if (toBeString.length > kMaxLength) {
            NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:kMaxLength];
            if (rangeIndex.length == 1) {
                //最后输入的字符是文本
                placeholderTextView.text = [toBeString substringToIndex:kMaxLength];
            } else {
                //最后输入的表情符号
                NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0,rangeIndex.location)];
                placeholderTextView.text = [toBeString substringWithRange:rangeRange];
            }
        }
        [self setTextTipLabel:placeholderTextView.text.length];
        [self textViewDidChangeText:placeholderTextView];
    }
}

- (void)textViewDidChangeText:(PlaceholderTextView *)textView {
    if (self.textInputViewDelegate && [self.textInputViewDelegate respondsToSelector:@selector(textViewDidChange:)]) {
        [self.textInputViewDelegate textViewDidChange:textView];
    }
}

#pragma mark - 通知响应方法
- (void)didShowKeyboardNotification:(NSNotification *)notifation {
    CGRect keyBoardRect=[notifation.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat deltaY = keyBoardRect.size.height;
    [UIView animateWithDuration:[notifation.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        //键盘 + ToolBarHeight + SafeAreaTopHeight 的高度
        self.keyboardHeight = deltaY + SafeAreaTopHeight;
    }];
}

#pragma mark - ToolBarView 的点击事件处理
- (void)didClickResponseWithInputType:(InputType)inputType {
    if (inputType == ShowKeyBoardType) {
        [self.placeholderTextView resignFirstResponder];
        return;
    }
    if (self.textInputViewDelegate && [self.textInputViewDelegate respondsToSelector:@selector(didClickInputType:)]) {
        [self.textInputViewDelegate didClickInputType:inputType];
    }
}

#pragma mark - setter
- (void)setDefaultText:(NSString *)defaultText {
    self.placeholderTextView.text = defaultText;
    [self setTextTipLabel:defaultText.length];
    [self textViewDidChangeText:self.placeholderTextView];
}

- (void)setTextTipLabel:(NSInteger)textCount {
    _tipLabel.text = [NSString stringWithFormat:@"%ld/%d",textCount,kMaxLength];
}

- (void)setEditting:(BOOL)editting {
    _editting = editting;
    _editting ? [_placeholderTextView becomeFirstResponder] : [_placeholderTextView resignFirstResponder];
}

- (void)setScrollEnabled:(BOOL)scrollEnabled {
    _scrollEnabled = scrollEnabled;
    _placeholderTextView.scrollEnabled = scrollEnabled;
}

#pragma mark - getter
- (CSToolBarView *)toolBarView {
    if (!_toolBarView) {
        NSArray * actionInfos = @[
                   @{@"AddImg":@(ImageType)},
                   @{@"camera":@(CameraType)},
                   //@{@"Emoji":@(EmojiType)},
               ];
        _toolBarView = [[CSToolBarView alloc]initWithFrame:CGRectMake(0,SCREEN_HEIGHT - (ToolBarHeight + SafeAreaTopHeight),SCREEN_WIDTH,ToolBarHeight) itemArray:actionInfos];
        _toolBarView.showNormalImage = @"ShowKeyBoard";
        _toolBarView.showSelectedImage = @"ShowKeyBoard";
        _toolBarView.toolBarViewDelegate = self;
    }
    return _toolBarView;
}

- (PlaceholderTextView *)placeholderTextView {
    if (!_placeholderTextView) {
        _placeholderTextView = [[PlaceholderTextView alloc]initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH, 0)];
        _placeholderTextView.placeholder = @"请说出你的故事...";
        _placeholderTextView.placeholderColor = kUIColorFromRGB(0x999999, 1.0);
        _placeholderTextView.font = [UIFont systemFontOfSize:17.0];
        _placeholderTextView.tintColor = kUIColorFromRGB(0x6dd7d5,1.0);
        _placeholderTextView.inputAccessoryView = self.toolBarView;
        _placeholderTextView.delegate = self;
        //设置不允许滚动，否则会有问题
        _placeholderTextView.scrollEnabled = NO;
    }
    return _placeholderTextView;
}

- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _tipLabel.text = [NSString stringWithFormat:@"0/%d",kMaxLength];
        _tipLabel.textColor = kUIColorFromRGB(0xBBBBBB, 1.0);
        _tipLabel.font = [UIFont systemFontOfSize:14.0];
    }
    return _tipLabel;
}

- (NSString *)text {
    return self.placeholderTextView.text ?: @"";
}

@end
