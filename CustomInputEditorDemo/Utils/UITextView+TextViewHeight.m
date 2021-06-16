//
//  UITextView+TextViewHeight.m
//  UPOC_Teacher
//
//  Created by Mac on 17/10/23.
//  Copyright © 2017年 星梦. All rights reserved.
//

#import "UITextView+TextViewHeight.h"

@implementation UITextView (TextViewHeight)


+(NSAttributedString *)fetchAttributedStringWithString:(NSString *)OrginString withLineSpace:(CGFloat)lineSpace fontSize:(CGFloat)fontSize{
    
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    [paragraphStyle setLineSpacing:lineSpace];
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    [attributes setObject:font forKey:NSFontAttributeName];
    [attributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
    
    return [[NSAttributedString alloc] initWithString:OrginString attributes:attributes];
    
}


+(CGFloat)fetchTextViewHeightWithAttributeString:(NSAttributedString *)arrbuteText textViewWitdh:(CGFloat)textViewWitdh{
    
    UITextView *textView = [UITextView new];
    
    CGRect rect = [arrbuteText boundingRectWithSize:CGSizeMake(textViewWitdh - 2 * [[textView textContainer] lineFragmentPadding], CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    
    return rect.size.height + [textView textContainerInset].top * 2 + 0.5;
    
}

+(void)setAttributeStringMatterWithString:(NSMutableAttributedString *)attributeString withLineSpace:(CGFloat)lineSpace fontSize:(CGFloat)fontSize color:(UIColor *)color{
    
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    [paragraphStyle setLineSpacing:lineSpace];
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    [attributes setObject:font forKey:NSFontAttributeName];
    
    [attributes setObject:color forKey:NSForegroundColorAttributeName];
    [attributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
    [attributeString addAttributes:attributes range:NSMakeRange(0, attributeString.length)];
}

@end
