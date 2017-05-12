//
//  GGHttpRequest.h
//  GGHttpManager
//
//  Created by David on 2017/5/10.
//  Copyright © 2017年 GangZi. All rights reserved.
//

#import "GGBaseRequest.h"


@class GGHttpRequest;

// 数据解析的protocol
@protocol GGHttpResponseParser <NSObject>

- (BOOL)isValidResponse:(id)response request:(GGHttpRequest *)request error:(NSError *__autoreleasing*)error;

- (id)parseResponse:(id)response request:(GGHttpRequest *)request;

@end

// 数据缓存的protocol
@protocol GGHttpResponseCache <NSObject>

- (void)setObject:(id<NSCoding>)object forKey:(NSString *)Key;

- (id<NSCoding>)objectForKey:(NSString *)key overdueDate:(NSDate *)overdueDate;

@end


@interface GGHttpRequest : GGBaseRequest
// 是否从缓存中请求数据
@property (nonatomic, assign, readonly) BOOL responseFromCache;
// 是否请求缓存的数据
@property (nonatomic, assign) BOOL requestFromCache;
// 是否缓存response 默认为NO
@property (nonatomic, assign) BOOL cacheResponse;
// 缓存时间 默认7天
@property (nonatomic, assign) NSInteger cacheTimeInSeconds;
// 缓存忽略的某些parameter的key
@property (nonatomic, strong) NSArray *cacheIgnoreParametersKeys;
// 数据解析
@property (nonatomic, strong) id<GGHttpResponseParser>responseParser;
// 数据缓存
@property (nonatomic, strong) id<GGHttpResponseCache>responseCache;


@end
