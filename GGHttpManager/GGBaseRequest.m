//
//  GGBaseRequest.m
//  GGHttpManager
//
//  Created by David on 2017/5/9.
//  Copyright © 2017年 GangZi. All rights reserved.
//

#import "GGBaseRequest.h"
#import "GGHttpManager.h"


@interface GGBaseRequest ()

@property (nonatomic, copy) GGRequestSuccessBlock successBlock;
@property (nonatomic, copy) GGRequestFailureBlock failureBlock;

@property (nonatomic, assign) GGRequestState state;
@property (nonatomic, strong) id responseObject;

@end


@implementation GGBaseRequest


- (instancetype)init {
    if (self == [super init]) {
        _method = GGRequestMethodGet;
        _serializerType = GGRequestSerializerTypeJSON;
        _timeoutInterval = 60;
    }
    return self;
}



// 请求
- (void)load
{
    [[GGHttpManager sharedInstance] addRequest:self];
    _state = GGRequestStateLoading;
}

// 设置回调
- (void)setRequestSuccessBlock:(GGRequestSuccessBlock)successBlock failureBlock:(GGRequestFailureBlock)failureBlock
{
    _successBlock = successBlock;
    _failureBlock = failureBlock;
}

//
- (void)loadWithSuccessBlock:(GGRequestSuccessBlock)successBlock failureBlock:(GGRequestFailureBlock)failureBlock
{
    [self setRequestSuccessBlock:successBlock failureBlock:failureBlock];
    [self load];
}

// 取消
- (void)cancel {
    [_dataTask cancel];
    [self clearRequestBlock];
    _delegate = nil;
    _state = GGRequestStateCancel;
}

#pragma mark - delegate

/**
 这个方法在遵循的两个协议里都有定义

 @param responseObject <#responseObject description#>
 @param error <#error description#>
 */
- (void)requestDidResponse:(id)responseObject error:(NSError *)error {
    
    if (error) {
        [self requestDidFailWithError:error];
    } else {
        
        if ([self validResponseObject:responseObject error:&error]) {
            
            [self requestDidFinish];
        } else {
            [self requestDidFailWithError:error];
        }
        
    }
}

// 检测数据有效性（这里的responseObject 貌似是转换过model的）
- (BOOL)validResponseObject:(id)responseObject error:(NSError *__autoreleasing *)error {
    
    _responseObject = responseObject;
    return _responseObject ? YES : NO;
}


/**
 请求完成时调用的代理（内部的，外部调用的代理是带request参数的代理）
 */
- (void)requestDidFinish {
    _state = GGRequestStateFinish;
    void (^finishBlock)() = ^{
        
        if ([_delegate respondsToSelector:@selector(requestDidFinish:)]) {
            [_delegate requestDidFinish:self];
        }
        if (_successBlock) {
            _successBlock(self);
        }
        if (_embedAccesory && [_embedAccesory respondsToSelector:@selector(requestDidFinish:)]) {
            [_embedAccesory requestDidFinish:self];
        }
    };
    if (_asynCompleteQueue) {
        finishBlock();
    } else {
        dispatch_async(dispatch_get_main_queue(), finishBlock);
    }
}


/**
 请求出现错误时调用

 @param error 错误
 */
- (void)requestDidFailWithError:(NSError *)error {
    
    _state = GGRequestStateError;
    
    void (^failBlock)() = ^{
      
        if ([_delegate respondsToSelector:@selector(requestDidFail:error:)]) {
            [_delegate requestDidFail:self error:error];
        }
        if (_failureBlock) {
            _failureBlock(self,error);
        }
        if (_embedAccesory && [_embedAccesory respondsToSelector:@selector(requestDidFail:error:)]) {
            [_embedAccesory requestDidFail:self error:error];
        }
    };
    if (_asynCompleteQueue) {
        failBlock();
    } else {
        dispatch_async(dispatch_get_main_queue(), failBlock);
    }
    
}

#pragma mark - private method
- (void)clearRequestBlock {
    _successBlock = nil;
    _failureBlock = nil;
    _progressBlock = nil;
    _constructingBodyBlock = nil;
}

- (void)dealloc {
    [self clearRequestBlock];
    [_dataTask cancel];
    _delegate = nil;
}

@end
