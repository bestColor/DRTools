//
//  LFAudioTool.h
//  JGTown
//
//  Created by libx on 2019/6/20.
//  Copyright © 2019 JG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

typedef NS_ENUM(NSUInteger, LFAlertSoundType) {
    LFAlertSoundTypeMute = 1,             // 静音
    LFAlertSoundTypeRingtone,             // 铃声
    LFAlertSoundTypeShock,                // 震动
    LFAlertSoundTypeBlend,                // 混合（震动+铃声）
};

NS_ASSUME_NONNULL_BEGIN

@interface LFAudioTool : NSObject

/// 播放 铃声
+ (SystemSoundID)playSoundType:(LFAlertSoundType)alertSoundType soundID:(SystemSoundID)soundID;

/// 停止播放铃声
+ (void)stopSystemSound:(SystemSoundID)soundID;

/// 播放震动
+ (void)playShock;

@end

NS_ASSUME_NONNULL_END
