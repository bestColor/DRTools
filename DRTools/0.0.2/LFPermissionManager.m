//
//  LFPermissionManager.m
//  NoticeSheet
//
//  Created by libx on 2019/8/2.
//  Copyright © 2019 LF. All rights reserved.
//

#import "LFPermissionManager.h"
#import <Photos/Photos.h>                          // 相册
#import <AVFoundation/AVFoundation.h>              // 相机/麦克风
#import <Contacts/Contacts.h>                      // 通讯录
#import <Speech/Speech.h>                          // 语音识别
#import <EventKit/EventKit.h>                      // 日历
#import <UserNotifications/UserNotifications.h>    // 通知

static NSString * const _Nonnull tipOfCamera           =   @"App没有相机使用权限，您可以在\"隐私设置\"中启用访问";
static NSString * const _Nonnull tipOfPhotoLibrary     =   @"App没有相册使用权限，您可以在\"隐私设置\"中启用访问";
static NSString * const _Nonnull tipOfMicrophone       =   @"App没有麦克风使用权限，您可以在\"隐私设置\"中启用访问";
static NSString * const _Nonnull tipOfAddressBook      =   @"App没有通讯录使用权限，您可以在\"隐私设置\"中启用访问";
static NSString * const _Nonnull tipOfSRUDescription   =   @"App没有语音识别使用权限，您可以在\"隐私设置\"中启用访问";
static NSString * const _Nonnull tipOfCalendar         =   @"App没有日历使用权限，您可以在\"隐私设置\"中启用访问";
static NSString * const _Nonnull tipOfNotification     =   @"App没有通知使用权限，您可以在\"隐私设置\"中启用访问";

static NSString * const _Nonnull tipOfError            =   @"权限参数错误，无法识别";

/// 未获得权限的提示
static __inline__ __attribute__((always_inline)) void ShowAlert(__unsafe_unretained NSString *alert) {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:alert preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"去开启" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (@available(iOS 10, *)) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:^(BOOL success) {
                }];
            }
        }]];
        
        UIViewController *topRootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
        while (topRootViewController.presentedViewController)
        {
            topRootViewController = topRootViewController.presentedViewController;
        }
        
        [topRootViewController presentViewController:alertController animated:YES completion:^{
        }];
    });
}

@implementation LFPermissionManager
+ (void)checkPermissions:(LFPermissionType)type handler:(void (^)(LFAuthorizationStatus status))handler {
    switch (type) {
        case LFPermissionTypeCamera: {
            [LFPermissionManager checkPermissionsOfCameraCompletionHandler:^(LFAuthorizationStatus status) {
                handler(status);
            }];
            break;
        }
        case LFPermissionTypePhotoLibrary: {
            [LFPermissionManager checkPermissionsPhotoLibraryCompletionHandler:^(LFAuthorizationStatus status) {
                handler(status);
            }];
            break;
        }
        case LFPermissionTypeMicrophone: {
            [LFPermissionManager checkPermissionsOfMicrophoneCompletionHandler:^(LFAuthorizationStatus status) {
                handler(status);
            }];
            break;
        }
        case LFPermissionTypeAddressBook: {
            [LFPermissionManager checkPermissionsOfAddressBookCompletionHandler:^(LFAuthorizationStatus status) {
                handler(status);
            }];
            break;
        }
        case LFPermissionTypeSRUDescription: {
            [LFPermissionManager checkPermissionsOfSRUDescriptionCompletionHandler:^(LFAuthorizationStatus status) {
                handler(status);
            }];
            break;
        }
        case LFPermissionTypeCalendar: {
            [LFPermissionManager checkPermissionsOfCalendarCompletionHandler:^(LFAuthorizationStatus status) {
                handler(status);
            }];
            break;
        }
        case LFPermissionTypeNotification: {
            [LFPermissionManager checkPermissionsOfNotificationCompletionHandler:^(LFAuthorizationStatus status) {
                handler(status);
            }];
            break;
        }
        default: {
            ShowAlert(tipOfError);
            handler(LFAuthorizationStatusError);
            break;
        }
    }
}

/// 检查拍照权限
+ (void)checkPermissionsOfCameraCompletionHandler:(void (^)(LFAuthorizationStatus status))handler {
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    switch (authStatus) {
        case AVAuthorizationStatusRestricted: {
            ShowAlert(tipOfCamera);
            handler(LFAuthorizationStatusRestricted);
            break;
        }
        case AVAuthorizationStatusDenied: {
            ShowAlert(tipOfCamera);
            handler(LFAuthorizationStatusDenied);
            break;
        }
        case AVAuthorizationStatusNotDetermined: {
            [AVCaptureDevice requestAccessForMediaType:mediaType completionHandler:^(BOOL granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if(granted){
                        handler(LFAuthorizationStatusAuthorized);
                    } else {
                        ShowAlert(tipOfCamera);
                        handler(LFAuthorizationStatusDenied);
                    }
                });
            }];
            break;
        }
        default: {
            handler(LFAuthorizationStatusAuthorized);
            break;
        }
    }
}

/// 检查相册权限
+ (void)checkPermissionsPhotoLibraryCompletionHandler:(void (^)(LFAuthorizationStatus status))handler {
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        dispatch_async(dispatch_get_main_queue(), ^{
            switch (status) {
                case PHAuthorizationStatusAuthorized: {
                    handler(LFAuthorizationStatusAuthorized);
                    break;
                }
                case PHAuthorizationStatusDenied: {
                    ShowAlert(tipOfPhotoLibrary);
                    handler(LFAuthorizationStatusDenied);
                    break;
                }
                case PHAuthorizationStatusRestricted: {
                    ShowAlert(tipOfPhotoLibrary);
                    handler(LFAuthorizationStatusDenied);
                    break;
                }
                default: {
                    ShowAlert(tipOfError);
                    handler(LFAuthorizationStatusError);
                    break;
                }
            }
        });
    }];
}

/// 检查麦克风权限 - 权限获取是同步线程获取
+ (void)checkPermissionsOfMicrophoneCompletionHandler:(void (^)(LFAuthorizationStatus status))handler {
    [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (granted) {
                handler(LFAuthorizationStatusAuthorized);
            } else {
                ShowAlert(tipOfMicrophone);
                handler(LFAuthorizationStatusDenied);
            }
        });
    }];
}

/// 检查通讯录权限
+ (void)checkPermissionsOfAddressBookCompletionHandler:(void (^)(LFAuthorizationStatus status))handler {
    if (@available(iOS 10, *)) {
        
        CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
        switch (status) {
            case CNAuthorizationStatusRestricted: {
                ShowAlert(tipOfAddressBook);
                handler(LFAuthorizationStatusRestricted);
                break;
            }
            case CNAuthorizationStatusDenied: {
                ShowAlert(tipOfAddressBook);
                handler(LFAuthorizationStatusDenied);
                break;
            }
            case CNAuthorizationStatusNotDetermined: {
                CNContactStore *store = [[CNContactStore alloc] init];
                [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError*  _Nullable error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (granted && error == nil) {
                            handler(LFAuthorizationStatusAuthorized);
                        } else {
                            ShowAlert(tipOfAddressBook);
                            handler(LFAuthorizationStatusDenied);
                        }
                    });
                }];
                break;
            }
            default: {
                handler(LFAuthorizationStatusAuthorized);
                break;
            }
        }
    }
}

/// 检查语音识别权限
+ (void)checkPermissionsOfSRUDescriptionCompletionHandler:(void (^)(LFAuthorizationStatus status))handler {
    if (@available(iOS 10, *)) {
        [SFSpeechRecognizer requestAuthorization:^(SFSpeechRecognizerAuthorizationStatus status) {
            dispatch_async(dispatch_get_main_queue(), ^{
                switch (status) {
                    case SFSpeechRecognizerAuthorizationStatusRestricted: {
                        ShowAlert(tipOfSRUDescription);
                        handler(LFAuthorizationStatusRestricted);
                        break;
                    }
                    case SFSpeechRecognizerAuthorizationStatusDenied: {
                        ShowAlert(tipOfSRUDescription);
                        handler(LFAuthorizationStatusDenied);
                        break;
                    }
                    case SFSpeechRecognizerAuthorizationStatusAuthorized: {
                        handler(LFAuthorizationStatusAuthorized);
                        break;
                    }
                    default: {
                        ShowAlert(tipOfError);
                        handler(LFAuthorizationStatusError);
                        break;
                    }
                }
            });
        }];
    }
}

/// 检查日历权限
+ (void)checkPermissionsOfCalendarCompletionHandler:(void (^)(LFAuthorizationStatus status))handler {
    EKAuthorizationStatus status = [EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent];
    switch (status) {
        case EKAuthorizationStatusDenied: {
            handler(LFAuthorizationStatusDenied);
            ShowAlert(tipOfCalendar);
            break;
        }
        case EKAuthorizationStatusRestricted: {
            handler(LFAuthorizationStatusRestricted);
            ShowAlert(tipOfCalendar);
            break;
        }
        case EKAuthorizationStatusNotDetermined: {
            EKEventStore *store = [[EKEventStore alloc] init];
            [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError * _Nullable error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (granted && error == nil) {
                        handler(LFAuthorizationStatusAuthorized);
                    } else {
                        handler(LFAuthorizationStatusDenied);
                        ShowAlert(tipOfCalendar);
                    }
                });
            }];
            break;
        }
        default: {
            handler(LFAuthorizationStatusAuthorized);
            break;
        }
    }
}

/// 检查通知权限，如果返回Authorized，那么是获取权限或者还没有配置权限，因为这里如果配置权限跟极光冲突，所以这里只是单纯的获取权限
+ (void)checkPermissionsOfNotificationCompletionHandler:(void (^)(LFAuthorizationStatus status))handler {
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    
    [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
        switch (settings.authorizationStatus) {
            case UNAuthorizationStatusDenied: {
                ShowAlert(tipOfNotification);
                handler(LFAuthorizationStatusDenied);
                break;
            }
            case UNAuthorizationStatusNotDetermined: {
                [center requestAuthorizationWithOptions:UNAuthorizationOptionSound | UNAuthorizationOptionBadge | UNAuthorizationOptionAlert completionHandler:^(BOOL granted, NSError * _Nullable error) {
                    sleep(3);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
                            switch (settings.authorizationStatus) {
                                case UNAuthorizationStatusDenied: {
                                    ShowAlert(tipOfNotification);
                                    handler(LFAuthorizationStatusDenied);
                                    break;
                                }
                                default: {
                                    handler(LFAuthorizationStatusAuthorized);
                                    break;
                                }
                            }
                        }];
                    });
                }];
                break;
            }
            default: {
                handler(LFAuthorizationStatusAuthorized);
                break;
            }
        }
    }];
}

@end
