//
//  XGCMainFormRowDictMapCollectionViewCell.m
//  XGCMain
//
//  Created by 凌志 on 2024/1/15.
//

#import "XGCMainFormRowDictMapCollectionViewCell.h"
//
#import "XGCConfiguration.h"
#import "XGCUserDictMapModel.h"
//
#import <Masonry/Masonry.h>

@interface XGCMainFormRowDictMapCollectionViewCell ()
@property (nonatomic, strong) UIButton *cName;
@end

@implementation XGCMainFormRowDictMapCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.cName = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.userInteractionEnabled = NO;
            button.imageView.layer.masksToBounds = NO;
            button.titleLabel.font = [UIFont systemFontOfSize:13];
            button.imageView.contentMode = UIViewContentModeCenter;
            button.titleEdgeInsets = UIEdgeInsetsMake(0, 10.0, 0, -10.0);
            [button setTitleColor:XGCCMI.labelColor forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"main_xuanze_n"] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"main_xuanze_s"] forState:UIControlStateSelected];
            [self.contentView addSubview:button];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(self.contentView);
            }];
            button;
        });
    }
    return self;
}

- (void)setModel:(XGCUserDictMapModel *)model {
    _model = model;
    self.cName.selected = _model.selected;
    [self.cName setTitle:_model.cName forState:UIControlStateNormal];
}

- (void)setContentEdgeInsets:(UIEdgeInsets)contentEdgeInsets {
    _contentEdgeInsets = contentEdgeInsets;
    self.cName.contentEdgeInsets = UIEdgeInsetsMake(_contentEdgeInsets.top, 0, _contentEdgeInsets.bottom, 10);
}

- (void)setSelected:(BOOL)selected { }

- (void)setHighlighted:(BOOL)highlighted { }

@end
