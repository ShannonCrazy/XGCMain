//
//  XGCToolBarContainerView.m
//  XGCMain_Example
//
//  Created by 凌志 on 2024/5/13.
//  Copyright © 2024 ShannonCrazy. All rights reserved.
//

#import "XGCToolBarContainerView.h"
//
#import "XGCConfiguration.h"
//
#import <Masonry/Masonry.h>

#pragma mark XGCToolBarModel
@interface XGCToolBarModel : NSObject
/// 标题
@property (nonatomic, copy) NSString *title;
/// 按钮颜色
@property (nonatomic, strong) UIColor *backgroundColor;
/// 对象
@property (nonatomic, weak, nullable) id target;
/// 事件
@property (nonatomic, assign, nullable) SEL action;

+ (instancetype)title:(NSString *)title backgroundColor:(UIColor *)backgroundColor target:(nullable id)target action:(nullable SEL)action;
@end

@implementation XGCToolBarModel

+ (instancetype)title:(NSString *)title backgroundColor:(UIColor *)backgroundColor target:(id)target action:(SEL)action {
    XGCToolBarModel *model = [[XGCToolBarModel alloc] init];
    model.title = title;
    model.backgroundColor = backgroundColor;
    model.target = target;
    model.action = action;
    return model;
}

@end

#pragma mark XGCToolBarCollectionViewCell
@interface XGCToolBarCollectionViewCell : UICollectionViewCell
/// 内容
@property (nonatomic, strong) UIView *containerView;
/// 文本
@property (nonatomic, strong) UILabel *cTextLabel;
@end

@implementation XGCToolBarCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.containerView = ({
            UIView *view = [[UIView alloc] init];
            view.layer.cornerRadius = 5.0;
            [self.contentView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(self.contentView);
            }];
            view;
        });
        self.cTextLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.numberOfLines = 0;
            label.textColor = XGCCMI.whiteColor;
            label.font = [UIFont systemFontOfSize:16];
            label.textAlignment = NSTextAlignmentCenter;
            [self.containerView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(self.containerView);
            }];
            label;
        });
    }
    return self;
}

@end

@interface XGCToolBarContainerView ()<UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>
/// 格视图
@property (nonatomic, strong) UICollectionView *collectionView;
/// 数据
@property (nonatomic, strong) NSMutableArray <XGCToolBarModel *> *lists;
@end

@implementation XGCToolBarContainerView

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = XGCCMI.whiteColor;
        self.lists = [NSMutableArray array];
        self.collectionView = ({
            UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
            layout.minimumLineSpacing = 10.0;
            layout.minimumInteritemSpacing = 0;
            layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
            
            UICollectionView *collection = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
            collection.delegate = self;
            collection.dataSource = self;
            collection.backgroundColor = UIColor.clearColor;
            collection.contentInset = UIEdgeInsetsMake(4.0, 20.0, 4.0, 20.0);
            [collection registerClass:[XGCToolBarCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([XGCToolBarCollectionViewCell class])];
            [self addSubview:collection];
            [collection mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.top.mas_equalTo(self);
                make.height.mas_equalTo(48.0);
            }];
            collection ;
        });
    }
    return self;
}

- (void)reloadData {
    [self.collectionView reloadData];
}

- (void)removeAllObjects {
    [self.lists removeAllObjects];
}

- (void)setTitle:(NSString *)title backgroundColor:(UIColor *)backgroundColor target:(id)target action:(SEL)action {
    [self.lists addObject:[XGCToolBarModel title:title backgroundColor:backgroundColor target:target action:action]];
}

#pragma mark - <UICollectionViewDelegate, UICollectionViewDataSource>
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger count = self.lists.count;
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)collectionViewLayout;
    CGFloat width = CGRectGetWidth(collectionView.frame) - collectionView.contentInset.left - collectionView.contentInset.right - layout.minimumLineSpacing * (count - 1);
    return CGSizeMake(floor((width / count)), 40.0);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.lists.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XGCToolBarModel *item = self.lists[indexPath.item];
    XGCToolBarCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([XGCToolBarCollectionViewCell class]) forIndexPath:indexPath];
    cell.cTextLabel.text = item.title;
    cell.containerView.backgroundColor = item.backgroundColor;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    XGCToolBarModel *model = self.lists[indexPath.item];
    if (!model.target || !model.action) {
        return;
    }
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [model.target performSelector:model.action];
#pragma clang diagnostic pop
}

@end
