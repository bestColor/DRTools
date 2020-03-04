//
//  LFFMDBManager.h
//  NoticeSheet
//
//  Created by libx on 2019/7/26.
//  Copyright © 2019 LF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YIIFMDB/YIIFMDB.h>

NS_ASSUME_NONNULL_BEGIN

@interface LFFMDBManager : NSObject

/// 单例
+ (id)sharedManager;

/// 初始化
- (void)initData;

/// 插入一条数据到数据库
- (BOOL)insertModel:(id)model tableName:(NSString *)tableName;

/// 删除一条数据从数据库
- (BOOL)deleteModel:(id)model tableName:(NSString *)tableName;

/// 更新一条数据从数据库
- (BOOL)updateModel:(id)model tableName:(NSString *)tableName;

/// 获取某表的所有数据 lastId为0，就是指获取最新的 limit 条，否则一直向前获取
- (id)getDataListWithLastId:(NSString *)lastId tableName:(NSString *)tableName model:(NSObject *)model;

@end

NS_ASSUME_NONNULL_END
