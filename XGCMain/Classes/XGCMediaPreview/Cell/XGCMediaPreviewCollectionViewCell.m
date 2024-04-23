//
//  XGCMediaPreviewCollectionViewCell.m
//  XGCMain_Example
//
//  Created by 凌志 on 2024/4/22.
//  Copyright © 2024 ShannonCrazy. All rights reserved.
//

#import "XGCMediaPreviewCollectionViewCell.h"
//
#import "XGCConfiguration.h"
#import "UIImage+XGCImage.h"
#import "NSString+XGCString.h"
//
#import <Masonry/Masonry.h>
#import <SDWebImage/UIImageView+WebCache.h>
//
#import "XGCMediaPreviewModel.h"

@interface XGCMediaPreviewCollectionViewCell ()
/// 附件
@property (nonatomic, strong) XGCMediaPreviewModel *model;
/// 是否可以编辑
@property(nonatomic, assign, getter=isEditable) BOOL editable;
/// 图片
@property (nonatomic, strong, readwrite) UIImageView *fileUrl;
/// 流水布局
@property (nonatomic, strong) UIStackView *stackView;
/// 图标
@property (nonatomic, strong) UIImageView *iconImageView;
/// 名称
@property (nonatomic, strong) UILabel *fileName;
/// 点击操作View
@property (nonatomic, strong) UIView *containerView;
/// 查看详情
@property (nonatomic, strong) UIButton *detailButon;
/// 替换
@property (nonatomic, strong) UIButton *replaceButton;
/// 删除
@property (nonatomic, strong) UIButton *deleteButton;
@end

@implementation XGCMediaPreviewCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.contentView.backgroundColor = XGCCMI.whiteColor;
        self.fileUrl = ({
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.layer.cornerRadius = 6.0;
            imageView.layer.masksToBounds = YES;
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            [self.contentView addSubview:imageView];
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(self.contentView);
            }];
            imageView;
        });
        self.iconImageView = ({
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView;
        });
        self.fileName = ({
            UILabel *label = [[UILabel alloc] init];
            label.textColor = XGCCMI.labelColor;
            label.font = [UIFont systemFontOfSize:13];
            label.textAlignment = NSTextAlignmentCenter;
            label;
        });
        self.stackView = ({
            UIStackView *stackView = [[UIStackView alloc] initWithArrangedSubviews:@[self.iconImageView, self.fileName]];
            stackView.spacing = 8.0;
            stackView.axis = UILayoutConstraintAxisVertical;
            stackView.alignment = UIStackViewAlignmentCenter;
            [self.contentView addSubview:stackView];
            [stackView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(self.contentView);
                make.left.mas_equalTo(self.contentView).offset(5.0);
                make.right.mas_equalTo(self.contentView).offset(-5.0);
            }];
            stackView;
        });
        self.contentView.layer.borderWidth = 1.0;
        self.contentView.layer.cornerRadius = 6.0;
        self.contentView.layer.borderColor = XGCCMI.backgroundColor.CGColor;
        
        self.containerView = ({
            UIView *view = [[UIView alloc] init];
            view.hidden = YES;
            view.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.2];
            [self.contentView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(self.contentView);
            }];
            view;
        });
        self.detailButon = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.imageView.contentMode = UIViewContentModeScaleAspectFit;
            [button addTarget:self action:@selector(detailButonTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
            [button setImage:[UIImage imageNamed:@"main_amplify" inResource:@"XGCMain"] forState:UIControlStateNormal];
            [self.containerView addSubview:button];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.right.mas_equalTo(self.containerView);
                make.bottom.mas_equalTo(self.containerView.mas_centerY);
            }];
            button;
        });
        self.replaceButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button addTarget:self action:@selector(replaceButtonTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
            [button setImage:[UIImage imageNamed:@"main_replace" inResource:@"XGCMain"] forState:UIControlStateNormal];
            [self.containerView addSubview:button];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.bottom.mas_equalTo(self.containerView);
                make.top.mas_equalTo(self.containerView.mas_centerY);
                make.right.mas_equalTo(self.containerView.mas_centerX);
            }];
            button;
        });
        self.deleteButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button addTarget:self action:@selector(deleteButtonTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
            [button setImage:[UIImage imageNamed:@"main_delete" inResource:@"XGCMain"] forState:UIControlStateNormal];
            [self.containerView addSubview:button];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.bottom.mas_equalTo(self.containerView);
                make.top.mas_equalTo(self.containerView.mas_centerY);
                make.left.mas_equalTo(self.containerView.mas_centerX);
            }];
            button;
        });
    }
    return self;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    self.contentView.layer.borderColor = selected ? XGCCMI.blueColor.CGColor : XGCCMI.backgroundColor.CGColor;
    if (!self.isEditable) {
        return;
    }
    self.containerView.hidden = !selected;
}

#pragma mark get
- (UIImageView *)fileUrlImageView {
    return self.fileUrl;
}

#pragma mark action
- (void)detailButonTouchUpInside {
    self.detailButonTouchUpInsideAction ? self.detailButonTouchUpInsideAction(self, self.model) : nil;
}

- (void)replaceButtonTouchUpInside {
    self.replaceButtonTouchUpInsideAction ? self.replaceButtonTouchUpInsideAction(self, self.model) : nil;
}

- (void)deleteButtonTouchUpInside {
    self.deleteButtonTouchUpInsideAction ? self.deleteButtonTouchUpInsideAction(self, self.model) : nil;
}

- (void)setModel:(XGCMediaPreviewModel *)model editable:(BOOL)editable {
    self.model = model;
    self.editable = editable;
    //
    BOOL flag = [self.model.suffix isImageFormat] || self.model.image;
    self.fileUrl.hidden = !(self.stackView.hidden = flag);
    if (self.model.image) {
        self.fileUrl.image = self.model.image;
    } else if ([self.model.suffix isImageFormat]) {
        [self.fileUrl sd_setImageWithURL:[NSURL URLWithString:self.model.fileUrl]];
    } else if ([self.model.suffix isWordFormat]) {
        self.iconImageView.image = [UIImage imageNamed:@"main_word" inResource:@"XGCMain"];
    } else if ([self.model.suffix isExcelFormat]) {
        self.iconImageView.image = [UIImage imageNamed:@"main_excel" inResource:@"XGCMain"];
    } else if ([self.model.suffix isPdfFormat]) {
        self.iconImageView.image = [UIImage imageNamed:@"main_pdf" inResource:@"XGCMain"];
    } else if ([self.model.suffix isArchiveFormat]) {
        if ([self.model.suffix isEqualToString:@"rar"]) {
            self.iconImageView.image = [UIImage imageNamed:@"main_rar" inResource:@"XGCMain"];
        } else if ([self.model.suffix isEqualToString:@"zip"]) {
            self.iconImageView.image = [UIImage imageNamed:@"main_zip" inResource:@"XGCMain"];
        }
    } else if ([self.model.suffix isVideoFormat] || [self.model.fileUrl isVideoFormat]) {
        self.iconImageView.image = [UIImage imageNamed:@"main_video" inResource:@"XGCMain"];
    }
    self.fileName.text = self.model.fileName;
}

@end
