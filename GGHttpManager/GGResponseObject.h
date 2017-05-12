//
//  GGResponseObject.h
//  GGHttpManager
//
//  Created by David on 2017/5/10.
//  Copyright © 2017年 GangZi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GGHttpRequest.h"

@interface GGResponseObject : NSObject<GGHttpResponseParser>

@property (nonatomic, strong) NSString *msg;

@property (nonatomic, assign) NSInteger status;

@property (nonatomic, strong) id data;

@property (nonatomic, assign, readonly) Class modelClass;

- (instancetype)initWithModelClass:(Class)modelClass;

- (BOOL)isValidResponse:(id)response request:(GGHttpRequest *)request error:(NSError *__autoreleasing*)error;

- (id)parseResponse:(id)response request:(GGHttpRequest *)request;

@end
