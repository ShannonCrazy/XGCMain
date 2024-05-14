//
//  XGCIconGetRedDotNumModel.h
//  XGCMain_Example
//
//  Created by 凌志 on 2024/5/13.
//  Copyright © 2024 ShannonCrazy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XGCIconGetRedDotNumModel : NSObject
/// 我的待办(未处理红点数量)
@property (nonatomic, assign) NSInteger myAgentNum;
/// 抄送我的(未处理红点数量)
@property (nonatomic, assign) NSInteger myCopyNum;
/// 公文数量(未处理红点数量)
@property (nonatomic, assign) NSInteger officeNum;
/// 公文 - 我的收文 - 未签收数量
@property (nonatomic, assign) NSInteger officeNumUnCmpNum;
/// 公文 - 抄送我的 - 未读数量
@property (nonatomic, assign) NSInteger officeNumCsNum;
/// 工作计划数量(未处理红点数量)”
@property (nonatomic, assign) NSInteger workJhNum;
/// 工作计划数量(抄送红点数量)”
@property (nonatomic, assign) NSInteger workJhCsNum;
/// 工作计划数量(未读红点数量)”
@property (nonatomic, assign) NSInteger workJhUnCmpNum;
/// 安全检查
@property (nonatomic, assign) NSInteger checkHisNum;
/// 隐患整改
@property (nonatomic, assign) NSInteger checkTroubleHisNum;
/// 公告未读数量
@property (nonatomic, assign) NSInteger ggUnReadNum;
@end

NS_ASSUME_NONNULL_END
