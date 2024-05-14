//
//  XGCToolBarContainerView.h
//  XGCMain_Example
//
//  Created by 凌志 on 2024/5/13.
//  Copyright © 2024 ShannonCrazy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XGCToolBarContainerView : UIView
/// 标题
/// - Parameters:
///   - title: 标题
///   - backgroundColor: 背景色
///   - target: 对象
///   - action: 事件
- (void)setTitle:(NSString *)title backgroundColor:(UIColor *)backgroundColor target:(nullable id)target action:(nullable SEL)action;
/// 刷新
- (void)reloadData;
/// 移除全部
- (void)removeAllObjects;
@end

NS_ASSUME_NONNULL_END
