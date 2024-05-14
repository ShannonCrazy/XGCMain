//
//  XGCCataloguesView.m
//  XGCMain_Example
//
//  Created by 凌志 on 2024/5/13.
//  Copyright © 2024 ShannonCrazy. All rights reserved.
//

#import "XGCCataloguesView.h"
//
#import <Masonry/Masonry.h>
//
#import "XGCConfiguration.h"

@interface SSCataloguesCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UIImageView *imageView;
@end

@interface XGCCataloguesView ()<UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, readonly) NSInteger numberOfItems;
@end

@implementation XGCCataloguesView

- (instancetype)init {
    if (self = [super init]) {
        _font = [UIFont systemFontOfSize:13];
        self.collectionView = ({
            UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
            layout.minimumLineSpacing = 0;
            layout.minimumInteritemSpacing = 10.0;
            layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
            
            UICollectionView *collection = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
            collection.delegate = self;
            collection.dataSource = self;
            collection.showsHorizontalScrollIndicator = NO;
            collection.backgroundColor = UIColor.clearColor;
            [collection registerClass:SSCataloguesCollectionViewCell.class forCellWithReuseIdentifier:NSStringFromClass(SSCataloguesCollectionViewCell.class)];
            collection.contentInset = UIEdgeInsetsMake(0, 20.0, 0, 20.0);
            [self addSubview:collection];
            [collection mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(40.0);
                make.left.right.top.mas_equalTo(self);
            }];
            collection;
        });
    }
    return self;
}

- (void)reloadData {
    [self.collectionView reloadData];
    if (self.numberOfItems == 0) {
        return;
    }
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.numberOfItems - 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionRight animated:YES];
}

- (void)updateConstraints {
    [super updateConstraints];
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.collectionView);
    }];
}


#pragma mark <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = [[self cTextLabelText:indexPath.item] sizeWithAttributes:[NSDictionary dictionaryWithObject:self.font forKey:NSFontAttributeName]].width;
    BOOL flag = indexPath.item == self.numberOfItems - 1;
    width += (flag ? 0 : 8.0 * 2);
    return CGSizeMake(width, CGRectGetHeight(collectionView.frame));
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.numberOfItems;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SSCataloguesCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([SSCataloguesCollectionViewCell class]) forIndexPath:indexPath];
    cell.textLabel.font = self.font;
    cell.textLabel.text = [self cTextLabelText:indexPath.item];
    cell.textLabel.textColor = (indexPath.item == self.numberOfItems - 1) ? XGCCMI.labelColor : XGCCMI.blueColor;
    cell.imageView.hidden = indexPath.item == self.numberOfItems - 1;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item == self.numberOfItems - 1) {
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(cataloguesView:didSelectItem:)]) {
        [self.delegate cataloguesView:self didSelectItem:indexPath.item];
    }
}

#pragma mark delegate
- (NSString *)cTextLabelText:(NSInteger)item {
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(cataloguesView:titleInItem:)]) {
        return [self.dataSource cataloguesView:self titleInItem:item];
    }
    return @"";
}

- (NSInteger)numberOfItems {
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(numberOfItemsInCataloguesView:)]) {
        return [self.dataSource numberOfItemsInCataloguesView:self];
    }
    return 0;
}

@end


@implementation SSCataloguesCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.textLabel = ({
            UILabel *label = [[UILabel alloc] init];
            [self.contentView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.top.bottom.mas_equalTo(self.contentView);
            }];
            label;
        });
        self.imageView = ({
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"main_arrow_blue_right"]];
            [self.contentView addSubview:imageView];
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.textLabel.mas_right).offset(8.0);
                make.centerY.mas_equalTo(self.contentView);
            }];
            imageView;
        });
        self.contentView.layer.masksToBounds = YES;
    }
    return self;
}

@end
