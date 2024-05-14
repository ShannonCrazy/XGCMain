//
//  XGCCataloguesView.h
//  XGCMain_Example
//
//  Created by 凌志 on 2024/5/13.
//  Copyright © 2024 ShannonCrazy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XGCCataloguesView;

NS_ASSUME_NONNULL_BEGIN

@protocol XGCMainCataloguesDataSource <NSObject>
@optional
- (NSInteger)numberOfItemsInCataloguesView:(XGCCataloguesView *)cataloguesView;
- (NSString *)cataloguesView:(XGCCataloguesView *)cataloguesView titleInItem:(NSInteger)item;
@end

@protocol XGCMainCataloguesDelegate <NSObject>
@optional
- (void)cataloguesView:(XGCCataloguesView *)cataloguesView didSelectItem:(NSInteger)item;
@end

@interface XGCCataloguesView : UIView
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, weak, nullable) id <XGCMainCataloguesDelegate> delegate;
@property (nonatomic, weak, nullable) id <XGCMainCataloguesDataSource> dataSource;
- (void)reloadData;
@end

NS_ASSUME_NONNULL_END
