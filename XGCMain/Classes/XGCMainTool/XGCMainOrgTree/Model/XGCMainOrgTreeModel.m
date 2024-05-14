//
//  XGCMainOrgTreeModel.m
//  securitysystem
//
//  Created by 凌志 on 2024/1/11.
//

#import "XGCMainOrgTreeModel.h"

@implementation XGCMainOrgTreeModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"children" : [XGCMainOrgTreeModel class]};
}

+ (instancetype)cId:(NSString *)cId cName:(NSString *)cName busType:(NSString *)busType level:(NSUInteger)level {
    XGCMainOrgTreeModel *model = [[XGCMainOrgTreeModel alloc] init];
    model.cId = cId;
    model.cName = cName;
    model.busType = busType;
    model.level = level;
    return model;
}
@end
