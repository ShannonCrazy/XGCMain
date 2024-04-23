//
//  KSPhotoView.m
//  KSPhotoBrowser
//
//  Created by Kyle Sun on 12/25/16.
//  Copyright © 2016 Kyle Sun. All rights reserved.
//

#import "KSPhotoView.h"
#import "KSPhotoItem.h"
#import "KSProgressLayer.h"
#import "KSImageManagerProtocol.h"
#import <SDWebImage/SDWebImage.h>

const CGFloat kKSPhotoViewPadding = 0;
const CGFloat kKSPhotoViewMaxScale = 3;

@interface KSPhotoView ()<UIScrollViewDelegate, UIGestureRecognizerDelegate>

@property (strong, nonatomic, readwrite) SDAnimatedImageView * privateImageView;
@property (strong, nonatomic, readwrite) KSProgressLayer *progressLayer;
@property (strong, nonatomic, readwrite) KSPhotoItem *item;
@property (strong, nonatomic) id<KSImageManager> imageManager;

@end

@implementation KSPhotoView

- (UIImageView *)imageView {
    return self.privateImageView;
}

- (instancetype)initWithFrame:(CGRect)frame imageManager:(id<KSImageManager>)imageManager {
    self = [super initWithFrame:frame];
    if (self) {
        self.bouncesZoom = YES;
        self.maximumZoomScale = kKSPhotoViewMaxScale;
        self.multipleTouchEnabled = YES;
        self.showsHorizontalScrollIndicator = YES;
        self.showsVerticalScrollIndicator = YES;
        self.delegate = self;
        if (@available(iOS 11.0, *)) {
            self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        
        self.privateImageView = [[SDAnimatedImageView alloc] init];
        self.privateImageView.contentMode = UIViewContentModeScaleAspectFit;
        self.privateImageView.clipsToBounds = YES;
        [self addSubview:self.privateImageView];
        [self resizeImageView];
        
        _progressLayer = [[KSProgressLayer alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        _progressLayer.position = CGPointMake(frame.size.width/2, frame.size.height/2);
        _progressLayer.hidden = YES;
        [self.layer addSublayer:_progressLayer];
        
        _imageManager = imageManager;
    }
    return self;
}

- (void)setItem:(KSPhotoItem *)item determinate:(BOOL)determinate {
    _item = item;
    [_imageManager cancelImageRequestForImageView:self.privateImageView];
    if (item) {
        if (item.image) {
            self.privateImageView.image = item.image;
            _item.finished = YES;
            [_progressLayer stopSpin];
            _progressLayer.hidden = YES;
            [self resizeImageView];
            return;
        }
        __weak typeof(self) wself = self;
        KSImageManagerProgressBlock progressBlock = nil;
        if (determinate) {
            progressBlock = ^(NSInteger receivedSize, NSInteger expectedSize, CGFloat progress) {
                __strong typeof(wself) sself = wself;
                sself.progressLayer.hidden = NO;
                sself.progressLayer.strokeEnd = MAX(progress, 0.01);
            };
        } else {
            [_progressLayer startSpin];
        }
        _progressLayer.hidden = NO;
        
        self.privateImageView.image = item.thumbImage;
        KSImageManagerCompletionBlock completion = ^(UIImage * image, NSData * data , NSURL * url, BOOL success, NSError * error) {
            __strong typeof(wself) sself = wself;
            if (data && !error) {
                self.privateImageView.image = [UIImage imageWithData:data];
            }
            if (success) {
                [sself resizeImageView];
            }
            [sself.progressLayer stopSpin];
            sself.progressLayer.hidden = YES;
            sself.item.finished = YES;
        };
        [_imageManager setImageForImageView:self.privateImageView
                                    withURL:item.imageUrl
                                placeholder:item.thumbImage
                                   progress:progressBlock
                                 completion:completion];
    } else {
        [_progressLayer stopSpin];
        _progressLayer.hidden = YES;
        self.privateImageView.image = nil;
    }
    [self resizeImageView];
}

- (void)resizeImageView {
    if (self.privateImageView.image) {
        CGSize imageSize = self.privateImageView.image.size;
        
        CGFloat width = self.privateImageView.frame.size.width;
        
        CGFloat height = width * (imageSize.height / imageSize.width);
        if (isnan(height)) {
            height = 0;
        }
        CGRect rect = CGRectMake(0, 0, width, height);
        
        self.privateImageView.bounds = rect;
        
        // If image is very high, show top content.
        if (height <= self.bounds.size.height) {
            self.privateImageView.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
        } else {
            self.privateImageView.center = CGPointMake(self.bounds.size.width / 2, height / 2);
        }
        
        // If image is very wide, make sure user can zoom to fullscreen.
        @try {
            if (width / height > 2) {
                self.maximumZoomScale = self.bounds.size.height / height;
            }
        } @catch (NSException *exception) {} @finally {}

    } else {
        CGFloat width = self.frame.size.width - 2 * kKSPhotoViewPadding;
        
        self.privateImageView.bounds = CGRectMake(0, 0, width, width * 2.0 / 3);
        
        self.privateImageView.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    }
    self.contentSize = self.privateImageView.frame.size;
}

- (void)cancelCurrentImageLoad {
    [_imageManager cancelImageRequestForImageView:self.privateImageView];
    [_progressLayer stopSpin];
}

- (BOOL)isScrollViewOnTopOrBottom {
    CGPoint translation = [self.panGestureRecognizer translationInView:self];
    if (translation.y > 0 && self.contentOffset.y <= 0) {
        return YES;
    }
    CGFloat maxOffsetY = floor(self.contentSize.height - self.bounds.size.height);
    if (translation.y < 0 && self.contentOffset.y >= maxOffsetY) {
        return YES;
    }
    return NO;
}

#pragma mark - ScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.privateImageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    
    self.privateImageView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                 scrollView.contentSize.height * 0.5 + offsetY);
}

#pragma mark - GestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer == self.panGestureRecognizer) {
        if (gestureRecognizer.state == UIGestureRecognizerStatePossible) {
            if ([self isScrollViewOnTopOrBottom]) {
                return NO;
            }
        }
    }
    return YES;
}


@end
