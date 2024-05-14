//
//  XGCUserNotificationCenter.h
//  XGCMain_Example
//
//  Created by 凌志 on 2024/5/11.
//  Copyright © 2024 ShannonCrazy. All rights reserved.
//

#import <Foundation/Foundation.h>
// system
#import <UserNotifications/UserNotifications.h>
@class XGCUserNotificationCenter;

NS_ASSUME_NONNULL_BEGIN

@protocol XGCUserNotificationCenterDelegate <NSObject>
/// 收到消息
/// - Parameters:
///   - center: 管理者
///   - notification: 内容
- (void)userNotificationCenter:(XGCUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification;

/// 点击消息
/// - Parameters:
///   - center: 管理者
///   - response: 内容
- (void)userNotificationCenter:(XGCUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response;
@end

@interface XGCUserNotificationCenter : NSObject
/// 单例
@property (class, nonatomic, strong, readonly) XGCUserNotificationCenter *shareInstance;
/// 是否要激活
@property (nonatomic, assign, getter=isActive) BOOL active;
/// 添加代理
/// - Parameter delegate: 代理
- (void)addDelegate:(id <XGCUserNotificationCenterDelegate>)delegate;
@end

NS_ASSUME_NONNULL_END
