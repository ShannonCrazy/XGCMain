//
//  XGCMainProPersonListViewController.h
//  securitysystem
//
//  Created by 凌志 on 2024/1/12.
//

#import "XGCMainViewController.h"
@class XGCMainProPersonPersonModel;

NS_ASSUME_NONNULL_BEGIN

@interface XGCMainProPersonListViewController : XGCMainViewController
@property (nonatomic, strong) NSArray <XGCMainProPersonPersonModel *> *original;
@property (nonatomic, copy) void(^doneAction)(NSArray <NSString *> *deletes);
@end

NS_ASSUME_NONNULL_END
