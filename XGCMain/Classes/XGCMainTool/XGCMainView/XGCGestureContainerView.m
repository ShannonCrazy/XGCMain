//
//  XGCGestureContainerView.m
//  XGCMain_Example
//
//  Created by 凌志 on 2024/5/13.
//  Copyright © 2024 ShannonCrazy. All rights reserved.
//

#import "XGCGestureContainerView.h"
//
#import "XGCConfiguration.h"

@interface XGCGestureCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView *imageView;
- (void)flashGestureIndicators;
@end

@implementation XGCGestureCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.imageView = ({
            UIImageView *imageView = [[UIImageView alloc] init];
            [self.contentView addSubview:imageView];
            imageView;
        });
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.center = self.contentView.center;
}
- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    self.imageView.image = [UIImage imageNamed:selected ? @"main_gesture_s" : @"main_gesture_n"];
}
- (void)flashGestureIndicators {
    self.imageView.image = [UIImage imageNamed:@"main_gesture_h"];
}
@end

@interface XGCGestureContainerView ()<UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>;
@property (nonatomic, assign) CGPoint point;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray <NSIndexPath *> *selecteds;
@end

@implementation XGCGestureContainerView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = UIColor.clearColor;
        //
        _itemSize = CGSizeMake(68.0, 68.0);
        _minimumLineSpacing = 30.0;
        _minimumInteritemSpacing = 30.0;
        // UI
        self.collectionView = ({
            UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
            layout.scrollDirection = UICollectionViewScrollDirectionVertical;
            
            UICollectionView *collection = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
            collection.delegate = self;
            collection.dataSource = self;
            collection.userInteractionEnabled = NO;
            collection.allowsMultipleSelection = YES;
            collection.backgroundColor = UIColor.clearColor;
            collection.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            [collection registerClass:[XGCGestureCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([XGCGestureCollectionViewCell class])];
            [self addSubview:collection];
            collection;
        });
        UIPanGestureRecognizer *gestureRecognizer = ({
            UIPanGestureRecognizer *gestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizer:)];
            gestureRecognizer;
        });
        [self addGestureRecognizer:gestureRecognizer];
        //
        self.selecteds = [NSMutableArray array];
    }
    return self;
}

#pragma mark - action
- (void)panGestureRecognizer:(UIPanGestureRecognizer *)gestureRecognizer {
    self.point = [gestureRecognizer locationInView:self];
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
        case UIGestureRecognizerStateChanged: {
            NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:self.point];
            if (indexPath) {
                [self.collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
                if (![self.selecteds containsObject:indexPath]) {
                    [self.selecteds addObject:indexPath];
                }
            }
            [self setNeedsDisplay];
        } break;
        case UIGestureRecognizerStateEnded: {
            NSMutableString *code = [[NSMutableString alloc] init];
            [self.selecteds enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [code appendFormat:@"%zd", obj.item + 1];
            }];
            self.didFinishDrawCodeAction ? self.didFinishDrawCodeAction(self, code) : nil;
        } break;
        default: {
        } break;
    }
}

#pragma mark set
- (void)setItemSize:(CGSize)itemSize {
    _itemSize = itemSize;
    [self.collectionView reloadData];
}

- (void)setMinimumLineSpacing:(CGFloat)minimumLineSpacing {
    _minimumLineSpacing = minimumLineSpacing;
    [self.collectionView reloadData];
}

- (void)setMinimumInteritemSpacing:(CGFloat)minimumInteritemSpacing {
    _minimumInteritemSpacing = minimumInteritemSpacing;
    [self.collectionView reloadData];
}

- (void)reset {
    [self.selecteds enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.collectionView deselectItemAtIndexPath:obj animated:NO];
    }];
    [self.selecteds removeAllObjects];
    self.point = CGPointZero;
    [self setNeedsDisplay];
}

- (void)flashGestureIndicators {
    [self.selecteds enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        XGCGestureCollectionViewCell *cell = (XGCGestureCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:obj];
        [cell flashGestureIndicators];
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self reset];
    });
}

#pragma mark - UICollectionViewDelegateFlowLayout, UICollectionViewDataSource
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.itemSize;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return self.minimumLineSpacing;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return self.minimumInteritemSpacing;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    CGFloat width = CGRectGetWidth(collectionView.frame) - self.itemSize.width * 3 - self.minimumLineSpacing * 2;
    CGFloat height = CGRectGetHeight(collectionView.frame) - self.itemSize.height * 3 - self.minimumInteritemSpacing * 2;
    return UIEdgeInsetsMake(height / 2.0, width / 2.0, height / 2.0, width / 2.0);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 9;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XGCGestureCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([XGCGestureCollectionViewCell class]) forIndexPath:indexPath];
    return cell;
}

- (void)drawRect:(CGRect)rect {
    if (isnan(rect.origin.x) || isnan(rect.origin.y)) {
        return;
    }
    UIBezierPath *path = [UIBezierPath bezierPath];
    [self.selecteds enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:obj];
        idx == 0 ? [path moveToPoint:cell.center] : [path addLineToPoint:cell.center];
    }];
    if (!path.isEmpty) {
        [path addLineToPoint:self.point];
    }
    [XGCCMI.blueColor set];
    path.lineJoinStyle = kCGLineJoinRound;
    path.lineWidth = 6;
    [path stroke];
}

@end
