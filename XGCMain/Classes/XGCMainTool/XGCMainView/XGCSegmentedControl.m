//
//  XGCSegmentedControl.m
//  XGCMain_Example
//
//  Created by 凌志 on 2024/5/13.
//  Copyright © 2024 ShannonCrazy. All rights reserved.
//

#import "XGCSegmentedControl.h"

@interface XGCMainSegmentedCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) UILabel *textLabel;
@end

@interface XGCSegmentedControl ()<UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>
/// 当前选中的
@property (nonatomic, assign, readwrite) NSInteger selectedSegmentIndex;
@property (nonatomic, assign) BOOL animated;
@property (nonatomic, assign) CGFloat spacing;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIView *indicator;
@end

@implementation XGCSegmentedControl

- (instancetype)init {
    if (self = [super init]) {
        _font = [UIFont systemFontOfSize:15];
        _textColor = UIColor.blackColor;
        _highlightedTextColor = UIColor.blueColor;
        _indicatorColor = UIColor.blueColor;
        
        self.collectionView = ({
            UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
            layout.minimumLineSpacing = layout.minimumInteritemSpacing = 0;
            layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
            
            UICollectionView *collection = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
            collection.delegate = self;
            collection.dataSource = self;
            collection.showsHorizontalScrollIndicator = NO;
            collection.backgroundColor = UIColor.clearColor;
            [collection registerClass:[XGCMainSegmentedCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([XGCMainSegmentedCollectionViewCell class])];
            [self addSubview:collection];
            collection;
        });
        
        self.indicator = ({
            UIView *view = [[UIView alloc] init];
            view.backgroundColor = self.indicatorColor;
            view.layer.cornerRadius = 2.0;
            [self.collectionView insertSubview:view atIndex:0];
            view;
        });
        
        self.contentInset = UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0);
    }
    return self;
}

- (void)setFont:(UIFont *)font {
    _font = font;
    [self reloadData];
}

- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    [self reloadData];
}

- (void)setHighlightedTextColor:(UIColor *)highlightedTextColor {
    _highlightedTextColor = highlightedTextColor;
    [self reloadData];
}

- (void)setIndicatorColor:(UIColor *)indicatorColor {
    _indicatorColor = indicatorColor;
    self.indicator.backgroundColor = _indicatorColor;
}

- (void)setContentInset:(UIEdgeInsets)contentInset {
    _contentInset = contentInset;
    self.collectionView.contentInset = UIEdgeInsetsMake(0, _contentInset.left, 0, _contentInset.right);
    [self reloadData];
}

#pragma mark lifcy
- (void)layoutSubviews {
    [super layoutSubviews];
    self.collectionView.frame = self.bounds;
}

- (void)updateConstraints {
    [super updateConstraints];
    [self reloadData];
}

- (CGSize)intrinsicContentSize {
    CGSize size = [super intrinsicContentSize];
    return CGSizeMake(size.width, self.contentInset.top + self.contentInset.bottom + self.font.lineHeight);
}

- (void)drawRect:(CGRect)rect {
    NSInteger numberOfItemsInSection = self.numberOfItemsInSegmented ? self.numberOfItemsInSegmented(self) : 0;
    if (numberOfItemsInSection <= 0) {
        return;
    }
    CGFloat width = self.contentInset.left + self.contentInset.right;
    for (NSInteger item = 0; item < numberOfItemsInSection; item++) {
        NSString *title = self.titleForSegmentedInItem ? self.titleForSegmentedInItem(self, item) : @"";
        width += [title sizeWithAttributes:@{NSFontAttributeName : self.font}].width + self.minimumSpacing * 2;
    }
    CGFloat difference = rect.size.width - width;
    self.spacing = difference > 0 ? self.minimumSpacing + (difference / numberOfItemsInSection / 2.0) : self.minimumSpacing;
    [self.collectionView reloadData];
    [self setIndicatorSelection];
}

#pragma mark private
- (void)setIndicatorSelection {
    if (!self.superview || !self.window) {
        return;
    }
    if (self.selectedSegmentIndex < 0 || self.selectedSegmentIndex == NSNotFound) {
        return;
    }
    if (self.selectedSegmentIndex >= [self.collectionView numberOfItemsInSection:0]) {
        return;
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.selectedSegmentIndex inSection:0];
    // 选中
    [self.collectionView selectItemAtIndexPath:indexPath animated:self.animated scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    // 移动指示条
    UICollectionViewLayoutAttributes *attributes = [self.collectionView layoutAttributesForItemAtIndexPath:indexPath];
    if (!attributes) {
        return;
    }
    void (^animations) (void) = ^(void) {
        CGFloat y = CGRectGetHeight(self.collectionView.frame) - 4.0;
        CGFloat width = CGRectGetWidth(attributes.frame) - self.spacing * 2;
        self.indicator.frame = CGRectMake(CGRectGetMinX(attributes.frame) + self.spacing, y, width, 4.0);
    };
    if (CGRectEqualToRect(self.indicator.frame, CGRectZero) || !self.animated) {
        [UIView performWithoutAnimation:animations];
    } else {
        [UIView animateWithDuration:0.25 animations:animations];
    }
}

#pragma mark public
- (void)reloadData {
    [self invalidateIntrinsicContentSize];
    [self setNeedsLayout];
    [self.collectionView reloadData];
    [self setNeedsDisplay];
    [self.superview setNeedsUpdateConstraints];
}

- (void)setSelectedSegmentIndex:(NSInteger)selectedSegmentIndex animated:(BOOL)animated {
    if (self.selectedSegmentIndex == selectedSegmentIndex) {
        return;
    }
    self.selectedSegmentIndex = selectedSegmentIndex;
    self.animated = animated;
    [self setIndicatorSelection];
}

#pragma mark - <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *title = self.titleForSegmentedInItem ? self.titleForSegmentedInItem(self, indexPath.item) : @"";
    CGSize size = [title sizeWithAttributes:@{NSFontAttributeName : self.font}];
    return CGSizeMake(size.width + self.spacing * 2, size.height + self.contentInset.top + self.contentInset.bottom);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.animated = YES;
    self.selectedSegmentIndex = indexPath.item;
    [self setIndicatorSelection];
    self.didSelectItemInSegmented ? self.didSelectItemInSegmented(self, indexPath.item) : nil;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.numberOfItemsInSegmented ? self.numberOfItemsInSegmented(self) : 0;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XGCMainSegmentedCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([XGCMainSegmentedCollectionViewCell class]) forIndexPath:indexPath];
    cell.textLabel.font = self.font;
    cell.textLabel.textColor = self.textColor;
    cell.textLabel.highlightedTextColor = self.highlightedTextColor;
    cell.textLabel.text = self.titleForSegmentedInItem ? self.titleForSegmentedInItem(self, indexPath.item) : @"";
    return cell;
}

@end

@implementation XGCMainSegmentedCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.textLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.textAlignment = NSTextAlignmentCenter;
            [self.contentView addSubview:label];
            label;
        });
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.textLabel.frame = self.contentView.bounds;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    self.textLabel.highlighted = selected;
}

@end
