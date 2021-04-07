//
//  CSToolBarView.h
//  UPOC_Teacher
//
//  Created by a on 2019/12/11.
//  Copyright © 2019 北京新东方教育科技(集团)有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    ImageType,/// < 从相册选择图片
    CameraType,/// < 相机
    FileType,/// < 文件
    PencilType,/// < 手绘
    VoiceType,/// < 语音
    EmojiType,/// < 表情符
    ShowKeyBoardType,/// < 展示 收起
    OtherType,/// < 其他
} InputType;

NS_ASSUME_NONNULL_BEGIN

@protocol CSToolBarViewDelegate <NSObject>

-(void)didClickResponseWithInputType:(InputType)inputType;

@end

@interface CSToolBarView : UIView

///折叠按钮选中时的图片
@property(nonatomic,strong) NSString *showSelectedImage;
///折叠按钮正常时，图片
@property(nonatomic,strong) NSString *showNormalImage;
///工具ItemsArraay: @[@{@"AddImg":@(ImageType)},@{@"camera":@(CameraType)}];
@property(nonatomic,strong) NSArray *actionTypeArray;
///折叠按钮是否选中
@property(nonatomic,assign) BOOL isBtnSelected;
///是否隐藏折叠按钮
@property(nonatomic,assign) BOOL isHiddenShowBtn;
///代理
@property(nonatomic,assign) id<CSToolBarViewDelegate> toolBarViewDelegate;
///分割线高度
@property(nonatomic,assign) CGFloat lineViewHeight;

/// 初始化方法
/// @param frame frame
/// @param itemArray 格式：@[@{@"AddImg":@(ImageType)},@{@"camera":@(CameraType)}];
-(instancetype)initWithFrame:(CGRect)frame itemArray:(NSArray *)itemArray;


@end

NS_ASSUME_NONNULL_END
