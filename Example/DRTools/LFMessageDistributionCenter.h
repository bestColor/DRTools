//
//  LFMessageDistributionCenter.h
//  NoticeSheet
//
//  Created by libx on 2019/8/20.
//  Copyright © 2019 LF. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 需要添加新的消息类型的话，在这里添加枚举 */
typedef NS_ENUM(NSUInteger, MessageDistributionType) {
    MessageDistributionTypeLoginSuccessed = 1,
    MessageDistributionTypeLogoutSuccessed,
};

NS_ASSUME_NONNULL_BEGIN

@interface LFMessageDistributionCenter : NSObject

/** target 注册到消息分发中心的 type */
+ (void)addObserver:(id)target forKeyPath:(MessageDistributionType)keyPath;

/** 消息发送 type */
+ (void)postMessageForKeyPath:(MessageDistributionType)keyPath;

/** 从消息分发中心移除 type 的 target */
+ (void)removeObserver:(id)target forKeyPath:(MessageDistributionType)keyPath;

@end

NS_ASSUME_NONNULL_END
