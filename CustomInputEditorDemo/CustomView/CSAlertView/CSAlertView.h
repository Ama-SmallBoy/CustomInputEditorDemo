//
//  AlertViewSelf.h
//  UPOC_Teacher
//
//  Created by Mac on 17/10/9.
//  Copyright © 2017年 星梦. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    SBAlertType,//单按钮
    DBAlertType,//双按钮
} AlertButtonType;

typedef enum : NSUInteger {
    ImageAlertType,//带有图片
    TitleAlertType,//带有标题
    MessageAlertType,//仅有信息提示
    TIMgeAlertType,//图片/标题
} AlertMainType;


@interface CSAlertView : UIView
///主页面样式  是否 带图片 带标题
@property(assign,nonatomic,readonly) AlertMainType alertMainType;
///按钮样式 单按钮模式 双按钮模式
@property(assign,nonatomic,readonly) AlertButtonType alertButtonType;
//点击确定事件
@property(nonatomic,copy)void(^sureAction)(UIButton * sureBtn);
//点击取消事件
@property(nonatomic,copy)void(^cancelAction)(UIButton * cancelBtn);

/// 更改alert 的 一些属性问题
/// @param cancelTitleColor             取消按钮颜色
/// @param sureTitleColor                 确定按钮颜色
/// @param cancelTitle                        取消按钮的文字
/// @param sureTitle                            确定按钮的文字
/// @param messageString                   消息文本
-(void)changeCancelTitleColor:(UIColor *)cancelTitleColor
               sureTitleColor:(UIColor *)sureTitleColor
                  cancelTitle:(NSString *)cancelTitle
                    sureTitle:(NSString *)sureTitle
                messageString:(NSString *)messageString
                    imageName:(NSString *)imageName
                  titleString:(NSString *)titleString
                alertMainType:(AlertMainType)alertMainType
              alertButtonType:(AlertButtonType)alertButtonType;

/// 弹出视图
-(void)showAlertViewAction;
/// 收回弹框
-(void)dismissAlertView;

@end
