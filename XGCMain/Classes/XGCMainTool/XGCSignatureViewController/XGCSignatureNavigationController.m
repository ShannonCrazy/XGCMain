//
//  XGCSignatureNavigationController.m
//  XGCMain_Example
//
//  Created by 凌志 on 2024/5/13.
//  Copyright © 2024 ShannonCrazy. All rights reserved.
//

#import "XGCSignatureNavigationController.h"
//
#import "XGCSignatureViewController.h"

@interface XGCSignatureNavigationController ()
@property (nonatomic, strong) XGCSignatureViewController *rootViewController;
@end

@implementation XGCSignatureNavigationController

- (instancetype)init {
    return [self initWithRootViewController:(self.rootViewController = [[XGCSignatureViewController alloc] init])];
}

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
    if (self = [super initWithRootViewController:rootViewController]) {
        self.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.rootViewController.completionHandler = self.completionHandler;
}

@end
