//
//  XGCMainOrgTreeViewController.m
//  XGCMain
//
//  Created by 凌志 on 2024/3/27.
//

#import "XGCMainOrgTreeViewController.h"
//
#import "XGCConfiguration.h"
#import "XGCSearchTextField.h"
#import "XGCPageViewManager.h"
#import "XGCSegmentedControl.h"
//
#import "XGCMainOrgTreeViewTypeController.h"
//
#import <Masonry/Masonry.h>
#import <M13OrderedDictionary/M13OrderedDictionary.h>

@interface XGCMainOrgTreeViewController ()<XGCPageViewDelegate>
@property (nonatomic, strong) NSMutableArray <XGCMainOrgTreeViewTypeController *> *viewControllers;
@property (nonatomic, strong) XGCSegmentedControl *segmentedControl;
@property (nonatomic, strong) XGCPageViewManager *pageViewManager;
// 选中的数据
@property (nonatomic, strong) M13MutableOrderedDictionary <NSString *, XGCMainOrgTreeModel *> *maps;
@end

@implementation XGCMainOrgTreeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 确定按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(confirm)];
    // 字典
    self.maps = [M13MutableOrderedDictionary orderedDictionary];
    // 子项
    self.viewControllers = [NSMutableArray array];
    [self.busTypes enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        XGCMainOrgTreeViewTypeController *viewController = [[XGCMainOrgTreeViewTypeController alloc] init];
        viewController.busType = obj;
        viewController.orgIdList = self.orgIdList;
        viewController.onlyChild = self.onlyChild;
        viewController.enabledBusTypes = self.enabledBusTypes;
        viewController.cIds = self.allowsMultipleSelection ? self.cIds : nil;
        __weak typeof(self) this = self;
        viewController.didSelectRowAtOrgTreeAction = ^(XGCMainOrgTreeModel * _Nonnull model) {
            [this didSelectRowAtOrgTree:model];
        };
        viewController.afterRequestAction = ^(NSMutableDictionary<NSString *,XGCMainOrgTreeModel *> * _Nonnull maps) {
            [this afterRequest:maps];
        };
        [self.viewControllers addObject:viewController];
    }];
    // 请求数据
    [self.viewControllers enumerateObjectsUsingBlock:^(XGCMainOrgTreeViewTypeController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj beginRequest];
    }];
    // UI
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
    XGCSearchTextField *textField = ({
        XGCSearchTextField *textField = [[XGCSearchTextField alloc] init];
        textField.placeholder = @"请输入名称搜索";
        [textField addTarget:self action:@selector(UITextFieldTextDidChangeAction:) forControlEvents:UIControlEventEditingChanged];
        [containerView addSubview:textField];
        [textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(containerView).offset(10.0);
            make.left.mas_equalTo(containerView).offset(20.0);
            make.right.mas_equalTo(containerView).offset(-20.0);
            make.height.mas_equalTo(30.0);
        }];
        textField;
    });
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(textField).offset(10.0);
    }];
    MASViewAttribute *attribute = containerView.mas_bottom;
    if (self.viewControllers.count > 1) {
        self.segmentedControl = ({
            XGCSegmentedControl *control = [[XGCSegmentedControl alloc] init];
            control.minimumSpacing = 12.0;
            control.indicatorColor = XGCCMI.blueColor;
            control.backgroundColor = XGCCMI.whiteColor;
            control.textColor = XGCCMI.tertiaryLabelColor;
            control.highlightedTextColor = XGCCMI.labelColor;
            __weak typeof(self) this = self;
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
                make.top.mas_equalTo(attribute).offset(1.0);
            }];
            control;
        });
        attribute = self.segmentedControl.mas_bottom;
    }
    self.pageViewManager = ({
        XGCPageViewManager *manager = [[XGCPageViewManager alloc] init];
        manager.delegate = self;
        manager.viewControllers = self.viewControllers;
        [manager didMoveToParentViewController:self];
        [manager.pageViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(self.view);
            make.top.mas_equalTo(attribute).offset(1.0);
        }];
        manager;
    });
    [self.pageViewManager setSelectedPageIndex:0 animated:YES completion:nil];
}

#pragma mark func
- (void)didSelectRowAtOrgTree:(XGCMainOrgTreeModel *)model {
    model.selected = !model.selected;
    // 记录
    if (!self.allowsMultipleSelection) {
        [self.maps removeAllObjects];
    }
    model.isSelected ? [self.maps setObject:model forKey:model.cId] : [self.maps removeObjectForKey:model.cId];
    // 通知两个页面
    [self.viewControllers enumerateObjectsUsingBlock:^(XGCMainOrgTreeViewTypeController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.cIds = self.maps.allKeys;
    }];
}

- (void)afterRequest:(NSMutableDictionary <NSString *, XGCMainOrgTreeModel *> *)maps {
    [self.cIds enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        XGCMainOrgTreeModel *object = [maps objectForKey:obj];
        object ? [self.maps setObject:object forKey:obj] : nil;
    }];
    // 通知两个页面
    [self.viewControllers enumerateObjectsUsingBlock:^(XGCMainOrgTreeViewTypeController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.cIds = self.maps.allKeys;
    }];
}

#pragma mark action
- (void)confirm {
    self.didSelectOrgTreeAction ? self.didSelectOrgTreeAction(self, self.maps.allObjects) : nil;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)UITextFieldTextDidChangeAction:(XGCSearchTextField *)textField {
    if (textField.markedTextRange) {
        return;
    }
    [self.viewControllers enumerateObjectsUsingBlock:^(XGCMainOrgTreeViewTypeController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.searchVal = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    }];
}

#pragma mark - XGCPageViewDelegate
- (void)pageViewManager:(XGCPageViewManager *)pageViewManager didShowViewController:(__kindof UIViewController *)viewController {
    [self.segmentedControl setSelectedSegmentIndex:pageViewManager.selectedPageIndex animated:YES];
}

@end
