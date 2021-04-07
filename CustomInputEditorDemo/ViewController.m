//
//  ViewController.m
//  CustomInputEditorDemo
//
//  Created by Xdf on 2020/7/6.
//  Copyright © 2020 Xdf. All rights reserved.
//

#import "ViewController.h"
#import "CSTextInputView.h"
#import "TextViewController.h"

@interface ViewController () <JZTextInputViewDelegate>
@property (nonatomic, strong) CSTextInputView *textInputView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
//    //设置 placeholderTextView
//    [self.view addSubview:self.textInputView];
//
//    [self.textInputView mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.view).offset(10);
//        make.right.equalTo(self.view).offset(-10);
//        make.top.equalTo(self.view).offset(SafeAreaTopHeight);
//        make.bottom.equalTo(self.view).offset(-10);
//    }];

}

- (IBAction)pushEditorAction:(UIButton *)sender {
    TextViewController * editorViewController = [[TextViewController alloc]init];
    [self.navigationController pushViewController:editorViewController animated:YES];
}

#pragma mark - CSTextInputViewDelegate
- (void)textViewDidChange:(PlaceholderTextView *_Nonnull )textView {
    NSLog(@"=====+++====%lf",self.textInputView.keyboardHeight);
}

- (void)didClickInputType:(InputType)inputType {
    
}

- (CSTextInputView *)textInputView {
    if (!_textInputView) {
        _textInputView = [[CSTextInputView alloc] init];
        _textInputView.textInputViewDelegate = self;
    }
    return _textInputView;
}

@end
