//
//  XGCQRCodeControl.m
//  XGCMain_Example
//
//  Created by 凌志 on 2024/5/13.
//  Copyright © 2024 ShannonCrazy. All rights reserved.
//

#import "XGCQRCodeControl.h"

@interface XGCQRCodeControl ()
@property (nonatomic, strong, readwrite) UIImageView *imageView;
@property (nonatomic, assign, getter=isNeedsDisplay) BOOL needsDisplay;
@end

@implementation XGCQRCodeControl

- (instancetype)init {
    if (self = [super init]) {
        self.imageView = ({
            UIImageView *imageView = [[UIImageView alloc] init];
            [self addSubview:imageView];
            imageView;
        });
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = self.bounds;
}

#pragma mark set
- (void)setMessageString:(NSString *)messageString {
    _messageString = messageString;
    self.needsDisplay = YES;
    [self setNeedsDisplay];
}

- (void)setQRCodeForegroundColor:(UIColor *)QRCodeForegroundColor {
    _QRCodeForegroundColor = QRCodeForegroundColor;
    self.needsDisplay = YES;
    [self setNeedsDisplay];
}

- (void)setQRCodeBackgroundColor:(UIColor *)QRCodeBackgroundColor {
    _QRCodeBackgroundColor = QRCodeBackgroundColor;
    self.needsDisplay = YES;
    [self setNeedsDisplay];
}

#pragma mark system
- (void)drawRect:(CGRect)rect {
    if (CGRectIsInfinite(rect)) {
        return;
    }
    if (!self.isNeedsDisplay) {
        return;
    }
    if (self.messageString.length == 0) {
        return;
    }
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];
    [filter setValue:[self.messageString dataUsingEncoding:NSUTF8StringEncoding] forKey:@"inputMessage"];
    [filter setValue:@"Q" forKey:@"inputCorrectionLevel"];
    CIImage *outputImage = filter.outputImage;
    if (outputImage && (self.QRCodeForegroundColor || self.QRCodeBackgroundColor)) { // 二维码颜色
        filter = [CIFilter filterWithName:@"CIFalseColor"];
        [filter setDefaults];
        [filter setValue:outputImage forKey:@"inputImage"];
        UIColor *inputColor0 = self.QRCodeForegroundColor ?: [UIColor blackColor];
        [filter setValue:[CIColor colorWithCGColor:inputColor0.CGColor] forKey:@"inputColor0"];
        UIColor *inputColor1 = self.QRCodeBackgroundColor ?: [UIColor whiteColor];
        [filter setValue:[CIColor colorWithCGColor:inputColor1.CGColor] forKey:@"inputColor1"];
        outputImage = filter.outputImage;
    }
    if (outputImage) { // 二维码放大倍数要是一个整数倍数，否则会被裁边
        CGFloat scaleX = rect.size.width / outputImage.extent.size.width;
        CGFloat scaleY = rect.size.height / outputImage.extent.size.height;
        outputImage = [outputImage imageByApplyingTransform:CGAffineTransformMakeScale(round(scaleX), round(scaleY))];
    }
    UIImage *image = [UIImage imageWithCIImage:outputImage];
    UIGraphicsBeginImageContextWithOptions(image.size, YES, image.scale);
    [image drawAtPoint:CGPointZero];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.imageView.image = image;
    self.needsDisplay = NO;
}

@end
