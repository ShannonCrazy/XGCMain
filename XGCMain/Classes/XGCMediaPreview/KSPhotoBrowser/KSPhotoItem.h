//
//  KSPhotoItem.h
//  KSPhotoBrowser
//
//  Created by Kyle Sun on 12/25/16.
//  Copyright © 2016 Kyle Sun. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KSPhotoItem : NSObject

@property (strong, nonatomic , nullable) UIView *sourceView;
@property (strong, nonatomic , nullable) UIImage *thumbImage;
@property (strong, nonatomic , nullable) UIImage *image;
@property (strong, nonatomic , nullable) NSURL *imageUrl;
@property (assign, nonatomic ) BOOL finished;

- (nonnull instancetype)initWithSourceView:(nullable UIView *)view
                                thumbImage:(nullable UIImage *)image
                                  imageUrl:(nullable NSURL *)url;

- (nonnull instancetype)initWithSourceView:(nullable UIImageView * )view
                                  imageUrl:(nullable NSURL *)url;

- (nonnull instancetype)initWithSourceView:(nullable UIImageView *)view
                                     image:(nullable UIImage *)image;

+ (nonnull instancetype)itemWithSourceView:(nullable UIView *)view
                                thumbImage:(nullable UIImage *)image
                                  imageUrl:(nullable NSURL *)url;

+ (nonnull instancetype)itemWithSourceView:(nullable UIImageView *)view
                                  imageUrl:(nullable NSURL *)url;

+ (nonnull instancetype)itemWithSourceView:(nullable UIImageView *)view
                                     image:(nullable UIImage *)image;

+ (instancetype)itemWithSourceView:(nullable __kindof UIView *)view
                             image:(nullable UIImage *)image
                          imageUrl:(nullable NSURL *)imageUrl;
@end

NS_ASSUME_NONNULL_END
