//
//  XGCIconCollectionViewCell.m
//  XGCMain_Example
//
//  Created by 凌志 on 2024/5/13.
//  Copyright © 2024 ShannonCrazy. All rights reserved.
//

#import "XGCIconCollectionViewCell.h"
//
#import "XGCMenuDataModel.h"
#import "XGCConfiguration.h"
//
#import <Masonry/Masonry.h>

@interface XGCIconCollectionViewCell ()
/// 名称
@property (nonatomic, strong, readwrite) UILabel *cName;
/// 图片
@property (nonatomic, strong, readwrite) UIImageView *cImageUrl;
/// 红点
@property (nonatomic, strong) UIButton *badgeValueButton;
@end

@implementation XGCIconCollectionViewCell

+ (CGFloat)height {
    return 9.0 + 44.0 + 8.0 + [UIFont systemFontOfSize:13].lineHeight * 2;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.cImageUrl = ({
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.contentMode = UIViewContentModeCenter;
            [self.contentView addSubview:imageView];
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(self.contentView);
                make.top.mas_equalTo(self.contentView).offset(9.0);
                make.size.mas_greaterThanOrEqualTo(CGSizeMake(44.0, 44.0));
            }];
            imageView;
        });
        self.cName = ({
            UILabel *label = [[UILabel alloc] init];
            label.numberOfLines = 2;
            label.font = [UIFont systemFontOfSize:13];
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = XGCCMI.labelColor;
            [self.contentView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.contentView).offset(5.0);
                make.right.mas_equalTo(self.contentView).offset(-5.0);
                make.top.mas_equalTo(self.cImageUrl.mas_bottom).offset(8.0);
            }];
            label;
        });
        self.badgeValueButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.enabled = NO;
            button.layer.cornerRadius = 9.0;
            button.backgroundColor = UIColor.redColor;
            button.titleLabel.font = [UIFont systemFontOfSize:13.0];
            button.contentEdgeInsets = UIEdgeInsetsMake(0, 5.0, 0, 5.0);
            [button setTitleColor:XGCCMI.whiteColor forState:UIControlStateNormal];
            [button setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
            [self.contentView addSubview:button];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(self.cImageUrl.mas_right).offset(-2.0);
                make.centerY.mas_equalTo(self.cImageUrl.mas_top).offset(2.0);
                make.width.mas_greaterThanOrEqualTo(18.0);
                make.height.mas_equalTo(18.0);
            }];
            button;
        });
    }
    return self;
}

- (void)setImageNamed:(NSString *)imageNamed {
    _imageNamed = imageNamed;
    self.cImageUrl.image = [UIImage imageNamed:_imageNamed] ?: [UIImage imageNamed:@"main_icon_default"];
}

- (void)setBadgeValue:(NSUInteger)badgeValue {
    _badgeValue = badgeValue;
    self.badgeValueButton.hidden = _badgeValue == 0;
    [self.badgeValueButton setTitle:(_badgeValue > 99 ? @"99+" : @(_badgeValue).description) forState:UIControlStateNormal];
}

@end

@interface XGCIconReusableView ()
@end

@implementation XGCIconReusableView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.cName = ({
            UILabel *label = [[UILabel alloc] init];
            label.numberOfLines = 2;
            label.font = [UIFont boldSystemFontOfSize:16];
            label.textColor = XGCCMI.labelColor;
            [self addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self).offset(20.0);
                make.right.mas_equalTo(self).offset(-20.0);
                make.top.mas_equalTo(self).offset(10.0);
            }];
            label;
        });
    }
    return self;
}

+ (Class)layerClass {
    if (@available(iOS 11.0, *)) {
        return [XGCIconLayer class];
    } else {
        return [super layerClass];
    }
}

@end

@implementation XGCIconLayer

- (CGFloat)zPosition {
    return 0;
}

@end
