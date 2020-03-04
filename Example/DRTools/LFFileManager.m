//
//  LFFileManager.m
//  NoticeSheet
//
//  Created by libx on 2019/7/26.
//  Copyright © 2019 LF. All rights reserved.
//

#import "LFFileManager.h"

@implementation LFFileManager

+ (NSFileManager *)fileManager {
    return [NSFileManager defaultManager];
}

+ (NSString *)createDirectoryAtPath:(NSString *)path {
    BOOL isDir = NO;
    BOOL existed = [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir];
    if (!(isDir == YES && existed == YES))
    {
        // withIntermediateDirectories 为 yes 代表是否自动创建中间的文件夹
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return path;
}

+ (NSArray *)contentsOfDirectoryAtPath:(NSString *)path {
    return [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
}

+ (BOOL)fileExistsAtPath:(NSString *)path {
    return [[NSFileManager defaultManager] fileExistsAtPath:path];
}

+ (BOOL)removeItemAtPath:(NSString *)path {
    return [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
}

+ (BOOL)copyItemAtPath:(NSString *)path toPath:(NSString *)dstPath {
    return [[NSFileManager defaultManager] copyItemAtPath:path toPath:dstPath error:nil];
}

+ (BOOL)moveItemAtPath:(NSString *)srcPath toPath:(NSString *)dstPath {
    return [[NSFileManager defaultManager] moveItemAtPath:srcPath toPath:dstPath error:nil];
}

+ (NSDictionary *)fileAttributesOfItemAtPath:(NSString *)path {
    NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
    return fileAttributes;
}

+ (NSData *)contentsAtPath:(NSString *)path {
    NSData *fileData = [[NSFileManager defaultManager] contentsAtPath:path];
    return fileData;
}

@end
