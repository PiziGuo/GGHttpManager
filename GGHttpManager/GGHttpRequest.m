//
//  GGHttpRequest.m
//  GGHttpManager
//
//  Created by David on 2017/5/10.
//  Copyright © 2017年 GangZi. All rights reserved.
//

#import "GGHttpRequest.h"
#import "GGResponseCache.h"
#import "GGHttpManager.h"

// 这里是声明的 GGResponseCache的
@interface GGResponseCache ()<GGHttpResponseCache>
@end


@implementation GGHttpRequest

- (instancetype)init {
    if (self = [super init]) {
        _cacheTimeInSeconds = 60*60*24*7;
    }
    return self;
}

#pragma mark - 

- (id<GGHttpResponseCache>)responseCache {
    
    if (_responseCache == nil) {
        _responseCache = [[GGResponseCache alloc] init];
    }
    return _responseCache;
}


- (void)load {
    
    _responseFromCache = NO;
    if (_requestFromCache && _cacheTimeInSeconds > 0) {
        // 从缓存中取数据
        [self loadResponseFromCache];
    }
    if (!_responseFromCache) {
        [super load];
    }
    
}

// 从缓存中取数据
- (void)loadResponseFromCache
{
    
    id<GGHttpResponseCache> responseCache = [self responseCache];
    if (!responseCache) {
        return;
    }
    
    // 计算过期时间
    double pastTimeInterval = [[NSDate date] timeIntervalSince1970] - [self cacheTimeInSeconds];
    NSDate *pastDate = [NSDate dateWithTimeIntervalSince1970:pastTimeInterval];
    
    //
    NSString *urlKey = [self serializeURLKey];
    id responseObject = [responseCache objectForKey:urlKey overdueDate:pastDate];
    if (responseObject) {
        // 获取到缓存
        _responseFromCache = YES;
        // 回调
        [self requestDidResponse:responseObject error:nil];
    }
    
}


/**
 这里是在请求到数据之后，在没有错误的情况下验证数据的有效性
 有效：解析数据并转model
 无效：进入失败的回调

 @param responseObject <#responseObject description#>
 @param error <#error description#>
 @return <#return value description#>
 */
- (BOOL)validResponseObject:(id)responseObject error:(NSError *__autoreleasing *)error {
    
    id<GGHttpResponseParser> responseParser = [self responseParser];
    if (responseParser == nil) {
        [self cacheRequestResponse:responseObject];
        return [super validResponseObject:responseObject error:error];
    }
    if (_responseFromCache || [responseParser isValidResponse:responseObject request:self error:error]) {
        [self cacheRequestResponse:responseObject];
        id responseParserdObject = [responseObject parseResponse:responseObject request:self];
        return [super validResponseObject:responseParserdObject error:error];
    } else {
        return NO;
    }
    
}

// 缓存数据
- (void)cacheRequestResponse:(id)responseObject {
    
    if (responseObject && _cacheResponse && !_responseFromCache) {
        NSString *urlKey = [self serializeURLKey];
        [[self responseCache] setObject:responseObject forKey:urlKey];
    }
}


#pragma mark - private method
// 拼接查找缓存的KEY
- (NSString *)serializeURLKey {
    NSDictionary *parameters = [self parameters];
    NSArray *ignoreParameterKeys = [self cacheIgnoreParametersKeys];
    if (ignoreParameterKeys) {
        NSMutableDictionary *filterParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
        [filterParameters removeObjectForKey:ignoreParameterKeys];
        parameters = filterParameters;
    }
    NSString *URLString = [[GGHttpManager sharedInstance] buildRequestURL:self];
    return [URLString stringByAppendingString:[self serializeParams:parameters]];
}


- (NSString *)serializeParams:(NSDictionary *)params {
    NSMutableArray *parts = [NSMutableArray array];
    [params enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id<NSObject> obj, BOOL * _Nonnull stop) {
        NSString *encodedKey = [key stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        NSString *encodedValue = [obj.description stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        NSString *part = [NSString stringWithFormat:@"%@=%@",encodedKey,encodedValue];
        [parts addObject:part];
    }];
    NSString *queryString = [parts componentsJoinedByString:@"&"];
    return queryString ? [NSString stringWithFormat:@"?%@",queryString] : @"";
}

@end
