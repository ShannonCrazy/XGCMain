//
//  KSPhotoView.h
//  KSPhotoBrowser
//
//  Created by Kyle Sun on 12/25/16.
//  Copyright © 2016 Kyle Sun. All rights reserved.
//

#import <UIKit/UIKit.h>
//
#import "KSProgressLayer.h"

NS_ASSUME_NONNULL_BEGIN

extern const CGFloat kKSPhotoViewPadding;

@protocol KSImageManager;
@class KSPhotoItem, SDAnimatedImageView;

@interface KSPhotoView : UIScrollView

@property (strong, nonatomic, readonly) UIImageView * imageView;
@property (strong, nonatomic, readonly) KSProgressLayer *progressLayer;
@property (strong, nonatomic, readonly) KSPhotoItem *item;

- (instancetype)initWithFrame:(CGRect)frame imageManager:(id<KSImageManager>)imageManager;
- (void)setItem:(KSPhotoItem *)item determinate:(BOOL)determinate;
- (void)resizeImageView;
- (void)cancelCurrentImageLoad;

@end

NS_ASSUME_NONNULL_END
