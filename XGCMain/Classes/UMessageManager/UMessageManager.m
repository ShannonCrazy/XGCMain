//
//  UMessageManager.m
//  XGCMain_Example
//
//  Created by 凌志 on 2024/5/11.
//  Copyright © 2024 ShannonCrazy. All rights reserved.
//

#import "UMessageManager.h"
//
#import "XGCUserNotificationCenter.h"
// 友盟
#import <UMPush/UMessage.h>
//
#import "XGCUserManager.h"
//
#import "UMConfigureCenter.h"

@interface UMessageManager ()<XGCUserNotificationCenterDelegate>
@end

@implementation UMessageManager

+ (UMessageManager *)shareInstance {
    static UMessageManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[UMessageManager alloc] init];
    });
    return manager;
}

+ (void)load {
    // 注册push
    [UMConfigureCenter registerModule:[UMessageManager shareInstance]];
}

- (instancetype)init {
    if (self = [super init]) {
        NSNotificationCenter *defaultCenter = NSNotificationCenter.defaultCenter;
        [defaultCenter addObserver:self selector:@selector(cUserLoginNotification) name:XGCUserLoginNotification object:nil];
        [defaultCenter addObserver:self selector:@selector(cUserLogoutNotification) name:XGCUserLogoutNotification object:nil];
        [defaultCenter addObserver:self selector:@selector(cUserLogoutNotification) name:XGCUserKickOutNotification object:nil];
        // 远程推送代理
        XGCUserNotificationCenter.shareInstance.active = YES;
        [XGCUserNotificationCenter.shareInstance addDelegate:self];
        // 自动弹窗
        [UMessage setAutoAlert:NO];
        // 设置是否允许SDK自动清空角标
        [UMessage setBadgeClear:NO];
    }
    return self;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary<UIApplicationLaunchOptionsKey,id> *)launchOptions {
    // 注册友盟推送
    [UMessage registerForRemoteNotificationsWithLaunchOptions:launchOptions Entity:nil completionHandler:^(BOOL granted, NSError * _Nullable error) { }];
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [UMessage registerDeviceToken:deviceToken];
}

+ (void)setBadge:(NSInteger)badge {
    [UMessage setBadge:(int)badge response:^(id  _Nullable responseObject, NSError * _Nullable error) { }];
}

#pragma mark NSNotification
- (void)cUserLoginNotification {
    XGCUserMapModel *userMap = XGCUM.cUser.userMap;
    if (!userMap) {
        return;
    }
#if DEBUG
    NSString *name = [NSString stringWithFormat:@"dev_%@", userMap.cId];
#else
    NSString *name = [NSString stringWithFormat:@"prod_%@", userMap.cId];
#endif
    [UMessage setAlias:name type:@"umeng" response:^(id  _Nullable responseObject, NSError * _Nullable error) { }];
}

- (void)cUserLogoutNotification {
    XGCUserMapModel *userMap = XGCUM.cUser.userMap;
    if (!userMap) {
        return;
    }
#if DEBUG
    NSString *name = [NSString stringWithFormat:@"dev_%@", userMap.cId];
#else
    NSString *name = [NSString stringWithFormat:@"prod_%@", userMap.cId];
#endif
    [UMessage removeAlias:name type:@"umeng" response:^(id  _Nullable responseObject, NSError * _Nullable error) { }];
    // 清空服务器角标
    [UMessage setBadge:0 response:^(id  _Nullable responseObject, NSError * _Nullable error) { }];
}

#pragma mark - XGCUserNotificationCenterDelegate
- (void)userNotificationCenter:(XGCUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification {
    [UMessage didReceiveRemoteNotification:notification.request.content.userInfo];
}

- (void)userNotificationCenter:(XGCUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response {
    // 是否是远程推送
    UNNotificationRequest *request = response.notification.request;
    if (![request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        return;
    }
    [UMessage didReceiveRemoteNotification:response.notification.request.content.userInfo];
}

@end
