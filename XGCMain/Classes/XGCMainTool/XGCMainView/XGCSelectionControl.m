//
//  XGCSelectionControl.m
//  XGCMain_Example
//
//  Created by 凌志 on 2024/5/13.
//  Copyright © 2024 ShannonCrazy. All rights reserved.
//

#import "XGCSelectionControl.h"
//
#import "XGCConfiguration.h"

@interface XGCSelectionControl ()
@property (nonatomic, strong) UILabel *placeholderLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) NSMutableDictionary <NSNumber *, NSString *> *titleMaps;
@property (nonatomic, strong) NSMutableDictionary <NSNumber *, UIColor *> *colorMaps;
@property (nonatomic, strong) NSMutableDictionary <NSNumber *, UIImage *> *imageMaps;
@end

@implementation XGCSelectionControl

- (instancetype)init {
    if (self = [super init]) {
        [self didInitialize];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        [self didInitialize];
    }
    return self;
}

- (void)didInitialize {
    self.backgroundColor = UIColor.whiteColor;
    self.placeholderLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = [UIColor.grayColor colorWithAlphaComponent:0.7];
        [self addSubview:label];
        label;
    });
    self.titleLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = [UIColor.blackColor colorWithAlphaComponent:0.7];
        [self addSubview:label];
        label;
    });
    self.imageView = ({
        UIImageView *imageView = [[UIImageView alloc] init];
        [self addSubview:imageView];
        imageView;
    });
    // 字典
    self.titleMaps = [NSMutableDictionary dictionary];
    self.colorMaps = [NSMutableDictionary dictionary];
    self.imageMaps = [NSMutableDictionary dictionary];
    // 阴影
    self.layer.shadowRadius = 5.0;
    self.layer.shadowOpacity = 0.3;
    self.layer.shadowOffset = CGSizeZero;
    self.layer.shadowColor = XGCCMI.shadowColor.CGColor;
    //
    self.contentEdgeInsets = UIEdgeInsetsMake(8.0, 15.0, 8.0, 15.0);
    //
    [self setImage:self.defaultImage forState:UIControlStateNormal];
    //
    self.imagePadding = 10.0;
    self.cornerRadius = UITableViewAutomaticDimension;
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state {
    if (title) {
        [self.titleMaps setObject:title forKey:[NSNumber numberWithUnsignedInteger:state]];
    } else {
        [self.titleMaps removeObjectForKey:[NSNumber numberWithUnsignedInteger:state]];
    }
    [self setNeedsUpdateTitleLabelText];
}

- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state {
    if (color) {
        [self.colorMaps setObject:color forKey:[NSNumber numberWithUnsignedInteger:state]];
    } else {
        [self.colorMaps removeObjectForKey:[NSNumber numberWithUnsignedInteger:state]];
    }
    [self setNeedsUpdateTitleLabelText];
}

- (void)setImage:(UIImage *)image forState:(UIControlState)state {
    if (image) {
        [self.imageMaps setObject:image forKey:[NSNumber numberWithUnsignedInteger:state]];
    } else {
        [self.imageMaps removeObjectForKey:[NSNumber numberWithUnsignedInteger:state]];
    }
    [self setNeedsUpdateImageViewImage];
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    [self setNeedsUpdateTitleLabelText];
    [self setNeedsUpdateImageViewImage];
}

- (void)setEnabled:(BOOL)enabled {
    [super setEnabled:enabled];
    [self setNeedsUpdateTitleLabelText];
    [self setNeedsUpdateImageViewImage];
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    [self setNeedsUpdateTitleLabelText];
    [self setNeedsUpdateImageViewImage];
}

- (void)setNeedsUpdateTitleLabelText {
    NSNumber *state = [NSNumber numberWithUnsignedInteger:self.state];
    self.titleLabel.text = self.titleMaps[state] ?: self.titleMaps[[NSNumber numberWithUnsignedInteger:UIControlStateNormal]];
    self.titleLabel.textColor = self.colorMaps[state] ?: self.colorMaps[[NSNumber numberWithUnsignedInteger:UIControlStateNormal]];
    [self invalidateIntrinsicContentSize];
    self.placeholderLabel.alpha = self.titleLabel.text.length > 0 ? 0.0 : 1.0;
    self.imageView.hidden = !self.enabled;
}

- (void)setNeedsUpdateImageViewImage {
    NSNumber *state = [NSNumber numberWithUnsignedInteger:self.state];
    self.imageView.image = self.imageMaps[state] ?: self.imageMaps[[NSNumber numberWithUnsignedInteger:UIControlStateNormal]];
}

#pragma mark public
- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    self.placeholderLabel.text = _placeholder;
}

- (void)setAttributedPlaceholder:(NSAttributedString *)attributedPlaceholder {
    _attributedPlaceholder = attributedPlaceholder;
    self.placeholderLabel.attributedText = _attributedPlaceholder;
}

- (void)setFont:(UIFont *)font {
    _font = font;
    self.titleLabel.font = _font;
}

- (void)setContentEdgeInsets:(UIEdgeInsets)contentEdgeInsets {
    _contentEdgeInsets = contentEdgeInsets;
    [self setNeedsLayout];
}

#pragma mark Lifecycle
- (void)layoutSubviews {
    [super layoutSubviews];
    // 图片
    CGFloat x = CGRectGetWidth(self.bounds) - self.contentEdgeInsets.right - self.imageView.image.size.width;
    CGFloat y = (CGRectGetHeight(self.bounds) - self.imageView.image.size.height) / 2.0;
    self.imageView.frame = CGRectMake(x, y, self.imageView.image.size.width, self.imageView.image.size.height);
    // 提示语
    CGFloat width = CGRectGetMinX(self.imageView.frame) - self.contentEdgeInsets.left - self.imagePadding;
    CGFloat height = CGRectGetHeight(self.bounds) - self.contentEdgeInsets.top - self.contentEdgeInsets.bottom;
    self.placeholderLabel.frame = CGRectMake(self.contentEdgeInsets.left, self.contentEdgeInsets.top, width, height);
    // 文字
    self.titleLabel.frame = self.placeholderLabel.frame;
    // 圆角
    self.layer.cornerRadius = self.cornerRadius == UITableViewAutomaticDimension ? CGRectGetHeight(self.frame) / 2.0 : self.cornerRadius;
}

- (CGSize)intrinsicContentSize {
    NSString *text = self.titleLabel.text;
    if (text.length == 0) {
        text = self.placeholderLabel.text;
    }
    CGSize size = [text sizeWithAttributes:[NSDictionary dictionaryWithObject:(self.font ?: [UIFont systemFontOfSize:13]) forKey:NSFontAttributeName]];
    size.width += self.contentEdgeInsets.left + self.contentEdgeInsets.right + self.imagePadding + self.imageView.image.size.width;
    size.height += self.contentEdgeInsets.top + self.contentEdgeInsets.bottom;
    size.height = MAX(size.height, 30.0);
    return CGSizeMake(ceil(size.width), ceil(size.height));
}

- (UIImage *)defaultImage {
    if (!_defaultImage) {
        CGSize size = CGSizeMake(12, 7);
        UIGraphicsBeginImageContextWithOptions(size, NO, 0);
        CGContextRef c = UIGraphicsGetCurrentContext();
        if (!c) {
            return nil;
        }
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(0, 0)];
        [path addLineToPoint:CGPointMake(size.width / 2.0, size.height)];
        [path addLineToPoint:CGPointMake(size.width, 0)];
        [path closePath];
        CGContextSetFillColorWithColor(c, [UIColor.blackColor colorWithAlphaComponent:0.7].CGColor);
        [path fill];
        _defaultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return _defaultImage;
}

@end
