//
//  FFRequestConfigure.m
//  GGHttpManager
//
//  Created by David on 2017/5/8.
//  Copyright © 2017年 GangZi. All rights reserved.
//

#import "GGRequestConfigure.h"

@implementation GGRequestConfigure

+ (GGRequestConfigure *)shareInstance {
    static id shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[self alloc] init];
    });
    return shareInstance;
}


@end
