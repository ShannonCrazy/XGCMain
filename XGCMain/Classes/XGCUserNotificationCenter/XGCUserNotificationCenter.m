//
//  XGCUserNotificationCenter.m
//  XGCMain_Example
//
//  Created by 凌志 on 2024/5/11.
//  Copyright © 2024 ShannonCrazy. All rights reserved.
//

#import "XGCUserNotificationCenter.h"

@interface XGCUserNotificationCenter ()<UNUserNotificationCenterDelegate>
/// 代理对象
@property (nonatomic, strong) NSHashTable <id <XGCUserNotificationCenterDelegate>> *delegates;
@end

@implementation XGCUserNotificationCenter

+ (XGCUserNotificationCenter *)shareInstance {
    static XGCUserNotificationCenter *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[XGCUserNotificationCenter alloc] init];
    });
    return manager;
}

- (instancetype)init {
    if (self = [super init]) {
        self.delegates = [NSHashTable weakObjectsHashTable];
    }
    return self;
}

- (void)setActive:(BOOL)active {
    _active = active;
    [UNUserNotificationCenter currentNotificationCenter].delegate = _active ? self : nil;
}

- (void)addDelegate:(id<XGCUserNotificationCenterDelegate>)delegate {
    if (!delegate || [self.delegates containsObject:delegate]) {
        return;
    }
    [self.delegates addObject:delegate];
}

#pragma mark - UNUserNotificationCenterDelegate
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    for (id <XGCUserNotificationCenterDelegate> delegate in self.delegates) {
        if (![delegate respondsToSelector:@selector(userNotificationCenter:willPresentNotification:)]) {
            continue;
        }
        [delegate userNotificationCenter:self willPresentNotification:notification];
    }
    completionHandler ? completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert) : nil;
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
    for (id <XGCUserNotificationCenterDelegate> delegate in self.delegates) {
        if (![delegate respondsToSelector:@selector(userNotificationCenter:didReceiveNotificationResponse:)]) {
            continue;
        }
        [delegate userNotificationCenter:self didReceiveNotificationResponse:response];
    }
    completionHandler ? completionHandler() : nil;
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center openSettingsForNotification:(UNNotification *)notification {
}

@end
