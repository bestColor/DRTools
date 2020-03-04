//
//  LFImagePickerController.m
//  NoticeSheet
//
//  Created by libx on 2019/8/20.
//  Copyright © 2019 LF. All rights reserved.
//

#import "LFImagePickerController.h"
#import <Photos/Photos.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreServices/CoreServices.h>

typedef void(^SelectedImageBlock)(ImagePickerResultCode code, UIImage *_Nullable image);

@interface LFImagePickerController()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (nonatomic, strong) UIImagePickerController *imagePickerController;
@property (nonatomic, strong) SelectedImageBlock resultBlock;
@end

@implementation LFImagePickerController

- (void)dealloc
{
    NSLog(@"选择 相机/相册 控件释放");
}

- (void)showImagePickerAlert:(void(^)(ImagePickerResultCode code, UIImage *_Nullable image))block {
    self.resultBlock = block;
    [self show];
}

- (void)show {
    if (!self.imagePickerController) {
        self.imagePickerController = [[UIImagePickerController alloc] init];
        self.imagePickerController.delegate = self;
        self.imagePickerController.allowsEditing = NO;
    }
    
    UIAlertControllerStyle style = UIAlertControllerStyleActionSheet;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        style = UIAlertControllerStyleAlert;
    }
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请选择" message:nil preferredStyle:style];
    
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        //判断是否可以打开照相机
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            //摄像头
            self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            
            [self im_isCanUseCamera:^(BOOL isCanUse) {
                if (isCanUse) {
                    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:self.imagePickerController animated:YES completion:nil];
                } else {
                    self.resultBlock(ImagePickerResultCodeError, nil);
                }
            }];
        } else {
            self.resultBlock(ImagePickerResultCodeError, nil);
        }
    }];
    
    UIAlertAction *libraryAction = [UIAlertAction actionWithTitle:@"从手机相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (@available(iOS 11, *)) {
            UIScrollView.appearance.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
        }
        self.imagePickerController.navigationBar.tintColor = [UIColor blackColor];
        self.imagePickerController.navigationBar.barTintColor = [UIColor whiteColor];
        
        //判断是否可以打开相册
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
            //摄像头
            self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            
            [self im_isCanUsePhotoLibrary:^(BOOL isCanUse) {
                if (isCanUse) {
                    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:self.imagePickerController animated:YES completion:nil];
                    
                } else {
                    self.resultBlock(ImagePickerResultCodeError, nil);
                }
            }];
        } else {
            self.resultBlock(ImagePickerResultCodeError, nil);
        }
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    [alertController addAction:cameraAction];
    [alertController addAction:libraryAction];
    [alertController addAction:cancelAction];
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    self.resultBlock(ImagePickerResultCodeCancel, nil);
    [[UIApplication sharedApplication].keyWindow.rootViewController dismissViewControllerAnimated:YES completion:nil];
}

//适用获取所有媒体资源，只需判断资源类型
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    NSString *mediaType=[info objectForKey:UIImagePickerControllerMediaType];
    //判断资源类型
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]){
        self.resultBlock(ImagePickerResultCodeSuccessed, info[UIImagePickerControllerOriginalImage]);
    }
    [[UIApplication sharedApplication].keyWindow.rootViewController dismissViewControllerAnimated:YES completion:nil];
}

/// 检查相册权限
- (void)im_isCanUsePhotoLibrary:(void (^)(BOOL isCanUse))handler {
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        dispatch_async(dispatch_get_main_queue(), ^{
            switch (status) {
                case PHAuthorizationStatusAuthorized: {
                    handler(YES);
                    break;
                }
                case PHAuthorizationStatusDenied: {
                    [self im_showNoCanAlertIsCamera:false];
                    handler(NO);
                    break;
                }
                case PHAuthorizationStatusRestricted: {
                    [self im_showNoCanAlertIsCamera:false];
                    handler(NO);
                    break;
                }
                default: {
                    [self im_showNoCanAlertIsCamera:false];
                    handler(NO);
                    break;
                }
            }
        });
    }];
}

/// 检查拍照权限
- (void)im_isCanUseCamera:(void (^)(BOOL isCanUse))handler {
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    switch (authStatus) {
        case AVAuthorizationStatusRestricted: {
            [self im_showNoCanAlertIsCamera:true];
            handler(NO);
            break;
        }
        case AVAuthorizationStatusDenied: {
            [self im_showNoCanAlertIsCamera:true];
            handler(NO);
            break;
        }
        case AVAuthorizationStatusNotDetermined: {
            [AVCaptureDevice requestAccessForMediaType:mediaType completionHandler:^(BOOL granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if(granted){
                        handler(YES);
                    } else {
                        [self im_showNoCanAlertIsCamera:true];
                        handler(NO);
                    }
                });
            }];
            break;
        }
        default: {
            handler(YES);
            break;
        }
    }
}

- (void)im_showNoCanAlertIsCamera:(BOOL)isCamera {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:isCamera ? @"此应用没有相机使用权限, 您可以在\"隐私设置\"中启用访问." : @"此应用没有相册使用权限, 您可以在\"隐私设置\"中启用访问." preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"去开启" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (@available(iOS 10, *)) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:^(BOOL success) {
            }];
        }
    }]];
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:^{
    }];
}

@end
