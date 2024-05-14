//
//  XGCSubscriptView.h
//  XGCMain_Example
//
//  Created by 凌志 on 2024/5/13.
//  Copyright © 2024 ShannonCrazy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XGCSubscriptView : UIView
/// 角标颜色
@property (nonatomic, strong) IBInspectable UIColor *fillColor;
/// 文字
@property (nonatomic, copy) IBInspectable NSString *text;
/// 字体大小 默认 8
@property (nonatomic, strong) IBInspectable UIFont *font;
/// X轴偏移量 default 19
@property (nonatomic, assign) IBInspectable CGFloat offset;
@end

NS_ASSUME_NONNULL_END
