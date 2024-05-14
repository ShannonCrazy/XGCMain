//
//  XGCMainProPersonBusTypeViewController.h
//  securitysystem
//
//  Created by 凌志 on 2024/1/10.
//

#import "XGCMainViewController.h"
// model
#import "XGCMainProPersonPersonModel.h"

@class XGCMainProPersonBusTypeViewController;

NS_ASSUME_NONNULL_BEGIN

@protocol XGCMainProPersonBusTypeDelegate <NSObject>
@optional
- (void)viewController:(XGCMainProPersonBusTypeViewController *)viewController refreshAction:(NSArray <XGCMainProPersonPersonModel *> *)personData;

- (void)viewController:(XGCMainProPersonBusTypeViewController *)viewController didSelectRowAtPerson:(XGCMainProPersonPersonModel *)person;

- (void)viewController:(XGCMainProPersonBusTypeViewController *)viewController viewWillAppear:(NSArray <XGCMainProPersonPersonModel *> *)personData;
@end

@interface XGCMainProPersonBusTypeViewController : XGCMainViewController
/// 组织ID
@property (nonatomic, strong) NSArray <NSString *> *orgIdList;
/// 查询机构树层级[空:有权限的机构,CMP(CMP):集团或分局或子公司,AREA(AREA):工区,PRO(PRO):项目,GC(GC):工程,BM(BM):部门] ，默认：BM
@property (nonatomic, copy, nullable) NSString *busType;
/// 搜索
@property (nonatomic, copy) NSString *searchVal;
/// 后台标志 true:所有后代（包含下瞎所有有权限（工区，项目，子公司）的部门）,false:只包含自身的部门
@property (nonatomic, copy) NSString *allFlag;
/// 代理
@property (nonatomic, weak) id <XGCMainProPersonBusTypeDelegate> delegate;
/// 个人
@property (nonatomic, strong, readonly) NSMutableArray <XGCMainProPersonPersonModel *> *personData;
/// 刷新数据
- (void)reloadData;
@end

NS_ASSUME_NONNULL_END
