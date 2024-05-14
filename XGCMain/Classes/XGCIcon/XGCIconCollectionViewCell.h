//
//  XGCIconCollectionViewCell.h
//  XGCMain_Example
//
//  Created by 凌志 on 2024/5/13.
//  Copyright © 2024 ShannonCrazy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XGCMenuDataModel;

NS_ASSUME_NONNULL_BEGIN

@interface XGCIconCollectionViewCell : UICollectionViewCell
/// 高度
@property (class, assign, readonly) CGFloat height;
/// 名称
@property (nonatomic, strong, readonly) UILabel *cName;
/// 图片
@property (nonatomic, strong, readonly) UIImageView *cImageUrl;

/// 图标名字
@property (nonatomic, copy) NSString *imageNamed;
/// 角标
@property (nonatomic, assign) NSUInteger badgeValue;
@end

@interface XGCIconReusableView : UICollectionReusableView
/// 名称
@property (nonatomic, strong) UILabel *cName;
@end

@interface XGCIconLayer : CALayer

@end
NS_ASSUME_NONNULL_END
