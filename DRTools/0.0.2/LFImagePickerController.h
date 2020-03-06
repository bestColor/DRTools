//
//  LFImagePickerController.h
//  NoticeSheet
//
//  Created by libx on 2019/8/20.
//  Copyright © 2019 LF. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, ImagePickerResultCode) {
    ImagePickerResultCodeSuccessed = 1,
    ImagePickerResultCodeCancel,
    ImagePickerResultCodeError,
};

NS_ASSUME_NONNULL_BEGIN

@interface LFImagePickerController : NSObject

/** 显示 拍照/从相册选择 的alert 不压缩*/
- (void)showImagePickerAlert:(void(^)(ImagePickerResultCode code, UIImage *_Nullable image))block;

@end

NS_ASSUME_NONNULL_END
