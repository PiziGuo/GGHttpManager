//
//  GGHttpManager.m
//  GGHttpManager
//
//  Created by David on 2017/5/9.
//  Copyright © 2017年 GangZi. All rights reserved.
//

#import "GGHttpManager.h"
#import "AFNetworking.h"



@implementation GGHttpManager


+ (instancetype)sharedInstance {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}


+ (dispatch_queue_t)completeQueue {
    
    static dispatch_queue_t completeQueue = NULL;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        completeQueue = dispatch_queue_create("com.GGHttpManager.completeQueue", DISPATCH_QUEUE_SERIAL);
        dispatch_set_target_queue(completeQueue, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
    });
    return completeQueue;
}


- (instancetype)init {
    if (self = [super init]) {
        _requestConfiguration = [GGRequestConfigure shareInstance];
    }
    return self;
}


#pragma mark - 

- (void)addRequest:(id<GGRequestProtocol>)request {
    
    // 根据request创建manager
    AFHTTPSessionManager *manager = [self defaultSessionManagerWithRequest:request];
    
    // 配置manager
    [self configureSessionManager:manager request:request];
    
    // 进行请求
    [self loadRequest:request sessionManager:manager];
}

- (void)cancelRequest:(id<GGRequestProtocol>)request {
    [request cancel];
}

#pragma mark - 
// 初始化AFHTTPSessionManager
- (AFHTTPSessionManager *)defaultSessionManagerWithRequest:(id<GGRequestProtocol>)request
{
    
    GGRequestConfigure *requestConfiguration = [request configuration];
    if (requestConfiguration == nil) {
        requestConfiguration = [GGRequestConfigure shareInstance];
    }
    AFHTTPSessionManager *manager = nil;
    if (requestConfiguration.sessionConfiguration) {
        manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:requestConfiguration.baseURL] sessionConfiguration:requestConfiguration.sessionConfiguration];
    } else {
        manager = [AFHTTPSessionManager manager];
    }
    manager.completionQueue = [[self class] completeQueue];
    return manager;
}

- (void)configureSessionManager:(AFHTTPSessionManager *)manager request:(id<GGRequestProtocol>)request
{
    
    if ([request serializerType] == GGRequestSerializerTypeJSON) {
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
    } else if ([request serializerType] == GGRequestSerializerTypeString) {
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    }
    NSDictionary *headerFieldValue = [request headerFieldValues];
    if (headerFieldValue) {
        [headerFieldValue enumerateKeysAndObjectsUsingBlock:^(id key, id  value, BOOL * stop) {
            if ([key isKindOfClass:[NSString class]]) {
                [manager.requestSerializer setValue:value forHTTPHeaderField:key];
            }
        }];
    }
    manager.requestSerializer.cachePolicy = [request cachePolicy];
    manager.requestSerializer.timeoutInterval = [request timeoutInterval];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/plain", @"text/javascript", @"text/json", @"text/html", nil];
}

- (NSString *)buildRequestURL:(id<GGRequestProtocol>)request
{
    NSString *URLPath = [request URLString];
    if ([URLPath hasPrefix:@"http"]) {
        return URLPath;
    }
    NSString *baseURL = request.baseURL.length > 0 ? request.baseURL : (request.configuration ? request.configuration.baseURL : [GGRequestConfigure shareInstance].baseURL);
    return [NSString stringWithFormat:@"%@%@",baseURL?baseURL:@"", URLPath];
}

- (void)loadRequest:(id<GGRequestProtocol>)request sessionManager:(AFHTTPSessionManager *)manager
{
    NSString *URLString = [self buildRequestURL:request];
    NSDictionary *parameters = [request parameters];
    GGRequestMethod requestMethod = [request method];
    AFProgressBlock progressBlock = [request progressBlock];
    
    if (requestMethod == GGRequestMethodGet) {
        request.dataTask = [manager GET:URLString parameters:parameters progress:progressBlock success:^(NSURLSessionDataTask * task, id responseObject) {
            
            [request requestDidResponse:responseObject error:nil];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            [request requestDidResponse:nil error:error];
        }];
    } else if (requestMethod == GGRequestMethodPost) {
        
        AFConstructingBodyBlock constructingBodyBlock = [request constructingBodyBlock];
        if (constructingBodyBlock) {
            request.dataTask = [manager POST:URLString parameters:parameters constructingBodyWithBlock:constructingBodyBlock progress:progressBlock success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                [request requestDidResponse:responseObject error:nil];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                [request requestDidResponse:nil error:error];
            }];
        } else {
            request.dataTask = [manager POST:URLString parameters:parameters progress:progressBlock success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                [request requestDidResponse:responseObject error:nil];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                [request requestDidResponse:nil error:error];
            }];
        }
        
    } else if (requestMethod == GGRequestMethodHead) {
        request.dataTask = [manager HEAD:URLString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task) {
            
            [request requestDidResponse:nil error:nil];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            [request requestDidResponse:nil error:error];
        }];
    } else if (requestMethod == GGRequestMethodPut) {
        
        request.dataTask = [manager PUT:URLString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            [request requestDidResponse:responseObject error:nil];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            [request requestDidResponse:nil error:error];
        }];
    } else if (requestMethod == GGRequestMethodPatch) {
        
        request.dataTask = [manager PATCH:URLString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            [request requestDidResponse:responseObject error:nil];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            [request requestDidResponse:nil error:error];
        }];
    }
}

@end
