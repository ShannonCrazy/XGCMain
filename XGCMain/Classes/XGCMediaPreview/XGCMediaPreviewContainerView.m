//
//  XGCMediaPreviewContainerView.m
//  XGCMain_Example
//
//  Created by 凌志 on 2024/4/22.
//  Copyright © 2024 ShannonCrazy. All rights reserved.
//

#import "XGCMediaPreviewContainerView.h"
// cell
#import "XGCMediaPreviewCollectionViewCell.h"
//
#import <Masonry/Masonry.h>
//
#import "XGCMainRoute.h"
#import "NSArray+XGCArray.h"
#import "NSString+XGCString.h"
//
#import "XGCMainPickerManager.h"

@interface XGCMediaPreviewContainerView ()<UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) XGCMediaPreviewModel *addFileJson;
@property (nonatomic, strong) XGCMainPickerManager *pickerManager;
@property (nonatomic, strong) XGCMediaPreviewModel *original;
@end

@implementation XGCMediaPreviewContainerView

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = UIColor.clearColor;
        
        self.layout = ({
            UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
            layout.minimumLineSpacing = 10.0;
            layout.minimumInteritemSpacing = 0;
            layout.itemSize = CGSizeMake(80.0, 80.0);
            layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
            layout;
        });
        
        self.collectionView = ({
            UICollectionView *collection = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layout];
            collection.delegate = self;
            collection.dataSource = self;
            collection.showsHorizontalScrollIndicator = NO;
            collection.backgroundColor = UIColor.clearColor;
            collection.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            [collection registerClass:[XGCMediaPreviewCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([XGCMediaPreviewCollectionViewCell class])];
            [self addSubview:collection];
            [collection mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.top.mas_equalTo(self);
                make.height.mas_equalTo(self.layout.itemSize.height);
            }];
            collection;
        });
        
        self.addFileJson = ({
            XGCMediaPreviewModel *media = [XGCMediaPreviewModel image:[UIImage imageNamed:@"main_add"] filePathURL:nil fileName:nil suffix:nil];
            media;
        });
    }
    return self;
}

#pragma mark system
- (void)updateConstraints {
    [super updateConstraints];
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.collectionView);
    }];
}

#pragma mark set
- (void)setFileJsons:(NSMutableArray <XGCMediaPreviewModel *> *)fileJsons {
    _fileJsons = fileJsons;
    [self.collectionView reloadData];
}

- (void)setContentInset:(UIEdgeInsets)contentInset {
    _contentInset = contentInset;
    self.collectionView.contentInset = _contentInset;
    // 约束
    CGFloat height = self.layout.itemSize.height + _contentInset.top + _contentInset.bottom;
    [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height);
    }];
    // 通知更改约束
    [self setNeedsUpdateConstraints];
    // 刷新
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.fileJsons.count + (self.isEditable ? 1 : 0);
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XGCMediaPreviewCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([XGCMediaPreviewCollectionViewCell class]) forIndexPath:indexPath];
    if (indexPath.item < self.fileJsons.count) {
        [cell setModel:self.fileJsons[indexPath.item] editable:self.editable];
    } else {
        [cell setModel:self.addFileJson editable:NO];
    }
    __weak typeof(self) this = self;
    cell.detailButonTouchUpInsideAction = ^(XGCMediaPreviewCollectionViewCell * _Nonnull cell, XGCMediaPreviewModel * _Nonnull model) {
        [this mediaPreviewAction:model sourceView:cell.fileUrlImageView];
    };
    cell.replaceButtonTouchUpInsideAction = ^(XGCMediaPreviewCollectionViewCell * _Nonnull cell, XGCMediaPreviewModel * _Nonnull model) {
        [this mediaOperationAction:model maxFilesCount:1 sourceView:cell.fileUrlImageView];
    };
    cell.deleteButtonTouchUpInsideAction = ^(XGCMediaPreviewCollectionViewCell * _Nonnull cell, XGCMediaPreviewModel * _Nonnull model) {
        [this.fileJsons removeObject:model];
        [this.collectionView reloadData];
    };
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    XGCMediaPreviewCollectionViewCell *cell = (XGCMediaPreviewCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (indexPath.item >= self.fileJsons.count) {
        [self mediaOperationAction:nil maxFilesCount:NSUIntegerMax sourceView:cell.fileUrlImageView];
    } else  {
        if (self.editable) {
            return;
        }
        [self mediaPreviewAction:self.fileJsons[indexPath.item] sourceView:cell.fileUrlImageView];
    }
}

- (void)mediaOperationAction:(nullable XGCMediaPreviewModel *)original maxFilesCount:(NSUInteger)maxFilesCount sourceView:(__kindof UIView *)sourceView {
    self.original = original;
    if (!self.pickerManager) {
        self.pickerManager = [[XGCMainPickerManager alloc] init];
    }
    self.pickerManager.sourceView = sourceView.superview;
    self.pickerManager.sourceRect = sourceView.frame;
    self.pickerManager.maxFilesCount = maxFilesCount;
    __weak typeof(self) this = self;
    self.pickerManager.didFinishPickingPhotosWithInfosHandle = ^(NSArray <UIImage *> * _Nonnull photos, NSArray <NSDictionary *> * _Nonnull infos) {
        __block NSMutableArray <XGCMediaPreviewModel *> *inserts = [NSMutableArray array];
        [photos enumerateObjectsUsingBlock:^(UIImage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [inserts addObject:[XGCMediaPreviewModel image:obj filePathURL:nil fileName:nil suffix:nil]];
        }];
        [this addObjectsFromArray:inserts];
    };
    self.pickerManager.didPickDocumentsAtURLs = ^(NSArray<NSURL *> * _Nonnull urls) {
        __block NSMutableArray <XGCMediaPreviewModel *> *inserts = [NSMutableArray array];
        [urls enumerateObjectsUsingBlock:^(NSURL * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [inserts addObject:[XGCMediaPreviewModel image:nil filePathURL:obj fileName:nil suffix:nil]];
        }];
        [this addObjectsFromArray:inserts];
    };
    [self.pickerManager presentFromViewController:self.aTarget];
}

- (void)mediaPreviewAction:(XGCMediaPreviewModel *)model sourceView:(__kindof UIView *)sourceView {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:model forKey:@"fileJson"];
    [parameters setObject:self.fileJsons forKey:@"fileJsons"];
    [parameters setObject:sourceView forKey:@"sourceView"];
    [XGCMainRoute routeURL:[NSURL URLWithString:@"xinggc://XGCMediaPreview"] withParameters:parameters];
}

- (void)addObjectsFromArray:(NSMutableArray <XGCMediaPreviewModel *> *)otherArray; {
    if (self.original) {
        [self.fileJsons replaceObjectIn:self.original withObject:otherArray.firstObject];
    } else {
        [self.fileJsons addObjectsFromArray:otherArray];
    }
    [self.collectionView reloadData];
    // 清空
    self.original = nil;
}

@end
