//
//  XGCEmptyCollectionView.m
//  XGCMain_Example
//
//  Created by 凌志 on 2024/4/26.
//  Copyright © 2024 ShannonCrazy. All rights reserved.
//

#import "XGCEmptyCollectionView.h"
// tool
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>

@interface XGCEmptyCollectionView ()<DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@end

@implementation XGCEmptyCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        self.emptyDataSetSource = self;
        self.emptyDataSetDelegate = self;
    }
    return self;
}

#pragma mark DZNEmptyDataSetSource, DZNEmptyDataSetDelegate
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return self.imageForEmptyDataSet ? self.imageForEmptyDataSet(scrollView) : [UIImage imageNamed:@"main_default"];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    return self.titleForEmptyDataSet ? self.titleForEmptyDataSet(scrollView) : nil;
}

- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView {
    return self.spaceHeightForEmptyDataSet ? self.spaceHeightForEmptyDataSet(scrollView) : 0;
}

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    return self.emptyDataSetShouldDisplay ? self.emptyDataSetShouldDisplay(scrollView) : YES;
}

- (BOOL)emptyDataSetShouldBeForcedToDisplay:(UIScrollView *)scrollView {
    return self.emptyDataSetShouldBeForcedToDisplay ? self.emptyDataSetShouldBeForcedToDisplay(scrollView) : NO;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}

- (void)emptyDataSetWillAppear:(UIScrollView *)scrollView {
    self.emptyDataSetWillAppear ? self.emptyDataSetWillAppear(scrollView) : nil;
}

@end
