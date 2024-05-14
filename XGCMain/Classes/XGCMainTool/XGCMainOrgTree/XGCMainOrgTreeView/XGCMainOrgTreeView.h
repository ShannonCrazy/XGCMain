//
//  XGCMainOrgTreeView.h
//  securitysystem
//
//  Created by 凌志 on 2024/1/11.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
// model
#import "XGCMainOrgTreeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XGCMainOrgTreeView : UIView
/// 查询机构树层级[空:有权限的机构,CMP(CMP):集团或分局或子公司,AREA(AREA):工区,PRO(PRO):项目,GC(GC):工程,BM(BM):部门] ，默认：空（PRO）
@property (nonatomic, copy) NSString *busType;
/// 允许选择的机构数层级类型[空:有权限的机构,CMP(CMP):集团或分局或子公司,AREA(AREA):工区,PRO(PRO):项目,GC(GC):工程,BM(BM):部门] ，默认：空
@property (nonatomic, strong) NSArray <NSString *> *enabledBusTypes;
/// 要查询的组织机构
@property (nonatomic, strong) NSArray <NSString *> *orgIdList;
/// 是否只查询orgIdList的子集，默认 false
@property (nonatomic, copy, nullable) NSString *onlyChild;
/// 是否支持多选
@property (nonatomic, assign) BOOL allowsMultipleSelection;
/// 标题 default nil
@property (nonatomic, copy, nullable) NSString *title;
/// 默认选中
@property (nonatomic, strong) NSArray <NSString *> *cIds;
/// 点击确定事件
@property (nonatomic, copy) void(^didSelectOrgTreeAction)(XGCMainOrgTreeView *orgTreeView, NSArray <XGCMainOrgTreeModel *> *orgTrees);
/// 添加数据
/// - Parameter anObject: 数据
/// - Parameter index: 从哪里开始插入
- (void)insertOrgTreeModels:(NSArray <XGCMainOrgTreeModel *> *)objects fromIndex:(NSUInteger)index;
@end

NS_ASSUME_NONNULL_END
