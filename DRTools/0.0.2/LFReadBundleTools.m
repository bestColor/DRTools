//
//  LFReadBundleTools.m
//  NoticeSheet
//
//  Created by libx on 2019/8/19.
//  Copyright © 2019 LF. All rights reserved.
//

#import "LFReadBundleTools.h"
#import <MJExtension/MJExtension.h>

static NSArray *ReadPlist(__unsafe_unretained NSString *plistPath, __unsafe_unretained NSString *cls_name) {
    NSMutableArray *result = @[].mutableCopy;
    NSString *filePath = [[NSBundle mainBundle] pathForResource:plistPath ofType:@""];
    NSArray *cache = [NSArray arrayWithContentsOfFile:filePath];
    assert(cache.count != 0);
    
    if (!cls_name || !cls_name.length) return cache;

    Class cls = NSClassFromString(cls_name);
    if (!cls) return cache;
    
    for (NSDictionary *dic in cache) {
        [result addObject:[cls mj_objectWithKeyValues:dic]];
    }
    return result;
}

@implementation LFReadBundleTools

+ (NSArray * _Nullable)readBunder:(NSString *)plistPath cls_name:(NSString *)cls_name {
    if (!plistPath || !plistPath.length) return nil;
    return ReadPlist(plistPath, cls_name);
}
@end
