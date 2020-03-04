//
//  LFAudioTool.m
//  JGTown
//
//  Created by libx on 2019/6/20.
//  Copyright © 2019 JG. All rights reserved.
//

#import "LFAudioTool.h"

/// 触觉反馈，暂时无用
#import <UIKit/UIImpactFeedbackGenerator.h>

static NSString * const sound_ringtone = @"tishiyin";
static NSString * const sound_mute = @"jingyin";
static NSString * const sound_type = @"caf";

@implementation LFAudioTool

/// 播放 铃声
+ (SystemSoundID)playSoundType:(LFAlertSoundType)alertSoundType soundID:(SystemSoundID)soundID {
    switch (alertSoundType) {
        case LFAlertSoundTypeMute:
            return [LFAudioTool playSystemSound:soundID soundName:sound_mute];
            break;
        case LFAlertSoundTypeRingtone:
            return [LFAudioTool playSystemSound:soundID soundName:sound_ringtone];
            break;
        case LFAlertSoundTypeShock:
            [LFAudioTool playShock];
            break;
        case LFAlertSoundTypeBlend:
            [LFAudioTool playShock];
            return [LFAudioTool playSystemSound:soundID soundName:sound_ringtone];
            break;
        default:
            break;
    }
    return soundID;
}

/// 播放铃声
+ (SystemSoundID)playSystemSound:(SystemSoundID)soundID
                       soundName:(NSString *)soundName {
    if (soundID) {
        AudioServicesPlaySystemSound(soundID);
        return soundID;
    }
    
    // 获取文件路径
    NSString *filePath = [[NSBundle mainBundle] pathForResource:soundName ofType:sound_type];
    
    // 加载音效文件，得到对应的音效ID
    SystemSoundID newSoundID = 0;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef _Nonnull)[NSURL fileURLWithPath:filePath], &newSoundID);
    // 播放音效
    AudioServicesPlaySystemSound(newSoundID);
    return newSoundID;
}

/// 停止播放铃声
+ (void)stopSystemSound:(SystemSoundID)soundID {
    //把需要销毁的音效文件的ID传递给它既可销毁
    AudioServicesDisposeSystemSoundID(soundID);
}

/// 播放震动
+ (void)playShock {
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

@end
