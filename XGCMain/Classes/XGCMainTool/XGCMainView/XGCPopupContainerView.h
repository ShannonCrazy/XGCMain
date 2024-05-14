//
//  XGCPopupContainerView.h
//  XGCMain_Example
//
//  Created by 凌志 on 2024/5/13.
//  Copyright © 2024 ShannonCrazy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XGCPopupContainerView : UIView
- (instancetype)init NS_UNAVAILABLE;
/// 放置控件的view
@property (nonatomic, strong) UIView *containerView;
/// 点击空白区域事件
- (void)backgroundControlTouchAction;
/// 动画移除事件
- (void)dismissAnimations;
@end

NS_ASSUME_NONNULL_END
