//
//  XGCSearchTextField.m
//  XGCMain_Example
//
//  Created by 凌志 on 2024/4/23.
//  Copyright © 2024 ShannonCrazy. All rights reserved.
//

#import "XGCSearchTextField.h"
//
#import "UIImage+XGCImage.h"

@implementation XGCSearchTextField

- (instancetype)init {
    if (self = [super init]) {
        [self _didInitialize];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        [self _didInitialize];
    }
    return self;
}

#pragma mark func
- (void)_didInitialize {
    self.font = [UIFont systemFontOfSize:13];
    // 左侧视图
    self.leftView = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.enabled = NO;
        button.contentEdgeInsets = UIEdgeInsetsMake(0, 5.0, 0, 5.0);
        [button setImage:[UIImage imageNamed:@"main_sousuo"] forState:UIControlStateNormal];
        button;
    });
    self.leftViewMode = UITextFieldViewModeAlways;
    // 清空按钮
    self.clearButtonMode = UITextFieldViewModeWhileEditing;
}

@end
