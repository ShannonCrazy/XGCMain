//
//  XGCImageUrlControl.m
//  xinggc
//
//  Created by 凌志 on 2023/12/4.
//

#import "XGCImageUrlControl.h"
//
#import "XGCConfiguration.h"
// 
#import <SDWebImage/UIImageView+WebCache.h>

@interface XGCImageUrlControl ()
/// 图片控件
@property (nonatomic, strong, readwrite) UIImageView *imageView;
/// 地址
@property (nonatomic, strong, nullable) NSURL *url;
/// 文字
@property (nonatomic, strong) UIButton *placeholder;
/// 填充颜色
@property (nonatomic, strong) UIColor *fillColor;
/// 字体颜色
@property (nonatomic, strong) UIColor *foregroundColor;
@end

@implementation XGCImageUrlControl

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        [self didInitialize];
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        [self didInitialize];
    }
    return self;
}

- (void)didInitialize {
    self.placeholder = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.enabled = NO;
        button.contentEdgeInsets = UIEdgeInsetsMake(0, 1.0, 0, 1.0);
        [self addSubview:button];
        button;
    });
    self.imageView = ({
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.layer.masksToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:imageView];
        imageView;
    });
    // observer
    [self.layer addObserver:self forKeyPath:@"cornerRadius" options:NSKeyValueObservingOptionNew context:nil];
}

#pragma mark - Lifecycle
- (void)layoutSubviews {
    [super layoutSubviews];
    self.placeholder.frame = self.bounds;
    self.imageView.frame = self.bounds;
}

- (void)dealloc {
    [self.layer removeObserver:self forKeyPath:@"cornerRadius"];
}

#pragma mark - NSKeyValueObserving
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    self.placeholder.layer.cornerRadius = self.layer.cornerRadius;
    self.imageView.layer.cornerRadius = self.layer.cornerRadius;
}

- (void)setImageWithURL:(NSURL *)url placeholder:(NSString *)placeholder {
    NSUInteger len = placeholder.length > 2 ? 2 : placeholder.length;
    [self setImageWithURL:url placeholder:[placeholder substringWithRange:NSMakeRange(placeholder.length - len, len)] fillColor:XGCCMI.blueColor foregroundColor:XGCCMI.whiteColor];
}

- (void)setImageWithURL:(NSURL *)url placeholder:(NSString *)placeholder fillColor:(UIColor *)fillColor foregroundColor:(UIColor *)foregroundColor {
    self.url = url;
    self.placeholder.backgroundColor = fillColor;
    [self.placeholder setTitle:placeholder forState:UIControlStateNormal];
    [self.placeholder setTitleColor:foregroundColor forState:UIControlStateNormal];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    if (isnan(rect.origin.x) || isnan(rect.origin.y) || isinf(rect.origin.x) || isinf(rect.origin.y) || CGSizeEqualToSize(rect.size, CGSizeZero)) {
        return;
    }
    if (!self.superview) {
        return;
    }
    self.placeholder.titleLabel.font = [UIFont systemFontOfSize:(CGRectGetWidth(rect) + 10.0) / 4.0];
    // 加载缩略图图片
    NSURL *url = self.url;
    if (url && url.scheme.length > 0) {
        NSURLComponents *components = [[NSURLComponents alloc] initWithURL:url resolvingAgainstBaseURL:NO];
        components.query = [(components.query ?: @"") stringByAppendingFormat:@"x-oss-process=image/resize,w_%.0f", rect.size.width * UIScreen.mainScreen.scale];
        url = components.URL;
    }
    [self.imageView sd_setImageWithURL:url];
}

@end
