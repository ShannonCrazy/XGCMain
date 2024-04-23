//
//  KSPhotoBrowserManager.m
//  Star
//
//  Created by 凌志 on 2021/5/6.
//  Copyright © 2021 Pingtan Jiutian Network Technology Co., Ltd. All rights reserved.
//

#import "KSPhotoBrowserManager.h"

@implementation KSPhotoBrowserManager

+ (KSPhotoBrowser *)browserWithPhotoItems:(NSArray<KSPhotoItem *> *)photoItems {
    return [self browserWithPhotoItems:photoItems imageUrl:nil image:nil content:nil];
}

+ (KSPhotoBrowser *)browserWithPhotoItems:(NSArray<KSPhotoItem *> *)photoItems imageUrl:(NSString *)imageUrl {
    return [self browserWithPhotoItems:photoItems imageUrl:imageUrl image:nil content:nil];
}

+ (KSPhotoBrowser *)browserWithPhotoItems:(NSArray<KSPhotoItem *> *)photoItems image:(UIImage *)image {
    return [self browserWithPhotoItems:photoItems imageUrl:nil image:image content:nil];
}

+ (KSPhotoBrowser *)browserWithPhotoItems:(NSArray<KSPhotoItem *> *)photoItems content:(id)content {
    return [self browserWithPhotoItems:photoItems imageUrl:nil image:nil content:content];
}

+ (KSPhotoBrowser *)browserWithPhotoItems:(NSArray<KSPhotoItem *> *)photoItems imageUrl:(NSString *)imageUrl image:(UIImage *)image content:(id)content {
    if (photoItems.count == 0) return nil;
    __block NSUInteger selectedIndex = 0;
    if (imageUrl.length > 0 || image || content) {
        [photoItems enumerateObjectsUsingBlock:^(KSPhotoItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.imageUrl && [obj.imageUrl.absoluteString isEqualToString:imageUrl]) {
                selectedIndex = idx;
                *stop = YES;
            } else if (obj.image && image && obj.image == image) {
                selectedIndex = idx;
                *stop = YES;
            }
        }];
    }
    KSPhotoBrowser *browser = [KSPhotoBrowser browserWithPhotoItems:photoItems selectedIndex:selectedIndex];
    return browser;
}

@end
