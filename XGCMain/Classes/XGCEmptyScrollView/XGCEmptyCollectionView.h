//
//  XGCEmptyCollectionView.h
//  XGCMain_Example
//
//  Created by 凌志 on 2024/4/26.
//  Copyright © 2024 ShannonCrazy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XGCEmptyCollectionView : UICollectionView
/// 空白图片
@property (nonatomic, copy) UIImage *(^imageForEmptyDataSet)(UIScrollView *scrollView);
/// 空白文字
@property (nonatomic, copy) NSAttributedString *(^titleForEmptyDataSet)(UIScrollView *scrollView);
/// 空白图片和文字之间间距
@property (nonatomic, copy) CGFloat(^spaceHeightForEmptyDataSet) (UIScrollView *scrollView);
/// 是否要显示空白图片，默认NO
@property (nonatomic, copy) BOOL(^emptyDataSetShouldDisplay)(UIScrollView *scrollView);
/// 项目数量大于0时是否仍应显示空数据集，默认NO
@property (nonatomic, copy) BOOL(^emptyDataSetShouldBeForcedToDisplay)(UIScrollView *scrollView);
/// 空白页面将要出现回调
@property (nonatomic, copy) void(^emptyDataSetWillAppear)(UIScrollView *scrollView);
@end

NS_ASSUME_NONNULL_END
