//
//  XGCIconRouteViewController.m
//  XGCMain_Example
//
//  Created by 凌志 on 2024/5/13.
//  Copyright © 2024 ShannonCrazy. All rights reserved.
//

#import "XGCIconRouteViewController.h"
//
#import "XGCIconRoute.h"
#import "XGCUserManager.h"
#import "XGCConfiguration.h"
#import "XGCSegmentedControl.h"
#import "XGCEmptyCollectionView.h"
//
#import "XGCIconCollectionViewCell.h"
//
#import <Masonry/Masonry.h>

@interface XGCIconRouteViewController ()<UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>
/// 数据
@property (nonatomic, strong) XGCMenuDataModel *cMenuData;
/// 选项卡
@property (nonatomic, strong) XGCSegmentedControl *segmentedControl;
/// 格视图
@property (nonatomic, strong) XGCEmptyCollectionView *collectionView;
@end

@implementation XGCIconRouteViewController

- (instancetype)initWithParameters:(NSDictionary *)parameters {
    if (self = [super init]) {
        self.cMenuData = [XGCUM.cMenu cMenuData:@"cd_yingyong" cAppFuncCode:parameters[@"cAppFuncCode"] filter:YES];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.cMenuData.cName;
    MASViewAttribute *attribute = self.mas_topLayoutGuideBottom;
    BOOL flag = self.cMenuData.children.count > 1;
    if (flag) {
        self.segmentedControl = ({
            XGCSegmentedControl *control = [[XGCSegmentedControl alloc] init];
            control.minimumSpacing = 12.0;
            control.backgroundColor = UIColor.whiteColor;
            control.textColor = XGCCMI.tertiaryLabelColor;
            control.highlightedTextColor = XGCCMI.labelColor;
            control.indicatorColor = XGCCMI.blueColor;
            __weak typeof(self) this = self;
            control.numberOfItemsInSegmented = ^NSInteger(XGCSegmentedControl * _Nonnull segmentedControl) {
                return this.cMenuData.children.count;
            };
            control.titleForSegmentedInItem = ^NSString * _Nonnull(XGCSegmentedControl * _Nonnull segmentedControl, NSInteger item) {
                return this.cMenuData.children[item].cName;
            };
            control.didSelectItemInSegmented = ^(XGCSegmentedControl * _Nonnull segmentedControl, NSInteger item) {
                [this.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:item] animated:YES scrollPosition:UICollectionViewScrollPositionTop];
            };
            [self.view addSubview:control];
            [control mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(self.view);
                make.top.mas_equalTo(self.mas_topLayoutGuideBottom);
            }];
            control;
        });
        [self.segmentedControl setSelectedSegmentIndex:0 animated:NO];
        attribute = self.segmentedControl.mas_bottom;
    }
    self.collectionView = ({
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = layout.minimumInteritemSpacing = 0;
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 10.0, 0);
        
        XGCEmptyCollectionView *collection = [[XGCEmptyCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        collection.delegate = self;
        collection.dataSource = self;
        collection.backgroundColor = UIColor.whiteColor;
        [collection registerClass:[XGCIconCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([XGCIconCollectionViewCell class])];
        [collection registerClass:[XGCIconReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([XGCIconReusableView class])];
        [collection registerClass:[XGCIconReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:NSStringFromClass([XGCIconReusableView class])];
        [self.view addSubview:collection];
        [collection mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(attribute).offset(flag ? 0 : 1.0);
            make.left.right.bottom.mas_equalTo(self.view);
        }];
        collection;
    });
}

#pragma mark UICollectionViewDelegateFlowLayout, UICollectionViewDataSource
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)collectionViewLayout;
    CGFloat width = CGRectGetWidth(collectionView.frame) - collectionView.contentInset.left - collectionView.contentInset.right - layout.sectionInset.left - layout.sectionInset.right;
    return CGSizeMake(floor(width / 5.0), XGCIconCollectionViewCell.height);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(CGRectGetWidth(collectionView.frame), 10.0 * 2 + [UIFont boldSystemFontOfSize:16].lineHeight);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return section < self.cMenuData.children.count - 1 ? CGSizeMake(CGRectGetWidth(collectionView.frame), 10.0) : CGSizeZero;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    BOOL flag = [kind isEqualToString:UICollectionElementKindSectionHeader];
    NSString *identifier = NSStringFromClass([XGCIconReusableView class]);
    XGCIconReusableView *reusableView  = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:identifier forIndexPath:indexPath];
    reusableView.cName.text = flag ? self.cMenuData.children[indexPath.section].cName : nil;
    reusableView.backgroundColor = flag ? UIColor.whiteColor : XGCCMI.backgroundColor;
    return reusableView;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.cMenuData.children.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.cMenuData.children[section].children.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XGCMenuDataModel *item = self.cMenuData.children[indexPath.section].children[indexPath.item];
    XGCIconCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([XGCIconCollectionViewCell class]) forIndexPath:indexPath];
    cell.cName.text = item.cName;
    cell.badgeValue = item.badgeValue;
    cell.cImageUrl.image = [UIImage imageNamed:item.cAppFuncCode] ?: [UIImage imageNamed:@"main_icon_default"];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    XGCMenuDataModel *row = self.cMenuData.children[indexPath.section].children[indexPath.row];
    if (row.children.count > 0) {
        [XGCMainRoute routeURL:[NSURL URLWithString:@"xinggc://XGCApplication"] withParameters:@{@"cAppFuncCode" : row.cAppFuncCode}];
    } else {
        [XGCMainRoute routeURL:[NSURL URLWithString:[NSString stringWithFormat:@"xinggc://%@", row.cAppFuncCode]]];
    }
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!scrollView.isDragging && !scrollView.isDecelerating) {
        return;
    }
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:CGPointMake(0, scrollView.contentOffset.y)];
    if (!indexPath) {
        return;
    }
    [self.segmentedControl setSelectedSegmentIndex:indexPath.section animated:YES];
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
    [self.segmentedControl setSelectedSegmentIndex:0 animated:YES];
    return YES;
}

@end
