//
//  LifeCollectionCell.m
//  UPOC_Teacher
//
//  Created by a on 2020/1/21.
//  Copyright © 2020 星梦. All rights reserved.
//

#import "JZPhotoFlowListItemCell.h"
#import <UIImageView+WebCache.h>

@interface JZPhotoFlowListItemCell ()

@property(nonatomic,strong)UIImageView *photoImageView;
@property(nonatomic,strong)UIButton *deleteButton;

@end

@implementation JZPhotoFlowListItemCell

- (instancetype)init {
    self = [super init];
    if (self) {
        [self createViewsHierarchy];
        [self layoutContentViews];
    }
    return self;
}

- (void)createViewsHierarchy {
    [self addSubview:self.photoImageView];
    [self addSubview:self.deleteButton];
}

- (void)layoutContentViews {
    [self.photoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.mas_equalTo(self);
        make.top.mas_equalTo(8);
        make.right.mas_equalTo(-8);
    }];
    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(20);
        make.top.mas_equalTo(self.photoImageView.mas_top).offset(-8);
        make.right.mas_equalTo(self.photoImageView.mas_right).offset(8);
    }];
}

- (void)setItemModel:(id<JZPhotoFlowListModelProtocol>)itemModel {
    _itemModel = itemModel;
    
    if (_itemModel.photoImage) {
        self.photoImageView.image = _itemModel.photoImage;
    } else {
        [self.photoImageView sd_setImageWithURL:[NSURL URLWithString:_itemModel.imageURL] placeholderImage:[UIImage imageNamed:@"icon_photoalbum_placeholder"]];
    }
}

#pragma mark - Action

- (void)deletePhotoAction {
    if (_delegate && [_delegate respondsToSelector:@selector(deletePhotoWithPhotoFlowListItemCell:)]) {
        [_delegate deletePhotoWithPhotoFlowListItemCell:self];
    }
}

#pragma mark - Getter

- (UIImageView *)photoImageView {
    if (!_photoImageView) {
        _photoImageView = [[UIImageView alloc] init];
        _photoImageView.layer.cornerRadius = 5;
        _photoImageView.layer.masksToBounds = YES;
        _photoImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _photoImageView;
}

- (UIButton *)deleteButton {
    if (!_deleteButton) {
        _deleteButton = [[UIButton alloc] init];
        [_deleteButton setImage:[UIImage imageNamed:@"icon_photoalbum_placeholder"] forState:UIControlStateNormal];
        [_deleteButton addTarget:self action:@selector(deletePhotoAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteButton;
}

@end
