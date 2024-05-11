//
//  XGCUploadSession.m
//  XGCMain_Example
//
//  Created by 凌志 on 2024/4/26.
//  Copyright © 2024 ShannonCrazy. All rights reserved.
//

#import "XGCUploadSession.h"
// 
#import "XGCAliyunOSSiOS.h"
//
#import "XGCUserManager.h"

@implementation XGCUploadSession
+ (void)uploadWithData:(NSData *)data fileName:(NSString *)fileName pathExtension:(NSString *)pathExtension uploadProgress:(XGCUploadSessionProgressBlock)uploadProgress completionHandler:(XGCUploadSessionCompletionHandler)completionHandler {
    NSString *cName = XGCUM.cUser.userMap.cName;
    NSString *objectKey = pathExtension;
    if (cName.length > 0) {
        objectKey = [objectKey stringByAppendingPathComponent:cName];
    }
    if (fileName.length > 0) {
        objectKey = [objectKey stringByAppendingPathComponent:fileName];
    }
    if (pathExtension.length > 0) {
        objectKey = [objectKey stringByAppendingPathExtension:pathExtension];
    }
    [XGCAliyunOSSiOS.shareInstance putObject:data objectKey:objectKey uploadProgress:uploadProgress completionHandler:completionHandler];
}
@end
