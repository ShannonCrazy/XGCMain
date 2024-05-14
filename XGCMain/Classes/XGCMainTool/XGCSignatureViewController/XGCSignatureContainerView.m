//
//  XGCSignatureContainerView.m
//  XGCMain_Example
//
//  Created by 凌志 on 2024/5/13.
//  Copyright © 2024 ShannonCrazy. All rights reserved.
//

#import "XGCSignatureContainerView.h"
//
#import "XGCConfiguration.h"

@interface XGCSignatureContainerView ()
/// 提示文本
@property (strong, nonatomic) UILabel *placeholderLabel;
/// 最有一条线条
@property (nonatomic, strong) UIBezierPath *lastObject;
/// 所有贝塞尔曲线
@property (nonatomic, strong) NSMutableArray <UIBezierPath *> *bezierPaths;
/// 路线图层
@property (nonatomic, strong) CAShapeLayer *shapeLayer;
@end

@implementation XGCSignatureContainerView

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = XGCCMI.whiteColor;
        self.placeholderLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.text = @"签名区";
            label.font = [UIFont systemFontOfSize:24];
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = [XGCCMI.blueColor colorWithAlphaComponent:0.4];
            [self addSubview:label];
            label;
        });
        self.shapeLayer = ({
            CAShapeLayer *layer = [CAShapeLayer layer];
            layer.fillColor = nil;
            layer.lineWidth = 1;
            layer.lineDashPattern = @[@4, @2];
            layer.lineJoin = kCALineJoinRound;
            layer.strokeColor = XGCCMI.blueColor.CGColor;
            [self.layer addSublayer:layer];
            layer;
        });
        self.bezierPaths = [NSMutableArray array];
    }
    return self;
}

#pragma mark func
- (BOOL)isEmpty {
    if (self.bezierPaths.count == 0) {
        return YES;
    }
    return NO;
}

- (UIImage *)image {
    __block CGFloat minX = self.bounds.size.width, minY = self.bounds.size.height, maxX = 0, maxY = 0;
    [self.bezierPaths enumerateObjectsUsingBlock:^(UIBezierPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        minX = MIN(minX, obj.bounds.origin.x);
        maxX = MAX(maxX, CGRectGetMaxX(obj.bounds));
        minY = MIN(minY, obj.bounds.origin.y);
        maxY = MAX(maxY, CGRectGetMaxY(obj.bounds));
    }];
    CGRect rect = CGRectInset(CGRectMake(minX, minY, maxX - minX, maxY - minY), -10.0, -10.0);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    if (!ctx) {
        return nil;
    }
    CGContextSaveGState(ctx);
    CGContextTranslateCTM(ctx, -rect.origin.x, -rect.origin.y);
    [self snapshotViewAfterScreenUpdates:YES];
    if([self respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
        [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:NO];
    } else {
        [self.layer renderInContext:ctx];
    }
    CGContextRestoreGState(ctx);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark system
- (void)layoutSubviews {
    [super layoutSubviews];
    self.placeholderLabel.frame = self.bounds;
}

#pragma mark UIResponder
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.lastObject = [UIBezierPath bezierPath];
    self.lastObject.lineWidth = 4.5;
    self.lastObject.lineCapStyle = kCGLineCapRound;
    self.lastObject.lineJoinStyle = kCGLineJoinRound;
    [self.lastObject moveToPoint:[touches.anyObject locationInView:self]];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // 隐藏提示语
    self.placeholderLabel.alpha = 0.0;
    // 手指的point
    CGPoint point = [touches.anyObject locationInView:self];
    if (![self.bezierPaths containsObject:self.lastObject]) {
        [self.bezierPaths addObject:self.lastObject];
    }
    [self.lastObject addLineToPoint:point];
    [self setNeedsDisplay];
}

#pragma mark public
- (void)clean {
    self.lastObject = nil;
    [self.bezierPaths removeAllObjects];
    self.placeholderLabel.alpha = 1.0;
    [self setNeedsDisplay];
}

#pragma mark UIViewRendering
- (void)drawRect:(CGRect)rect {
    if (isnan(rect.origin.x) || isnan(rect.origin.y)) {
        return;
    }
    self.shapeLayer.path = [UIBezierPath bezierPathWithRect:rect].CGPath;
    self.shapeLayer.frame = rect;
    [XGCCMI.labelColor setStroke];
    [self.bezierPaths enumerateObjectsUsingBlock:^(UIBezierPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj stroke];
    }];
}

@end
