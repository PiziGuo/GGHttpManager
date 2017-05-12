//
//  GGBaseRequest.h
//  GGHttpManager
//
//  Created by David on 2017/5/9.
//  Copyright © 2017年 GangZi. All rights reserved.
//

#import "GGRequestProtocol.h"


typedef void (^GGRequestSuccessBlock)(id<GGRequestProtocol>request);
typedef void (^GGRequestFailureBlock)(id<GGRequestProtocol>request, NSError *error);

@protocol GGRequestOverride <NSObject>

// 收到请求数据
- (void)requestDidResponse:(id)responseObject error:(NSError *)error;

// 验证请求数据
- (BOOL)validResponseObject:(id)responseObject error:(NSError *__autoreleasing *)error;

- (void)requestDidFinish;

- (void)requestDidFailWithError:(NSError *)error;

@end


@interface GGBaseRequest : NSObject<GGRequestProtocol, GGRequestOverride>

#pragma mark --
@property (nonatomic, weak) NSURLSessionDataTask *dataTask;
@property (nonatomic, assign, readonly) GGRequestState state;
@property (nonatomic, strong, readonly) id responseObject;


@property (nonatomic, weak) id<GGRequestDelegate>delegate;
@property (nonatomic,strong) id<GGRequestDelegate>embedAccesory;

@property (nonatomic, assign) BOOL asynCompleteQueue;

#pragma mark --
@property (nonatomic, copy, readonly) GGRequestSuccessBlock successBlock;
@property (nonatomic, copy, readonly) GGRequestFailureBlock failureBlock;

@property (nonatomic, copy) AFProgressBlock progressBlock;
@property (nonatomic, copy) AFConstructingBodyBlock constructingBodyBlock;

#pragma mark --
// baseURL 如果为nil，则为全局或者本类requestConfigure.baseURL
@property (nonatomic, strong) NSString *baseURL;

// 请求的URLString 或者URL path
@property (nonatomic, strong) NSString *URLString;

// 请求方法  默认get
@property (nonatomic, assign) GGRequestMethod method;

// 请求参数
@property (nonatomic, strong) NSDictionary *parameters;

// 设置请求格式  默认JSON
@property (nonatomic, assign) GGRequestSerializerType serializerType;

// 请求缓存策略
@property (nonatomic, assign) NSURLRequestCachePolicy cachePolicy;

// 请求链接的超时时间 默认60秒
@property (nonatomic, assign) NSTimeInterval timeoutInterval;

// 请求设置   默认使用全局的requestConfigure
@property (nonatomic, strong) GGRequestConfigure *configuration;

// 在HTTP报头添加自定义参数
@property (nonatomic, strong) NSDictionary *headerFieldValues;

// 请求
- (void)load;

// 设置回调
- (void)setRequestSuccessBlock:(GGRequestSuccessBlock)successBlock failureBlock:(GGRequestFailureBlock)failureBlock;

//
- (void)loadWithSuccessBlock:(GGRequestSuccessBlock)successBlock failureBlock:(GGRequestFailureBlock)failureBlock;

// 取消
- (void)cancel;

@end
