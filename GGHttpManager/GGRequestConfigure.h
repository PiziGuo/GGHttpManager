//
//  FFRequestConfigure.h
//  GGHttpManager
//
//  Created by David on 2017/5/8.
//  Copyright © 2017年 GangZi. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface GGRequestConfigure : NSObject

@property (nonatomic, strong) NSString *baseURL;

@property (nonatomic, strong) NSURLSessionConfiguration *sessionConfiguration;

+ (GGRequestConfigure *)shareInstance;

@end
