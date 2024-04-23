//
//  KSWebImageProtocol.h
//  KSPhotoBrowserDemo
//
//  Created by Kyle Sun on 22/05/2017.
//  Copyright © 2017 Kyle Sun. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^KSImageManagerProgressBlock)(NSInteger receivedSize, NSInteger expectedSize , CGFloat progress);

typedef void (^KSImageManagerCompletionBlock)(UIImage * _Nullable image, NSData * _Nullable data , NSURL * _Nullable url, BOOL success, NSError * _Nullable error);

@protocol KSImageManager <NSObject>

- (void)setImageForImageView:(nullable UIImageView *)imageView
                     withURL:(nullable NSURL *)imageURL
                 placeholder:(nullable UIImage *)placeholder
                    progress:(nullable KSImageManagerProgressBlock)progress
                  completion:(nullable KSImageManagerCompletionBlock)completion;

- (void)cancelImageRequestForImageView:(nullable UIImageView *)imageView;

- (UIImage *_Nullable)imageFromMemoryForURL:(nullable NSURL *)url;
@end

NS_ASSUME_NONNULL_END
