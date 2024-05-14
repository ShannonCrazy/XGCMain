//
//  XGCDashPatternView.m
//  XGCMain_Example
//
//  Created by 凌志 on 2024/5/13.
//  Copyright © 2024 ShannonCrazy. All rights reserved.
//

#import "XGCDashPatternView.h"

@implementation XGCDashPatternView

+ (Class)layerClass {
    return [CAShapeLayer class];
}

- (void)setStrokeColor:(UIColor *)strokeColor {
    _strokeColor = strokeColor;
    [self setNeedsDisplay];
}

- (void)setLineDashPattern:(NSArray<NSNumber *> *)lineDashPattern {
    _lineDashPattern = lineDashPattern;
    [self setNeedsDisplay];
}

- (void)updateConstraints {
    [super updateConstraints];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    if (isnan(rect.origin.x) || isnan(rect.origin.y) || CGSizeEqualToSize(rect.size, CGSizeZero)) {
        return;
    }
    CAShapeLayer *layer = (CAShapeLayer *)self.layer;
    layer.strokeColor = (self.strokeColor ?: UIColor.groupTableViewBackgroundColor).CGColor;
    layer.fillColor = UIColor.clearColor.CGColor;
    layer.lineDashPattern = self.lineDashPattern ?: @[@3, @1];
    layer.lineWidth = MIN(rect.size.width, rect.size.height);
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    if (rect.size.width > rect.size.height) {
        [bezierPath moveToPoint:CGPointMake(0, CGRectGetMidY(rect))];
        [bezierPath addLineToPoint:CGPointMake(CGRectGetWidth(rect), CGRectGetMidY(rect))];
    } else {
        [bezierPath moveToPoint:CGPointMake(CGRectGetMidX(rect), 0)];
        [bezierPath addLineToPoint:CGPointMake(CGRectGetMidX(rect), CGRectGetHeight(rect))];
    }
    layer.path = bezierPath.CGPath;
}

@end
