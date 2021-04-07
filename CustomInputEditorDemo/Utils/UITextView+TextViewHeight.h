//
//  UITextView+TextViewHeight.h
//  UPOC_Teacher
//
//  Created by Mac on 17/10/23.
//  Copyright © 2017年 北京新东方教育科技(集团)有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextView (TextViewHeight)

/**
 获取TextView的高度，以达到自适应高度的效果，需要与-fetchAttributedStringWithString:withLineSpace:fontSize:;该方法配合使用

 @param arrbuteText 要现实的格式文本
 @param textViewWitdh textView的布局宽度
 @return textView的高度
 */
+(CGFloat)fetchTextViewHeightWithAttributeString:(NSAttributedString *)arrbuteText textViewWitdh:(CGFloat)textViewWitdh;


/**
 获取一个文本字符串，可设置行间距，字体大小

 @param OrginString 原始的普通文本
 @param lineSpace 行间距
 @param fontSize 文本字体大小
 @return 格式文本字符串
 */
+(NSAttributedString *)fetchAttributedStringWithString:(NSString *)OrginString withLineSpace:(CGFloat)lineSpace fontSize:(CGFloat)fontSize;


/**
 获取一个文本字符串，可设置行间距，字体大小
 
 @param attributeString 原始的普通文本
 @param lineSpace 行间距
 @param fontSize 文本字体大小
 @param color 文本颜色
 @return 格式文本字符串
 */
+(void)setAttributeStringMatterWithString:(NSMutableAttributedString *)attributeString withLineSpace:(CGFloat)lineSpace fontSize:(CGFloat)fontSize  color:(UIColor *)color;


@end
