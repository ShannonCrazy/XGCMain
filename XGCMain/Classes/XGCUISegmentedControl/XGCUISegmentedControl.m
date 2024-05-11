//
//  XGCUISegmentedControl.m
//  an
//
//  Created by 凌志 on 2024/5/10.
//

#import "XGCUISegmentedControl.h"
#import "XGCConfiguration.h"

@implementation XGCUISegmentedControl

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        [self _didInitialize];
    }
    return self;
}

- (instancetype)initWithItems:(NSArray *)items {
    if (self = [super initWithItems:items]) {
        [self _didInitialize];
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        [self _didInitialize];
    }
    return self;
}

- (void)_didInitialize {
    self.layer.borderWidth = 2.0;
    self.layer.cornerRadius = 5.0;
    self.layer.borderColor = XGCCMI.backgroundColor.CGColor;
    self.tintColor = XGCCMI.whiteColor;
}

@end
