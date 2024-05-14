//
//  XGCFileJsonViewController.h
//  XGCMain_Example
//
//  Created by 凌志 on 2024/5/13.
//  Copyright © 2024 ShannonCrazy. All rights reserved.
//

#import "XGCMainViewController.h"
// model
#import "XGCMediaPreviewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XGCFileJsonViewController : XGCMainViewController
/// Default is 4, Use in photos collectionView in XGCFileJsonViewController
/// 默认4列, XGCFileJsonViewController中的照片collectionView
@property (nonatomic, assign) NSInteger columnNumber;
/// 附件
@property (nonatomic, strong) NSMutableArray <XGCMediaPreviewModel *> *fileJson;
@end

NS_ASSUME_NONNULL_END
