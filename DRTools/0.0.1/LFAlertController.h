//
//  LFAlertController.h
//  NoticeSheet
//
//  Created by libx on 2019/7/26.
//  Copyright © 2019 LF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LFResultCode.h"

NS_ASSUME_NONNULL_BEGIN

@interface LFAlertController : NSObject

/**
 显示 UIAlertController （不带输入框，可以自定义多个菜单）
 
 @note LFResultCode 确定/取消/Other，如果code是Other的值，则actionTitle是自定义菜单的点击的字符串
 */
+ (void)showAlertTitle:(NSString *)title
               message:(NSString *)message
           cancelTitle:(NSString *)cancelTitle
             sureTitle:(NSString *)sureTitle
        preferredStyle:(UIAlertControllerStyle)preferredStyle
                 block:(void (^)(LFResultCode code))block;

/**
 显示 UIAlertController（带输入框，不可以自定义多个菜单）
 
 @note LFResultCode 确定/取消，  inputString 输入的字符串
 */
+ (void)showInputAlertTitle:(NSString *)title
                    message:(NSString *)message
                cancelTitle:(NSString *)cancelTitle
                  sureTitle:(NSString *)sureTitle
                      block:(void (^)(LFResultCode code, NSString *inputString))block;
@end

NS_ASSUME_NONNULL_END
