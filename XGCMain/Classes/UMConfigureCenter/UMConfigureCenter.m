//
//  UMConfigureCenter.m
//  XGCMain_Example
//
//  Created by 凌志 on 2024/5/13.
//  Copyright © 2024 ShannonCrazy. All rights reserved.
//

#import "UMConfigureCenter.h"
//
#import <UMCommon/UMConfigure.h>

@interface UMConfigureCenter ()
@property (nonatomic, strong) NSObject <UMConfigureProtocol> *protocol;
@property (nonatomic, strong) NSHashTable <NSObject <UIApplicationDelegate> *> *objects;
@end

@implementation UMConfigureCenter

+ (UMConfigureCenter *)shareInstance {
    static UMConfigureCenter *center = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        center = [[UMConfigureCenter alloc] init];
    });
    return center;
}

- (instancetype)init {
    if (self = [super init]) {
        self.objects = [NSHashTable weakObjectsHashTable];
    }
    return self;
}

+ (void)registerProtocol:(NSObject <UMConfigureProtocol> *)protocol {
    UMConfigureCenter.shareInstance.protocol = protocol;
}

+ (void)registerModule:(NSObject<UIApplicationDelegate> *)object {
    if ([UMConfigureCenter.shareInstance.objects containsObject:object]) {
        return;
    }
    [UMConfigureCenter.shareInstance.objects addObject:object];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary<UIApplicationLaunchOptionsKey,id> *)launchOptions {
    NSObject <UMConfigureProtocol> *protocol = [UMConfigureCenter shareInstance].protocol;
    // 登录
    [UMConfigure initWithAppkey:[protocol appKey] channel:[protocol channel]];
    for (NSObject <UIApplicationDelegate> *object in self.objects) {
        if (![object respondsToSelector:_cmd]) {
            continue;
        }
        [object application:application didFinishLaunchingWithOptions:launchOptions];
    }
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    for (NSObject <UIApplicationDelegate> *object in self.objects) {
        if (![object respondsToSelector:_cmd]) {
            continue;
        }
        [object application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
    }
}

@end
