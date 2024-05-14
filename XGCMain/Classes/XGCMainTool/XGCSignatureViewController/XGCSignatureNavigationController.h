//
//  XGCSignatureNavigationController.h
//  XGCMain_Example
//
//  Created by 凌志 on 2024/5/13.
//  Copyright © 2024 ShannonCrazy. All rights reserved.
//

#import "XGCMainNavigationController.h"

NS_ASSUME_NONNULL_BEGIN

@interface XGCSignatureNavigationController : XGCMainNavigationController
/// 完成签名
@property (nonatomic, copy) void(^completionHandler)(NSString *signUrl);
@end

NS_ASSUME_NONNULL_END
