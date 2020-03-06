//
//  LFKeyChain.h
//  NoticeSheet
//
//  Created by libx on 2019/5/13.
//  Copyright © 2019 LF. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LFKeyChain : NSObject

/// 获取永久缓存UUID
+ (id)getUUID;

@end

NS_ASSUME_NONNULL_END
