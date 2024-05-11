//
//  XGCUploadSession.h
//  XGCMain_Example
//
//  Created by 凌志 on 2024/4/26.
//  Copyright © 2024 ShannonCrazy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/// 上传回调
typedef void (^XGCUploadSessionProgressBlock) (int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend);
/// 完成回调
typedef void (^XGCUploadSessionCompletionHandler) (NSString * _Nullable destination, NSError * _Nullable error);

@interface XGCUploadSession : NSObject
/// 上传文件
/// - Parameters:
///   - data: 文件二进制
///   - fileName: 文件后名称
///   - pathExtension: 文件后缀名
///   - uploadProgress: 上传进度
///   - completionHandler: 完成
+ (void)uploadWithData:(NSData *)data fileName:(nullable NSString *)fileName pathExtension:(NSString *)pathExtension uploadProgress:(nullable XGCUploadSessionProgressBlock)uploadProgress completionHandler:(nullable XGCUploadSessionCompletionHandler)completionHandler;
@end

NS_ASSUME_NONNULL_END
