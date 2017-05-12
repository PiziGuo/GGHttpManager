//
//  GGResponseCache.h
//  GGHttpManager
//
//  Created by David on 2017/5/10.
//  Copyright © 2017年 GangZi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GGResponseCache : NSObject


- (id <NSCoding>)objectForKey:(NSString *)key;

- (id<NSCoding>)objectForKey:(NSString *)key overdueDate:(NSDate *)overdueDate;

- (void)setObject:(id<NSCoding>)object forKey:(NSString *)key;

- (void)removeObjectForKey:(NSString *)key;

- (void)removeAllObjects;

- (void)trimToDate:(NSDate *)date;

@end
