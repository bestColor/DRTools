//
//  LFFMDBManager.m
//  NoticeSheet
//
//  Created by libx on 2019/7/26.
//  Copyright © 2019 LF. All rights reserved.
//

#import "LFFMDBManager.h"
#import "LFFileManager.h"
#import "LFProgressHUD.h"
#import <MJExtension/MJExtension.h>

@interface LFFMDBManager()
@property (nonatomic, strong) YIIFMDB *yiiFMDB;
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

/// 初始化
- (void)initData {
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *sqlPath = [NSString stringWithFormat:@"%@/data.sqlite",documentPath];

    if ([[NSFileManager defaultManager] fileExistsAtPath:sqlPath] == NO) {
        NSString *bundleSQLPath = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"sqlite"];
        if ([LFFileManager copyItemAtPath:bundleSQLPath toPath:sqlPath]) {
            NSLog(@"copy success");
        } else {
            NSLog(@"copy failed");
        }
    } else {
        NSLog(@"数据库已经存在了");
    }
    
    _yiiFMDB = [YIIFMDB shareDatabaseForName:@"data.sqlite" path:documentPath];
    _yiiFMDB.shouldOpenDebugLog = YES;
    
    [self createTableList];
}

/// 创建数据库里的表
- (void)createTableList {
    /// 创建表
//    if ([_yiiFMDB existTable:kSECENTABLE]) {
//        NSLog(@"表已经存在");
//    } else {
//        BOOL isScucess = [_yiiFMDB createTableWithModelClass:[SecenModel class] excludedProperties:nil tableName:kSECENTABLE];
//        NSLog(@"表创建结果 = %d",isScucess);
//    }
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
        [LFProgressHUD showAlert:@"数据库插入数据失败"];
        
    }
    return ret;
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
        [LFProgressHUD showAlert:@"删除一条数据库记录失败"];
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
        [LFProgressHUD showAlert:@"某一条数据库记录更新失败"];
    }
    return ret;
}

static int dataListLimit = 30;
/// 获取某表的所有数据 lastId为0，就是指获取最新的 dataListLimit 条，否则一直向前获取
- (id)getDataListWithLastId:(NSString *)lastId tableName:(NSString *)tableName model:(NSObject *)model {
    __block NSMutableArray *cacheArray = [NSMutableArray array];
    
    __weak typeof(YIIFMDB *)weakFMDB = _yiiFMDB;
    
    YIIParameters *parameters = [[YIIParameters alloc] init];
    
    if ([lastId intValue] == 0) {
        //        [parameters orWhere:@"cPowerTimeSecond" value:@"9999999999" relationType:YIIParametersRelationTypeLessThan];
    } else {
        //        [parameters orWhere:@"cPowerTimeSecond" value:lastId relationType:YIIParametersRelationTypeLessThan];
    }
    // 数量限制在30个
    parameters.limitCount = dataListLimit;
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
