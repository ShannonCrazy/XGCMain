//
//  XGCAliyunOSSiOS.m
//  xinggc
//
//  Created by 凌志 on 2023/11/27.
//

#import "XGCAliyunOSSiOS.h"
//
#import <AliyunOSSiOS/AliyunOSSiOS.h>
//
#import "XGCAliyunOSSiOSDelegate.h"

@interface XGCAliyunOSSiOS ()
/// 协议
@property (nonatomic, strong) NSObject <XGCAliyunOSSiOSProtocol> *protocol;
@property (nonatomic, strong) OSSClient *client;
@property (nonatomic, strong) NSMutableArray <XGCAliyunOSSiOSDelegate *> *delegates;
@end

@implementation XGCAliyunOSSiOS

+ (void)registerProtocol:(NSObject<XGCAliyunOSSiOSProtocol> *)protocol {
    XGCAliyunOSSiOS.shareInstance.protocol = protocol;
}

+ (instancetype)shareInstance {
    static XGCAliyunOSSiOS *session = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        session = [[XGCAliyunOSSiOS alloc] init];
    });
    return session;
}

- (instancetype)init {
    if (self = [super init]) {
        self.delegates = [NSMutableArray array];
    }
    return self;
}

- (void)setProtocol:(NSObject <XGCAliyunOSSiOSProtocol> *)protocol {
    _protocol = protocol;
    if (!self.client) {
        id <OSSCredentialProvider> credentialProvider = [[OSSAuthCredentialProvider alloc] initWithAuthServerUrl:[_protocol authServerUrl]];
        self.client = [[OSSClient alloc] initWithEndpoint:[_protocol endpoint] credentialProvider:credentialProvider];
    }
}

- (void)putObject:(NSData *)uploadingData objectKey:(NSString *)objectKey uploadProgress:(XGCAliyunOSSiOSUploadProgressBlock)uploadProgress completionHandler:(XGCAliyunOSSiOSCompletionHandler)completionHandler {
    OSSPutObjectRequest *request = [[OSSPutObjectRequest alloc] init];
    request.bucketName = [self.protocol bucketName];
    request.objectKey = objectKey;
    request.uploadingData = uploadingData;
    request.uploadProgress = uploadProgress;
    // 预请求
    OSSTask *task = [self.client putObject:request];
    // 生成最终网络地址
    NSString *destination = [self.client presignPublicURLWithBucketName:request.bucketName withObjectKey:request.objectKey].result;
    // 代理
    [self.delegates addObject:[XGCAliyunOSSiOSDelegate task:task destination:destination completionHandler:completionHandler]];
    __weak typeof(self) this = self;
    // 发起请求
    [task continueWithBlock:^id _Nullable(OSSTask * _Nonnull task) {
        XGCAliyunOSSiOSDelegate *delegate = [this delegateForTask:task];
        dispatch_async(dispatch_get_main_queue(), ^{
            delegate.completionHandler ? delegate.completionHandler(delegate.destination, task.error) : nil;
            [this.delegates removeObject:delegate];
        });
        return nil;
    }];
}

- (nullable XGCAliyunOSSiOSDelegate *)delegateForTask:(OSSTask *)task {
    __block XGCAliyunOSSiOSDelegate *delegate = nil;
    [self.delegates enumerateObjectsUsingBlock:^(XGCAliyunOSSiOSDelegate * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.task isEqual:task]) {
            *stop = (delegate = obj) ? YES : NO;
        }
    }];
    return delegate;
}

@end
