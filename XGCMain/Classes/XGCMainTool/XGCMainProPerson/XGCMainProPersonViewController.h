//
//  XGCMainProPersonViewController.h
//  securitysystem
//
//  Created by 凌志 on 2024/1/9.
//

#import "XGCMainViewController.h"
// model
#import "XGCMainProPersonPersonModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XGCMainProPersonViewController : XGCMainViewController
/// 组织ID
@property (nonatomic, strong) NSArray <NSString *> *orgIdList;
/// 是否支持多选 ，默认： NO
@property (nonatomic, assign) BOOL allowsMultipleSelection;
/// 查询机构树层级[空:有权限的机构,CMP(CMP):集团或分局或子公司,AREA(AREA):工区,PRO(PRO):项目,GC(GC):工程,BM(BM):部门] ，默认：BM
@property (nonatomic, strong) NSArray <NSString *> *busTypes;
/// 在职/离职状态(不传:在职)[0:在职 , 1:离职]
@property (nonatomic, copy, nullable) NSString *cWorkStatus;
/// 已选人员
@property (nonatomic, strong) NSArray <NSString *> *userIdList;
/// 完成选择
@property (nonatomic, copy) void(^didFinishPickingPersonalsHandle)(NSArray <XGCMainProPersonPersonModel *> *models);
@end

NS_ASSUME_NONNULL_END
