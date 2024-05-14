//
//  XGCPageViewManager.h
//  XGCMain_Example
//
//  Created by 凌志 on 2024/5/13.
//  Copyright © 2024 ShannonCrazy. All rights reserved.
//

#import <Foundation/Foundation.h>
@class XGCPageViewManager;

NS_ASSUME_NONNULL_BEGIN

@protocol XGCPageViewDelegate <NSObject>
@optional
- (void)pageViewManager:(XGCPageViewManager *)pageViewManager didShowViewController:(__kindof UIViewController *)viewController;
@end

/// 分页管理器
@interface XGCPageViewManager : NSObject

@property (nonatomic, weak) id <XGCPageViewDelegate> delegate;

@property (nonatomic, assign, readonly) NSUInteger selectedPageIndex;

@property (nonatomic, strong) NSArray<__kindof UIViewController *> *viewControllers;

@property (nonatomic, strong, readonly) UIPageViewController *pageViewController;

- (instancetype)initWithPageSpacing:(CGFloat)PageSpacing;

- (void)didMoveToParentViewController:(UIViewController *)parent;

- (void)setSelectedPageIndex:(NSUInteger)selectedPageIndex animated:(BOOL)animated completion:(void (^ __nullable)(BOOL finished))completion;

- (void)requireGestureRecognizerToFail:(UIGestureRecognizer *)otherGestureRecognizer;
@end

NS_ASSUME_NONNULL_END
