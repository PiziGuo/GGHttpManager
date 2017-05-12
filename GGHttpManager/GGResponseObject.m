//
//  GGResponseObject.m
//  GGHttpManager
//
//  Created by David on 2017/5/10.
//  Copyright © 2017年 GangZi. All rights reserved.
//

#import "GGResponseObject.h"

@interface GGResponseObject ()

@property (nonatomic, assign) Class modelClass;

@end


@implementation GGResponseObject

- (instancetype)initWithModelClass:(Class)modelClass {
    if (self = [super init]) {
        _modelClass = modelClass;
    }
    return self;
}

- (BOOL)isValidResponse:(id)response request:(GGHttpRequest *)request error:(NSError *__autoreleasing*)error {
    
    if (!response) {
        *error = [NSError errorWithDomain:@"response is nil" code:-1 userInfo:nil];
        return NO;
    }
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)request.dataTask.response;
    NSInteger responseStatusCode = [httpResponse statusCode];
    
    if (responseStatusCode < 200 || responseStatusCode > 299) {
        *error = [NSError errorWithDomain:@"invalid http request" code:responseStatusCode userInfo:nil];
        return NO;
    }
    return YES;
}

- (id)parseResponse:(id)response request:(GGHttpRequest *)request {
    _data = response;
    return self;
}


- (NSString *)description {
    return [NSString stringWithFormat:@"\nstatus:%d \nmsg:%@ \n",(int)_status, _msg ? _msg : @""];
}

@end
