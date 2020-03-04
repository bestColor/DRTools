//
//  LFReadBundleTools.h
//  NoticeSheet
//
//  Created by libx on 2019/8/19.
//  Copyright © 2019 LF. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LFReadBundleTools : NSObject

/**
 获取自定义的plist的配置
 
 @param plistPath 文件名字
 @param cls_name  类的字符串
 @return 返回组装好的Class的模型列表
 */
+ (NSArray * _Nullable)readBunder:(NSString *)plistPath cls_name:(NSString *)cls_name;

@end

NS_ASSUME_NONNULL_END
