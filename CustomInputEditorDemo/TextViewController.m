//
//  TextViewController.m
//  CustomInputEditorDemo
//
//  Created by zhanggaotong on 2021/3/30.
//  Copyright © 2021 Xdf. All rights reserved.
//

#import "TextViewController.h"
#import "JZImageTextInputView.h"
@interface TextViewController ()
@property (nonatomic, strong) JZImageTextInputView *imageTextInputView;
@end

@implementation TextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.imageTextInputView];
    
    [self.imageTextInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.bottom.mas_equalTo(self.view);
    }];

}

- (JZImageTextInputView *)imageTextInputView {
    if (!_imageTextInputView) {
        _imageTextInputView = [[JZImageTextInputView alloc] init];
    }
    return _imageTextInputView;
}

- (void)dealloc {

}

@end
