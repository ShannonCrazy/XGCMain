//
//  XGCMainOrgTreeViewControllerCell.h
//  XGCMain
//
//  Created by 凌志 on 2024/3/27.
//

#import <UIKit/UIKit.h>
@class XGCMainOrgTreeModel;

NS_ASSUME_NONNULL_BEGIN

@interface XGCMainOrgTreeViewControllerCell : UITableViewCell
- (void)setModel:(XGCMainOrgTreeModel *)model inset:(BOOL)inset;
/// 点击事件
@property (nonatomic, copy) void(^selectedButtonTouchUpInsideAction)(XGCMainOrgTreeModel *model);
// 东海
- (void)startAnimating;
@end

NS_ASSUME_NONNULL_END
