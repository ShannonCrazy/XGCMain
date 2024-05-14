//
//  XGCMediaPreviewModel.h
//  XGCMain_Example
//
//  Created by 凌志 on 2024/4/22.
//  Copyright © 2024 ShannonCrazy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XGCMediaPreviewModel : NSObject
/// 文件地址
@property (nonatomic, copy, nullable) NSString *fileUrl;
/// 文件名
@property (nonatomic, copy) NSString *fileName;
/// 后缀
@property (nonatomic, copy) NSString *suffix;
/// 图像
@property (nonatomic, strong, nullable) UIImage *image;
/// 本地文件路径
@property (nonatomic, strong, nullable) NSURL *filePathURL;
/// 创建时间
@property (nonatomic, copy) NSString *creTime;

/// 快捷创建
/// - Parameters:
///   - image: 图片对象
///   - filePathURL: 本地路径
///   - fileName: 文件名
///   - suffix: 后缀
+ (instancetype)image:(nullable UIImage *)image filePathURL:(nullable NSURL *)filePathURL fileName:(nullable NSString *)fileName suffix:(nullable NSString *)suffix;

/// 快捷创建
/// - Parameters:
///   - fileUrl: 网络地址
///   - suffix: 后缀
+ (instancetype)fileUrl:(NSString *)fileUrl suffix:(nullable NSString *)suffix;
@end

NS_ASSUME_NONNULL_END
