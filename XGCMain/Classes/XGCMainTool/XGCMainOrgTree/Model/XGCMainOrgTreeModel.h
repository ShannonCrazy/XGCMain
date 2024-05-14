//
//  XGCMainOrgTreeModel.h
//  securitysystem
//
//  Created by 凌志 on 2024/1/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XGCMainOrgTreeModel : NSObject
/// 机构树主键
@property (nonatomic, copy) NSString *cId;
/// 所属机构id
@property (nonatomic, copy) NSString *rootId;
/// 机构名称
@property (nonatomic, copy) NSString *cName;
/// 业务类型[(JT(JT):集团,CMP(CMP):公司或分局,AREA(AREA):工区,PRO(PRO):项目,GC(GC):工程,BM(BM):部门]
@property (nonatomic, copy) NSString *busType;
/// 项目类型
@property (nonatomic, copy) NSString *xmLx;
/// 单位类型
@property (nonatomic, copy) NSString *dwType;
/// 是否可选 是否可用节点（true:未拥有权限机构,false:拥有权限机构）
@property (nonatomic, assign) BOOL disabled;
/// 子项
@property (nonatomic, strong) NSArray <XGCMainOrgTreeModel *> *children;

/// 等级
@property (nonatomic, assign) NSUInteger level;
/// 是否展开
@property (nonatomic, assign, getter=isOpen) BOOL open;
/// 是否允许选择
@property (nonatomic, assign, getter=isEnabled) BOOL enabled;
/// 是否选中
@property (nonatomic, assign, getter=isSelected) BOOL selected;
/// 快捷初始化
/// - Parameters:
///   - cId: id
///   - cName: 名称
///   - busType: 业务类型
///   - level: 登记
+ (instancetype)cId:(NSString *)cId cName:(NSString *)cName busType:(NSString *)busType level:(NSUInteger)level;
@end

NS_ASSUME_NONNULL_END
