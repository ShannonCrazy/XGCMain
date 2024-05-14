//
//  XGCSelectionControl.h
//  XGCMain_Example
//
//  Created by 凌志 on 2024/5/13.
//  Copyright © 2024 ShannonCrazy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XGCSelectionControl : UIControl
@property (nullable, nonatomic, copy) NSString *placeholder;// default is nil. string is drawn 70% gray
@property (nullable, nonatomic, copy) NSAttributedString *attributedPlaceholder; // default is nil
@property (nullable, nonatomic, strong) UIFont *font;// default is nil. use system font 13 pt
@property (nonatomic, assign) CGFloat cornerRadius; // detault UITableViewAutomaticDimension (高度的一半)
@property (nonatomic, assign) UIEdgeInsets contentEdgeInsets; // default UIEdgeInsetsMake(8.0, 15.0, 8.0, 15.0)
@property (nonatomic, assign) CGFloat imagePadding; // default 10.0
@property (nonatomic, strong, nullable) UIImage *defaultImage; // 默认图片
- (void)setTitle:(nullable NSString *)title forState:(UIControlState)state; // default is nil
- (void)setTitleColor:(nullable UIColor *)color forState:(UIControlState)state; // default is nil
- (void)setImage:(nullable UIImage *)image forState:(UIControlState)state;
@end

NS_ASSUME_NONNULL_END
