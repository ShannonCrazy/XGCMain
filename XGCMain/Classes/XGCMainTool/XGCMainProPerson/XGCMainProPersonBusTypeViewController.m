//
//  XGCMainProPersonBusTypeViewController.m
//  securitysystem
//
//  Created by 凌志 on 2024/1/10.
//

#import "XGCMainProPersonBusTypeViewController.h"
// XGCMain
#import "XGCURLSession.h"
#import "UIView+XGCView.h"
#import "XGCConfiguration.h"
#import "NSArray+XGCArray.h"
#import "XGCCataloguesView.h"
#import "XGCRefreshTableView.h"
// model
#import "XGCMainProPersonPersonModel.h"
#import "XGCMainProPersonPersonOrgModel.h"
// cell
#import "XGCMainProPersonOrgBusTypeOrgTableViewCell.h"
#import "XGCMainProPersonBusTypePersonTableViewCell.h"
//
#import <Masonry/Masonry.h>
#import <MJExtension/MJExtension.h>

@interface XGCMainProPersonBusTypeViewController ()<UITableViewDelegate, UITableViewDataSource, XGCTableViewRefreshDelegate, XGCMainCataloguesDelegate, XGCMainCataloguesDataSource>
@property (nonatomic, strong) XGCCataloguesView *cataloguesView;
@property (nonatomic, strong) XGCRefreshTableView *tableView;
/// 组织
@property (nonatomic, strong) NSMutableArray <XGCMainProPersonPersonOrgModel *> *orgData;
/// 目录
@property (nonatomic, strong) NSMutableArray <XGCMainProPersonPersonOrgModel *> *catalogues;
/// 个人
@property (nonatomic, strong, readwrite) NSMutableArray <XGCMainProPersonPersonModel *> *personData;
@end

@implementation XGCMainProPersonBusTypeViewController

- (NSString *)description {
    if ([self.busType isEqualToString:@"LW"]) {
        return @"劳务班组";
    }
    return @"组织结构";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cataloguesView = ({
        XGCCataloguesView *view = [[XGCCataloguesView alloc] init];
        view.delegate = self;
        view.dataSource = self;
        view.backgroundColor = XGCCMI.whiteColor;
        [self.view addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(self.view);
        }];
        view;
    });
    self.tableView = ({
        XGCRefreshTableView *tableView = [[XGCRefreshTableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.refreshDelegate = self;
        tableView.sectionHeaderHeight = 0;
        tableView.sectionFooterHeight = 0;
        tableView.beginRefreshingWhenDidMoveToSuperView = NO;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGFLOAT_MIN)];
        tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGFLOAT_MIN)];
        [tableView registerClass:[XGCMainProPersonBusTypePersonTableViewCell class] forCellReuseIdentifier:NSStringFromClass([XGCMainProPersonBusTypePersonTableViewCell class])];
        [tableView registerClass:[XGCMainProPersonOrgBusTypeOrgTableViewCell class] forCellReuseIdentifier:NSStringFromClass([XGCMainProPersonOrgBusTypeOrgTableViewCell class])];
        [self.view addSubview:tableView];
        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(self.view);
            make.top.mas_equalTo(self.cataloguesView.mas_bottom);
        }];
        tableView;
    });
    self.personData = [NSMutableArray array];
    self.catalogues = [NSMutableArray array];
    [self beginRequest];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.delegate && [self.delegate respondsToSelector:@selector(viewController:viewWillAppear:)]) {
        [self.delegate viewController:self viewWillAppear:self.personData];
    }
    [self.tableView reloadData];
}

#pragma mark request
- (void)beginRequest {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObject:self.busType forKey:@"busType"];
    parameters[@"onlyChild"] =  self.allFlag ?: @"false";
    parameters[@"orgIdList"] = self.orgIdList;
    __weak typeof(self) this = self;
    [this.view startAnimating];
    [XGCURLSession POST:@"orgTree/orgTree" parameters:parameters aTarget:self callback:^(id  _Nullable responseObject, NSError * _Nullable error) {
        [this.view stopAnimating];
        if (responseObject) {
            NSMutableArray <XGCMainProPersonPersonOrgModel *> *temps = [XGCMainProPersonPersonOrgModel mj_objectArrayWithKeyValuesArray:responseObject];
            if (temps.count == 0) {
                this.orgData = nil;
            } else if (temps.count == 1) {
                [this.catalogues addObject:temps.firstObject];
                this.orgData = temps.firstObject.children;
            } else {
                [this.catalogues addObject:({
                    XGCMainProPersonPersonOrgModel *model = [[XGCMainProPersonPersonOrgModel alloc] init];
                    model.cName = @"全部";
                    model.children = temps;
                    model;
                })];
                this.orgData = temps;
            }
            [this.cataloguesView reloadData];
            [this beginRefreshing];
        } else {
            [this.view makeToast:error.localizedDescription position:XGCToastViewPositionCenter];
        }
    }];
}

#pragma mark set
- (void)setSearchVal:(NSString *)searchVal {
    _searchVal = searchVal;
    [self mj_headerRefreshingAction:self.tableView];
}

- (void)setAllFlag:(NSString *)allFlag {
    _allFlag = allFlag;
    [self beginRefreshing];
}

- (void)reloadData {
    [self.tableView reloadData];
}

- (void)beginRefreshing {
    if (!self.isViewLoaded) {
        return;
    }
    [self.personData removeAllObjects];
    [self.tableView reloadData];
    if (self.delegate && [self.delegate respondsToSelector:@selector(viewController:refreshAction:)]) {
        [self.delegate viewController:self refreshAction:self.personData];
    }
    if (self.catalogues.lastObject.cId.length == 0) {
        return;
    }
    [self.tableView beginRefreshing];
}

#pragma mark - <XGCTableViewRefreshDelegate>
- (void)mj_headerRefreshingAction:(XGCRefreshTableView *)tableView {
    tableView.startRow = 0;
    [self mj_footerRefreshingAction:tableView];
}

- (void)mj_footerRefreshingAction:(XGCRefreshTableView *)tableView {
    if (self.catalogues.lastObject.cId.length == 0) {
        [self.personData removeAllObjects];
        [tableView endRefreshing];
        [tableView endRefreshingWithNoMoreData];
        [tableView reloadData];
        if (self.delegate && [self.delegate respondsToSelector:@selector(viewController:refreshAction:)]) {
            [self.delegate viewController:self refreshAction:self.personData];
        }
        return;
    }
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjects:@[@(tableView.startRow), @(tableView.rows), self.busType] forKeys:@[@"startRow", @"rows", @"busType"]];
    parameters[@"searchVal"] = self.searchVal;
    parameters[@"allFlag"] = self.allFlag;
    parameters[@"orgId"] = self.catalogues.lastObject.cId;
    __weak typeof(self) this = self;
    [XGCURLSession POST:@"proPersonAdmin/selectDataByPage" parameters:parameters aTarget:self callback:^(id  _Nullable responseObject, NSError * _Nullable error) {
        [tableView endRefreshing];
        if (responseObject) {
            NSMutableArray <XGCMainProPersonPersonModel *> *temps = [XGCMainProPersonPersonModel mj_objectArrayWithKeyValuesArray:responseObject];
            if (tableView.startRow == 0) {
                [this.personData removeAllObjects];
            }
            if (temps.count < tableView.rows) {
                [tableView endRefreshingWithNoMoreData];
            }
            [this.personData addObjectsFromArray:temps];
            tableView.startRow += tableView.rows;
            if (this.delegate && [this.delegate respondsToSelector:@selector(viewController:refreshAction:)]) {
                [this.delegate viewController:this refreshAction:this.personData];
            }
        } else {
            [this.view makeToast:error.localizedDescription position:XGCToastViewPositionCenter];
        }
        [tableView reloadData];
    }];
}

#pragma mark - <UITableViewDelegate, UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.searchVal.length > 0 ? 0 : self.orgData.count;
    }
    return self.personData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        XGCMainProPersonOrgBusTypeOrgTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XGCMainProPersonOrgBusTypeOrgTableViewCell class])];
        cell.model = self.orgData[indexPath.row];
        return cell;
    } else {
        XGCMainProPersonBusTypePersonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XGCMainProPersonBusTypePersonTableViewCell class])];
        cell.model = self.personData[indexPath.row];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    NSInteger count = 0;
    if (section == 0) {
        count = self.searchVal.length > 0 ? 0 : self.orgData.count;
    } else {
        count = self.personData.count;
    }
    return count > 0 ? 5.0 : 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.tableView.isRefreshing) {
        return;
    }
    if (indexPath.section == 0) {
        [self.catalogues addObject:self.orgData[indexPath.row]];
        [self.cataloguesView reloadData];
        self.orgData = self.orgData[indexPath.row].children;
        [self.personData removeAllObjects];
        [tableView reloadData];
        [self beginRefreshing];
    } else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(viewController:didSelectRowAtPerson:)]) {
            [self.delegate viewController:self didSelectRowAtPerson:self.personData[indexPath.row]];
        }
        [tableView reloadData];
    }
}

#pragma mark XGCMainCataloguesDelegate, XGCMainCataloguesDataSource
- (NSInteger)numberOfItemsInCataloguesView:(XGCCataloguesView *)cataloguesView {
    return self.catalogues.count;
}

- (NSString *)cataloguesView:(XGCCataloguesView *)cataloguesView titleInItem:(NSInteger)item {
    return self.catalogues[item].cName;
}

- (void)cataloguesView:(XGCCataloguesView *)cataloguesView didSelectItem:(NSInteger)item {
    self.orgData = self.catalogues[item].children;
    [self.catalogues removeObjectFromIndex:item];
    [cataloguesView reloadData];
    [self beginRefreshing];
}

@end
