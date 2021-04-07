//
//  JZImageTextInputView.m
//  CustomInputEditorDemo
//
//  Created by zhanggaotong on 2021/3/30.
//  Copyright © 2021 Xdf. All rights reserved.
//

#import "JZImageTextInputView.h"
#import "JZTextInputView.h"
#import "JZPhotoFlowListView.h"

#define ExtentHeight 20
//static CGFloat const kNEKnowledgePointBottomSpace = 20.0;
static CGFloat const kNECourseTestTableViewCellLeftSpace = 16.0;
static CGFloat const kNECourseTestTableViewCellImageRightSpace = 16.0;

@interface JZImageTextInputView () <JZTextInputViewDelegate, JZPhotoFlowListViewDelegate, JZPhotoFlowListViewDataSource>

@property (nonatomic, strong) JZTextInputView *textInputView;
@property (nonatomic, strong) JZPhotoFlowListView *photoFlowListView;

@property (nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, assign) CGFloat headHeight;

@end

@implementation JZImageTextInputView
- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubviews];
        [self layoutContentViews];
        [self.photoFlowListView reloadData];
    }
    return self;
}

- (void)addSubviews {
    [self addSubview:self.scrollView];
    [self.scrollView addSubview:self.textInputView];
    [self.scrollView addSubview:self.photoFlowListView];
}

- (void)layoutContentViews {
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
//        make.bottom.mas_equalTo(self);
        make.height.mas_equalTo(SCREEN_HEIGHT);
        make.width.mas_equalTo(SCREEN_WIDTH);
    }];
    
    [self.textInputView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(10);
        make.right.mas_equalTo(self).offset(-10);
        make.top.mas_equalTo(self.scrollView).offset(5.0);
        make.height.mas_equalTo(50);
    }];
    
    [self.photoFlowListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(kNECourseTestTableViewCellLeftSpace);
        make.right.mas_equalTo(self).offset(-kNECourseTestTableViewCellImageRightSpace);
        make.top.mas_equalTo(self.textInputView.mas_bottom);//.offset(-kNEKnowledgePointBottomSpace).priorityHigh();
    }];
}

#pragma mark - JZTextInputViewDelegate
- (void)textViewDidChange:(PlaceholderTextView *_Nonnull )textView {
    
    float textViewHeight = [textView sizeThatFits:CGSizeMake(textView.frame.size.width, MAXFLOAT)].height + ExtentHeight;
    
    if (textViewHeight != self.headHeight) {
        
        self.headHeight = textViewHeight;
        [self.textInputView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(self.headHeight);
        }];
        
        [self fetchOriginFrameOfContentViewAtWindow:self.textInputView.frame keyboardHeight:self.textInputView.keyboardHeight];
        
        self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH,self.photoFlowListView.listViewHeight + self.headHeight);
    }
    
    ///规避 莫名情况导致 textView的急剧增大，从而导致 内部滚动式偏移量不正确的问题  ---
    textView.contentSize = CGSizeZero;
    textView.contentOffset = CGPointZero;
}

- (void)fetchOriginFrameOfContentViewAtWindow:(CGRect)cellRect keyboardHeight:(CGFloat)keyboardHeight {
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    //获取 qrCodeImgView 在 window 上面的位置坐标
    CGRect rect = [self.scrollView convertRect:cellRect toView:window];
    //该控件高度 Y
    //被点击的cell 底部位置
    CGFloat cellMaxY = CGRectGetMaxY(rect);
    //CGFloat keyBoardHeight = [[[NSUserDefaults standardUserDefaults] objectForKey:@"KeyBoardHeight"] floatValue];
    //键盘顶部 距离 顶部的位置：
    CGFloat topHeight = SCREEN_HEIGHT - keyboardHeight;
    //要滚动的偏移量
    CGFloat scrollOffSet = ceil(cellMaxY - topHeight);//当cell 的底部 超出 键盘顶部位置时，大于0 ,
    // 24 是 文字行高
    CGFloat heightTmp = self.scrollView.contentOffset.y + scrollOffSet;
    if (scrollOffSet > 0 && heightTmp > 0 ) {
        [self.scrollView setContentOffset:CGPointMake(0, heightTmp) animated:NO];
    }else{
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    }
}

- (void)didClickInputType:(InputType)inputType {
    
}

#pragma mark - JZPhotoFlowListViewDelegate
///点击事件
- (void)photoFlowListView:(JZPhotoFlowListView *)photoFlowListView didSelectItemAtIndex:(NSUInteger)index {
    
}

///添加图片
- (void)photoFlowListViewAddPhoto:(JZPhotoFlowListView *)photoFlowListView {
    
}

///删除图片
- (void)photoFlowListView:(JZPhotoFlowListView *)photoFlowListView didDeleteItemAtIndex:(NSUInteger)index {
    
}

///加载数据后更新布局
- (void)photoFlowListViewLayoutDidUpdate:(JZPhotoFlowListView *)listView {
    
    [self.photoFlowListView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.photoFlowListView.listViewHeight);
    }];
    
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH,self.photoFlowListView.listViewHeight + self.headHeight);
}

#pragma mark - JZPhotoFlowListViewDataSource
- (NSArray <id<JZPhotoFlowListModelProtocol>> *)photoFlowListViewDataSource {
    return nil;
}

#pragma mark--------- 一波懒加载 ---
- (JZTextInputView *)textInputView {
    if (!_textInputView) {
        _textInputView = [[JZTextInputView alloc]init];
        _textInputView.textInputViewDelegate = self;
    }
    return _textInputView;
}

- (JZPhotoFlowListView *)photoFlowListView {
    if (!_photoFlowListView) {
        _photoFlowListView = [[JZPhotoFlowListView alloc] init];
        _photoFlowListView.delegate = self;
        _photoFlowListView.dataSource = self;
    }
    return _photoFlowListView;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH,SCREEN_HEIGHT)];
        _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH,SCREEN_HEIGHT);
        _scrollView.backgroundColor = [UIColor redColor];
    }
    return _scrollView;
}

@end
