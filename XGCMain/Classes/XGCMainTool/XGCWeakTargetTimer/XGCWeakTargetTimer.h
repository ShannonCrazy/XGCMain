//
//  XGCWeakTargetTimer.h
//  XGCMain_Example
//
//  Created by 凌志 on 2024/5/13.
//  Copyright © 2024 ShannonCrazy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XGCWeakTargetTimer : NSObject
/**
 创建定时器，防止强引用
 
 @param ti 定时器时长
 @param aTarget 对象来引用
 @param aSelector 执行的方法
 @param userInfo 用户信息
 @param yesOrNo 是否要重复
 @return 定时器NSTimer
 */
+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(nullable id)userInfo repeats:(BOOL)yesOrNo;

/**
 创建定时器，防止强引用

 @param ti 定时器时长
 @param aTarget 对象来引用
 @param aSelector 执行的方法
 @param userInfo 用户信息
 @param yesOrNo 是否要重复
 @return 定时器NSTimer
 */
+ (NSTimer *)timerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(nullable id)userInfo repeats:(BOOL)yesOrNo;
@end

NS_ASSUME_NONNULL_END
