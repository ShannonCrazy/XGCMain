//
//  XGCQRCodeControl.h
//  XGCMain_Example
//
//  Created by 凌志 on 2024/5/13.
//  Copyright © 2024 ShannonCrazy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XGCQRCodeControl : UIControl
/// 图片
@property (nonatomic, strong, readonly) UIImageView *imageView;
/// 二维码信息
@property (nonatomic, copy) NSString* messageString;
/// 二维码前景色
@property (nonatomic, strong) UIColor *QRCodeForegroundColor;
/// 二维码背景色
@property (nonatomic, strong) UIColor *QRCodeBackgroundColor;
@end

NS_ASSUME_NONNULL_END
