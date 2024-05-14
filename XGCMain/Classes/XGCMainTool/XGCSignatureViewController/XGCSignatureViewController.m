//
//  XGCSignatureViewController.m
//  XGCMain_Example
//
//  Created by 凌志 on 2024/5/13.
//  Copyright © 2024 ShannonCrazy. All rights reserved.
//

#import "XGCSignatureViewController.h"
// view
#import "UIView+XGCView.h"
#import "NSDate+XGCDate.h"
#import "XGCUserManager.h"
#import "XGCAliyunOSSiOS.h"
// containerView
#import "XGCSignatureContainerView.h"
//
#import <Masonry/Masonry.h>

@interface XGCSignatureViewController ()
@property (nonatomic, assign, getter=isUploading) BOOL uploading;
@property (nonatomic, strong) XGCSignatureContainerView *containerView;
@end

@implementation XGCSignatureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"签名";
    
    UIBarButtonItem *ok = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(okButtonTouchUpInside)];
    
    UIBarButtonItem *clean = [[UIBarButtonItem alloc] initWithTitle:@"清除" style:UIBarButtonItemStylePlain target:self action:@selector(cleanButtonTouchUpInside)];
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:ok, clean, nil];
    
    self.containerView = ({
        XGCSignatureContainerView *view = [[XGCSignatureContainerView alloc] init];
        [self.view addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.view.mas_safeAreaLayoutGuideLeft).offset(20.0);
            make.right.mas_equalTo(self.view.mas_safeAreaLayoutGuideRight).offset(-20.0);
            make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-20.0);
            make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(20.0);
        }];
        view;
    });
    if (@available(iOS 16.0, *)) {
    } else {
        [UIViewController attemptRotationToDeviceOrientation];
    }
}

#pragma mark action
- (void)goBackAction:(UIBarButtonItem *)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)okButtonTouchUpInside {
    if (self.isUploading) {
        return;
    }
    if (self.containerView.isEmpty) {
        [self.view makeToast:@"请先签名" position:XGCToastViewPositionCenter];
        return;
    }
    UIImage *image = self.containerView.image;
    if (!image) {
        [self.view makeToast:@"签名获取失败，请重试" position:XGCToastViewPositionCenter];
        return;
    }
    __weak typeof(self) this = self;
    void (^uploadProgress) (int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) = ^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [this.view showProgress:totalBytesSent / totalBytesExpectedToSend status:@"签名上传中..."];
        });
    };
    self.uploading = YES;
    NSString *objectKey = [NSString stringWithFormat:@"%@/%@/.jpg", XGCUM.cUser.userMap.cId, [[NSDate date] stringFromDateFormat:@"yyyyMMddHHmmssSSS"]];
    [XGCAliyunOSSiOS.shareInstance putObject:UIImageJPEGRepresentation(image, 1.0) objectKey:objectKey uploadProgress:uploadProgress completionHandler:^(NSString * _Nullable destination, NSError * _Nullable error) {
        [this.view dismiss];
        if (!error) {
            this.completionHandler ? this.completionHandler(destination) : nil;
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        } else {
            [this.view makeToast:@"签名上传失败，请稍后再试" position:XGCToastViewPositionCenter];
        }
    }];
}

- (void)cleanButtonTouchUpInside {
    [self.containerView clean];
}

#pragma mark system
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [self.containerView setNeedsDisplay];
}

- (void)viewSafeAreaInsetsDidChange {
    [super viewSafeAreaInsetsDidChange];
    [self.containerView setNeedsDisplay];
}

#pragma mark UIViewControllerRotation
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationLandscapeRight;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
