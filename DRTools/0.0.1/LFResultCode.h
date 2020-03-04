
//
//  LFResultCode.h
//  NoticeSheet
//
//  Created by libx on 2019/7/29.
//  Copyright © 2019 LF. All rights reserved.
//

#ifndef LFResultCode_h
#define LFResultCode_h

typedef NS_ENUM(NSInteger, LFResultCode) {
    LFResultCodeFailed = -1,
    LFResultCodeSuccess = 1,
    LFResultCodeSure = LFResultCodeSuccess,
    LFResultCodeCancel = LFResultCodeFailed,
    LFResultCodeOther,
};

#endif /* LFResultCode_h */
