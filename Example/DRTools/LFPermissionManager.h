//
//  LFPermissionManager.h
//  NoticeSheet
//
//  Created by libx on 2019/8/2.
//  Copyright © 2019 LF. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
    Privacy - Camera Usage Description                            App需要你的权限，才可以访问相机
    Privacy - Photo Library Additions Usage Description           App需要你的权限，才可以保存到相册
    Privacy - Photo Library Usage Description                     App需要你的权限，才可以访问相册（ios11之前需要添加这个到plist）
    Privacy - Microphone Usage Description                        App需要你的权限，才可以访问麦克风
    Privacy - Location When In Use Usage Description              App需要你的权限，才可以定位（App使用过中可以访问定位）
    Privacy - Contacts Usage Description                          App需要你的权限，才可以访问联系人
    Privacy - Speech Recognition Usage Description                App需要你的权限，才可以开启语音识别
    Privacy - Calendars Usage Description                         App需要你的权限，才可以访问日历
 */

typedef NS_ENUM(NSUInteger, LFPermissionType) {
    LFPermissionTypeCamera = 1,           // 拍照权限
    LFPermissionTypePhotoLibrary,         // 相册权限
    LFPermissionTypeMicrophone,           // 麦克风权限
    LFPermissionTypeAddressBook,          // 通讯录权限
    LFPermissionTypeSRUDescription,       // 语音识别权限
    LFPermissionTypeCalendar,             // 日历权限
    LFPermissionTypeNotification,         // 通知权限
};

typedef NS_ENUM(NSUInteger, LFAuthorizationStatus) {
    LFAuthorizationStatusDenied = 1,      // 拒绝授权
    LFAuthorizationStatusAuthorized,      // 已经授权
    LFAuthorizationStatusError,           // 授权错误
    LFAuthorizationStatusRestricted,      // 限制授权（家长模式限制授权）
};

NS_ASSUME_NONNULL_BEGIN

@interface LFPermissionManager : NSObject

/// 检查用户权限
+ (void)checkPermissions:(LFPermissionType)type handler:(void (^)(LFAuthorizationStatus status))handler;

@end

NS_ASSUME_NONNULL_END
