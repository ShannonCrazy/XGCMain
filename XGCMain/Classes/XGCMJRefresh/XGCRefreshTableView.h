//
//  XGCRefreshTableView.h
//  xinggc
//
//  Created by 凌志 on 2023/12/11.
//

#import "XGCEmptyTableView.h"
@class XGCRefreshTableView;

NS_ASSUME_NONNULL_BEGIN

@protocol XGCTableViewRefreshDelegate <NSObject>
@optional
/// 头部下拉刷新
- (void)mj_headerRefreshingAction:(XGCRefreshTableView *)tableView;
/// 尾部上提刷新
- (void)mj_footerRefreshingAction:(XGCRefreshTableView *)tableView;
@end

@interface XGCRefreshTableView : XGCEmptyTableView
/// 起始条数
@property (nonatomic, assign) NSInteger startRow;
/// 每次加载的条数
@property (nonatomic, assign) NSUInteger rows;

#pragma mark MJRefresh
/// 下拉上提刷新代理
@property (nonatomic, weak) id <XGCTableViewRefreshDelegate> refreshDelegate;
/// 是否自动下拉刷新
@property (nonatomic, assign) BOOL beginRefreshingWhenDidMoveToSuperView;
/// 是否正在刷新
@property (nonatomic, assign, readonly, getter=isRefreshing) BOOL refreshing;
/// 进入刷新状态
- (void)beginRefreshing;
/// 结束刷新状态 
- (void)endRefreshing;
/// 提示没有更多的数据
- (void)endRefreshingWithNoMoreData;
@end

NS_ASSUME_NONNULL_END
