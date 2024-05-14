//
//  XGCPageViewManager.m
//  XGCMain_Example
//
//  Created by 凌志 on 2024/5/13.
//  Copyright © 2024 ShannonCrazy. All rights reserved.
//

#import "XGCPageViewManager.h"

@interface XGCPageViewManager ()<UIPageViewControllerDelegate, UIPageViewControllerDataSource>
@property (nonatomic, strong, readwrite) UIPageViewController *pageViewController;
@end

@implementation XGCPageViewManager

- (instancetype)init {
    return [self initWithPageSpacing:10];
}

#pragma mark public
- (instancetype)initWithPageSpacing:(CGFloat)pageSpacing {
    if (self = [super init]) {
        NSDictionary *options = @{UIPageViewControllerOptionInterPageSpacingKey:@(pageSpacing)};
        UIPageViewControllerTransitionStyle style = UIPageViewControllerTransitionStyleScroll;
        UIPageViewControllerNavigationOrientation orientation = UIPageViewControllerNavigationOrientationHorizontal;
        self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:style navigationOrientation:orientation options:options];
        self.pageViewController.delegate = self;
        self.pageViewController.dataSource = self;
    }
    return self;
}

- (NSUInteger)selectedPageIndex {
    __kindof UIViewController *firstObject = self.pageViewController.viewControllers.firstObject;
    if (!firstObject) {
        return 0;
    }
    return [self.viewControllers indexOfObject:firstObject];
}

- (void)setViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers {
    _viewControllers = viewControllers;
    self.pageViewController.dataSource = _viewControllers.count > 1 ? self : nil;
}

- (void)didMoveToParentViewController:(UIViewController *)parent {
    [parent.view addSubview:self.pageViewController.view];
    [parent addChildViewController:self.pageViewController];
    [self.pageViewController didMoveToParentViewController:parent];
    // 全屏左滑
    [self requireGestureRecognizerToFail:parent.navigationController.interactivePopGestureRecognizer];
}

- (void)setSelectedPageIndex:(NSUInteger)selectedPageIndex animated:(BOOL)animated completion:(void (^)(BOOL))completion {
    if (selectedPageIndex >= self.viewControllers.count) {
        return;
    }
    UIPageViewControllerNavigationDirection direction = UIPageViewControllerNavigationDirectionForward;
    __kindof UIViewController *firstObject = self.pageViewController.viewControllers.firstObject;
    if (firstObject) {
        direction = selectedPageIndex > [self.viewControllers indexOfObject:firstObject] ? UIPageViewControllerNavigationDirectionForward : UIPageViewControllerNavigationDirectionReverse;
    }
    [self.pageViewController setViewControllers:@[self.viewControllers[selectedPageIndex]] direction:direction animated:animated completion:completion];
}

- (void)requireGestureRecognizerToFail:(UIGestureRecognizer *)otherGestureRecognizer {
    if (!otherGestureRecognizer) {
        return;
    }
    [self.pageViewController.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([NSStringFromClass([obj class]) isEqualToString:@"_UIQueuingScrollView"]) {
            [((UIScrollView *)obj).panGestureRecognizer requireGestureRecognizerToFail:otherGestureRecognizer];
        }
    }];
}

#pragma mark - UIPageViewControllerDelegate, UIPageViewControllerDataSource
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    if (!completed) {
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(pageViewManager:didShowViewController:)]) {
        [self.delegate pageViewManager:self didShowViewController:previousViewControllers.firstObject];
    }
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    return [self viewController:viewController direction:UIPageViewControllerNavigationDirectionForward];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    return [self viewController:viewController direction:UIPageViewControllerNavigationDirectionReverse];
}

- (UIViewController *)viewController:(UIViewController *)viewController direction:(UIPageViewControllerNavigationDirection)direction {
    NSUInteger selectedPageIndex = [self.viewControllers indexOfObject:viewController];
    if (selectedPageIndex == NSNotFound || selectedPageIndex >= self.viewControllers.count) {
        return nil;
    }
    switch (direction) {
        case UIPageViewControllerNavigationDirectionForward: selectedPageIndex --; break;
        case UIPageViewControllerNavigationDirectionReverse: selectedPageIndex ++; break;
        default: break;
    }
    if (selectedPageIndex < 0 || selectedPageIndex >= self.viewControllers.count) {
        return nil;
    }
    return [self.viewControllers objectAtIndex:selectedPageIndex];
}

- (UIInterfaceOrientationMask)pageViewControllerSupportedInterfaceOrientations:(UIPageViewController *)pageViewController {
    return UIInterfaceOrientationMaskPortrait;
}

@end
