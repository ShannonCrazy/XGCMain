//
//  XGCSegmentedControl.h
//  XGCMain_Example
//
//  Created by 凌志 on 2024/5/13.
//  Copyright © 2024 ShannonCrazy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XGCSegmentedControl : UIView
/// 最小间隔
@property (nonatomic, assign) CGFloat minimumSpacing;
/// 缩进
@property (nonatomic, assign) UIEdgeInsets contentInset;
/// 字体大小
@property (nonatomic, strong) UIFont *font;
/// 文本颜色
@property (nonatomic, strong) UIColor *textColor;
/// 高亮颜色
@property (nonatomic, strong) UIColor *highlightedTextColor;
/// 指示器颜色
@property (nonatomic, strong) UIColor *indicatorColor;
/// 有多少个item
@property (nonatomic, copy) NSInteger(^numberOfItemsInSegmented)(XGCSegmentedControl *segmentedControl);
/// item显示的文字
@property (nonatomic, copy) NSString *(^titleForSegmentedInItem)(XGCSegmentedControl *segmentedControl, NSInteger item);
/// 点击事件
@property (nonatomic, copy) void(^didSelectItemInSegmented)(XGCSegmentedControl *segmentedControl, NSInteger item);
/// 刷新
- (void)reloadData;
/// 选中某条
/// - Parameters:
///   - selectedSegmentIndex: 指定位置
///   - animated: 是否要动画
- (void)setSelectedSegmentIndex:(NSInteger)selectedSegmentIndex animated:(BOOL)animated;
/// 当前选中的
@property (nonatomic, assign, readonly) NSInteger selectedSegmentIndex;
@end

NS_ASSUME_NONNULL_END
