//
//  LFMessageDistributionCenter.m
//  NoticeSheet
//
//  Created by libx on 2019/8/20.
//  Copyright © 2019 LF. All rights reserved.
//

#import "LFMessageDistributionCenter.h"
#import "objc/message.h"

/// 全局字典
static NSMutableDictionary *MessagesDictionary() {
    static NSMutableDictionary *msgDictionary = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        msgDictionary = @{}.mutableCopy;
    });
    return msgDictionary;
}

/// 获取消息类型对应的方法
static __inline__ __attribute__((always_inline)) NSString *SelName(MessageDistributionType keyPath) {
    switch (keyPath) {
        case MessageDistributionTypeLoginSuccessed:
            return @"loginSuccessed";
            break;
        case MessageDistributionTypeLogoutSuccessed:
            return @"logoutSuccessed";
            break;
        default:
            assert(0);
            break;
    }
}

/// objc_msgSend，发送无参数的消息
static __inline__ __attribute__((always_inline)) void PostMessage(__unsafe_unretained id target, MessageDistributionType keyPath) {
    ((void (*)(id, SEL))objc_msgSend)(target, NSSelectorFromString(SelName(keyPath)));
}

@implementation LFMessageDistributionCenter

+ (void)addObserver:(id)target forKeyPath:(MessageDistributionType)keyPath {
    if (!target) return;    
    if (![target respondsToSelector:NSSelectorFromString(SelName(keyPath))]) {
        NSAssert(0, @"注册消息通知的类里，请实现%@的方法",SelName(keyPath));
        return;
    }
    
    NSArray *cache = [MessagesDictionary() objectForKey:@(keyPath)];
    if (!cache) cache = @[];
    
    NSMutableArray *newCache = cache.mutableCopy;
    if (![newCache containsObject:target]) {
        [newCache addObject:target];
        [MessagesDictionary() setObject:newCache forKey:@(keyPath)];
    }
}

+ (void)postMessageForKeyPath:(MessageDistributionType)keyPath {
    NSArray *cache = [MessagesDictionary() objectForKey:@(keyPath)];
    if (!cache) return;
    
    for (id target in cache) {
        if ([target respondsToSelector:NSSelectorFromString(SelName(keyPath))]) {
            PostMessage(target, keyPath);
        }
    }
}

+ (void)removeObserver:(id)target forKeyPath:(MessageDistributionType)keyPath {
    if (!target) return;
    
    NSArray *cache = [MessagesDictionary() objectForKey:@(keyPath)];
    if (!cache || !cache.count) return;
    
    NSMutableArray *newCache = cache.mutableCopy;
    
    for (id aTarget in newCache) {
        if ([aTarget isEqual:target]) {
            [newCache removeObject:aTarget];
            break;
        }
    }
    [MessagesDictionary() setObject:newCache forKey:@(keyPath)];
}

@end
