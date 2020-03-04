//
//  LFAlertController.m
//  NoticeSheet
//
//  Created by libx on 2019/7/26.
//  Copyright © 2019 LF. All rights reserved.
//

#import "LFAlertController.h"

/// 跳转
static __inline__ __attribute__((always_inline)) void PresentViewController(__unsafe_unretained UIAlertController *alertController) {
    UIViewController *topRootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (topRootViewController.presentedViewController)
    {
        topRootViewController = topRootViewController.presentedViewController;
    }
    
    [topRootViewController presentViewController:alertController animated:YES completion:^{
    }];
}

@implementation LFAlertController
+ (void)showAlertTitle:(NSString *)title
               message:(NSString *)message
           cancelTitle:(NSString *)cancelTitle
             sureTitle:(NSString *)sureTitle
        preferredStyle:(UIAlertControllerStyle)preferredStyle
                 block:(void (^)(LFResultCode code))block {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? UIAlertControllerStyleAlert : preferredStyle];
    
    if (cancelTitle.length) {
        [alertController addAction:[UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            block(LFResultCodeCancel);
        }]];
    }
    
    if (sureTitle.length) {
        [alertController addAction:[UIAlertAction actionWithTitle:sureTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            block(LFResultCodeSure);
        }]];
    }
    
    PresentViewController(alertController);
}

+ (void)showInputAlertTitle:(NSString *)title
                    message:(NSString *)message
                cancelTitle:(NSString *)cancelTitle
                  sureTitle:(NSString *)sureTitle
                      block:(void (^)(LFResultCode code, NSString *inputString))block {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    __weak typeof(alertController)weakAlert = alertController;
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
    }];
    
    if (cancelTitle.length) {
        [alertController addAction:[UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            block(LFResultCodeCancel, @"");
        }]];
    }
    
    if (sureTitle.length) {
        [alertController addAction:[UIAlertAction actionWithTitle:sureTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

            UITextField *inputTextField = weakAlert.textFields.firstObject;
            block(LFResultCodeSure, inputTextField.text);

        }]];
    }
    
    PresentViewController(alertController);
}

@end
