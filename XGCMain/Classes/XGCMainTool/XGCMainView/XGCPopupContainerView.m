//
//  XGCPopupContainerView.m
//  XGCMain_Example
//
//  Created by 凌志 on 2024/5/13.
//  Copyright © 2024 ShannonCrazy. All rights reserved.
//

#import "XGCPopupContainerView.h"
//
#import <Masonry/Masonry.h>
//
#import "UIView+XGCView.h"

@interface XGCPopupContainerView ()
@property (nonatomic, strong) UIControl *backgroundControl;

@property (nonatomic, assign, getter=isBeingPresented) BOOL beingPresented;
@property (nonatomic, assign, getter=isEndPresented)   BOOL endPresented;
@property (nonatomic, assign, getter=isBeingDismissed) BOOL beingDismissed;
@end

@implementation XGCPopupContainerView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = UIColor.clearColor;
        self.backgroundControl = ({
            UIControl *control = [[UIControl alloc] initWithFrame:self.bounds];
            control.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.0];
            [control addTarget:self action:@selector(backgroundControlTouchAction) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:control];
            [control mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(self);
            }];
            control;
        });
        self.containerView = ({
            XGCViewCornerRadiusConfiguration *configutation = [[XGCViewCornerRadiusConfiguration alloc] init];
            configutation.cornerRadii = 15.0;
            configutation.roundingCorners = UIRectCornerTopLeft | UIRectCornerTopRight;
            
            UIView *view = [[UIView alloc] init];
            view.backgroundColor = UIColor.groupTableViewBackgroundColor;
            [view setViewConfiguration:configutation];
            [self addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.mas_equalTo(self);
            }];
            view;
        });
    }
    return self;
}

#pragma mark action
- (void)backgroundControlTouchAction {
    [self dismissAnimations];
}

- (void)dismissAnimations {
    self.beingDismissed = YES;
    void (^animations)(void) = ^(void) {
        self.containerView.transform = CGAffineTransformMakeTranslation(0, CGRectGetHeight(self.containerView.frame));
        self.backgroundControl.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.0];
    };
    void (^completion) (BOOL finished) = ^(BOOL finished) {
        [self removeFromSuperview];
    };
    [UIView animateWithDuration:0.25 animations:animations completion:completion];
}

#pragma mark system
- (void)drawRect:(CGRect)rect {
    if (isnan(rect.origin.x) || isnan(rect.origin.y)) {
        return;
    }
    if (self.isBeingPresented) {
        return;
    }
    if (self.isEndPresented) {
        return;
    }
    if (self.isBeingDismissed) {
        return;
    }
    // 视图动画
    self.beingPresented = YES;
    self.containerView.transform = CGAffineTransformMakeTranslation(0, CGRectGetHeight(self.containerView.frame));
    // 将视图上的键盘回收
    [UIApplication.sharedApplication sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    void (^animations)(void) = ^(void) {
        self.containerView.alpha = 1.0;
        self.containerView.transform = CGAffineTransformIdentity;
        self.backgroundControl.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.5];
    };
    void (^completion)(BOOL finished) = ^(BOOL finished) {
        self.endPresented = YES;
        self.beingPresented = NO;
    };
    [UIView animateWithDuration:0.25 animations:animations completion:completion];
}

@end
