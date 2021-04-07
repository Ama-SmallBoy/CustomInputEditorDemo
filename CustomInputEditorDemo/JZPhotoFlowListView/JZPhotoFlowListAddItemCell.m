//
//  NEPhotoFlowListAddItemCell.m
//  CustomInputEditorDemo
//
//  Created by zhanggaotong on 2021/3/30.
//  Copyright © 2021 Xdf. All rights reserved.
//

#import "JZPhotoFlowListAddItemCell.h"

@interface JZPhotoFlowListAddItemCell ()

@property (nonatomic, strong) UIImageView *photoImageView;

@end

@implementation JZPhotoFlowListAddItemCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createViewsHierarchy];
        [self layoutContentViews];
    }
    return self;
}

- (void)createViewsHierarchy {
    [self addSubview:self.photoImageView];
}

- (void)layoutContentViews {
    [self.photoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(8, 0, 0, 8));
    }];
}

#pragma mark - Getter

- (UIImageView *)photoImageView {
    if (!_photoImageView) {
        _photoImageView = [[UIImageView alloc] init];
        _photoImageView.image = [UIImage imageNamed:@"icon_camera_add_photo"];
    }
    return _photoImageView;
}

@end
