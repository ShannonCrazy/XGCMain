//
//  XGCMainProPersonViewController.m
//  securitysystem
//
//  Created by 凌志 on 2024/1/9.
//

#import "XGCMainProPersonViewController.h"
// viewController
#import "XGCMainProPersonListViewController.h"
#import "XGCMainProPersonBusTypeViewController.h"
//
#import "XGCURLSession.h"
#import "UIView+XGCView.h"
#import "XGCConfiguration.h"
#import "XGCSearchTextField.h"
#import "XGCPageViewManager.h"
#import "NSString+XGCString.h"
#import "XGCSegmentedControl.h"
// view
#import <Masonry/Masonry.h>
#import <MJExtension/MJExtension.h>
#import <M13OrderedDictionary/M13OrderedDictionary.h>

@interface XGCMainProPersonViewController ()<XGCPageViewDelegate, XGCMainProPersonBusTypeDelegate>
@property (nonatomic, strong) XGCSearchTextField *searchVal;
@property (nonatomic, strong) XGCSegmentedControl *segmentedControl;
@property (nonatomic, strong) UIButton *selectTotalButton;
@property (nonatomic, strong) UIButton *doneButton;
@property (nonatomic, strong) UIButton *numberButton;
@property (nonatomic, strong) NSMutableArray <XGCMainProPersonBusTypeViewController *> *viewControllers;
@property (nonatomic, strong) XGCPageViewManager *pageViewManager;
@property (nonatomic, strong) M13MutableOrderedDictionary <NSString *, XGCMainProPersonPersonModel *> *maps;
@end

@implementation XGCMainProPersonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"选择人员";
    self.maps = [M13MutableOrderedDictionary orderedDictionary];
    
    UIView *containerView = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = XGCCMI.whiteColor;
        [self.view addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self.view);
            make.top.mas_equalTo(self.mas_topLayoutGuideBottom);
        }];
        view;
    });
    UIButton *allFlag = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.selected = YES;
        button.titleLabel.font = [UIFont systemFontOfSize:13];
        [button setTitle:@"包含子集" forState:UIControlStateNormal];
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 5.0, 0, -5.0);
        button.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 20.0);
        [button setTitleColor:XGCCMI.labelColor forState:UIControlStateNormal];
        [button setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [button setImage:[UIImage imageNamed:@"main_selection_n"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"main_selection_s"] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(allFlagButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [containerView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(30.0);
            make.right.mas_equalTo(containerView);
            make.top.mas_equalTo(containerView).offset(10.0);
        }];
        button;
    });
    self.searchVal = ({
        XGCSearchTextField *textField = [[XGCSearchTextField alloc] init];
        textField.placeholder = @"请输入姓名搜索";
        [textField addTarget:self action:@selector(UITextFieldTextDidChangeAction:) forControlEvents:UIControlEventEditingChanged];
        [containerView addSubview:textField];
        [textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(30.0);
            make.right.mas_equalTo(allFlag.mas_left);
            make.top.mas_equalTo(containerView).offset(10.0);
            make.left.mas_equalTo(containerView).offset(20.0);
        }];
        textField;
    });
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.searchVal.mas_bottom).offset(10.0);
    }];
    
    UIView *toolBar = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = XGCCMI.whiteColor;
        [self.view addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(self.view);
            make.top.mas_equalTo(self.mas_bottomLayoutGuideTop).offset(-48.0);
        }];
        view;
    });
    if (self.allowsMultipleSelection) {
        self.selectTotalButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.titleLabel.font = [UIFont systemFontOfSize:13];
            [button setTitle:@"全选" forState:UIControlStateNormal];
            button.titleEdgeInsets = UIEdgeInsetsMake(0, 5.0, 0, -5.0);
            button.contentEdgeInsets = UIEdgeInsetsMake(10.0, 20.0, 10.0, 25.0);
            [button setTitleColor:XGCCMI.blueColor forState:UIControlStateNormal];
            [button setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
            [button setImage:[UIImage imageNamed:@"main_selection_n"] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"main_selection_s"] forState:UIControlStateSelected];
            [button addTarget:self action:@selector(selectTotalButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
            [toolBar addSubview:button];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(toolBar);
                make.centerY.mas_equalTo(toolBar.mas_top).offset(24.0);
            }];
            button;
        });
    }
    self.doneButton = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.layer.cornerRadius = 5.0;
        button.backgroundColor = XGCCMI.buttonTintColor;
        button.titleLabel.font = [UIFont systemFontOfSize:16];
        [button setTitle:@"确定" forState:UIControlStateNormal];
        button.contentEdgeInsets = UIEdgeInsetsMake(10.0, 20.0, 10.0, 20.0);
        [button setTitleColor:XGCCMI.whiteColor forState:UIControlStateNormal];
        [button setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [button addTarget:self action:@selector(doneButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [toolBar addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(toolBar).offset(-20.0);
            make.centerY.mas_equalTo(toolBar.mas_top).offset(24.0);
        }];
        button;
    });
    self.numberButton = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font = [UIFont systemFontOfSize:13];
        button.contentEdgeInsets = UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0);
        [button setTitleColor:XGCCMI.blueColor forState:UIControlStateNormal];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [button addTarget:self action:@selector(numberButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [toolBar addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.doneButton.mas_left);
            make.centerY.mas_equalTo(self.doneButton);
            make.left.mas_equalTo(self.selectTotalButton ? self.selectTotalButton.mas_right : toolBar.mas_left);
        }];
        button;
    });
    
    self.viewControllers = [NSMutableArray array];
    [self.busTypes enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        XGCMainProPersonBusTypeViewController *viewController = [[XGCMainProPersonBusTypeViewController alloc] init];
        viewController.busType = obj;
        viewController.delegate = self;
        viewController.orgIdList = self.orgIdList;
        [self.viewControllers addObject:viewController];
    }];
    
    MASViewAttribute *topAttribute = containerView.mas_bottom;
    if (self.busTypes.count > 1) {
        __weak typeof(self) this = self;
        self.segmentedControl = ({
            XGCSegmentedControl *control = [[XGCSegmentedControl alloc] init];
            control.minimumSpacing = 12.0;
            control.indicatorColor = XGCCMI.blueColor;
            control.backgroundColor = UIColor.whiteColor;
            control.textColor = XGCCMI.tertiaryLabelColor;
            control.highlightedTextColor = XGCCMI.labelColor;
            control.numberOfItemsInSegmented = ^NSInteger(XGCSegmentedControl * _Nonnull segmentedControl) {
                return this.pageViewManager.viewControllers.count;
            };
            control.titleForSegmentedInItem = ^NSString * _Nonnull(XGCSegmentedControl * _Nonnull segmentedControl, NSInteger item) {
                return this.pageViewManager.viewControllers[item].description;
            };
            control.didSelectItemInSegmented = ^(XGCSegmentedControl * _Nonnull segmentedControl, NSInteger item) {
                [this.pageViewManager setSelectedPageIndex:item animated:YES completion:nil];
            };
            [self.view addSubview:control];
            [control mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(self.view);
                make.top.mas_equalTo(containerView.mas_bottom);
            }];
            control;
        });
        topAttribute = self.segmentedControl.mas_bottom;
    }
    
    self.pageViewManager = ({
        XGCPageViewManager *manager = [[XGCPageViewManager alloc] init];
        manager.delegate = self;
        manager.viewControllers = self.viewControllers;
        [manager didMoveToParentViewController:self];
        [manager.pageViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(toolBar.mas_top).offset(-0.5);
            make.left.right.mas_equalTo(self.view);
            make.top.mas_equalTo(topAttribute).offset(0.5);
        }];
        manager;
    });
    
    [self beginRequest];
}

- (void)beginRequest {
    if (self.userIdList.count == 0) {
        [self.pageViewManager setSelectedPageIndex:0 animated:YES completion:nil];
        return;
    }
    __weak typeof(self) this = self;
    [self.view startAnimating];
    NSDictionary *parameters = [NSDictionary dictionaryWithObject:self.userIdList forKey:@"userIdList"];
    [XGCURLSession POST:@"proPersonAdmin/selectDataByUserId" parameters:parameters aTarget:self callback:^(id  _Nullable responseObject, NSError * _Nullable error) {
        [this.view stopAnimating];
        if (responseObject) {
            NSMutableArray <XGCMainProPersonPersonModel *> *temps = [XGCMainProPersonPersonModel mj_objectArrayWithKeyValuesArray:responseObject];
            [temps enumerateObjectsUsingBlock:^(XGCMainProPersonPersonModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                obj.selected = YES;
                [this.maps setObject:obj forKey:obj.cUserId];
            }];
            [this setNeedsUpdatesNumberButton];
            // 
            NSUInteger selectedPageIndex = [this.cWorkStatus isEqualToString:@"1"] ? 1 : 0;
            [this.pageViewManager setSelectedPageIndex:selectedPageIndex animated:YES completion:nil];
        } else {
            [this.view makeToast:error.localizedDescription position:XGCToastViewPositionCenter];
        }
    }];
}

#pragma mark - action
- (void)allFlagButtonTouchUpInside:(UIButton *)sender {
    sender.selected = !sender.selected;
    [self.viewControllers enumerateObjectsUsingBlock:^(XGCMainProPersonBusTypeViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.allFlag = sender.selected ? @"1" : @"0";
    }];
}

- (void)UITextFieldTextDidChangeAction:(XGCSearchTextField *)textField {
    if (textField.markedTextRange) {
        return;
    }
    [self.viewControllers enumerateObjectsUsingBlock:^(XGCMainProPersonBusTypeViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.searchVal = [textField.text removeWhitespace];
    }];
}

- (void)selectTotalButtonTouchUpInside:(UIButton *)sender {
    XGCMainProPersonBusTypeViewController *viewController = [self.viewControllers objectAtIndex:self.pageViewManager.selectedPageIndex];
    if (viewController.personData.count == 0) {
        return;
    }
    sender.selected = !sender.selected;
    [viewController.personData enumerateObjectsUsingBlock:^(XGCMainProPersonPersonModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.selected = sender.selected;
        obj.selected ? [self.maps setObject:obj forKey:obj.cUserId] : [self.maps removeObjectForKey:obj.cUserId];
    }];
    [viewController reloadData];
    [self setNeedsUpdatesNumberButton];
}

- (void)doneButtonTouchUpInside:(UIButton *)sender {
    self.didFinishPickingPersonalsHandle ? self.didFinishPickingPersonalsHandle(self.maps.allObjects) : nil;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)numberButtonTouchUpInside:(UIButton *)sender {
    XGCMainProPersonListViewController *controller = [[XGCMainProPersonListViewController alloc] init];
    controller.original = self.maps.allObjects;
    __weak typeof(self) this = self;
    controller.doneAction = ^(NSArray <NSString *> * _Nonnull deletes) {
        [this.maps removeObjectsForKeys:deletes];
        [this setNeedsUpdatesNumberButton];
        // 子控制器
        NSArray <NSString *> *allKeys = this.maps.allKeys;
        [this.viewControllers enumerateObjectsUsingBlock:^(XGCMainProPersonBusTypeViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj.personData enumerateObjectsUsingBlock:^(XGCMainProPersonPersonModel * _Nonnull obj1, NSUInteger idx1, BOOL * _Nonnull stop1) {
                obj1.selected = [allKeys containsObject:obj1.cUserId];
            }];
            [obj reloadData];
        }];
        // 全选
        [this setNeedsUpdatesSelectTotalButtonSelected];
    };
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - <XGCPageViewDelegate>
- (void)pageViewManager:(XGCPageViewManager *)pageViewManager didShowViewController:(__kindof UIViewController *)viewController {
    [self.segmentedControl setSelectedSegmentIndex:pageViewManager.selectedPageIndex animated:YES];
}

#pragma mark - XGCMainProPersonBusTypeDelegate
- (void)viewController:(XGCMainProPersonBusTypeViewController *)viewController refreshAction:(NSArray<XGCMainProPersonPersonModel *> *)personData {
    NSArray <NSString *> *allKeys = self.maps.allKeys;
    [personData enumerateObjectsUsingBlock:^(XGCMainProPersonPersonModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.selected = [allKeys containsObject:obj.cUserId];
    }];
    [self setNeedsUpdatesSelectTotalButtonSelected];
}

- (void)viewController:(XGCMainProPersonBusTypeViewController *)viewController didSelectRowAtPerson:(XGCMainProPersonPersonModel *)person {
    if (!self.allowsMultipleSelection) {
        [self.maps removeAllObjects];
        [viewController.personData enumerateObjectsUsingBlock:^(XGCMainProPersonPersonModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (![obj isEqual:person]) {
                obj.selected = NO;
            }
        }];
    }
    person.selected = !person.selected;
    person.selected ? [self.maps setObject:person forKey:person.cUserId] : [self.maps removeObjectForKey:person.cUserId];
    // 更新数量
    [self setNeedsUpdatesNumberButton];
    // 更新全选按钮状态
    [self setNeedsUpdatesSelectTotalButtonSelected];
}

- (void)viewController:(XGCMainProPersonBusTypeViewController *)viewController viewWillAppear:(NSArray<XGCMainProPersonPersonModel *> *)personData {
    // 全选
    [self setNeedsUpdatesSelectTotalButtonSelected];
}

#pragma mark func
- (void)setNeedsUpdatesSelectTotalButtonSelected {
    XGCMainProPersonBusTypeViewController *viewController = self.viewControllers[self.pageViewManager.selectedPageIndex];
    __block BOOL selected = viewController.personData.count > 0 ? YES : NO;
    [viewController.personData enumerateObjectsUsingBlock:^(XGCMainProPersonPersonModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        *stop = !(selected = obj.selected);
    }];
    self.selectTotalButton.selected = selected;
}

- (void)setNeedsUpdatesNumberButton {
    [self.numberButton setTitle:[NSString stringWithFormat:@"已选%zd人", self.maps.count] forState:UIControlStateNormal];
}

@end
