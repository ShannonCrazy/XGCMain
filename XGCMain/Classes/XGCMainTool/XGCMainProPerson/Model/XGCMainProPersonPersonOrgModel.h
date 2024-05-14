//
//  XGCMainProPersonPersonOrgModel.h
//  securitysystem
//
//  Created by 凌志 on 2024/1/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XGCMainProPersonPersonOrgModel : NSObject
/// 机构树主键
@property (nonatomic, copy) NSString *cId;
/// 机构名称
@property (nonatomic, copy) NSString *cName;
/// 孩子节点
@property (nonatomic, strong) NSMutableArray <XGCMainProPersonPersonOrgModel *> *children;
@end

NS_ASSUME_NONNULL_END
