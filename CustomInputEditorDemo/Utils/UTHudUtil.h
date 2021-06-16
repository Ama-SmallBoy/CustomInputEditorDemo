//
//  UTHudUtil.h
//  UPOC_Teacher
//
//  Created by wangjiawei on 15/12/11.
//  Copyright © 2015年 星梦. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum : NSUInteger{
    Center, // 中间
    Top,     // 上1/3处
    Bom,     // 下1/3处
    Custom   // 自定义高度
}HUDPosition;

@interface UTHudUtil : NSObject

+ (id)shareInstance;

/**
 *  显示可以自动消失的提示框
 */
- (void)toggleMessage:(NSString *)message;

/**
 *  显示可以自动消失的提示框显示位置在屏幕中央
 */
- (void)toggleMessageInViewCenter:(NSString *)message;
/**
 *  页面加载中的动画
 */

- (void)toggleLoadingInView:(UIView *)view;

/**
 *  页面加载中动画（可设置动画位置）
 */
- (void)toggleLoadingInView:(UIView *)view position:(HUDPosition)position;

/**
 *  页面加载中动画（可设置动画位置和高度）
 */
- (void)toggleLoadingInView:(UIView *)view position:(HUDPosition)position andHeight:(CGFloat)height;

- (void)toggleLoadingInView:(UIView *)view position:(HUDPosition)position withClearColor:(BOOL)isClearColor;

/**
 *  登录中...
 */
- (void)toggleLoginLoadingInView:(UIView *)view;

/**
 *  登录中，不透明
 */
- (void)toggleLoginLoadingInViewWithColor:(UIView *)view;

/// 带有提示语的菊花
/// @param message 提示语
/// @param inView 父类图
/// @param backgroundColor 背景色
- (void)toggleUploadWithMessage:(NSString *)message messageColor:(UIColor*)messageColor messageFont:(UIFont *)messageFont inView:(UIView *)inView backgroundColor:(UIColor *)backgroundColor;


/**
 *  隐藏加载中动画
 */
- (void)hideLoadingInView:(UIView *)view;

- (void)toggleMessage:(NSString *)message andPosition:(HUDPosition)position andBackGroundColor:(UIColor *)color;


/**
 *  上传中的提示框架载到了keyWindow上
 */
- (void)toggleMessage:(NSString *)message position:(HUDPosition)position andBackGroundColor:(UIColor *)color alpha:(CGFloat)alpha animation:(BOOL)animation;


/**
 *  上传中的提示框
 */
- (void)toggleMessage:(NSString *)message InView:(UIView *)view position:(HUDPosition)position andBackGroundColor:(UIColor *)color alpha:(CGFloat)alpha animation:(BOOL)animation;

/**
 *  上传失败
 */
- (void)failToggleMessage:(NSString *)message position:(HUDPosition)position andBackGroundColor:(UIColor *)color alpha:(CGFloat)alpha;
/**
 *  登录失败，注册失败
 */

/**
 带有或不带有图片的提示

 @param message          提示文字消息
 @param textColor        文字Color
 @param isImageType      类型是否为带图片提示
 @param centerY          toast中心
 @param color            toast背景色
 @param alpha            toast透明度
 */
- (void)failLoginToggleMessage:(NSString *)message isImageType:(BOOL)isImageType  position:(HUDPosition)position;

- (void)toggleToastInWindowCenter;

//带有-- 图片样式 的提示框 --
- (void)toggleSuccessOrFailureMessageInViewCenter:(NSString *)message imageNamed:(NSString *)imageNamed;
- (void)hideToast;

- (void)hideUploadToast;

@end
