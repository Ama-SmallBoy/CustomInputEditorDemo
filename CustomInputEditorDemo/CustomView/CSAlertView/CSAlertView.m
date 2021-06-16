//
//  AlertViewSelf.m
//  UPOC_Teacher
//
//  Created by Mac on 17/10/9.
//  Copyright © 2017年 星梦. All rights reserved.
//

#import "CSAlertView.h"

#define kButtonHeight 50.0
#define SpaceWidth 52.5
#define kImgWidth 50
#define lineSpace 15

@interface CSAlertView()

/** 背景图片 */
@property (strong,nonatomic) UIView * backgroundView;
//图片
@property (strong,nonatomic) UIImageView * imgView;
//标题涂层
@property (strong,nonatomic) UILabel * titleLabel;
//信息涂层
@property (strong,nonatomic) UILabel * messageLable;
//按钮涂层
@property (strong,nonatomic) UIView * buttonView;
//确定按钮
@property (strong,nonatomic) UIButton * sureBtn;
//取消按钮
@property (strong,nonatomic) UIButton * cancelBtn;
//竖线
@property (strong,nonatomic) UIView * verticalLine;
//横线
@property (strong,nonatomic) UIView * horizontalLine;
//标题的高度
@property (assign,nonatomic) CGFloat titleHeight;
//消息的高度
@property (assign,nonatomic) CGFloat messageHeight;
//图像高度
@property (assign,nonatomic) CGFloat imgHeight;
///主页面样式  是否 带图片 带标题
@property(assign,nonatomic,readwrite) AlertMainType alertMainType;
///按钮样式 单按钮模式 双按钮模式
@property(assign,nonatomic,readwrite) AlertButtonType alertButtonType;
//标题
@property(nonatomic,strong) NSString * titleString;
//提示信息
@property(nonatomic,strong) NSString * messageString;
//确定按钮
@property(nonatomic,strong) NSString * sureTitle;
//取消按钮
@property(nonatomic,strong) NSString * cancelTitle;
//提示图片
@property(strong,nonatomic) NSString * imageName;

@end

@implementation CSAlertView

static const NSTimeInterval kAnimateDuration = 0.3f;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kUIColorFromRGB(0x000000, 0.6);
        self.backgroundView.layer.masksToBounds = YES;
        self.backgroundView.layer.cornerRadius = 10.0;
        [self setDefultValue];
        [self initBaseUI];
    }
    return self;
}

//设置 默认 属性
-(void)setDefultValue{
    //默认 单个 消息提示  双按钮 --
    self.alertMainType = MessageAlertType;
    self.alertButtonType = DBAlertType;
}
#pragma mark --- 初始化基本的UI 属性 ---
-(void)initBaseUI{
    //按钮层
    [self.buttonView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backgroundView);
        make.right.equalTo(_backgroundView);
        make.bottom.equalTo(_backgroundView);
        make.height.equalTo(@(kButtonHeight));
    }];
}
//主UI类型
- (void)setAlertMainType:(AlertMainType)alertMainType{
    _alertMainType = alertMainType;
    [self layoutSubviewsWithAlertMainType:alertMainType];
}
//按钮的 类型
-(void)setAlertButtonType:(AlertButtonType)alertButtonType{
    _alertButtonType = alertButtonType;
    [self layoutButtonWithAlertButtonType:alertButtonType];
}
-(void)setTitleString:(NSString *)titleString{
    _titleString = titleString;
    self.titleLabel.attributedText = [self fetchAttributeStringWithString:titleString];
    self.titleHeight = [self fetchHeightByMessage:titleString];
}
-(void)setMessageString:(NSString *)messageString{
    _messageString = messageString;
    self.messageLable.attributedText = [self fetchAttributeStringWithString:messageString];
    self.messageHeight = [self fetchHeightByMessage:messageString];
}
-(void)setSureTitle:(NSString *)sureTitle{
    _sureTitle = sureTitle;
    [self.sureBtn setTitle:sureTitle forState:UIControlStateNormal];
}
-(void)setCancelTitle:(NSString *)cancelTitle{
    _cancelTitle = cancelTitle;
    [self.cancelBtn setTitle:cancelTitle forState:UIControlStateNormal];
}
-(void)setImageName:(NSString *)imageName{
    _imageName = imageName;
    UIImage * imageSd = [UIImage imageNamed:imageName];
    self.imgHeight = imageSd.size.height/imageSd.size.width * kImgWidth;
    self.imgView.image = [UIImage imageNamed:imageName];
}
-(CGFloat)fetchHeightOfBackViewWithAlertMainType:(AlertMainType)alertMainType{
    CGFloat extentHeight = 20 * 2;
    CGFloat allHeight = 0;
    if (alertMainType == TitleAlertType) {
        allHeight = extentHeight + self.titleHeight + lineSpace + self.messageHeight;
    }else if (alertMainType == ImageAlertType) {
        allHeight = extentHeight + self.imgHeight + lineSpace + self.messageHeight;
    }else if (alertMainType == TIMgeAlertType) {
        allHeight = extentHeight +self.titleHeight+ lineSpace + self.imgHeight + lineSpace+ self.messageHeight;
    }else if (alertMainType == MessageAlertType){
        allHeight = extentHeight+self.messageHeight;
    }
    return (allHeight+kButtonHeight)<140?140:(allHeight+kButtonHeight);
}
-(void)layoutSubviewsWithAlertMainType:(AlertMainType)alertMainType{
    CGFloat backHeight = [self fetchHeightOfBackViewWithAlertMainType:alertMainType];
    [self.backgroundView mas_remakeConstraints:^(MASConstraintMaker *make) {
          make.center.equalTo(self);
          make.width.equalTo(@(SCREEN_WIDTH-2*SpaceWidth));
          make.height.equalTo(@(backHeight));
    }];
    [self layoutMainUIWithAlertButtonType:alertMainType];
}
//布局 底部按钮 --
-(void)layoutMainUIWithAlertButtonType:(AlertMainType)alertMainType{
    if (alertMainType == TitleAlertType) {
        self.imgView.hidden = YES;
        //只有 标题
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
              make.top.equalTo(_backgroundView.mas_top).offset(20);
              make.left.equalTo(_backgroundView.mas_left).offset(10);
              make.right.equalTo(_backgroundView.mas_right).offset(-10);
        }];
        //消息提示
        [self.messageLable mas_remakeConstraints:^(MASConstraintMaker *make) {
             make.top.equalTo(_titleLabel.mas_bottom).offset(lineSpace);
             make.left.equalTo(self.backgroundView.mas_left).offset(10);
             make.right.equalTo(self.backgroundView.mas_right).offset(-10);
             make.bottom.equalTo(self.buttonView.mas_top).offset(-20);
        }];
    }else if (alertMainType == ImageAlertType) {
        self.imgView.hidden = NO;
        //只有图像
        [self.imgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.backgroundView.mas_top).offset(20);
            make.centerX.equalTo(self.backgroundView.mas_centerX);
            make.width.equalTo(@(kImgWidth));
            make.height.equalTo(@(self.imgHeight));
        }];
        //消息提示
        [self.messageLable mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_imgView.mas_bottom).offset(lineSpace);
            make.left.equalTo(_backgroundView.mas_left).offset(10);
            make.right.equalTo(_backgroundView.mas_right).offset(-10);
            make.bottom.equalTo(_buttonView.mas_top).offset(-20);
        }];
        
    }else if (alertMainType == TIMgeAlertType) {
        //标题和图像都有
        self.imgView.hidden = NO;
        //只有图像
        [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_backgroundView.mas_top).offset(20);
            make.centerX.equalTo(_backgroundView.mas_centerX);
            make.height.equalTo(@(self.imgHeight));
        }];
        //只有 标题
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
             make.top.equalTo(_imgView.mas_bottom).offset(lineSpace);
             make.left.equalTo(_backgroundView.mas_left).offset(10);
             make.right.equalTo(_backgroundView.mas_right).offset(-10);
        }];
        //消息提示
        [self.messageLable mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_titleLabel.mas_bottom).offset(lineSpace);
            make.left.equalTo(_backgroundView.mas_left).offset(10);
            make.right.equalTo(_backgroundView.mas_right).offset(-10);
            make.bottom.equalTo(_buttonView.mas_top).offset(-20);
        }];
    }else if (alertMainType == MessageAlertType) {
        self.imgView.hidden = YES;
        //消息提示
        [self.messageLable mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.backgroundView).offset(20);
            make.left.equalTo(_backgroundView).offset(10);
            make.right.equalTo(_backgroundView).offset(-10);
            make.bottom.equalTo(self.buttonView.mas_top).offset(-20);
        }];
    }
}
//布局 底部按钮 --
-(void)layoutButtonWithAlertButtonType:(AlertButtonType)alertButtonType{
    //水平线 分割线
    [self.horizontalLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_buttonView);
        make.left.equalTo(_buttonView);
        make.right.equalTo(_buttonView);
        make.height.equalTo(@1);
    }];
    CGFloat buttonWidth = SCREEN_WIDTH - SpaceWidth*2;
    if (alertButtonType == DBAlertType) {
        self.verticalLine.hidden = NO;
        //双按钮
        [self.cancelBtn  mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.buttonView);
            make.bottom.equalTo(_buttonView);
            make.top.equalTo(_horizontalLine);
            make.width.equalTo(@((buttonWidth - 1)/2.0));
        }];
        [self.sureBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_buttonView);
            make.bottom.equalTo(_buttonView);
            make.top.equalTo(_horizontalLine);
            make.width.equalTo(@((buttonWidth - 1)/2.0));
        }];
        [self.verticalLine mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_buttonView);
            make.top.equalTo(_horizontalLine);
            make.centerX.equalTo(_backgroundView);
            make.width.equalTo(@1);
        }];
    }else if(alertButtonType == SBAlertType){
        self.verticalLine.hidden = YES;
        if (self.cancelTitle == nil) {
            [self.sureBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                   make.right.equalTo(_buttonView);
                   make.bottom.equalTo(_buttonView);
                   make.top.equalTo(_horizontalLine);
                   //make.left.equalTo(_buttonView);
                   make.width.equalTo(@(buttonWidth));
            }];
        }else if(self.sureTitle == nil){
            //双按钮
            [self.cancelBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_buttonView);
                make.bottom.equalTo(_buttonView);
                make.top.equalTo(_horizontalLine);
                make.right.equalTo(_buttonView);
            }];
        }
    }
}
#pragma mark --- 获取高度
-(CGFloat)fetchHeightByMessage:(NSString*)message{
    //两边间距为20；
    CGFloat messageWidth = SCREEN_WIDTH - SpaceWidth*4;
   // NSAttributedString * messageAttributedString = [self fetchAttributeStringWithString:message];
    CGSize textSize = [message boundingRectWithSize:CGSizeMake(messageWidth, MAXFLOAT) options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine) attributes:[self fetchAttributeMatter] context:nil].size;
    return textSize.height;
}

-(NSDictionary *)fetchAttributeMatter{
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    //行间距为5.0
    paragraphStyle.lineSpacing = 5.0;
    //剧中显示
    paragraphStyle.alignment = NSTextAlignmentCenter;
    //行高
    //paragraphStyle.lineHeightMultiple = 17.0;
    //分行的模式
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    //格式字典
    //1E2529 文字颜色 ---
    NSDictionary* attributedStringMatter =  @{
                           NSFontAttributeName : [UIFont boldSystemFontOfSize:16.0],
                           NSForegroundColorAttributeName:kUIColorFromRGB(0x1E2529, 1.0),
                           NSParagraphStyleAttributeName:paragraphStyle,
                       };
    return attributedStringMatter;
}
#pragma mark --- 获取富文本
-(NSAttributedString *)fetchAttributeStringWithString:(NSString *)messageString{
    //设置格式：
    NSMutableAttributedString * messageAttributedString = [[NSMutableAttributedString alloc]initWithString:messageString attributes:[self fetchAttributeMatter]];
    return messageAttributedString.copy;
}

#pragma mark --- 改变颜色
-(void)changeCancelTitleColor:(UIColor *)cancelTitleColor
               sureTitleColor:(UIColor *)sureTitleColor
                  cancelTitle:(NSString *)cancelTitle
                    sureTitle:(NSString *)sureTitle
                messageString:(NSString *)messageString
                    imageName:(NSString *)imageName
                  titleString:(NSString *)titleString
                alertMainType:(AlertMainType)alertMainType
              alertButtonType:(AlertButtonType)alertButtonType{
    
    [self.sureBtn setTitleColor:sureTitleColor forState:UIControlStateNormal];
    [self.cancelBtn setTitleColor:cancelTitleColor forState:UIControlStateNormal];
    self.cancelTitle = cancelTitle;
    self.sureTitle = sureTitle;
    self.messageString = messageString;
    if (imageName != nil) {
        self.imageName = imageName;
    }
    if (titleString != nil) {
        self.titleString = titleString;
    }
    self.alertButtonType = alertButtonType;
    self.alertMainType = alertMainType;
}
//展示
- (void)showAlertViewAction{
    // 在主线程中处理,否则在viewDidLoad方法中直接调用,会先加本视图,后加控制器的视图到UIWindow上,导致本视图无法显示出来,这样处理后便会优先加控制器的视图到UIWindow上
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        NSEnumerator *frontToBackWindows = [UIApplication.sharedApplication.windows reverseObjectEnumerator];
        for (UIWindow *window in frontToBackWindows)
        {
            BOOL windowOnMainScreen = window.screen == UIScreen.mainScreen;
            BOOL windowIsVisible = !window.hidden && window.alpha > 0;
            BOOL windowLevelNormal = window.windowLevel == UIWindowLevelNormal;
            
            if(windowOnMainScreen && windowIsVisible && windowLevelNormal)
            {
                [window addSubview:self];
                break;
            }
        }
        [UIView animateWithDuration:kAnimateDuration delay:0 usingSpringWithDamping:0.7f initialSpringVelocity:0.7f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.backgroundView.alpha = 1.0f;
        } completion:nil];
    }];
}
//消失
-(void)dismissAlertView{
    [UIView animateWithDuration:kAnimateDuration delay:0 usingSpringWithDamping:0.7f initialSpringVelocity:0.7f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.backgroundView.alpha = 0.0f;
        //self.scondBackView.frame = CGRectMake(0,self.frame.size.height,self.frame.size.width-SpaceWidth, self.scondBackView.frame.size.height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
#pragma mark --------------- get方法 ----
-(UIView *)backgroundView{
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc]initWithFrame:CGRectZero];
        _backgroundView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_backgroundView];
    }
    return _backgroundView;
}

-(UIView *)buttonView{
    if (!_buttonView) {
        _buttonView = [[UIView alloc]initWithFrame:CGRectZero];
        [self.backgroundView addSubview:_buttonView];
    }
    return _buttonView;
}
-(UIImageView *)imgView{
    if (!_imgView) {
        _imgView = [[UIImageView alloc]initWithFrame:CGRectZero];
        [self.backgroundView addSubview:_imgView];
    }
    return _imgView;
}
-(UIButton *)sureBtn{
    if (!_sureBtn) {
        _sureBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_sureBtn setTitleColor:kUIColorFromRGB(0x1E2529, 1.0) forState:UIControlStateNormal];
        _sureBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
        [_sureBtn addTarget:self action:@selector(didSureAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.buttonView addSubview:_sureBtn];
    }
    return _sureBtn;
}

-(void)didSureAction:(UIButton *)sureBtn{
    if (self.sureAction) {
        self.sureAction(sureBtn);
    }
    
}
-(UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_cancelBtn setTitleColor:kUIColorFromRGB(0x16CC9C, 1.0) forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
        [_cancelBtn addTarget:self action:@selector(didCancelAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.buttonView addSubview:_cancelBtn];
    }
    return _cancelBtn;
}
-(void)didCancelAction:(UIButton *)cancelBtn{
    if (self.cancelAction) {
        self.cancelAction(cancelBtn);
    }
}
-(UILabel *)messageLable{
    if (!_messageLable) {
        _messageLable = [[UILabel alloc]initWithFrame:CGRectZero];
        _messageLable.numberOfLines = 0;
        _messageLable.textAlignment = NSTextAlignmentCenter;
        _messageLable.backgroundColor = [UIColor whiteColor];
        [self.backgroundView addSubview:_messageLable];
    }
    return _messageLable;
}
-(UIView *)verticalLine{
    if (!_verticalLine) {
        _verticalLine = [[UIView alloc] initWithFrame:CGRectZero];
        _verticalLine.backgroundColor = kUIColorFromRGB(0xD8D8D8, 1.0);
        [self.buttonView addSubview:_verticalLine];
    }
    return _verticalLine;
}
-(UIView *)horizontalLine{
    if (!_horizontalLine) {
        _horizontalLine = [[UIView alloc]initWithFrame:CGRectZero];
        [self.buttonView addSubview:_horizontalLine];
        _horizontalLine.backgroundColor = kUIColorFromRGB(0xD8D8D8, 1.0);
    }
    return _horizontalLine;
}

@end
