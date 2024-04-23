//
//  XGCMediaPreviewContainerView.h
//  XGCMain_Example
//
//  Created by 凌志 on 2024/4/22.
//  Copyright © 2024 ShannonCrazy. All rights reserved.
//

#import <UIKit/UIKit.h>
//
#import "XGCMediaPreviewModel.h"
@class XGCMediaPreviewContainerView;

NS_ASSUME_NONNULL_BEGIN

@protocol XGCMediaPreviewDelegate <NSObject>
@optional
- (CGSize)mediaPreview:(XGCMediaPreviewContainerView *)preview sizeForItemAtIndexPath:(NSIndexPath *)indexPath;
@end

@interface XGCMediaPreviewContainerView : UIView

- (instancetype)initWithScrollDirection:(UICollectionViewScrollDirection)scrollDirection;
/// 代理
@property (nonatomic, weak, nullable) id <XGCMediaPreviewDelegate> delegate;
/// 对象
@property (nonatomic, weak, nullable) __kindof UIViewController *aTarget;
/// 是否可以编辑
@property (nonatomic, assign, getter=isEditable) BOOL editable;
/// 附件数组
@property (nonatomic, strong) NSMutableArray <XGCMediaPreviewModel *> *fileJsons;
/// 缩进 default UIEdgeInsetsZero.
@property (nonatomic, assign) UIEdgeInsets contentInset;
/// itemSize default : CGSizeMake(80.0, 80.0)
@property (nonatomic, assign) CGSize itemSize;
@end

NS_ASSUME_NONNULL_END
