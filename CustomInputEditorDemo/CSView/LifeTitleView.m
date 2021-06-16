//
//  LifeTitleView.m
//  UPOC_Teacher
//
//  Created by a on 2020/1/20.
//  Copyright © 2020 星梦. All rights reserved.
//

#import "LifeTitleView.h"
#import <Masonry.h>

#define  kMaxLength 30
//拾色
#define kUIColorFromRGB(rgbValue,alphy) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:alphy]

@interface LifeTitleView ()
@property(nonatomic,strong) UITextField * titleField;
@property(nonatomic,strong) UILabel * countLabel;
@end

@implementation LifeTitleView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createDefaultUI];
    }
    return self;
}

- (void)setTextForDefault:(NSString *)defaultText {
    self.titleField.text = defaultText;
    self.countLabel.text = [NSString stringWithFormat:@"%ld/%d",defaultText.length,kMaxLength];
    
}

- (void)setIsTitleEditting:(BOOL)isTitleEditting {
    _isTitleEditting = isTitleEditting;
    _isTitleEditting?[_titleField becomeFirstResponder]:[_titleField resignFirstResponder];
}

//创建默认UI
- (void)createDefaultUI {
    [self addSubview:self.countLabel];
    [self addSubview:self.titleField];
    
    [_countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-15);
        make.centerY.equalTo(self);
        make.height.equalTo(self);
        make.width.equalTo(@50);
    }];
    
    //设置位置
    [_titleField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.centerY.equalTo(self);
        make.right.equalTo(_countLabel.mas_left).offset(-5);
        make.height.equalTo(self);
    }];
}

#pragma mark - 一波懒加载
- (UITextField *)titleField {
    if (!_titleField) {
        _titleField = [[UITextField alloc] initWithFrame:CGRectZero];
        _titleField.placeholder = @"标题";
        _titleField.font = [UIFont boldSystemFontOfSize:17.0];
        _titleField.textColor = kUIColorFromRGB(0x333333, 1.0);
        _titleField.tintColor = kUIColorFromRGB(0x6dd7d5,1.0);
        [_titleField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _titleField;
}

- (UILabel *)countLabel {
    if (!_countLabel) {
        _countLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _countLabel.text = [NSString stringWithFormat:@"0/%d",kMaxLength];
        _countLabel.font = [UIFont systemFontOfSize:14.0];
        _countLabel.textColor = [UIColor colorWithRed:187/255.0 green:187/255.0 blue:187/255.0 alpha:1.0];
        _countLabel.textAlignment = NSTextAlignmentRight;
    }
    return _countLabel;
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidChange:(UITextField *)textField {
    
    NSString * toBeString = textField.text;
    //获取高亮部分
    UITextRange * selectedRange = [textField markedTextRange];
    
    UITextPosition * position = [textField positionFromPosition:selectedRange.start offset:0];
    
    if(!position || !selectedRange)
    {
        if(toBeString.length > kMaxLength)
        {
            NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:kMaxLength];
            
            if(rangeIndex.length ==1)
            {
                textField.text = [toBeString substringToIndex:kMaxLength];
                
            }else{
                
                NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, kMaxLength)];
                textField.text = [toBeString substringWithRange:rangeRange];
            }
            _countLabel.text = [NSString stringWithFormat:@"%ld/%d",textField.text.length,kMaxLength];
            
            if (self.lifeTitleViewDelegate && [self.lifeTitleViewDelegate respondsToSelector:@selector(textFieldDidChangeWithText:)]) {
                [self.lifeTitleViewDelegate textFieldDidChangeWithText:textField.text];
            }
            [[UTHudUtil shareInstance] toggleMessageInViewCenter:@"标题超过最大字数限制\n最多可输入30字"];
            return;
        }
        _countLabel.text = [NSString stringWithFormat:@"%ld/%d",textField.text.length,kMaxLength];
    }
    
    if (self.lifeTitleViewDelegate && [self.lifeTitleViewDelegate respondsToSelector:@selector(textFieldDidChangeWithText:)]) {
        [self.lifeTitleViewDelegate textFieldDidChangeWithText:textField.text];
    }
}

@end
