//
//  XGCFileJsonViewController.m
//  XGCMain_Example
//
//  Created by 凌志 on 2024/5/13.
//  Copyright © 2024 ShannonCrazy. All rights reserved.
//

#import "XGCFileJsonViewController.h"
//
#import "XGCMainRoute.h"
#import "XGCMediaPreviewCollectionViewCell.h"

@interface XGCFileJsonViewController ()<UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>
/// 格视图
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation XGCFileJsonViewController

- (instancetype)init {
    if (self = [super init]) {
        self.columnNumber = 4;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView = ({
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 10.0;
        layout.minimumInteritemSpacing = 10.0;
        
        UICollectionView *collection = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        collection.delegate = self;
        collection.dataSource = self;
        collection.backgroundColor = UIColor.clearColor;
        collection.contentInset = UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0);
        [collection registerClass:[XGCMediaPreviewCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([XGCMediaPreviewCollectionViewCell class])];
        [self.view addSubview:collection];
        collection;
    });
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.collectionView.frame = self.view.bounds;
}

- (void)setColumnNumber:(NSInteger)columnNumber {
    _columnNumber = columnNumber;
    if (columnNumber <= 2) {
        _columnNumber = 2;
    } else if (columnNumber >= 6) {
        _columnNumber = 6;
    }
    if (!self.isViewLoaded) {
        return;
    }
    [self.collectionView reloadData];
}

- (void)setFileJson:(NSMutableArray<XGCMediaPreviewModel *> *)fileJson {
    _fileJson = fileJson;
    if (!self.isViewLoaded) {
        return;
    }
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDelegateFlowLayout, UICollectionViewDataSource
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)collectionViewLayout;
    CGFloat width = (CGRectGetWidth(collectionView.frame) - collectionView.contentInset.left - collectionView.contentInset.right - (self.columnNumber - 1) * layout.minimumLineSpacing) / self.columnNumber;
    return CGSizeMake(width, width);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.fileJson.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XGCMediaPreviewModel *item = self.fileJson[indexPath.item];
    XGCMediaPreviewCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([XGCMediaPreviewCollectionViewCell class]) forIndexPath:indexPath];
    [cell setModel:item editable:NO];
    __weak typeof(self) this = self;
    cell.detailButonTouchUpInsideAction = ^(XGCMediaPreviewCollectionViewCell * _Nonnull cell, XGCMediaPreviewModel * _Nonnull model) {
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        [parameters setObject:model forKey:@"fileJson"];
        [parameters setObject:this.fileJson forKey:@"fileJsons"];
        [parameters setObject:cell.fileUrlImageView forKey:@"sourceView"];
        [XGCMainRoute routeURL:[NSURL URLWithString:@"xinggc://XGCMediaPreview"] withParameters:parameters method:@"present" animated:NO];
    };
    return cell;
}

@end
