//
//  XGCMainOrgTreeViewTypeController.h
//  XGCMain
//
//  Created by 凌志 on 2024/3/27.
//

#import "XGCMainViewController.h"
@class XGCMainOrgTreeModel;

NS_ASSUME_NONNULL_BEGIN

@interface XGCMainOrgTreeViewTypeController : XGCMainViewController
/// 查询机构树层级[空:有权限的机构,CMP(CMP):集团或分局或子公司,AREA(AREA):工区,PRO(PRO):项目,GC(GC):工程,BM(BM):部门,LW(LW):劳务] ，默认：空（PRO）
@property (nonatomic, copy) NSString *busType;
/// 允许选择的机构数层级类型[空:有权限的机构,CMP(CMP):集团或分局或子公司,AREA(AREA):工区,PRO(PRO):项目,GC(GC):工程,BM(BM):部门,LW(LW):劳务] ，默认：空
@property (nonatomic, strong) NSArray <NSString *> *enabledBusTypes;
/// 要查询的组织机构
@property (nonatomic, strong) NSArray <NSString *> *orgIdList;
/// 默认选中
@property (nonatomic, strong) NSArray <NSString *> *cIds;
/// 是否只展示自己的子集,default false
@property (nonatomic, copy, nullable) NSString *onlyChild;
/// 搜索条件
@property (nonatomic, copy) NSString *searchVal;
/// 点击事件
@property (nonatomic, copy) void(^didSelectRowAtOrgTreeAction)(XGCMainOrgTreeModel *model);
/// 请求完成时间
@property (nonatomic, copy) void(^afterRequestAction)(NSMutableDictionary <NSString *, XGCMainOrgTreeModel *> *maps);
/// 刷新
- (void)beginRequest;
@end

NS_ASSUME_NONNULL_END
