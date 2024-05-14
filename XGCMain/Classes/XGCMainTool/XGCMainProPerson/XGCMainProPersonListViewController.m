//
//  XGCMainProPersonListViewController.m
//  securitysystem
//
//  Created by 凌志 on 2024/1/12.
//

#import "XGCMainProPersonListViewController.h"
// XGCMain
#import "XGCEmptyTableView.h"
// view
#import "XGCMainProPersonOrgBusTypeOrgTableViewCell.h"
#import "XGCMainProPersonBusTypePersonTableViewCell.h"
// model
#import "XGCMainProPersonPersonModel.h"
//
#import <Masonry/Masonry.h>
#import <MJExtension/MJExtension.h>

@interface XGCMainProPersonListViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) XGCEmptyTableView *tableView;
@property (nonatomic, strong) NSArray <XGCMainProPersonPersonModel *> *temps;
@end

@implementation XGCMainProPersonListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"已选人员";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(done)];
    self.tableView = ({
        XGCEmptyTableView *tableView = [[XGCEmptyTableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.sectionHeaderHeight = 0;
        tableView.sectionFooterHeight = 0;
        tableView.allowsMultipleSelection = YES;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGFLOAT_MIN)];
        tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGFLOAT_MIN)];
        [tableView registerClass:[XGCMainProPersonBusTypePersonTableViewCell class] forCellReuseIdentifier:NSStringFromClass([XGCMainProPersonBusTypePersonTableViewCell class])];
        [self.view addSubview:tableView];
        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.view);
        }];
        tableView;
    });
    self.temps = [XGCMainProPersonPersonModel mj_objectArrayWithKeyValuesArray:[NSArray mj_keyValuesArrayWithObjectArray:self.original]];
}

#pragma mark action
- (void)done {
    __block NSMutableArray <NSString *> *deletes = [NSMutableArray array];
    [self.temps enumerateObjectsUsingBlock:^(XGCMainProPersonPersonModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.selected == NO ? [deletes addObject:obj.cUserId] : nil;
    }];
    self.doneAction ? self.doneAction(deletes) : nil;
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - <UITableViewDelegate, UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.temps.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XGCMainProPersonBusTypePersonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XGCMainProPersonBusTypePersonTableViewCell class])];
    cell.model = self.temps[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    XGCMainProPersonPersonModel *row = self.temps[indexPath.row];
    row.selected = !row.selected;
    [tableView reloadData];
}

@end
