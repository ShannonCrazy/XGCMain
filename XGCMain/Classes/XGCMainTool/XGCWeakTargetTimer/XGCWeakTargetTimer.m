//
//  XGCWeakTargetTimer.m
//  XGCMain_Example
//
//  Created by 凌志 on 2024/5/13.
//  Copyright © 2024 ShannonCrazy. All rights reserved.
//

#import "XGCWeakTargetTimer.h"

@interface XGCWeakTargetTimer()
// @param 对象
@property (weak, nonatomic) id aTarget;
// @param 方法
@property (assign, nonatomic) SEL aSelector;
@end

@implementation XGCWeakTargetTimer

+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(id)userInfo repeats:(BOOL)yesOrNo {
    XGCWeakTargetTimer * object = [XGCWeakTargetTimer WeakTargetWithTarget:aTarget selector:aSelector];
    return [NSTimer scheduledTimerWithTimeInterval:ti target:object selector:@selector(fire:) userInfo:userInfo repeats:yesOrNo];
}

+ (NSTimer *)timerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(id)userInfo repeats:(BOOL)yesOrNo {
    XGCWeakTargetTimer * object = [XGCWeakTargetTimer WeakTargetWithTarget:aTarget selector:aSelector];
    return [NSTimer timerWithTimeInterval:ti target:object selector:@selector(fire:) userInfo:userInfo repeats:yesOrNo];
}

+ (XGCWeakTargetTimer *)WeakTargetWithTarget:(id)aTarget selector:(SEL)aSelector {
    XGCWeakTargetTimer * object = [[XGCWeakTargetTimer alloc] init];
    object.aTarget = aTarget;
    object.aSelector = aSelector;
    return object;
}

- (void)fire:(id)object {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [self.aTarget performSelector:self.aSelector withObject:object];
#pragma clang diagnostic pop
}

@end
