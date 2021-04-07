//
//  PlaceholderTextView.h
//  UPOC_Teacher
//
//  Created by Jessica on 16/6/7.
//  Copyright © 2016年 北京新东方教育科技(集团)有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlaceholderTextView : UITextView

@property(nonatomic, copy) NSString *placeholder;
@property(nonatomic, copy) NSAttributedString *attributedPlaceholder;

@property (nonatomic, strong) UIFont *placeholderFont;
@property (nonatomic, strong) UIColor *placeholderColor;

@end
