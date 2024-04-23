//
//  KSPhotoBrowser.h
//  KSPhotoBrowser
//
//  Created by Kyle Sun on 12/25/16.
//  Copyright © 2016 Kyle Sun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KSPhotoItem.h"
#import "KSSDImageManager.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, KSPhotoBrowserInteractiveDismissalStyle) {
    KSPhotoBrowserInteractiveDismissalStyleRotation,
    KSPhotoBrowserInteractiveDismissalStyleScale,
    KSPhotoBrowserInteractiveDismissalStyleSlide,
    KSPhotoBrowserInteractiveDismissalStyleNone
};

typedef NS_ENUM(NSUInteger, KSPhotoBrowserBackgroundStyle) {
    KSPhotoBrowserBackgroundStyleBlurPhoto,
    KSPhotoBrowserBackgroundStyleBlur,
    KSPhotoBrowserBackgroundStyleBlack
};

typedef NS_ENUM(NSUInteger, KSPhotoBrowserPageIndicatorStyle) {
    KSPhotoBrowserPageIndicatorStyleDot,
    KSPhotoBrowserPageIndicatorStyleText
};

typedef NS_ENUM(NSUInteger, KSPhotoBrowserImageLoadingStyle) {
    KSPhotoBrowserImageLoadingStyleIndeterminate,
    KSPhotoBrowserImageLoadingStyleDeterminate
};

@protocol KSPhotoBrowserDelegate, KSImageManager;
@interface KSPhotoBrowser : UIViewController

@property (assign, nonatomic) KSPhotoBrowserInteractiveDismissalStyle dismissalStyle;
@property (assign, nonatomic) KSPhotoBrowserBackgroundStyle backgroundStyle;
@property (assign, nonatomic) KSPhotoBrowserPageIndicatorStyle pageindicatorStyle;
@property (assign, nonatomic) KSPhotoBrowserImageLoadingStyle loadingStyle;
@property (assign, nonatomic) BOOL bounces;
@property (nonatomic,   weak) id<KSPhotoBrowserDelegate> delegate;

+ (instancetype)browserWithPhotoItems:(NSArray<KSPhotoItem *> *)photoItems selectedIndex:(NSUInteger)selectedIndex;
- (instancetype)initWithPhotoItems:(NSArray<KSPhotoItem *> *)photoItems selectedIndex:(NSUInteger)selectedIndex;
- (void)showFromViewController:(UIViewController *)vc;
+ (void)setImageManagerClass:(Class<KSImageManager>)cls;

@end

@protocol KSPhotoBrowserDelegate <NSObject>

- (void)ks_photoBrowser:(KSPhotoBrowser *)browser didSelectItem:(KSPhotoItem *)item atIndex:(NSUInteger)index;

@end

NS_ASSUME_NONNULL_END
