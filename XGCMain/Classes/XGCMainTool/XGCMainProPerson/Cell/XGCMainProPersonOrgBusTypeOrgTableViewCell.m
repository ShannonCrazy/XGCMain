//
//  XGCMainProPersonOrgBusTypeOrgTableViewCell.m
//  securitysystem
//
//  Created by 凌志 on 2024/1/10.
//

#import "XGCMainProPersonOrgBusTypeOrgTableViewCell.h"
// model
#import "XGCMainProPersonPersonOrgModel.h"
//
#import "XGCConfiguration.h"
//
#import <Masonry/Masonry.h>

@interface XGCMainProPersonOrgBusTypeOrgTableViewCell ()
@property (nonatomic, strong) UILabel *cName;
@end

@implementation XGCMainProPersonOrgBusTypeOrgTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        UIImageView *imageView = ({
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"main_arrow_blue_right"]];
            [imageView setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
            [self.contentView addSubview:imageView];
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(self.contentView);
                make.right.mas_equalTo(self.contentView).offset(-20.0);
            }];
            imageView;
        });
        self.cName = ({
            UILabel *label = [[UILabel alloc] init];
            label.numberOfLines = 0;
            label.textColor = XGCCMI.labelColor;
            label.font = [UIFont systemFontOfSize:13];
            [self.contentView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.contentView).offset(20.0);
                make.top.mas_equalTo(self.contentView).offset(14.0);
                make.right.mas_equalTo(imageView.mas_left).offset(-10.0);
                make.height.mas_greaterThanOrEqualTo(label.font.lineHeight);
                make.bottom.mas_equalTo(self.contentView).offset(-14.0).priorityMedium();
            }];
            label;
        });
    }
    return self;
}

- (void)setModel:(XGCMainProPersonPersonOrgModel *)model {
    _model = model;
    self.cName.text = _model.cName;
}

@end
