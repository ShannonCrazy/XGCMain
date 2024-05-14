//
//  MobClickCenter.m
//  XGCMain_Example
//
//  Created by 凌志 on 2024/5/11.
//  Copyright © 2024 ShannonCrazy. All rights reserved.
//

#import "MobClickCenter.h"
//
#import <UMCommon/MobClick.h>

@implementation MobClickCenter

+ (void)profileSignInWithPUID:(NSString *)puid {
    [MobClick profileSignInWithPUID:puid];
}

+ (void)profileSignOff {
    [MobClick profileSignOff];
}

+ (void)beginLogPageView:(NSString *)pageName {
    [MobClick beginLogPageView:pageName];
}

+ (void)endLogPageView:(NSString *)pageName {
    [MobClick endLogPageView:pageName];
}

@end
