//
//  LifeHeadView.m
//  UPOC_Teacher
//
//  Created by a on 2020/1/20.
//  Copyright © 2020 星梦. All rights reserved.
//

#import "LifeHeadView.h"
#import "LifeTitleView.h"

#define TitleHeight 50
#define ExtentHeight 86

@interface LifeHeadView () <LifeTitleViewDelegate, JZTextInputViewDelegate>

@property(nonatomic, strong) LifeTitleView *lifeTitleView;
@property(nonatomic, strong) CSTextInputView *textInputView;
@property(nonatomic, strong, readwrite) NSString *titleString;
@property(nonatomic, strong, readwrite) NSString *storyContent;

@end

@implementation LifeHeadView

- (void)dealloc {
    self.lifeTitleView.lifeTitleViewDelegate = nil;
    self.textInputView.textInputViewDelegate = nil;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setDefaultUI];
    }
    return self;
}

- (void)setDefaultUI {
    
    [self addSubview:self.lifeTitleView];
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectZero];
    lineView.backgroundColor = kUIColorFromRGB(0xE2E2E2, 1.0);
    [self addSubview:lineView];
    [self addSubview:self.textInputView];
   
    //设置UIView
    [_lifeTitleView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(0);
        make.right.equalTo(self).offset(0);
        make.top.equalTo(self);
        make.height.equalTo(@(TitleHeight));
    }];
    //设置line
    [lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
        make.top.equalTo(_lifeTitleView.mas_bottom).offset(0);
        make.height.equalTo(@1);
    }];
    //设置 placeholderTextView
    [_textInputView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-10);
        make.top.equalTo(lineView.mas_bottom).offset(5);
        make.bottom.equalTo(self).offset(-10);
    }];
}

#pragma mark - LifeTitleViewDelegate
-(void)textFieldDidChangeWithText:(NSString *)text{
    //将 内容 传递 首页
    self.titleString = text;
}

#pragma mark - CSTextInputViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    //将 内容 传递 首页
    self.storyContent = textView.text;
    CGFloat textViewHeight = [textView sizeThatFits:CGSizeMake(textView.frame.size.width, MAXFLOAT)].height;
    
    if ([self.lifeHeadViewDelegate respondsToSelector:@selector(didChangeTextViewHeight:keyBoardHeight:)]) {
        [self.lifeHeadViewDelegate didChangeTextViewHeight:textViewHeight + ExtentHeight keyBoardHeight:self.textInputView.keyboardHeight];
    }
}

- (void)didClickInputType:(InputType)inputType {
    if (self.lifeHeadViewDelegate && [self.lifeHeadViewDelegate respondsToSelector:@selector(didClickActionWithInputType:)]) {
        [self.lifeHeadViewDelegate didClickActionWithInputType:inputType];
    }
}

#pragma mark - setter
- (void)setIsTitleEditting:(BOOL)isTitleEditting {
    _isTitleEditting = isTitleEditting;
    _lifeTitleView.isTitleEditting = isTitleEditting;
}

- (void)setTitle:(NSString *)titleString storyContent:(NSString *)storyContent {
    [self.lifeTitleView setTextForDefault:titleString];
    self.textInputView.defaultText = storyContent;
    self.titleString = titleString;
    self.storyContent = storyContent;
}

#pragma mark - 懒加载
- (LifeTitleView *)lifeTitleView {
    if (!_lifeTitleView) {
        _lifeTitleView = [[LifeTitleView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame),TitleHeight)];
        _lifeTitleView.lifeTitleViewDelegate = self;
    }
    return _lifeTitleView;
}

- (CSTextInputView *)textInputView {
    if (!_textInputView) {
        _textInputView = [[CSTextInputView alloc]initWithFrame:CGRectMake(15, 0,CGRectGetWidth(self.frame),0)];
        _textInputView.textInputViewDelegate = self;
    }
    return _textInputView;
}

@end
