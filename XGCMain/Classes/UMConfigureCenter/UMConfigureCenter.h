//
//  UMConfigureCenter.h
//  XGCMain_Example
//
//  Created by 凌志 on 2024/5/13.
//  Copyright © 2024 ShannonCrazy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol UMConfigureProtocol <NSObject>
/// 友盟Key
- (NSString *)appKey;
/// 渠道
- (NSString *)channel;
@end

@interface UMConfigureCenter : NSObject <UIApplicationDelegate>
/// 单例
@property (class, nonatomic, strong, readonly) UMConfigureCenter *shareInstance;
/// 注册友盟配置协议
/// - Parameter protocol: 协议
+ (void)registerProtocol:(NSObject <UMConfigureProtocol> *)protocol;
/// 注册模块
/// - Parameter object: 模块
+ (void)registerModule:(NSObject <UIApplicationDelegate> *)object;
@end

NS_ASSUME_NONNULL_END
