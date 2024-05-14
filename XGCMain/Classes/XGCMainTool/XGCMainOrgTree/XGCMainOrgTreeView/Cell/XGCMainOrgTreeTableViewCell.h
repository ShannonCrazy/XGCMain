//
//  XGCMainOrgTreeTableViewCell.h
//  XGCMain
//
//  Created by 凌志 on 2024/3/27.
//

#import <UIKit/UIKit.h>
@class XGCMainOrgTreeModel;

NS_ASSUME_NONNULL_BEGIN

@interface XGCMainOrgTreeTableViewCell : UITableViewCell
@property (nonatomic, strong) XGCMainOrgTreeModel *model;
@property (nonatomic, strong) UILabel *cName;
@property (nonatomic, strong) UIImageView *cImageView;
@end

NS_ASSUME_NONNULL_END
