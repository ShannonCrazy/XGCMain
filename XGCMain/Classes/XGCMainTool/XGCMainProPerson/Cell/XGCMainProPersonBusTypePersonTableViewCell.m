//
//  XGCMainProPersonBusTypePersonTableViewCell.m
//  securitysystem
//
//  Created by 凌志 on 2024/1/10.
//

#import "XGCMainProPersonBusTypePersonTableViewCell.h"
//
#import "XGCUserManager.h"
#import "XGCConfiguration.h"
#import "XGCImageUrlControl.h"
// model
#import "XGCMainProPersonPersonModel.h"
//
#import <Masonry/Masonry.h>

@interface XGCMainProPersonBusTypePersonTableViewCell ()
/// 选中状态
@property (nonatomic, strong) UIImageView *cImageView;
/// 头像
@property (nonatomic, strong) XGCImageUrlControl *cImageUrl;
/// 员工姓名
@property (strong, nonatomic) UILabel *cRealname;
/// 完整部门树名称
@property (strong, nonatomic) UILabel *showOrgName;
/// 角色名称
@property (strong, nonatomic) UILabel *zwCode;
@end

@implementation XGCMainProPersonBusTypePersonTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.cImageView = ({
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"main_selection_n"]];
            imageView.highlightedImage = [UIImage imageNamed:@"main_selection_s"];
            [self.contentView addSubview:imageView];
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.contentView).offset(20.0);
                make.centerY.mas_equalTo(self.contentView);
                make.size.mas_equalTo(imageView.image.size);
            }];
            imageView;
        });
        self.cImageUrl = ({
            XGCImageUrlControl *control = [[XGCImageUrlControl alloc] init];
            control.enabled = NO;
            control.layer.cornerRadius = 23.0;
            [self.contentView addSubview:control];
            [control mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.cImageView.mas_right).offset(10.0);
                make.size.mas_equalTo(CGSizeMake(46, 46));
                make.centerY.mas_equalTo(self.contentView);
            }];
            control;
        });
        self.zwCode = ({
            UILabel *label = [[UILabel alloc] init];
            label.font = [UIFont systemFontOfSize:13];
            label.textAlignment = NSTextAlignmentRight;
            label.textColor = XGCCMI.secondaryLabelColor;
            [label setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
            [label setContentCompressionResistancePriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisHorizontal];
            [self.contentView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(self.contentView).offset(-20.0);
            }];
            label;
        });
        self.cRealname = ({
            UILabel *label = [[UILabel alloc] init];
            label.textColor = XGCCMI.labelColor;
            label.font = [UIFont systemFontOfSize:16];
            [self.contentView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.contentView).offset(12.0);
                make.left.mas_equalTo(self.cImageUrl.mas_right).offset(10.0);
                make.right.mas_equalTo(self.zwCode.mas_left).offset(-10.0);
            }];
            label;
        });
        [self.zwCode mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.cRealname);
        }];
        
        self.showOrgName = ({
            UILabel *label = [[UILabel alloc] init];
            label.numberOfLines = 0;
            label.font = [UIFont systemFontOfSize:13];
            label.textColor = XGCCMI.secondaryLabelColor;
            [self.contentView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.cRealname);
                make.right.mas_equalTo(self.zwCode);
                make.top.mas_equalTo(self.cRealname.mas_bottom).offset(3.0);
                make.height.mas_greaterThanOrEqualTo(label.font.lineHeight);
                make.bottom.mas_equalTo(self.contentView).offset(-12.0).priorityMedium();
            }];
            label;
        });
        
        ({
            UIView *view = [[UIView alloc] init];
            view.backgroundColor = XGCCMI.backgroundColor;
            [self.contentView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(1.0);
                make.left.right.mas_equalTo(self.contentView);
                make.bottom.mas_equalTo(self.contentView).priorityLow();
            }];
        });
    }
    return self;
}

- (void)setModel:(XGCMainProPersonPersonModel *)model {
    _model = model;
    self.cImageView.highlighted = _model.selected;
    [self.cImageUrl setImageWithURL:[NSURL URLWithString:_model.cImageUrl] placeholder:_model.cRealname];
    self.cRealname.text = _model.cRealname;
    self.showOrgName.text = [_model.showOrgName componentsJoinedByString:@","];
    self.zwCode.text = _model.zwName;
}

@end
