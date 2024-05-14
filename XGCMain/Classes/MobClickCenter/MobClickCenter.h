//
//  MobClickCenter.h
//  XGCMain_Example
//
//  Created by 凌志 on 2024/5/11.
//  Copyright © 2024 ShannonCrazy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MobClickCenter : NSObject
/// 用户登录
/// - Parameter puid: 用户id
+ (void)profileSignInWithPUID:(NSString *)puid;
/// 退出登录
+ (void)profileSignOff;
/// 自动页面时长统计, 开始记录某个页面展示时长.
/// - Parameter pageName: 统计的页面名称.
+ (void)beginLogPageView:(NSString *)pageName;
/// 自动页面时长统计, 结束记录某个页面展示时长.
/// - Parameter pageName: 统计的页面名称.
+ (void)endLogPageView:(NSString *)pageName;
@end

NS_ASSUME_NONNULL_END
