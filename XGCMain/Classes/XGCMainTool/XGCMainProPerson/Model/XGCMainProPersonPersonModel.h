//
//  XGCMainProPersonPersonModel.h
//  securitysystem
//
//  Created by 凌志 on 2024/1/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XGCMainProPersonPersonModel : NSObject
/// 用户id （id字段）
@property (nonatomic, copy) NSString *cUserId;
/// 头像
@property (nonatomic, copy) NSString *cImageUrl;
/// 员工姓名
@property (nonatomic, copy) NSString *cRealname;
/// 完整部门树名称
@property (nonatomic, strong) NSArray <NSString *> *showOrgName;
/// 角色名称
@property (nonatomic, copy) NSString *roleName;
/// 性别
@property (nonatomic, copy) NSString *cSex;
/// 年龄
@property (nonatomic, copy) NSString *cAge;
/// 职位 GW_TYPE
@property (nonatomic, copy) NSString *zwCode;
/// 职位名称
@property (nonatomic, copy) NSString *zwName;
/// 部门id
@property (nonatomic, copy) NSString *orgId;
/// 部门名称
@property (nonatomic, copy) NSString *orgName;
/// 所属组织id
@property (nonatomic, copy) NSString *pOrgId;
/// 所属组织名称
@property (nonatomic, copy) NSString *pOrgName;
/// 电话
@property (nonatomic, copy) NSString *cPhone;
/// 身份证号码
@property (nonatomic, copy) NSString *cIdcard;
/// 入职时间
@property (nonatomic, copy) NSString *cHireDate;
/// 是否选中
@property (nonatomic, assign, getter=isSelected) BOOL selected;
@end

NS_ASSUME_NONNULL_END
