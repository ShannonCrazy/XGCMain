//
//  XGCMainOrgTreeView.m
//  securitysystem
//
//  Created by 凌志 on 2024/1/11.
//

#import "XGCMainOrgTreeView.h"
// XGCMain
#import "XGCURLSession.h"
#import "UIView+XGCView.h"
#import "XGCConfiguration.h"
//
#import <Masonry/Masonry.h>
#import <MJExtension/MJExtension.h>
#import <M13OrderedDictionary/M13OrderedDictionary.h>
//
#import "XGCMainOrgTreeTableViewCell.h"

static CGFloat XGCMainOrgTreeToolBarHeight = 40.0;

@interface XGCMainOrgTreeView ()<UITableViewDelegate, UITableViewDataSource>
// default 270.0
@property (nonatomic, assign) CGFloat XGCMainOrgTreeTableViewHeight;
@property (nonatomic, strong) UIControl *backgroundControl;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIView *toolbar;
@property (nonatomic, strong) UIButton *leftBarButton;
@property (nonatomic, strong) UIButton *rightBarButton;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign, getter=isBeingPresented) BOOL beingPresented;
@property (nonatomic, assign, getter=isEndPresented)   BOOL endPresented;
@property (nonatomic, assign, getter=isBeingDismissed) BOOL beingDismissed;

@property (nonatomic, assign, getter=isBeingRequest) BOOL beingRequest;
@property (nonatomic, strong) NSMutableArray <XGCMainOrgTreeModel *> *delayeringTrees;

@property (nonatomic, strong) M13MutableOrderedDictionary <NSString *, XGCMainOrgTreeModel *> *maps;

/// 需要插入的数据
@property (nonatomic, strong) NSArray <XGCMainOrgTreeModel *> *objects;
/// 从哪里开始插入数据
@property (nonatomic, assign) NSUInteger index;
@end

@implementation XGCMainOrgTreeView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.XGCMainOrgTreeTableViewHeight = 270.0;
        // UI
        self.backgroundControl = ({
            UIControl *control = [[UIControl alloc] initWithFrame:self.bounds];
            control.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.0];
            [control addTarget:self action:@selector(backgroundControlTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:control];
            control;
        });
        self.containerView = ({
            CGFloat height = self.XGCMainOrgTreeTableViewHeight + XGCMainOrgTreeToolBarHeight;
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(frame) - height, CGRectGetWidth(frame), height)];
            view.backgroundColor = UIColor.whiteColor;
            [self addSubview:view];
            view;
        });
        self.toolbar = ({
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.containerView.frame), XGCMainOrgTreeToolBarHeight)];
            [self.containerView addSubview:view];
            view;
        });
        self.leftBarButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.titleLabel.font = [UIFont systemFontOfSize:13];
            [button setTitle:@"取消" forState:UIControlStateNormal];
            [button setTitleColor:XGCCMI.blueColor forState:UIControlStateNormal];
            button.frame = CGRectMake(10.0, 0, 44.0, CGRectGetHeight(self.toolbar.frame));
            [button addTarget:self action:@selector(backgroundControlTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
            [self.toolbar addSubview:button];
            button;
        });
        self.rightBarButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.titleLabel.font = [UIFont systemFontOfSize:13];
            [button setTitle:@"确定" forState:UIControlStateNormal];
            [button setTitleColor:XGCCMI.blueColor forState:UIControlStateNormal];
            button.frame = CGRectMake(CGRectGetWidth(self.toolbar.frame) - 44.0 - 10.0, 0, 44.0, CGRectGetHeight(self.toolbar.frame));
            [button addTarget:self action:@selector(rightBarButtonTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
            [self.toolbar addSubview:button];
            button;
        });
        self.titleLabel = ({
            CGFloat x = CGRectGetMaxX(self.leftBarButton.frame);
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, 0, CGRectGetMinX(self.rightBarButton.frame) - x, CGRectGetHeight(self.toolbar.frame))];
            label.textColor = XGCCMI.labelColor;
            label.font = [UIFont systemFontOfSize:13];
            label.textAlignment = NSTextAlignmentCenter;
            [self.toolbar addSubview:label];
            label;
        });
        ({
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.toolbar.frame) - 1.0, CGRectGetWidth(self.toolbar.frame), 1.0)];
            view.backgroundColor = UIColor.groupTableViewBackgroundColor;
            [self.toolbar addSubview:view];
        });
        self.tableView = ({
            CGFloat y = CGRectGetMaxY(self.toolbar.frame);
            UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.toolbar.frame), CGRectGetWidth(frame), CGRectGetWidth(self.containerView.frame) - y) style:UITableViewStylePlain];
            tableView.delegate = self;
            tableView.dataSource = self;
            if (@available(iOS 15.0, *)) {
                tableView.sectionHeaderTopPadding = 0;
            }
            tableView.rowHeight = UITableViewAutomaticDimension;
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGFLOAT_MIN, CGFLOAT_MIN)];
            tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGFLOAT_MIN, CGFLOAT_MIN)];
            [tableView registerClass:[XGCMainOrgTreeTableViewCell class] forCellReuseIdentifier:NSStringFromClass([XGCMainOrgTreeTableViewCell class])];
            [self.containerView addSubview:tableView];
            tableView;
        });
        self.containerView.alpha = 0.0;
        self.delayeringTrees = [NSMutableArray array];
        self.maps = [M13MutableOrderedDictionary orderedDictionary];
    }
    return self;
}

- (void)beginRequest {
    self.beingRequest = YES;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"onlyChild"] = self.onlyChild ?: @"false";
    parameters[@"busType"] = self.busType;
    parameters[@"orgIdList"] = self.orgIdList;
    __weak typeof(self) this = self;
    [XGCURLSession POST:@"orgTree/orgTree" parameters:parameters aTarget:self callback:^(id  _Nullable responseObject, NSError * _Nullable error) {
        if (responseObject) {
            NSMutableArray <XGCMainOrgTreeModel *> *temps = [XGCMainOrgTreeModel mj_objectArrayWithKeyValuesArray:responseObject];
            // 插入数据
            if (this.objects.count > 0) {
                NSIndexSet *indexes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(this.index, this.objects.count)];
                [temps insertObjects:this.objects atIndexes:indexes];
            }
            // 多远数据变成一维
            [temps enumerateObjectsUsingBlock:^(XGCMainOrgTreeModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [this delayeringTrees:obj level:0];
            }];
            // 刷新
            [this.tableView reloadData];
            // 移动到第一条被选中的数据
            if (this.maps.count > 0) {
                NSInteger row = [this.delayeringTrees indexOfObject:this.maps.allObjects.firstObject];
                if (row != NSNotFound) {
                    [this.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
                }
            }
            // 动画
            [this setNeedsDisplay];
        } else {
            [this makeToast:error.localizedDescription position:XGCToastViewPositionCenter];
        }
    }];
}

- (void)delayeringTrees:(XGCMainOrgTreeModel *)orgTree level:(NSUInteger)level {
    orgTree.level = level;
    // 选中状态
    orgTree.selected = [self.cIds containsObject:orgTree.cId];
    // 是否有权限
    orgTree.enabled = !orgTree.disabled;
    // 是否允许选择
    if (orgTree.enabled) {
        orgTree.enabled = self.enabledBusTypes.count > 0 ? [self.enabledBusTypes containsObject:orgTree.busType] : YES;
    }
    // 记录
    if (orgTree.selected && orgTree.enabled) {
        [self.maps setObject:orgTree forKey:orgTree.cId];
    }
    // 添加到一维数组中
    [self.delayeringTrees addObject:orgTree];
    // 循环子项
    [orgTree.children enumerateObjectsUsingBlock:^(XGCMainOrgTreeModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self delayeringTrees:obj level:level + 1];
    }];
}

#pragma mark public
- (void)insertOrgTreeModels:(NSArray<XGCMainOrgTreeModel *> *)objects fromIndex:(NSUInteger)index {
    self.objects = objects;
    self.index = index;
}

#pragma mark set
- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = _title;
}

#pragma mark system
- (void)safeAreaInsetsDidChange {
    [super safeAreaInsetsDidChange];
    [self updateContainerViewFrame];
}

- (void)drawRect:(CGRect)rect {
    if (isnan(rect.origin.x) || isnan(rect.origin.y)) {
        return;
    }
    if (!self.isBeingRequest) {
        [self beginRequest];
    }
    if (self.isBeingPresented) {
        return;
    }
    if (self.isEndPresented) {
        return;
    }
    if (self.isBeingDismissed) {
        return;
    }
    if (self.delayeringTrees.count == 0) {
        return;
    }
    // 高度重新计算
    CGFloat rowHeight = 14.0 * 2 + [UIFont systemFontOfSize:13].lineHeight;
    self.XGCMainOrgTreeTableViewHeight = MIN(rowHeight * self.delayeringTrees.count, 270.0);
    [self updateContainerViewFrame];
    // 视图动画
    self.beingPresented = YES;
    self.containerView.transform = CGAffineTransformMakeTranslation(0, CGRectGetHeight(self.containerView.frame));
    // 将视图上的键盘回收
    [UIApplication.sharedApplication sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    [NSNotificationCenter.defaultCenter postNotificationName:UIKeyboardWillShowNotification object:self];
    void (^animations)(void) = ^(void) {
        self.containerView.alpha = 1.0;
        self.containerView.transform = CGAffineTransformIdentity;
        self.backgroundControl.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.5];
    };
    void (^completion)(BOOL finished) = ^(BOOL finished) {
        self.endPresented = YES;
        self.beingPresented = NO;
        [NSNotificationCenter.defaultCenter postNotificationName:UIKeyboardDidShowNotification object:self];
    };
    [UIView animateWithDuration:0.25 animations:animations completion:completion];
}

- (void)updateContainerViewFrame {
    CGFloat height = self.XGCMainOrgTreeTableViewHeight + XGCMainOrgTreeToolBarHeight + self.safeAreaInsets.bottom;
    self.containerView.frame = CGRectMake(0, CGRectGetHeight(self.frame) - height, CGRectGetWidth(self.frame), height);
    CGFloat y = CGRectGetMaxY(self.toolbar.frame);
    self.tableView.frame = CGRectMake(0, y, CGRectGetWidth(self.containerView.frame), CGRectGetHeight(self.containerView.frame) - y);
}

#pragma mark action
- (void)backgroundControlTouchUpInside {
    self.beingDismissed = YES;
    void (^animations)(void) = ^(void) {
        self.containerView.transform = CGAffineTransformMakeTranslation(0, CGRectGetHeight(self.containerView.frame));
        self.backgroundControl.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.0];
    };
    [UIView animateWithDuration:0.25 animations:animations completion:^(BOOL finished) { [self removeFromSuperview]; }];
}

- (void)rightBarButtonTouchUpInside {
    // 回调
    self.didSelectOrgTreeAction ? self.didSelectOrgTreeAction(self, self.maps.allObjects) : nil;
    // 销毁页面
    [self backgroundControlTouchUpInside];
}

#pragma mark UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.delayeringTrees.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XGCMainOrgTreeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XGCMainOrgTreeTableViewCell class])];
    cell.model = self.delayeringTrees[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    XGCMainOrgTreeModel *row = self.delayeringTrees[indexPath.row];
    if (!row.enabled) {
        return;
    }
    if (row.selected && !self.allowsMultipleSelection) {
        return;
    }
    // 单选操作
    if (!self.allowsMultipleSelection) {
        [self.maps.allObjects enumerateObjectsUsingBlock:^(XGCMainOrgTreeModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.selected = NO;
        }];
        [self.maps removeAllObjects];
    }
    // 置为已选状态
    row.selected = !row.selected;
    // 记录操作
    row.selected ? [self.maps setObject:row forKey:row.cId] : [self.maps removeObjectForKey:row.cId];
    // 刷新
    [tableView reloadData];
}

@end
