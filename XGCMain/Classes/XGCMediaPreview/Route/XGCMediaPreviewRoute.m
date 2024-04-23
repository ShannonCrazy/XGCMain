//
//  XGCMediaPreviewRoute.m
//  XGCMain_Example
//
//  Created by 凌志 on 2024/4/22.
//  Copyright © 2024 ShannonCrazy. All rights reserved.
//

#import "XGCMediaPreviewRoute.h"
//
#import "KSPhotoBrowser.h"
//
#import "XGCMainRoute.h"
#import "NSString+XGCString.h"
#import "XGCMediaPreviewModel.h"

@implementation XGCMediaPreviewRoute

- (BOOL)canRouteURL:(NSURL *)URL withParameters:(NSDictionary<NSString *,id> *)parameters {
    return [URL.host isEqualToString:@"XGCMediaPreview"] && [parameters.allKeys containsObject:@"fileJson"];
}

- (__kindof UIViewController *)routeControllerForURL:(NSURL *)URL withParameters:(NSDictionary<NSString *,id> *)parameters {
    if (![self canRouteURL:URL withParameters:parameters]) {
        return nil;
    }
    // 附件
    XGCMediaPreviewModel *fileJson = parameters[@"fileJson"];
    // URL
    NSURL *imageUrl = [NSURL URLWithString:fileJson.fileUrl.URLEncoding];
    // 如果是图片
    if ([fileJson.suffix isImageFormat]) {
        // 预览控件
        __kindof UIView *sourceView = parameters[@"sourceView"];
        // 所有附件数组
        NSArray <XGCMediaPreviewModel *> *fileJsons = parameters[@"fileJsons"];
        // 预览数组
        NSMutableArray <KSPhotoItem *> *photoItems = [NSMutableArray array];
        // 循环
        for (XGCMediaPreviewModel *model in fileJsons) {
            if (![model isKindOfClass:[XGCMediaPreviewModel class]]) {
                continue;
            }
            if (![model.suffix isImageFormat] && ![model.fileUrl isImageFormat]) {
                continue;
            }
            if (model.image) {
                [photoItems addObject:[KSPhotoItem itemWithSourceView:sourceView image:model.image]];
            }
            if (model.fileUrl.length > 0) {
                [photoItems addObject:[KSPhotoItem itemWithSourceView:sourceView imageUrl:[NSURL URLWithString:model.fileUrl.URLEncoding]]];
            }
        }
        // 如果没有数据
        if (photoItems.count == 0) {
            [photoItems addObject:[KSPhotoItem itemWithSourceView:sourceView image:fileJson.image imageUrl:imageUrl]];
        }
        // 当前默认展示哪个item
        NSUInteger selectedIndex = 0;
        for (KSPhotoItem *item in photoItems) {
            if (item.image && fileJson.image && [item.image isEqual:fileJson.image]) {
                selectedIndex = [photoItems indexOfObject:item];
            }
            if (item.imageUrl && imageUrl && [item.imageUrl.absoluteString isEqualToString:imageUrl.absoluteString]) {
                selectedIndex = [photoItems indexOfObject:item];
            }
        }
        return [KSPhotoBrowser browserWithPhotoItems:photoItems selectedIndex:selectedIndex];
    } else {
        return [XGCMainRoute routeControllerForURL:[NSURL URLWithString:@"xinggc://XGCWebView"] withParameters:[NSDictionary dictionaryWithObject:imageUrl forKey:@"URL"]];
    }
}

@end
