//
//  XGCDashPatternView.h
//  XGCMain_Example
//
//  Created by 凌志 on 2024/5/13.
//  Copyright © 2024 ShannonCrazy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XGCDashPatternView : UIView
/// 线条颜色， 默认nil 使用 groupTableViewBackgroundColor
@property (nonatomic, strong, nullable) UIColor *strokeColor;
/// 虚线样式，默认nil 使用 @[@3, @1]
@property (nonatomic, copy, nullable) NSArray <NSNumber *> *lineDashPattern;
@end

NS_ASSUME_NONNULL_END
