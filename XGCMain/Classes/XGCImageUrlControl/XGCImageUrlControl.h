//
//  XGCImageUrlControl.h
//  xinggc
//
//  Created by 凌志 on 2023/12/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XGCImageUrlControl : UIControl
/// 配置图片
/// - Parameters:
///   - URL: 图片链接
///   - placeholder: 文字(自动截取最后两位)
- (void)setImageWithURL:(nullable NSURL *)url placeholder:(nullable NSString *)placeholder;
/// 配置图片
/// - Parameters:
///   - URL: 图片链接
///   - placeholder: 文字
///   - fillColor: 填充色
///   - foregroundColor: 字体颜色
- (void)setImageWithURL:(nullable NSURL *)url placeholder:(nullable NSString *)placeholder fillColor:(UIColor *)fillColor foregroundColor:(UIColor *)foregroundColor;
/// 图片控件
@property (nonatomic, strong, readonly) UIImageView *imageView;
@end

NS_ASSUME_NONNULL_END
