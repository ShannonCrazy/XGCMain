//
//  XGCSubscriptView.m
//  XGCMain_Example
//
//  Created by 凌志 on 2024/5/13.
//  Copyright © 2024 ShannonCrazy. All rights reserved.
//

#import "XGCSubscriptView.h"

@interface XGCSubscriptView ()
/// 梯形
@property (nonatomic, strong) CAShapeLayer *backgroundLayer;
/// 文本
@property (nonatomic, strong) UILabel *textLabel;
@end

@implementation XGCSubscriptView

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
    self.offset = 19.0;
    self.backgroundLayer = ({
        CAShapeLayer *layer = [CAShapeLayer layer];
        [self.layer addSublayer:layer];
        layer;
    });
    self.textLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.textColor = UIColor.whiteColor;
        label.font = [UIFont systemFontOfSize:8];
        label.textAlignment = NSTextAlignmentCenter;
        label.layer.anchorPoint = CGPointMake(0, 1.0);
        [self addSubview:label];
        label;
    });
}

- (void)setFillColor:(UIColor *)fillColor {
    _fillColor = fillColor;
    self.backgroundLayer.fillColor = _fillColor.CGColor;
}

- (void)setText:(NSString *)text {
    _text = text;
    [self setNeedsDisplay];
}

- (void)setOffset:(CGFloat)offset {
    _offset = offset;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    if (isnan(rect.origin.x) || isnan(rect.origin.y) || isinf(rect.origin.x) || isinf(rect.origin.y)) {
        return;
    }
    CGFloat offsetX = self.offset;
    CGFloat offsetY = CGRectGetHeight(rect) - self.offset;
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointZero];
    [bezierPath addLineToPoint:CGPointMake(offsetX, 0)];
    [bezierPath addLineToPoint:CGPointMake(CGRectGetMaxX(rect), offsetY)];
    [bezierPath addLineToPoint:CGPointMake(CGRectGetMaxX(rect), CGRectGetMaxY(rect))];
    [bezierPath closePath];
    self.backgroundLayer.path = bezierPath.CGPath;
    
    CGFloat height = offsetX / sqrtf(2);
    CGFloat width = CGRectGetWidth(rect) * sqrtf(2);
    self.textLabel.transform = CGAffineTransformIdentity;
    self.textLabel.frame = CGRectMake(0, -height, width, height);
    self.textLabel.transform = CGAffineTransformMakeRotation(M_PI_4);
    self.textLabel.text = self.text;
}

@end
