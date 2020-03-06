//
//  LFUserDefaults.m
//  NoticeSheet
//
//  Created by libx on 2019/7/26.
//  Copyright © 2019 LF. All rights reserved.
//

#import "LFUserDefaults.h"

@implementation LFUserDefaults

+ (NSUserDefaults *)standardUserDefaults {
    return [NSUserDefaults standardUserDefaults];
}

+ (void)setObject:(nullable id)value forKey:(NSString *)defaultName {
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:defaultName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)setValue:(nullable id)value forKey:(NSString *)defaultName {
    [[NSUserDefaults standardUserDefaults] setValue:value forKey:defaultName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (nullable id)objectForKey:(NSString *)defaultName {
    return [[NSUserDefaults standardUserDefaults] objectForKey:defaultName];
}

+ (nullable id)valueForKey:(NSString *)defaultName {
    return [[NSUserDefaults standardUserDefaults] valueForKey:defaultName];
}

+ (void)removeObjectForKey:(NSString *)defaultName {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:defaultName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


@end
