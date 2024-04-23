//
//  KSPhotoBrowserManager.h
//  Star
//
//  Created by 凌志 on 2021/5/6.
//  Copyright © 2021 Pingtan Jiutian Network Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "KSPhotoBrowser.h"
#import "KSPhotoBrowser.h"

NS_ASSUME_NONNULL_BEGIN

@interface KSPhotoBrowserManager : NSObject

/// 快捷创建
/// @param photoItems 数据，默认从第一个位置展示出来
+ (nullable KSPhotoBrowser *)browserWithPhotoItems:(NSArray<KSPhotoItem *> *)photoItems;

/// 快捷创建
/// @param photoItems 数据
/// @param imageUrl 默认展示的图片地址
+ (nullable KSPhotoBrowser *)browserWithPhotoItems:(NSArray<KSPhotoItem *> *)photoItems imageUrl:(NSString *)imageUrl;

/// 快捷创建
/// @param photoItems 数据
/// @param image 默认展示的图片对象
+ (nullable KSPhotoBrowser *)browserWithPhotoItems:(NSArray<KSPhotoItem *> *)photoItems image:(UIImage *)image;

/// 快捷创建
/// @param photoItems 数据
/// @param content 图片对象
+ (nullable KSPhotoBrowser *)browserWithPhotoItems:(NSArray<KSPhotoItem *> *)photoItems content:(id)content;

/// 快捷创建浏览器，配置基础数据
/// @param photoItems 元素
/// @param imageUrl 默认图片地址，可选
/// @param image 默认图片对象，可选
+ (nullable KSPhotoBrowser *)browserWithPhotoItems:(NSArray<KSPhotoItem *> *)photoItems imageUrl:(nullable NSString *)imageUrl image:(nullable UIImage *)image content:(nullable id)content;

@end

NS_ASSUME_NONNULL_END
