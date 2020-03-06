//
//  LFKeyChain.m
//  NoticeSheet
//
//  Created by libx on 2019/5/13.
//  Copyright © 2019 LF. All rights reserved.
//

#import "LFKeyChain.h"

#define THIS_WORK_UUID_KEY @"THIS_WORK_UUID_KEY"

@implementation LFKeyChain

+ (id)getUUID {
    if ([LFKeyChain load:THIS_WORK_UUID_KEY]) {
        
        NSString *result = [LFKeyChain load:THIS_WORK_UUID_KEY];
        
        return result;
    } else {
        CFUUIDRef puuid = CFUUIDCreate( nil );
        CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
        
        NSString *result = (NSString *)CFBridgingRelease(CFStringCreateCopy(NULL, uuidString));
        
        CFRelease(puuid);
        CFRelease(uuidString);
        
        [LFKeyChain save:THIS_WORK_UUID_KEY data:result];
        
        return result;
    }
}






















+ (NSMutableDictionary *)getKeychainQuery:(NSString *)service
{
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            (__bridge_transfer id)kSecClassGenericPassword,
            (__bridge_transfer id)kSecClass,
            service,
            (__bridge_transfer id)kSecAttrService,
            service,
            (__bridge_transfer id)kSecAttrAccount,
            (__bridge_transfer id)kSecAttrAccessibleAfterFirstUnlock,
            (__bridge_transfer id)kSecAttrAccessible,
            nil];
}

+ (void)save:(NSString *)service data:(id)data
{
    //Get search dictionary
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    
    CFDictionaryRef keychainQueryRef = (__bridge_retained CFDictionaryRef)keychainQuery;

    //Delete old item before add new item
    SecItemDelete(keychainQueryRef);
    //Add new object to search dictionary(Attention:the data format)
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(__bridge_transfer id)kSecValueData];
    //Add item to keychain with the search dictionary
    SecItemAdd(keychainQueryRef, NULL);
    CFRelease(keychainQueryRef);
}

+ (id)load:(NSString *)service
{
    id ret = nil;
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    //Configure the search setting
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(__bridge_transfer id)kSecReturnData];
    [keychainQuery setObject:(__bridge_transfer id)kSecMatchLimitOne forKey:(__bridge_transfer id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((__bridge_retained CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
        @try {
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge_transfer NSData *)keyData];
        } @catch (NSException *e) {
            NSLog(@"Unarchive of %@ failed: %@", service, e);
        } @finally {
        }
    }
    return ret;
}

+ (void)delete_data:(NSString *)service
{
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    CFDictionaryRef keychainQueryRef = (__bridge_retained CFDictionaryRef)keychainQuery;
    SecItemDelete(keychainQueryRef);
    CFRelease(keychainQueryRef);
}

@end
