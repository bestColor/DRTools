//
//  LFProgressHUD.h
//  NoticeSheet
//
//  Created by libx on 2019/7/26.
//  Copyright © 2019 LF. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LFProgressHUD : NSObject

/// 显示悦淘指示器
+ (void)showYTAlert;

/// 显示文字指示器 (背景可触摸)
+ (void)showAlert:(NSString *)title;

/// 显示转圈指示器 (背景可触摸)
+ (void)showActivityAlert:(NSString *)title;

/// 显示指示器 (背景不可以触摸)
+ (void)showDisenableAlert:(NSString *)title;

/// 主动隐藏指示器
+ (void)hideAlert;

@end

NS_ASSUME_NONNULL_END
