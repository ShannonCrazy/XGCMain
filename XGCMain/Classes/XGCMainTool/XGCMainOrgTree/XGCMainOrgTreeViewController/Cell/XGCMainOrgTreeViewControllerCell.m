//
//  XGCMainOrgTreeViewControllerCell.m
//  XGCMain
//
//  Created by 凌志 on 2024/3/27.
//

#import "XGCMainOrgTreeViewControllerCell.h"
//
#import <Masonry/Masonry.h>
//
#import "XGCConfiguration.h"
#import "XGCMainOrgTreeModel.h"

@interface XGCMainOrgTreeViewControllerCell ()
@property (nonatomic, strong) XGCMainOrgTreeModel *model;
@property (nonatomic, strong) UIImageView *cImageView;
@property (nonatomic, strong) UILabel *cName;
@property (nonatomic, strong) UIButton *selectedButton;
@end

@implementation XGCMainOrgTreeViewControllerCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.selectedButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.contentEdgeInsets = UIEdgeInsetsMake(10.0, 20.0, 10.0, 20.0);
            [button setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
            [button setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
            [button setImage:[UIImage imageNamed:@"main_selection_n"] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"main_selection_s"] forState:UIControlStateSelected];
            [button addTarget:self action:@selector(selectedButtonTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:button];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(self.contentView);
                make.centerY.mas_equalTo(self.contentView);
            }];
            button;
        });
        self.cImageView = ({
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"main_arrow_blue_down"]];
            [self.contentView addSubview:imageView];
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.contentView).offset(20.0);
                make.centerY.mas_equalTo(self.contentView);
                make.size.mas_equalTo(imageView.image.size);
            }];
            imageView;
        });
        self.cName = ({
            UILabel *label = [[UILabel alloc] init];
            label.numberOfLines = 2;
            label.textColor = XGCCMI.labelColor;
            label.font = [UIFont systemFontOfSize:15];
            label.highlightedTextColor = XGCCMI.blueColor;
            [self.contentView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.contentView).offset(14.0);
                make.left.mas_equalTo(self.cImageView.mas_right).offset(10.0);
                make.right.mas_equalTo(self.selectedButton.mas_left);
                make.bottom.mas_equalTo(self.contentView).offset(-14.0).priorityMedium();
            }];
            label;
        });
    }
    return self;
}

- (void)setModel:(XGCMainOrgTreeModel *)model inset:(BOOL)inset {
    self.model = model;
    self.cImageView.transform = self.model.isOpen ? CGAffineTransformMakeRotation(M_PI) : CGAffineTransformIdentity;
    self.cImageView.hidden = self.model.children.count == 0 || !inset;
    self.cName.text = self.model.cName;
    self.cName.highlighted = self.model.selected;
    self.selectedButton.selected = self.model.selected;
    [self.cImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(20.0 + (inset ? 8.0 * _model.level : 0));
    }];
    self.selectedButton.hidden = !_model.enabled;
    self.contentView.backgroundColor = [XGCCMI.blackColor colorWithAlphaComponent:(_model.level * 0.05)];
}

- (void)startAnimating {
    [UIView animateWithDuration:0.25 animations:^{
        self.cImageView.transform = self.model.isOpen ? CGAffineTransformMakeRotation(M_PI) : CGAffineTransformIdentity;
    }];
}

#pragma mark action
- (void)selectedButtonTouchUpInside {
    self.selectedButtonTouchUpInsideAction ? self.selectedButtonTouchUpInsideAction(self.model) : nil;
}

@end
