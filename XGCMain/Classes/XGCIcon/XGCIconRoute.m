//
//  XGCIconRoute.m
//  XGCMain_Example
//
//  Created by 凌志 on 2024/5/13.
//  Copyright © 2024 ShannonCrazy. All rights reserved.
//

#import "XGCIconRoute.h"
//
#import "XGCIconRouteViewController.h"

@implementation XGCIconRoute

- (BOOL)canRouteURL:(NSURL *)URL withParameters:(NSDictionary<NSString *,id> *)parameters {
    return [URL.host isEqualToString:@"XGCApplication"];
}

- (__kindof UIViewController *)routeControllerForURL:(NSURL *)URL withParameters:(NSDictionary<NSString *,id> *)parameters {
    if (![URL.host isEqualToString:@"XGCApplication"]) {
        return nil;
    }
    return [[XGCIconRouteViewController alloc] initWithParameters:parameters];
}

@end
