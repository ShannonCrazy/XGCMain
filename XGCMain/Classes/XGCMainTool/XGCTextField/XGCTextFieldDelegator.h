//
//  XGCTextFieldDelegator.h
//  XGCMain
//
//  Created by 凌志 on 2024/2/6.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
@class XGCTextField;

NS_ASSUME_NONNULL_BEGIN

@interface XGCTextFieldDelegator : NSObject <UITextFieldDelegate>
/// 输入框
@property (nonatomic, weak) XGCTextField *textField;
@end

NS_ASSUME_NONNULL_END
