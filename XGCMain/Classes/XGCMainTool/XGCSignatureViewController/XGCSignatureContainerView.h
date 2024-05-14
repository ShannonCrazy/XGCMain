//
//  XGCSignatureContainerView.h
//  XGCMain_Example
//
//  Created by 凌志 on 2024/5/13.
//  Copyright © 2024 ShannonCrazy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XGCSignatureContainerView : UIView
/// 清空
- (void)clean;
/// 是否空白
@property (nonatomic, assign, readonly, getter=isEmpty) BOOL empty;
/// 截屏
@property (nonatomic, strong, readonly, nullable) UIImage *image;
@end

NS_ASSUME_NONNULL_END
