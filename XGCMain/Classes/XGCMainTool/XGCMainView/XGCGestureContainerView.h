//
//  XGCGestureContainerView.h
//  XGCMain_Example
//
//  Created by 凌志 on 2024/5/13.
//  Copyright © 2024 ShannonCrazy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XGCGestureContainerView : UIView
/// default CGSizeMake(68.0 68.0);
@property (nonatomic, assign) CGSize itemSize;
/// default 30.0
@property (nonatomic, assign) CGFloat minimumLineSpacing;
/// default 30.0
@property (nonatomic, assign) CGFloat minimumInteritemSpacing;
/// 完成绘制手势密码
@property (nonatomic, copy) void(^didFinishDrawCodeAction)(XGCGestureContainerView *containerView, NSString *code);
/// 充值
- (void)reset;
/// 闪烁当前选中的节点
- (void)flashGestureIndicators;
@end

NS_ASSUME_NONNULL_END
