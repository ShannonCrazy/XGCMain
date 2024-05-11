//
//  XGCRefreshTableView.m
//  xinggc
//
//  Created by 凌志 on 2023/12/11.
//

#import "XGCRefreshTableView.h"
// thirdparty
#if __has_include (<MJRefresh/MJRefresh.h>)
#import <MJRefresh/MJRefresh.h>
#endif

@implementation XGCRefreshTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:style]) {
#if __has_include (<MJRefresh/MJRefresh.h>)
        self.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshingAction)];
        self.mj_header.automaticallyChangeAlpha = YES;
        self.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefreshingAction)];
#endif
        self.rows = 10;
        self.startRow = 0;
        self.beginRefreshingWhenDidMoveToSuperView = YES;
        // block
        __weak typeof(self) this = self;
        self.emptyDataSetWillAppear = ^(UIScrollView * _Nonnull scrollView) {
            if (scrollView.contentOffset.y >= 0) {
                [scrollView setContentOffset:CGPointZero animated:NO];
            }
            this.mj_footer.hidden = YES;
        };
    }
    return self;
}

#pragma mark action
- (void)headerRefreshingAction {
    if (!self.refreshDelegate || ![self.refreshDelegate respondsToSelector:@selector(mj_headerRefreshingAction:)]) {
        return;
    }
    [self.refreshDelegate mj_headerRefreshingAction:self];
}

- (void)footerRefreshingAction {
    if (!self.refreshDelegate || ![self.refreshDelegate respondsToSelector:@selector(mj_footerRefreshingAction:)]) {
        return;
    }
    [self.refreshDelegate mj_footerRefreshingAction:self];
}

- (BOOL)isRefreshing {
    return self.mj_header.isRefreshing || self.mj_footer.isRefreshing;
}

- (void)beginRefreshing {
#if __has_include (<MJRefresh/MJRefresh.h>)
    [self.mj_header beginRefreshing];
#endif
}

- (void)endRefreshing {
#if __has_include (<MJRefresh/MJRefresh.h>)
    [self.mj_header endRefreshing];
    self.mj_footer.hidden = NO;
    [self.mj_footer endRefreshing];
#endif
}

- (void)endRefreshingWithNoMoreData {
#if __has_include (<MJRefresh/MJRefresh.h>)
    [self.mj_footer endRefreshingWithNoMoreData];
#endif
}

#pragma mark Lifecycle
- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    if (!self.superview) {
        return;
    }
    if (!self.beginRefreshingWhenDidMoveToSuperView) {
        return;
    }
    [self beginRefreshing];
}

@end
