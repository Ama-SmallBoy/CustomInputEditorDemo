//
//  LifeCollectionView.m
//  UPOC_Teacher
//
//  Created by a on 2020/1/21.
//  Copyright © 2020 星梦. All rights reserved.
//

#import "JZPhotoFlowListView.h"
#import "JZPhotoFlowListItemCell.h"
#import "JZPhotoFlowListAddItemCell.h"

static CGFloat const itemHeight = 104;
static CGFloat const lineSpacing = 12;
static NSString *ListItemReuseIdentifierID = @"JZPhotoFlowListItemCell";
static NSString *ListAddItemReuseIdentifierID = @"JZPhotoFlowListAddItemCell";

@interface JZPhotoFlowListView () <JZPhotoFlowListItemCellDelegate, UICollectionViewDelegate, UICollectionViewDataSource>

@property(nonatomic, strong)UICollectionView *collectionView;
@property (nonatomic, copy) NSArray <id<JZPhotoFlowListModelProtocol>> *dataArray;
@property (nonatomic, assign) NSUInteger numberOfItems;
@property (nonatomic, assign, readwrite) CGFloat listViewHeight;

@end

@implementation JZPhotoFlowListView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self commitInit];
        [self createViewsHierarchy];
        [self layoutContentViews];
    }
    return self;
}

- (void)commitInit {
    self.maxPhotoLimit = 9;
}

- (void)createViewsHierarchy {
    [self addSubview:self.collectionView];
}

- (void)layoutContentViews {
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.mas_equalTo(itemHeight);
    }];
}

#pragma mark - reloadData
- (void)reloadData {
    self.dataArray = [self.dataSource photoFlowListViewDataSource];
    
    [self layoutCollectionView];
    
    if ([self.delegate respondsToSelector:@selector(photoFlowListViewLayoutDidUpdate:)]) {
        [self.delegate photoFlowListViewLayoutDidUpdate:self];
    }
    
    [self.collectionView reloadData];
}

#pragma mark - Private
- (void)layoutCollectionView {
    NSInteger count = self.numberOfItems;
    NSInteger row = count / 3 + (count % 3 ? 1 : 0);
    
    CGFloat viewHeight = itemHeight * row + (row ? (row - 1) * lineSpacing : 0);
    [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(viewHeight);
    }];
    self.listViewHeight = viewHeight;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.numberOfItems;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row >= self.dataArray.count) {
        JZPhotoFlowListAddItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ListAddItemReuseIdentifierID forIndexPath:indexPath];
        return cell;
    }
    
    JZPhotoFlowListItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ListItemReuseIdentifierID forIndexPath:indexPath];
    cell.delegate = self;
    NSArray *dataModel = [self.dataSource photoFlowListViewDataSource];
    cell.itemModel = [dataModel objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row >= self.dataArray.count) {
        if ([self.delegate respondsToSelector:@selector(photoFlowListViewAddPhoto:)]) {
            [self.delegate photoFlowListViewAddPhoto:self];
        }
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(photoFlowListView:didSelectItemAtIndex:)]) {
        [self.delegate photoFlowListView:self didSelectItemAtIndex:indexPath.row];
    }
}

#pragma mark - NEPhotoFlowListItemCellDelegate
- (void)deletePhotoWithPhotoFlowListItemCell:(JZPhotoFlowListItemCell *)cell {
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    if (!indexPath) { return; }
    if ([self.delegate respondsToSelector:@selector(photoFlowListView:didDeleteItemAtIndex:)]) {
        [self.delegate photoFlowListView:self didDeleteItemAtIndex:indexPath.row];
    }
}

#pragma mark - Getter
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        CGSize itemSize = CGSizeMake(itemHeight, itemHeight);
        CGFloat width = CGRectGetWidth([UIScreen mainScreen].bounds);
//        CGFloat space = floor((width - itemSize.width*3) / 2);
        CGFloat space = floor((width - itemSize.width*3 - 16*2) / 2);
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = lineSpacing;
        layout.minimumInteritemSpacing = space;
        layout.itemSize = itemSize;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.scrollEnabled = NO;
        _collectionView.pagingEnabled = YES;
        _collectionView.directionalLockEnabled = YES;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[JZPhotoFlowListItemCell class] forCellWithReuseIdentifier:ListItemReuseIdentifierID];
        [_collectionView registerClass:[JZPhotoFlowListAddItemCell class] forCellWithReuseIdentifier:ListAddItemReuseIdentifierID];
    }
    return _collectionView;
}

- (NSUInteger)numberOfItems {
    return MIN(self.dataArray.count + 1, self.maxPhotoLimit);
}

@end
