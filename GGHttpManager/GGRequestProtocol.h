//
//  GGRequestProtocol.h
//  GGHttpManager
//
//  Created by David on 2017/5/9.
//  Copyright © 2017年 GangZi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GGRequestConfigure.h"


typedef NS_ENUM(NSUInteger, GGRequestMethod) {
    GGRequestMethodGet,
    GGRequestMethodPost,
    GGRequestMethodHead,
    GGRequestMethodPut,
    GGRequestMethodDelete,
    GGRequestMethodPatch
};

typedef NS_ENUM(NSInteger, GGRequestSerializerType) {
    GGRequestSerializerTypeHTTP,
    GGRequestSerializerTypeJSON,
    GGRequestSerializerTypeString
};

typedef NS_ENUM(NSUInteger, GGRequestState) {
    GGRequestStateReady,
    GGRequestStateLoading,
    GGRequestStateCancel,
    GGRequestStateFinish,
    GGRequestStateError
};

// BLOCK
@protocol AFMultipartFormData;
typedef void(^AFProgressBlock)(NSProgress *progress);
typedef void(^AFConstructingBodyBlock)(id<AFMultipartFormData> formData);

// PROTOCOL GGRequestDelegate
@protocol GGRequestProtocol;
@protocol GGRequestDelegate <NSObject>

@optional
- (void)requestDidFinish:(id<GGRequestProtocol>)request;
- (void)requestDidFail:(id<GGRequestProtocol>)request error:(NSError *)error;
@end

// PROTOCOL GGRequestProtocol
@protocol GGRequestProtocol <NSObject>

@property (nonatomic, weak) NSURLSessionTask *dataTask;

@property (nonatomic, assign, readonly) GGRequestState state;
@property (nonatomic, strong, readonly) id responseObject;

@property (nonatomic, weak) id<GGRequestDelegate>delegate;
@property (nonatomic, strong) id<GGRequestDelegate>embedAccesory;// 嵌入请求代理（？？？）

// baseURL 如果为空，则为全局或者本类requestConfigure.baseURL
- (NSString *)baseURL;

// 请求的URLString，或者URL path
- (NSString *)URLString;

// 请求参数
- (NSDictionary *)parameters;

// 请求方法 默认get
- (GGRequestMethod)method;

// request configure
- (GGRequestConfigure *)configuration;

// 在HTTP报头添加的自定义参数
- (NSDictionary *)headerFieldValues;

// 请求的链接超时时间，默认60秒
- (NSTimeInterval)timeoutInterval;

// 缓存策略
- (NSURLRequestCachePolicy)cachePolicy;

// 设置请求的格式，默认JSON
- (GGRequestSerializerType)serializerType;

// 返回进度的block
- (AFProgressBlock)progressBlock;

// 返回post组装body block
- (AFConstructingBodyBlock)constructingBodyBlock;

// 处理请求数据，如果error为nil, 请求成功
- (void)requestDidResponse:(id)responseObject error:(NSError *)error;

// 请求
- (void)load;

// 取消
- (void)cancel;

@end
