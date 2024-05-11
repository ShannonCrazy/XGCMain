//
//  XGCViewController.m
//  XGCMain
//
//  Created by ShannonCrazy on 04/22/2024.
//  Copyright (c) 2024 ShannonCrazy. All rights reserved.
//

#import "XGCViewController.h"
//
#import "XGCSecondaryViewController.h"

@interface XGCViewController ()

@end

@implementation XGCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.purpleColor;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.navigationController pushViewController:[XGCSecondaryViewController new] animated:YES];
}

@end
