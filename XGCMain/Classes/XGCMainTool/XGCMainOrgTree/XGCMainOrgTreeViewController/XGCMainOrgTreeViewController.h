//
//  XGCMainOrgTreeViewController.h
//  XGCMain
//
//  Created by 凌志 on 2024/3/27.
//

#import "XGCMainViewController.h"
// model
#import "XGCMainOrgTreeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XGCMainOrgTreeViewController : XGCMainViewController
/// 查询机构树层级[空:有权限的机构,CMP(CMP):集团或分局或子公司,AREA(AREA):工区,PRO(PRO):项目,GC(GC):工程,BM(BM):部门,LW(LW):劳务] ，默认：空（PRO）
@property (nonatomic, strong) NSArray <NSString *> *busTypes;
/// 允许选择的机构数层级类型[空:有权限的机构,CMP(CMP):集团或分局或子公司,AREA(AREA):工区,PRO(PRO):项目,GC(GC):工程,BM(BM):部门,LW(LW):劳务] ，默认：空
@property (nonatomic, strong) NSArray <NSString *> *enabledBusTypes;
/// 要查询的组织机构
@property (nonatomic, strong) NSArray <NSString *> *orgIdList;
/// 是否支持多选
@property (nonatomic, assign) BOOL allowsMultipleSelection;
/// 是否只展示自己的子集,default false
@property (nonatomic, copy, nullable) NSString *onlyChild;
/// 默认选中
@property (nonatomic, strong) NSArray <NSString *> *cIds;
/// 点击确定事件
@property (nonatomic, copy) void(^didSelectOrgTreeAction)(XGCMainOrgTreeViewController *viewController, NSArray <XGCMainOrgTreeModel *> *orgTrees);
@end

NS_ASSUME_NONNULL_END
