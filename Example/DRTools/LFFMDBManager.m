//
//  LFFMDBManager.m
//  NoticeSheet
//
//  Created by libx on 2019/7/26.
//  Copyright © 2019 LF. All rights reserved.
//

#import "LFFMDBManager.h"
#import <MJExtension/MJExtension.h>

@interface LFFMDBManager() {
    YIIFMDB *_yiiFMDB;
}
@end

@implementation LFFMDBManager

#pragma mark - 单例
/// 获取单例
+ (id)sharedManager {
    static LFFMDBManager *_FMDBManager = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _FMDBManager = [[LFFMDBManager alloc] init];
    });
    return _FMDBManager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initData];
    }
    return self;
}

/// 创建数据库 实例话句柄
- (void)initData {
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *sqlPath = [NSString stringWithFormat:@"%@/lfdata.sqlite",documentPath];
    NSLog(@"sqlite = %@",sqlPath);

    if ([[NSFileManager defaultManager] fileExistsAtPath:sqlPath] == NO) {
        NSError *error = nil;
        [@"" writeToFile:sqlPath atomically:YES encoding:NSUTF8StringEncoding error:&error];
        if (error) NSLog(@"创建数据库失败 = %@",error);
        else NSLog(@"创建数据库成功");
    } else {
        NSLog(@"数据库已经存在了");
    }

    _yiiFMDB = [YIIFMDB shareDatabaseForName:@"lfdata.sqlite" path:documentPath];
#if DEBUG
    _yiiFMDB.shouldOpenDebugLog = YES;
#else
    _yiiFMDB.shouldOpenDebugLog = NO;
#endif
}

/// 创建表（根据模型）
- (BOOL)createTableWithTableName:(NSString *)tableName modelClass:(Class)modelClass {
    if ([_yiiFMDB existTable:tableName]) {
        NSLog(@"表已经存在");
        return YES;
    } else {
        BOOL isSuccessed = [_yiiFMDB createTableWithModelClass:modelClass excludedProperties:nil tableName:tableName];
        NSLog(@"表创建结果 = %d",isSuccessed);
        return isSuccessed;
    }
}

/// 插入一条数据到数据库
- (BOOL)insertModel:(id)model tableName:(NSString *)tableName {
    __block BOOL ret = NO;
    __weak typeof(YIIFMDB *)weakFMDB = _yiiFMDB;
    
    [_yiiFMDB inTransaction:^(BOOL *rollback) {
        ret = [weakFMDB insertWithModel:model tableName:tableName];
    }];
    
    if (ret) {
        NSLog(@"场的表插入一条数据成功");
    } else {
        NSLog(@"数据库插入数据失败");
    }
    return ret;
}

/// 批量插入到数据库
- (void)insertModels:(NSArray *)models tableName:(NSString *)tableName {
    __weak typeof(YIIFMDB *)weakFMDB = _yiiFMDB;
    
    NSLog(@"1");
    [_yiiFMDB inTransaction:^(BOOL *rollback) {
        NSLog(@"2");

        [weakFMDB insertWithModels:models tableName:tableName];
        NSLog(@"3");

    }];
    NSLog(@"4");

}

/// 删除一条数据从数据库
- (BOOL)deleteModel:(id)model tableName:(NSString *)tableName {
    __block BOOL ret = NO;
    __weak typeof(YIIFMDB *)weakFMDB = _yiiFMDB;
    
    YIIParameters *parameters = [[YIIParameters alloc] init];
    //    [parameters orWhere:@"cPowerTimeSecond" value:deleteModel.cPowerTimeSecond relationType:YIIParametersRelationTypeEqualTo];
    
    [_yiiFMDB inTransaction:^(BOOL *rollback) {
        ret = [weakFMDB deleteFromTable:tableName whereParameters:parameters];
    }];
    
    if (ret) {
        NSLog(@"删除一条数据成功");
    } else {
        NSLog(@"删除一条数据失败");
    }
    return ret;
}

/// 更新一条数据从数据库
- (BOOL)updateModel:(id)model tableName:(NSString *)tableName {
    __block BOOL ret = NO;
    __weak typeof(YIIFMDB *)weakFMDB = _yiiFMDB;
    
    YIIParameters *parameters = [[YIIParameters alloc] init];
    //    [parameters andWhere:@"cPowerTimeSecond" value:updateModel.cPowerTimeSecond relationType:YIIParametersRelationTypeEqualTo];
    
    NSObject *objectModel = (NSObject *)model;
    NSDictionary *dictionary = objectModel.mj_keyValues;
    
    [_yiiFMDB inTransaction:^(BOOL *rollback) {
        ret = [weakFMDB updateTable:tableName dictionary:dictionary whereParameters:parameters];
    }];
    
    if (ret) {
        NSLog(@"更新一条数据库记录成功");
    } else {
        NSLog(@"更新一条数据库记录失败");
    }
    return ret;
}

/// 获取某表的所有数据 lastId为0，就是指获取最新的 limitCount 条，否则一直向前获取
- (id)getDataListWithLastId:(NSString *)lastId tableName:(NSString *)tableName model:(NSObject *)model limitCount:(NSInteger)limitCount {
    __block NSMutableArray *cacheArray = [NSMutableArray array];
    
    __weak typeof(YIIFMDB *)weakFMDB = _yiiFMDB;
    
    YIIParameters *parameters = [[YIIParameters alloc] init];
    
    if ([lastId intValue] == 0) {
        //        [parameters orWhere:@"cPowerTimeSecond" value:@"9999999999" relationType:YIIParametersRelationTypeLessThan];
    } else {
        //        [parameters orWhere:@"cPowerTimeSecond" value:lastId relationType:YIIParametersRelationTypeLessThan];
    }
    // 数量限制在limitCount个
    parameters.limitCount = limitCount;
    // 根据时间戳进行降序
    //    [parameters orderByColumn:@"cPowerTimeSecond" orderType:YIIParametersOrderTypeDesc];
    
    [_yiiFMDB inTransaction:^(BOOL *rollback) {
        NSArray *list = [weakFMDB queryFromTable:tableName model:[model class] whereParameters:parameters];
        //        for (NSDictionary *dict in arraaa) {
        //            model *m = [[model alloc] init];
        //            [m setValuesForKeysWithDictionary:dict];
        //            [cacheArray addObject:m];
        //        }
    }];
    return cacheArray;
}

@end
