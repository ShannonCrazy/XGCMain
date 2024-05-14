//
//  XGCMainOrgTreeTableViewCell.m
//  XGCMain
//
//  Created by 凌志 on 2024/3/27.
//

#import "XGCMainOrgTreeTableViewCell.h"
// model
#import "XGCConfiguration.h"
#import "XGCMainOrgTreeModel.h"
//
#import <Masonry/Masonry.h>

@implementation XGCMainOrgTreeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.cImageView = ({
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"main_selection_n"]];
            imageView.highlightedImage = [UIImage imageNamed:@"main_selection_s"];
            [self.contentView addSubview:imageView];
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(self.contentView).offset(-20.0);
                make.centerY.mas_equalTo(self.contentView);
                make.size.mas_equalTo(imageView.image.size);
            }];
            imageView;
        });
        self.cName = ({
            UILabel *label = [[UILabel alloc] init];
            label.numberOfLines = 2;
            label.textColor = XGCCMI.labelColor;
            label.font = [UIFont systemFontOfSize:13];
            label.highlightedTextColor = XGCCMI.blueColor;
            [self.contentView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.contentView).offset(14.0);
                make.left.mas_equalTo(self.contentView).offset(20.0);
                make.right.mas_equalTo(self.cImageView.mas_left).offset(-10.0);
                make.bottom.mas_equalTo(self.contentView).offset(-14.0).priorityMedium();
            }];
            label;
        });
    }
    return self;
}

- (void)setModel:(XGCMainOrgTreeModel *)model {
    _model = model;
    self.cName.text = _model.cName;
    self.cName.highlighted = _model.selected;
    self.cImageView.highlighted = _model.selected;
    [self.cName mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(20.0 + 8.0 * _model.level);
    }];
    self.cImageView.hidden = !_model.enabled;
    self.cName.textColor = _model.enabled ? XGCCMI.labelColor : XGCCMI.placeholderTextColor;
    self.contentView.backgroundColor = [XGCCMI.blackColor colorWithAlphaComponent:(_model.level * 0.05)];
}

@end
