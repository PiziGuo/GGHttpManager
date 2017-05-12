//
//  GGHttpManager.h
//  GGHttpManager
//
//  Created by David on 2017/5/9.
//  Copyright © 2017年 GangZi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GGRequestProtocol.h"


@interface GGHttpManager : NSObject

@property (nonatomic, strong) GGRequestConfigure *requestConfiguration;

+ (instancetype)sharedInstance;

- (void)addRequest:(id<GGRequestProtocol>)request;

- (void)cancelRequest:(id<GGRequestProtocol>)request;

- (NSString *)buildRequestURL:(id<GGRequestProtocol>)request;


@end
