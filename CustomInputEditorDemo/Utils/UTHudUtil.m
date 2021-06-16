//
//  UTHudUtil.m
//  UPOC_Teacher
//
//  Created by wangjiawei on 15/12/11.
//  Copyright © 2015年 星梦. All rights reserved.
//

#import "UTHudUtil.h"
#import <MBHUDView.h>
#import <MBProgressHUD.h>
#import "GifView.h"
#import <CoreText/CoreText.h>
#import "UITextView+TextViewHeight.h"

@interface UTHudUtil()<MBProgressHUDDelegate>

@property (strong, nonatomic)MBProgressHUD *msgHud;
@property (assign, nonatomic)CGFloat keyboardOffsetY;
@property (strong, nonatomic)UIView *bgView;
@property (strong, nonatomic)NSMutableArray *hudArr;


@property (nonatomic , strong) NSString *tipText;
@property (nonatomic , strong) UIView *toast;
@property (nonatomic , strong) CAShapeLayer *textLayer;

@end

@implementation UTHudUtil

static UTHudUtil *shareInstance = nil;

#pragma mark - init and dealloc methods

+ (id)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[UTHudUtil alloc] init];
    });
    return shareInstance;
}

- (instancetype)init{
    if (self == [super init]) {
        if (!_hudArr) {
            _hudArr = [NSMutableArray array];
        }
        [self addNotification];
    }
    return self;
}

- (void)dealloc{
    [self removeNotification];
}

#pragma mark - custom methods

- (void)toggleMessage:(NSString *)message{
    if (message == nil || [message isEqualToString:@""]) {
        return;
    }
    if (self.msgHud != nil) {
        return;
    }
    
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    MBProgressHUD *msgHUD = [MBProgressHUD showHUDAddedTo:keyWindow animated:YES];
    msgHUD.mode = MBProgressHUDModeText;
    msgHUD.bezelView.layer.cornerRadius = 4.0f;
    msgHUD.detailsLabel.font = [UIFont systemFontOfSize:16];
    msgHUD.detailsLabel.text = message;
    msgHUD.detailsLabel.textColor = [UIColor whiteColor];
    //需要使用这种模式，否色颜色会出问题
    msgHUD.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    msgHUD.bezelView.color = [[UIColor blackColor] colorWithAlphaComponent:0.8];
//    CGPoint msgHUDOffset = msgHUD.offset;
//    msgHUDOffset.y = CGRectGetHeight(keyWindow.frame) / 2.f - 60.f - self.keyboardOffsetY;
//    msgHUD.offset = msgHUDOffset;
    msgHUD.removeFromSuperViewOnHide = YES;
    msgHUD.delegate = self;
    [msgHUD hideAnimated:YES afterDelay:1.5];
    
    self.msgHud = msgHUD;
}

- (void)toggleMessageInViewCenter:(NSString *)message{

    if (message == nil || [message isEqualToString:@""]) {
        return;
    }
    if (self.msgHud != nil) {
        return;
    }
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    MBProgressHUD *msgHUD = [MBProgressHUD showHUDAddedTo:keyWindow animated:YES];
    msgHUD.mode = MBProgressHUDModeText;
    msgHUD.bezelView.layer.cornerRadius = 4.0f;
    msgHUD.detailsLabel.font = [UIFont systemFontOfSize:16];
    msgHUD.detailsLabel.textColor =[UIColor whiteColor];
    msgHUD.detailsLabel.text = message;
    //需要使用这种模式，否色颜色会出问题
    msgHUD.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    msgHUD.bezelView.color = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    msgHUD.removeFromSuperViewOnHide = YES;
    msgHUD.delegate = self;
    [msgHUD hideAnimated:YES afterDelay:1.5];
    
    self.msgHud = msgHUD;
}


- (void)toggleSuccessOrFailureMessageInViewCenter:(NSString *)message imageNamed:(NSString *)imageNamed{
    
    if (message == nil || [message isEqualToString:@""]) {
        return;
    }
    if (self.msgHud != nil) {
        return;
    }
    
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    MBProgressHUD *msgHUD = [MBProgressHUD showHUDAddedTo:keyWindow animated:YES];
    msgHUD.mode = MBProgressHUDModeCustomView;
    // Set an image view with a checkmark.
    UIImage *image =[UIImage imageNamed:imageNamed];// [[UIImage imageNamed:@"successico"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    msgHUD.customView = [[UIImageView alloc] initWithImage:image];
    msgHUD.square = YES;
    msgHUD.bezelView.layer.cornerRadius = 11.0f;
    msgHUD.detailsLabel.font = [UIFont systemFontOfSize:16];
    msgHUD.detailsLabel.text = message;
    msgHUD.detailsLabel.textColor = [UIColor whiteColor];
    //图片颜色背景
    msgHUD.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    msgHUD.bezelView.color = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    msgHUD.removeFromSuperViewOnHide = YES;
    msgHUD.delegate = self;
    [msgHUD hideAnimated:YES afterDelay:1.5];

    self.msgHud = msgHUD;
    
}

- (void)toggleToastInWindowCenter {
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    UIView *bgView = [[UIView alloc] initWithFrame:keyWindow.bounds];
    [bgView setBackgroundColor:[UIColor clearColor]];
    bgView.tag = HUD_TAG;
    [keyWindow addSubview:bgView];
    
    NSData *gif = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"009" ofType:@"gif"]];
    GifView *gifView = [[GifView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 32)/2, (SCREEN_HEIGHT - SafeAreaTopHeight) / 2.0, 32, 32) data:gif timeInterval:0.12];
    [bgView addSubview:gifView];
    
    [self.hudArr addObject:bgView];
}

- (void)hideToast {
    if (!_hudArr || _hudArr.count == 0) {
        return;
    }
    
    for (UIView *view in self.hudArr) {
        [view removeFromSuperview];
    }
}

- (void)hideUploadToast {
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    for (UIView *subviews in keyWindow.subviews) {
        if ([subviews isKindOfClass:[UIView class]]) {
            if (subviews.tag == Upload_TAG) {
                [subviews removeFromSuperview];
            }
        }
    }
}

- (void)toggleLoadingInView:(UIView *)view{
    [self toggleLoadingInViews:view position:Center];
}

- (void)toggleLoadingInViews:(UIView *)view position:(HUDPosition)position{
    CGFloat y;
    switch (position) {
        case Top:
            y = (SCREEN_HEIGHT - SafeAreaTopHeight) / 3.0;
            break;
        case Center:
            y = (SCREEN_HEIGHT - SafeAreaTopHeight) / 2.0;
            break;
        default:
            y = (SCREEN_HEIGHT - SafeAreaTopHeight) / 2.0;
            break;
    }
    
    UIView *bgView = [[UIView alloc] initWithFrame:view.bounds];
    [bgView setBackgroundColor:[UIColor clearColor]];
    bgView.tag = HUD_TAG;
    [view addSubview:bgView];
    
    NSData *gif = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"009" ofType:@"gif"]];
    GifView *gifView = [[GifView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 32)/2, y, 32, 32) data:gif timeInterval:0.12];
    [bgView addSubview:gifView];
    
    [_hudArr addObject:view];
}

/** 含有白色遮罩*/
- (void)toggleLoadingInView:(UIView *)view position:(HUDPosition)position{
    CGFloat y = 0.0;
    switch (position) {
        case Top:
            y = (SCREEN_HEIGHT - SafeAreaTopHeight) / 3.0;
            break;
        case Center:
            y = (SCREEN_HEIGHT - SafeAreaTopHeight) / 2.0;
            break;
        case Bom:
            y = (SCREEN_HEIGHT - SafeAreaTopHeight) / 1.5;
            break;
            
        default:
            break;
    }
        
        UIView *bgView = [[UIView alloc] initWithFrame:view.bounds];
        [bgView setBackgroundColor:[UIColor colorWithRed:0.94 green:0.94 blue:0.96 alpha:1]];
        bgView.tag = HUD_TAG;
        [view addSubview:bgView];
        
        NSData *gif = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"009" ofType:@"gif"]];
        GifView *gifView = [[GifView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 32)/2, y, 32, 32) data:gif timeInterval:0.12];
        [bgView addSubview:gifView];
        
        [_hudArr addObject:view];
}

 /** 含有白色遮罩*/
- (void)toggleLoadingInView:(UIView *)view position:(HUDPosition)position andHeight:(CGFloat)height{
    CGFloat y;
    switch (position) {
        case Top:
            y = (SCREEN_HEIGHT - SafeAreaTopHeight) / 3.0;
            break;
        case Center:
            y = (SCREEN_HEIGHT - SafeAreaTopHeight) / 2.0 - height;
            break;
        case Bom:
            y = (SCREEN_HEIGHT - SafeAreaTopHeight) / 1.5;
            break;
        case Custom:
            y = (SCREEN_HEIGHT - SafeAreaTopHeight - height - 100) / 3.0;
            break;
        default:
            break;
    }
    
    if (height == 0) {
         /** 透明的View*/
        UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, height)];
        topView.backgroundColor = [UIColor clearColor];
        topView.tag = HUD_TAG + 1;
        [view addSubview:topView];
         /** 灰色的View*/
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, height, view.frame.size.width, view.frame.size.height)];
        [bgView setBackgroundColor:[UIColor colorWithRed:0.94 green:0.94 blue:0.96 alpha:1]];
        bgView.tag = HUD_TAG;
        [view addSubview:bgView];
        
        NSData *gif = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"009" ofType:@"gif"]];
        GifView *gifView = [[GifView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 32)/2, y, 32, 32) data:gif timeInterval:0.12];
        [bgView addSubview:gifView];
        
        [_hudArr addObject:view];
    } else {
        /** 透明的View*/
        UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, height)];
        topView.backgroundColor = [UIColor clearColor];
        topView.tag = HUD_TAG + 1;
        [view addSubview:topView];
        /** 灰色的View*/
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, height, view.bounds.size.width, view.bounds.size.height - height - textfield_Height)];
        [bgView setBackgroundColor:[UIColor colorWithRed:0.94 green:0.94 blue:0.96 alpha:1]];
        bgView.tag = HUD_TAG;
        [view addSubview:bgView];
        
        NSData *gif = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"009" ofType:@"gif"]];
        GifView *gifView = [[GifView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 32)/2, y, 32, 32) data:gif timeInterval:0.12];
        [bgView addSubview:gifView];
        
        [_hudArr addObject:view];

    }
}

- (void)toggleLoginLoadingInView:(UIView *)view{
    CGFloat y = (SCREEN_HEIGHT - SafeAreaTopHeight) / 2;
    
    UIView *bgView = [[UIView alloc] initWithFrame:view.bounds];
    [bgView setBackgroundColor:[UIColor clearColor]];
    bgView.tag = HUD_TAG;
    [view addSubview:bgView];
    
    UIView *styleView = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-100)*0.5, y-50, 100, 100)];
    [styleView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
    styleView.layer.cornerRadius = 8;
    NSData *gif = [NSData dataWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"009" ofType:@"gif"]];
    GifView *gifView = [[GifView alloc] initWithFrame:CGRectMake((styleView.bounds.size.width-32)*0.5, (100-32)*0.5, 32, 32) data:gif timeInterval:0.12];
    [styleView addSubview:gifView];
    [bgView addSubview:styleView];
    
    [self.hudArr addObject:view];
}

- (void)toggleLoadingInView:(UIView *)view position:(HUDPosition)position withClearColor:(BOOL)isClearColor{
    CGFloat y = 0.0;
    switch (position) {
        case Top:
            y = (SCREEN_HEIGHT-SafeAreaTopHeight)/3.0;
            break;
        case Center:
            y = (SCREEN_HEIGHT-SafeAreaTopHeight)*0.5;
            break;
        default:
            break;
    }
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    UIColor *bgColor = [UIColor whiteColor];
    if (isClearColor) {
        bgColor = [UIColor clearColor];
    }
    [bgView setBackgroundColor:bgColor];
    bgView.tag = HUD_TAG;
    [view addSubview:bgView];
    
    NSData *gif = [NSData dataWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"009" ofType:@"gif"]];
    GifView *gifView = [[GifView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-32)*0.5, y, 32, 32) data:gif timeInterval:0.12];
    [bgView addSubview:gifView];
    
    [_hudArr addObject:view];
}

- (void)toggleUploadWithMessage:(NSString *)message messageColor:(UIColor*)messageColor messageFont:(UIFont *)messageFont inView:(UIView *)inView backgroundColor:(UIColor *)backgroundColor {
    
    CGFloat y = (SCREEN_HEIGHT - SafeAreaTopHeight) / 2;
    
    UIView *bgView = [[UIView alloc] initWithFrame:inView.bounds];
    [bgView setBackgroundColor:[UIColor clearColor]];
    bgView.tag = HUD_TAG;
    [inView addSubview:bgView];
    
    UIView *styleView = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-130)*0.5, y-50, 130, 130)];
    
    [styleView setBackgroundColor:backgroundColor];
    styleView.layer.cornerRadius = 8;
    NSData *gif = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"009" ofType:@"gif"]];
    GifView *gifView = [[GifView alloc] initWithFrame:CGRectMake((styleView.bounds.size.width-32)*0.5, 30, 32, 32) data:gif timeInterval:0.12];
    
    UILabel *uploadLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,70, 130, 30)];
    uploadLabel.text = message;
    uploadLabel.textColor = messageColor;
    uploadLabel.font = messageFont;
    uploadLabel.textAlignment = NSTextAlignmentCenter;
    
    [styleView addSubview:gifView];
    [styleView addSubview:uploadLabel];
    [bgView addSubview:styleView];
    
    [self.hudArr addObject:inView];
}

- (void)toggleLoginLoadingInViewWithColor:(UIView *)view{
    CGFloat y = (SCREEN_HEIGHT - SafeAreaTopHeight) / 2;
    
    UIView *bgView = [[UIView alloc] initWithFrame:view.bounds];
    [bgView setBackgroundColor:[UIColor whiteColor]];
    bgView.tag = HUD_TAG;
    [view addSubview:bgView];
    
    UIView *styleView = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-100)*0.5, y-50, 100, 100)];
    [styleView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
    styleView.layer.cornerRadius = 8;
    NSData *gif = [NSData dataWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"009" ofType:@"gif"]];
    GifView *gifView = [[GifView alloc] initWithFrame:CGRectMake((styleView.bounds.size.width-32)*0.5, (100-32)*0.5, 32, 32) data:gif timeInterval:0.12];
    
    UILabel *uploadLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 70, 100, 30)];
    uploadLabel.text = @"登录中...";
    uploadLabel.textColor = [UIColor whiteColor];
    uploadLabel.font = [UIFont fontWithName:@"Arial" size:14.0f];
    uploadLabel.textAlignment = NSTextAlignmentCenter;
    
    [styleView addSubview:gifView];
    [styleView addSubview:uploadLabel];
    [bgView addSubview:styleView];
    
    [self.hudArr addObject:view];
}


- (void)hideLoadingInView:(UIView *)view{
    if (!_hudArr || _hudArr.count == 0) {
        return;
    }
    
    if ([_hudArr containsObject:view]) {
        [_hudArr removeObject:view];
        UIView *bgView = [view viewWithTag:HUD_TAG];
        UIView *topView = [view viewWithTag:HUD_TAG + 1];
        [topView removeFromSuperview];
        [bgView removeFromSuperview];
        bgView = nil;
    }
}

static CGFloat toastW = 170;
static CGFloat toastH = 60;
- (void)toggleMessage:(NSString *)message andPosition:(HUDPosition)position andBackGroundColor:(UIColor *)color
{
    CGFloat y = 0.0;
    switch (position) {
        case Top:
            y = (SCREEN_HEIGHT - SafeAreaTopHeight) / 3.0;
            break;
        case Center:
            y = (SCREEN_HEIGHT - SafeAreaTopHeight) / 2.0;
            break;
        case Bom:
            y = (SCREEN_HEIGHT - SafeAreaTopHeight);
            break;
            
        default:
            break;
    }
    
    if (message == nil || [message isEqualToString:@""]) {
        return;
    }
    if (self.msgHud != nil) {
        return;
    }
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    UIView *backGroudView = [[UIView alloc] initWithFrame:keyWindow.bounds];
    backGroudView.backgroundColor = [UIColor clearColor];
    [keyWindow addSubview:backGroudView];
    
    UIView *toastView = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - toastW) / 2, y - toastH / 2, toastW, toastH)];
    toastView.backgroundColor = color;
    toastView.layer.cornerRadius = 8;
    [backGroudView addSubview:toastView];
    
    UILabel *toastLabel = [[UILabel alloc] initWithFrame:toastView.bounds];
    toastLabel.text = message;
    toastLabel.textAlignment = NSTextAlignmentCenter;
    
    toastLabel.font = [UIFont systemFontOfSize:16];
    toastLabel.textColor = [UIColor whiteColor];
    
    [toastView addSubview:toastLabel];
    
    [UIView animateWithDuration:1.5 animations:^{
        toastView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [backGroudView removeFromSuperview];
    }];
    
    
}


- (void)toggleMessage:(NSString *)message position:(HUDPosition)position andBackGroundColor:(UIColor *)color alpha:(CGFloat)alpha animation:(BOOL)animation {
    CGFloat y = 0.0;
    switch (position) {
        case Top:
            y = (SCREEN_HEIGHT - SafeAreaTopHeight) / 3.0;
            break;
        case Center:
            y = (SCREEN_HEIGHT - SafeAreaTopHeight) / 2.0;
            break;
        case Bom:
            y = (SCREEN_HEIGHT - SafeAreaTopHeight) / 1.5;
            break;
            
        default:
            break;
    }
    
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    CGRect viewRect = CGRectMake(0, SafeAreaTopHeight, SCREEN_WIDTH, SCREEN_HEIGHT - SafeAreaTopHeight);
//    UIView *bgView = [[UIView alloc] initWithFrame:viewRect];
//    [bgView setBackgroundColor:[UIColor clearColor]];
//    bgView.tag = HUD_TAG;
//    [keyWindow addSubview:bgView];
//    
//    NSData *gif = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"009" ofType:@"gif"]];
//    GifView *gifView = [[GifView alloc] initWithFrame:CGRectMake((ScreenWidth - 32)/2, (ScreenHeight - SafeAreaTopHeight) / 2.0, 32, 32) data:gif];
//    [bgView addSubview:gifView];
//    
//    [self.hudArr addObject:bgView];
//    
//    if (message == nil || [message isEqualToString:@""]) {
//        return;
//    }
//    if (self.msgHud != nil) {
//        return;
//    }
    
    UIView *bgView = [[UIView alloc] initWithFrame:viewRect];
    [bgView setBackgroundColor:[UIColor clearColor]];
    bgView.tag = Upload_TAG;
    [keyWindow addSubview:bgView];
    
    UIView *toast = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - toastWidth - 32)/2, (y - 80 - toastHeight)/2, toastWidth, toastHeight)];
    toast.backgroundColor = color;
    toast.alpha = alpha;
    _toast = toast;
    _toast.layer.cornerRadius = 8;
    _toast.hidden = NO;
    [bgView addSubview:toast];
    
    _toast.center = CGPointMake(bgView.frame.size.width / 2, (bgView.frame.size.height - 80) / 2);
    _textLayer = [CAShapeLayer layer];
    _textLayer.fillColor   = [UIColor clearColor].CGColor;
    _textLayer.strokeColor = [UIColor whiteColor].CGColor;
    _textLayer.lineWidth   = 1;
    _textLayer.lineCap = kCALineCapButt;
    [_toast.layer addSublayer:_textLayer];
    
    CABasicAnimation *textAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    textAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    textAnimation.fromValue = @(0);
    textAnimation.toValue = @1;
    textAnimation.duration = 2;
    textAnimation.repeatCount = HUGE;
    textAnimation.removedOnCompletion = NO;
    
    if (animation) {
        
        [_textLayer addAnimation:textAnimation forKey:nil];
        self.tipText = message;
    } else {
        
        [_textLayer removeAllAnimations];
        self.tipText = message;
        [self performSelector:@selector(hideFailHUD:) withObject:bgView afterDelay:1.0];
    }
    
    [_hudArr addObject:bgView];

}

/**
 * TODO: 上传中的提示框
 */
static CGFloat toastWidth = 163;
static CGFloat toastHeight = 59;
- (void)toggleMessage:(NSString *)message InView:(UIView *)view position:(HUDPosition)position andBackGroundColor:(UIColor *)color alpha:(CGFloat)alpha animation:(BOOL)animation{
    CGFloat y = 0.0;
    switch (position) {
        case Top:
            y = (SCREEN_HEIGHT - SafeAreaTopHeight) / 3.0;
            break;
        case Center:
            y = (SCREEN_HEIGHT - SafeAreaTopHeight) / 2.0;
            break;
        case Bom:
            y = (SCREEN_HEIGHT - SafeAreaTopHeight) / 1.5;
            break;
            
        default:
            break;
    }
    
    if (message == nil || [message isEqualToString:@""]) {
        return;
    }
    if (self.msgHud != nil) {
        return;
    }
    
    UIView *bgView = [[UIView alloc] initWithFrame:view.bounds];
    [bgView setBackgroundColor:[UIColor clearColor]];
    bgView.tag = HUD_TAG;
    [view addSubview:bgView];
    
    UIView *toast = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - toastWidth - 32)/2, (y - 80 - toastHeight)/2, toastWidth, toastHeight)];
    toast.backgroundColor = color;
    toast.alpha = alpha;
    _toast = toast;
    _toast.layer.cornerRadius = 8;
    _toast.hidden = NO;
    [bgView addSubview:toast];
    
    _toast.center = CGPointMake(view.frame.size.width / 2, (view.frame.size.height - 80) / 2);
    _textLayer = [CAShapeLayer layer];
    _textLayer.fillColor   = [UIColor clearColor].CGColor;
    _textLayer.strokeColor = [UIColor whiteColor].CGColor;
    _textLayer.lineWidth   = 1;
    _textLayer.lineCap = kCALineCapButt;
    [_toast.layer addSublayer:_textLayer];
    
    CABasicAnimation *textAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    textAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    textAnimation.fromValue = @(0);
    textAnimation.toValue = @1;
    textAnimation.duration = 2;
    textAnimation.repeatCount = HUGE;
    textAnimation.removedOnCompletion = NO;
    
    if (animation) {
        
        [_textLayer addAnimation:textAnimation forKey:nil];
        self.tipText = message;
    } else {
        
        [_textLayer removeAllAnimations];
        self.tipText = message;
        [self performSelector:@selector(hideFailHUD:) withObject:bgView afterDelay:1.0];
    }
    
    [_hudArr addObject:view];
    
}

- (void)hideFailHUD:(UIView *)bgView {
    if (bgView) {
        [bgView removeFromSuperview];
    }
}

/** TODO:上传失败*/
- (void)failToggleMessage:(NSString *)message position:(HUDPosition)position andBackGroundColor:(UIColor *)color alpha:(CGFloat)alpha {
    CGFloat y = 0.0;
    switch (position) {
        case Top:
            y = (SCREEN_HEIGHT - SafeAreaTopHeight) / 3.0;
            break;
        case Center:
            y = (SCREEN_HEIGHT - SafeAreaTopHeight) / 2.0;
            break;
        case Bom:
            y = (SCREEN_HEIGHT - SafeAreaTopHeight) / 1.5;
            break;
            
        default:
            break;
    }
    
    if (message == nil || [message isEqualToString:@""]) {
        return;
    }
    if (self.msgHud != nil) {
        return;
    }
    
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    UIView *bgView = [[UIView alloc] initWithFrame:keyWindow.bounds];
    [bgView setBackgroundColor:[UIColor clearColor]];
    bgView.tag = HUD_TAG;
    [keyWindow addSubview:bgView];
    
    UIView *toast = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - toastWidth * 1.5 - 32)/2, (y - 80 - 100)/2, toastWidth * 1.5, 82)];
    toast.backgroundColor = color;
    toast.alpha = alpha;
    _toast = toast;
    _toast.layer.cornerRadius = 8;
    _toast.hidden = NO;
    [bgView addSubview:toast];
    
    _toast.center = CGPointMake(keyWindow.frame.size.width / 2, (keyWindow.frame.size.height - 80) / 2);
    
    UILabel *failabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 80, 20)];
    failabel.text = @"上传失败";
    failabel.font = [UIFont systemFontOfSize:17];
    failabel.textColor = [UIColor whiteColor];
    [_toast addSubview:failabel];
    failabel.center = CGPointMake(toast.bounds.size.width / 2, (toast.bounds.size.height) / 3);
    
    UILabel *failDetail = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, toastWidth * 1.4, 20)];
    failDetail.font = [UIFont systemFontOfSize:17];
    failDetail.textColor = [UIColor whiteColor];
    [_toast addSubview:failDetail];
    
    NSMutableAttributedString *voiceAtt = [[NSMutableAttributedString alloc] init];
    UIImage *img = [UIImage imageNamed:@"jinggao"];
    NSTextAttachment *imgAttachment = [[NSTextAttachment alloc] init];
    imgAttachment.image = img;
    imgAttachment.bounds = CGRectMake(2, -7, 28, 28);
    NSAttributedString *imgAtt = [NSAttributedString attributedStringWithAttachment:imgAttachment];
    [voiceAtt appendAttributedString:imgAtt];
    NSAttributedString *messageAtt = [[NSAttributedString alloc] initWithString:message];
    [voiceAtt appendAttributedString:messageAtt];
    failDetail.attributedText = voiceAtt;
    failDetail.center = CGPointMake(toast.bounds.size.width / 2, (toast.bounds.size.height) /  3 * 2);
    [self performSelector:@selector(hideFailHUD:) withObject:bgView afterDelay:1.0];
}

/** TODO:登录失败*/
- (void)failLoginToggleMessage:(NSString *)message isImageType:(BOOL)isImageType  position:(HUDPosition)position{
    
    CGFloat y = 0.0;
    switch (position) {
        case Top:
            y = (SCREEN_HEIGHT - SafeAreaTopHeight) / 3.0;
            break;
        case Center:
            y = (SCREEN_HEIGHT - SafeAreaTopHeight) / 2.0;
            break;
        case Bom:
            y = (SCREEN_HEIGHT - SafeAreaTopHeight) / 1.5;
            break;
            
        default:
            break;
    }
    
    if (message == nil || [message isEqualToString:@""]) {
        return;
    }
    if (self.msgHud != nil) {
        return;
    }
    
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    UIView *bgView = [[UIView alloc] initWithFrame:keyWindow.bounds];
    [bgView setBackgroundColor:[UIColor clearColor]];
    bgView.tag = HUD_TAG;
    [keyWindow addSubview:bgView];
    
    NSMutableAttributedString *voiceAtt = [[NSMutableAttributedString alloc] init];
    UIImage *img = [UIImage imageNamed:@"icon_problem"];
    NSString * messageStr = message;
    
    if (isImageType ){
        NSTextAttachment *imgAttachment = [[NSTextAttachment alloc] init];
        imgAttachment.image = img;
        imgAttachment.bounds = CGRectMake(2, -7, 28, 28);
        NSAttributedString *imgAtt = [NSAttributedString attributedStringWithAttachment:imgAttachment];
        [voiceAtt appendAttributedString:imgAtt];
        messageStr = [NSString stringWithFormat:@"   %@",message];
    }
    NSAttributedString *messageAtt = [[NSAttributedString alloc] initWithString:messageStr];
    [voiceAtt appendAttributedString:messageAtt];
    
    [UITextView setAttributeStringMatterWithString:voiceAtt withLineSpace:5 fontSize:15.0 color:kUIColorFromRGB(0xffffff,1.0)];
    
    CGFloat videoSignTextHeight = [UITextView fetchTextViewHeightWithAttributeString:voiceAtt textViewWitdh:toastWidth * 1.5];
    UITextView *failDetail = [[UITextView alloc] initWithFrame:CGRectMake(10, 20, toastWidth * 1.5 - 20.0, videoSignTextHeight)];
    
    failDetail.font = [UIFont systemFontOfSize:15.0];
    failDetail.textColor =kUIColorFromRGB(0xffffff,1.0);
    failDetail.backgroundColor= [UIColor clearColor];
    
    CGFloat  tmpHeight = 0;
    if (videoSignTextHeight>60.0) {
        tmpHeight = videoSignTextHeight;
    } else {
        tmpHeight = 60.0;
    }
    failDetail.attributedText = voiceAtt;
    failDetail.textAlignment= NSTextAlignmentCenter;
    
    UIView *toast = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - toastWidth * 1.5 - 32)/2, SCREEN_HEIGHT / 10.5, SCREEN_WIDTH-80.0, tmpHeight)];
    toast.backgroundColor = kUIColorFromRGB(0x222222,0.85);
    _toast = toast;
    _toast.layer.cornerRadius = 8;
    _toast.hidden = NO;
    [bgView addSubview:toast];
    
    _toast.center = CGPointMake(keyWindow.frame.size.width / 2, (keyWindow.frame.size.height - 80) / 2);
    [_toast addSubview:failDetail];
    failDetail.center = CGPointMake(toast.bounds.size.width / 2.0, (toast.bounds.size.height) / 2.0);
    
    [self performSelector:@selector(hideFailHUD:) withObject:bgView afterDelay:1.0];
}


#pragma mark SETORGET
- (void)setTipText:(NSString *)tipText {
    _tipText = tipText;
    
    [self textLayerPath:tipText];
}

- (void)textLayerPath:(NSString *)text
{
    NSMutableAttributedString *attributed = [[NSMutableAttributedString alloc] initWithString:text];
    [attributed addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, attributed.length)];
    _textLayer.path = [self textPath:attributed].CGPath;
    
    CGFloat width = attributed.size.width + 10;
    CGFloat maxWidth = SCREEN_WIDTH - 100;
    if (width >= _toast.frame.size.width)
    {
        CGRect frame = _toast.frame;
        if (width <= maxWidth)
        {
            frame.size.width = width;
        }
        else
        {
            frame.size.width = maxWidth;
        }
        _toast.frame = frame;
    }
    else
    {
        CGRect frame = _toast.frame;
        frame.size.width = toastWidth;
        _toast.frame = frame;
    }
    
    _textLayer.position = CGPointMake((_toast.frame.size.width - attributed.size.width) / 2, (_toast.bounds.size.height - 20) / 2);
}

#pragma mark Methods
- (UIBezierPath *)textPath:(NSMutableAttributedString *)text
{
    CGMutablePathRef letters = CGPathCreateMutable();
    CTLineRef line = CTLineCreateWithAttributedString((__bridge CFAttributedStringRef)text);
    CFArrayRef runArray = CTLineGetGlyphRuns(line);
    
    for (CFIndex runIndex = 0; runIndex < CFArrayGetCount(runArray); runIndex++)
    {
        CTRunRef run = (CTRunRef)CFArrayGetValueAtIndex(runArray, runIndex);
        CTFontRef runFont = CFDictionaryGetValue(CTRunGetAttributes(run), kCTFontAttributeName);
        
        for (CFIndex runGlyphIndex = 0; runGlyphIndex < CTRunGetGlyphCount(run); runGlyphIndex++)
        {
            CFRange thisGlyphRange = CFRangeMake(runGlyphIndex, 1);
            CGGlyph glyph;
            CGPoint position;
            CTRunGetGlyphs(run, thisGlyphRange, &glyph);
            CTRunGetPositions(run, thisGlyphRange, &position);
            CGPathRef letter = CTFontCreatePathForGlyph(runFont, glyph, NULL);
            CGAffineTransform t = CGAffineTransformMakeTranslation(position.x, position.y);
            CGPathAddPath(letters, &t, letter);
            CGPathRelease(letter);
        }
    }
    
    UIBezierPath *path = [UIBezierPath bezierPathWithCGPath:letters];
    CGRect boundingBox = CGPathGetBoundingBox(letters);
    CGPathRelease(letters);
    CFRelease(line);
    
    [path applyTransform:CGAffineTransformMakeScale(1.0, -1.0)];
    [path applyTransform:CGAffineTransformMakeTranslation(0.0, boundingBox.size.height)];
    
    return path;
}





#pragma mark - MBProgressHUDDelegate
- (void)hudWasHidden:(MBProgressHUD *)hud{
    if (self.msgHud) {
        [self.msgHud removeFromSuperview];
        self.msgHud = nil;
    }
}

#pragma mark - notification

- (void)addNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)removeNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    self.keyboardOffsetY = keyboardRect.size.height;
    
}
- (void)keyboardWillHide:(NSNotification *)notification
{
    self.keyboardOffsetY = 0;
}

@end
