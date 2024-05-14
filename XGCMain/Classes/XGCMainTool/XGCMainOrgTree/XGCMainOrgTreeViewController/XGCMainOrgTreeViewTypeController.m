//
//  XGCMainOrgTreeViewTypeController.m
//  XGCMain
//
//  Created by 凌志 on 2024/3/27.
//

#import "XGCMainOrgTreeViewTypeController.h"
//
#import <Masonry/Masonry.h>
#import <MJExtension/MJExtension.h>
//
#import "XGCURLSession.h"
#import "UIView+XGCView.h"
#import "XGCEmptyTableView.h"
//
#import "XGCMainOrgTreeModel.h"
//
#import "XGCMainOrgTreeViewControllerCell.h"

@interface XGCMainOrgTreeViewTypeController ()<UITableViewDelegate, UITableViewDataSource>
// 要展示的结果
@property (nonatomic, strong) NSMutableArray <XGCMainOrgTreeModel *> *lists;
// 搜索结果
@property (nonatomic, strong) NSArray <XGCMainOrgTreeModel *> *results;
/// 字典
@property (nonatomic, strong) NSMutableDictionary <NSString *, XGCMainOrgTreeModel *> *maps;
// UI
@property (nonatomic, strong) XGCEmptyTableView *tableView;
@end

@implementation XGCMainOrgTreeViewTypeController

- (NSString *)description {
    return [self.busType isEqualToString:@"LW"] ? @"劳务班组" : @"组织结构";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView = ({
        XGCEmptyTableView *tableView = [[XGCEmptyTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        if (@available(iOS 15.0, *)) {
            tableView.sectionHeaderTopPadding = 0;
        }
        tableView.rowHeight = UITableViewAutomaticDimension;
        tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGFLOAT_MIN, CGFLOAT_MIN)];
        tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGFLOAT_MIN, CGFLOAT_MIN)];
        [tableView registerClass:[XGCMainOrgTreeViewControllerCell class] forCellReuseIdentifier:NSStringFromClass([XGCMainOrgTreeViewControllerCell class])];
        [self.view addSubview:tableView];
        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.view);
        }];
        tableView;
    });
}

#pragma mark request
- (void)beginRequest {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"onlyChild"] = self.onlyChild ?: @"false";
    parameters[@"busType"] = self.busType;
    parameters[@"orgIdList"] = self.orgIdList;
    __weak typeof(self) this = self;
    [XGCURLSession POST:@"orgTree/orgTree" parameters:parameters aTarget:self callback:^(id  _Nullable responseObject, NSError * _Nullable error) {
        if (responseObject) {
            NSMutableArray <XGCMainOrgTreeModel *> *temps = [XGCMainOrgTreeModel mj_objectArrayWithKeyValuesArray:responseObject];
            //
            if (!this.maps) {
                this.maps = [NSMutableDictionary dictionary];
            }
            // 设置层级
            [temps enumerateObjectsUsingBlock:^(XGCMainOrgTreeModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [this lists:obj level:0];
            }];
            // 添加到数组中
            this.lists = [NSMutableArray arrayWithArray:(temps ?: @[])];
            // 展开第一层
            [temps enumerateObjectsUsingBlock:^(XGCMainOrgTreeModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                obj.open = YES;
                NSMutableArray <XGCMainOrgTreeModel *> *inserts = [NSMutableArray array];
                // 遍历要插入的数据，递归查询
                [this recursionOpenBy:obj totals:inserts];
                // 组装要插入数据的顺序 NSIndexSet
                NSIndexSet *indesSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(idx + 1, inserts.count)];
                [this.lists insertObjects:inserts atIndexes:indesSet];
            }];
            // 刷新
            [this.tableView reloadData];
            // 回调
            this.afterRequestAction ? this.afterRequestAction(this.maps) : nil;
        } else {
            [this.view makeToast:error.localizedDescription position:XGCToastViewPositionCenter];
        }
    }];
}

#pragma mark set
- (void)setSearchVal:(NSString *)searchVal {
    _searchVal = searchVal;
    self.results = [self.lists filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.cName CONTAINS %@", searchVal]];
    [self.tableView reloadData];
}

- (void)setCIds:(NSArray<NSString *> *)cIds {
    _cIds = cIds;
    [self.maps.allValues enumerateObjectsUsingBlock:^(XGCMainOrgTreeModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.selected = [_cIds containsObject:obj.cId];
    }];
    [self.tableView reloadData];
}

#pragma mark func
- (void)lists:(XGCMainOrgTreeModel *)orgTree level:(NSUInteger)level {
    orgTree.level = level;
    // 选中状态
    orgTree.selected = [self.cIds containsObject:orgTree.cId];
    // 没有权限
    orgTree.enabled = !orgTree.disabled;
    // 是否允许选择
    if (orgTree.enabled) {
        orgTree.enabled = self.enabledBusTypes.count > 0 ? [self.enabledBusTypes containsObject:orgTree.busType] : YES;
    }
    // 记录
    [self.maps setObject:orgTree forKey:orgTree.cId];
    // 循环子项
    [orgTree.children enumerateObjectsUsingBlock:^(XGCMainOrgTreeModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self lists:obj level:level + 1];
    }];
}

#pragma mark UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchVal.length > 0 ? self.results.count : self.lists.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XGCMainOrgTreeViewControllerCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XGCMainOrgTreeViewControllerCell class])];
    [cell setModel:(self.searchVal.length > 0 ? self.results[indexPath.row] : self.lists[indexPath.row]) inset:(self.searchVal.length == 0)];
    __weak typeof(self) this = self;
    cell.selectedButtonTouchUpInsideAction = ^(XGCMainOrgTreeModel * _Nonnull model) {
        this.didSelectRowAtOrgTreeAction ? this.didSelectRowAtOrgTreeAction(model) : nil;
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.searchVal.length > 0) {
        return;
    }
    XGCMainOrgTreeModel *model = self.lists[indexPath.row];
    model.open = !model.open;
    XGCMainOrgTreeViewControllerCell *cell = (XGCMainOrgTreeViewControllerCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (cell) {
        [cell startAnimating];
    }
    if (model.isOpen) {
        NSMutableArray <XGCMainOrgTreeModel *> *inserts = [NSMutableArray array];
        // 遍历要插入的数据，递归查询
        [self recursionOpenBy:model totals:inserts];
        // 组装要插入数据的顺序 NSIndexSet
        NSIndexSet *indesSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(indexPath.row + 1, inserts.count)];
        [self.lists insertObjects:inserts atIndexes:indesSet];
        // 表头要刷新的 NSIndexPath
        NSMutableArray <NSIndexPath *> *indexPaths = [NSMutableArray array];
        for (NSInteger row = 0; row < inserts.count; row++) {
            [indexPaths addObject:[NSIndexPath indexPathForRow:indexPath.row + row + 1 inSection:0]];
        }
        [tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    } else {
        NSMutableArray <XGCMainOrgTreeModel *> *deletes = [NSMutableArray array];
        // 遍历要删除的数据，递归查询
        [self recursionCloseBy:model totals:deletes];
        // 表头要删除的 NSIndexPath
        NSMutableArray <NSIndexPath *> *indexPaths = [NSMutableArray array];
        [deletes enumerateObjectsUsingBlock:^(XGCMainOrgTreeModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [indexPaths addObject:[NSIndexPath indexPathForRow:[self.lists indexOfObject:obj] inSection:0]];
        }];
        // 删除数据
        [self.lists removeObjectsInArray:deletes];
        [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)recursionOpenBy:(XGCMainOrgTreeModel *)source totals:(NSMutableArray <XGCMainOrgTreeModel *> *)totals {
    if (source.isOpen) {
        [source.children enumerateObjectsUsingBlock:^(XGCMainOrgTreeModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [totals addObject:obj];
            [self recursionOpenBy:obj totals:totals];
        }];
    }
}

- (void)recursionCloseBy:(XGCMainOrgTreeModel *)source totals:(NSMutableArray <XGCMainOrgTreeModel *> *)totals {
    if (!source.isOpen) {
        [source.children enumerateObjectsUsingBlock:^(XGCMainOrgTreeModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [totals addObject:obj];
            [self recursionOpenBy:obj totals:totals];
        }];
    }
}



@end
