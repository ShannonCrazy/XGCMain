//
//  XGCMediaPreviewCollectionViewCell.h
//  XGCMain_Example
//
//  Created by 凌志 on 2024/4/22.
//  Copyright © 2024 ShannonCrazy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XGCMediaPreviewModel;

NS_ASSUME_NONNULL_BEGIN

@interface XGCMediaPreviewCollectionViewCell : UICollectionViewCell
/// 配置数据
/// - Parameters:
///   - model: 模型
///   - editable: 是否可以编辑
- (void)setModel:(XGCMediaPreviewModel *)model editable:(BOOL)editable;
/// 图片
@property (nonatomic, strong, readonly) UIImageView *fileUrlImageView;
/// 查看详情
@property (nonatomic, copy) void (^detailButonTouchUpInsideAction)(XGCMediaPreviewCollectionViewCell *cell, XGCMediaPreviewModel *model);
/// 替换
@property (nonatomic, copy) void (^replaceButtonTouchUpInsideAction)(XGCMediaPreviewCollectionViewCell *cell, XGCMediaPreviewModel *model);
/// 删除
@property (nonatomic, copy) void (^deleteButtonTouchUpInsideAction)(XGCMediaPreviewCollectionViewCell *cell, XGCMediaPreviewModel *model);
@end

NS_ASSUME_NONNULL_END
