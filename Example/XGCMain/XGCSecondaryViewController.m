//
//  XGCSecondaryViewController.m
//  XGCMain_Example
//
//  Created by 凌志 on 2024/4/23.
//  Copyright © 2024 ShannonCrazy. All rights reserved.
//

#import "XGCSecondaryViewController.h"
//
#import <XGCMain/XGCSearchTextField.h>
//
#import <Masonry/Masonry.h>

@interface XGCSecondaryViewController ()

@end

@implementation XGCSecondaryViewController

- (void)viewDidLoad 
{
    [super viewDidLoad];
    ({
        XGCSearchTextField *textField = [[XGCSearchTextField alloc] init];
        textField.backgroundColor = UIColor.groupTableViewBackgroundColor;
        textField.placeholder = @"你好啊";
        [self.view addSubview:textField];
        [textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.view).offset(20.0);
            make.right.mas_equalTo(self.view).offset(-20.0);
            make.top.mas_equalTo(self.mas_topLayoutGuideBottom).offset(10.0);
            make.height.mas_equalTo(30.0);
        }];
    });
}

@end
