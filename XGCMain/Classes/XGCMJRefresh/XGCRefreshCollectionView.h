//
//  XGCRefreshCollectionView.h
//  XGCMain
//
//  Created by 凌志 on 2024/1/5.
//

#import "XGCEmptyCollectionView.h"
@class XGCRefreshCollectionView;

NS_ASSUME_NONNULL_BEGIN

@protocol XGCCollectionViewRefreshDelegate <NSObject>
@optional
/// 头部下拉刷新
- (void)mj_headerRefreshingAction:(XGCRefreshCollectionView *)collectionView;

/// 尾部上提刷新
- (void)mj_footerRefreshingAction:(XGCRefreshCollectionView *)collectionView;
@end

@interface XGCRefreshCollectionView : XGCEmptyCollectionView
/// 起始条数
@property (nonatomic, assign) NSInteger startRow;
/// 每次加载的条数
@property (nonatomic, assign) NSUInteger rows;

#pragma mark MJRefresh
/// 下拉上提刷新代理
@property (nonatomic, weak) id <XGCCollectionViewRefreshDelegate> refreshDelegate;
/// 是否自动下拉刷新
@property (nonatomic, assign) BOOL beginRefreshingWhenDidMoveToSuperView;
/// 进入刷新状态
- (void)beginRefreshing;
/// 结束刷新状态
- (void)endRefreshing;
/// 提示没有更多的数据
- (void)endRefreshingWithNoMoreData;
@end

NS_ASSUME_NONNULL_END
