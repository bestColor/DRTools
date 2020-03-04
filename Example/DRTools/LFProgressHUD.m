//
//  LFProgressHUD.m
//  NoticeSheet
//
//  Created by libx on 2019/7/26.
//  Copyright © 2019 LF. All rights reserved.
//

#import "LFProgressHUD.h"
#import <MBProgressHUD/MBProgressHUD.h>

static int const minDelay = 2.0f;
static int const maxDelay = 15.0f;

@interface ProgressHUD : NSObject
@property (nonatomic, strong) MBProgressHUD *pHUD;

@property (nonatomic, strong) UIImageView *gifImageView;

@end

@implementation ProgressHUD
+ (id)sharedManager {
    static ProgressHUD *_progressHUD = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _progressHUD = [[ProgressHUD alloc] init];
    });
    return _progressHUD;
}

- (void)setpHUD:(MBProgressHUD *)pHUD {
    _pHUD = pHUD;
}

- (MBProgressHUD *)pHUD {
    return _pHUD;
}

- (UIImageView *)gifImageView {
    if (!_gifImageView) {
        _gifImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        
        NSString *gifPath = [[NSBundle mainBundle] pathForResource:@"Loading" ofType:@"gif"];
        
        CGImageSourceRef source = CGImageSourceCreateWithURL((CFURLRef)[NSURL fileURLWithPath:gifPath], NULL);
        // 获取图片个数
        size_t count = CGImageSourceGetCount(source);
        // 定义一个可变数组存放所有图片
        NSMutableArray *imageArray = [[NSMutableArray alloc] init];

        // 遍历gif
        for (size_t i = 0; i < count; i++) {
            CGImageRef image = CGImageSourceCreateImageAtIndex(source, i, NULL);
            [imageArray addObject:[UIImage imageWithCGImage:image scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp]];
            CGImageRelease(image);
        }
        CFRelease(source);
        
        _gifImageView.animationImages = imageArray;
        _gifImageView.animationDuration = 2.4;
        _gifImageView.animationRepeatCount = 0;
        _gifImageView.image = [imageArray firstObject];
        [_gifImageView startAnimating];
    }
    return _gifImageView;
}

@end

static void ShowAlert(NSString *title, BOOL enable, float hideAfterDelay, MBProgressHUDMode mode) {
    dispatch_async(dispatch_get_main_queue(), ^{
        ProgressHUD *manager = [ProgressHUD sharedManager];
        if (manager.pHUD) {
            [manager.pHUD removeFromSuperview];
            manager.pHUD = nil;
        }
        manager.pHUD = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        manager.pHUD.mode = mode;
        manager.pHUD.label.text = title;
        manager.pHUD.userInteractionEnabled = enable;
        [manager.pHUD hideAnimated:YES afterDelay:hideAfterDelay];
    });
}

static void ShowYTAlert(BOOL enable) {
    dispatch_async(dispatch_get_main_queue(), ^{
        ProgressHUD *manager = [ProgressHUD sharedManager];
        if (manager.pHUD) {
            [manager.pHUD removeFromSuperview];
            manager.pHUD = nil;
        }
        // 添加到view上
        manager.pHUD = [MBProgressHUD showHUDAddedTo:[[[UIApplication sharedApplication].keyWindow subviews] objectAtIndex:0] animated:YES];
        manager.pHUD.mode = MBProgressHUDModeCustomView;
        manager.pHUD.customView = manager.gifImageView;
        [manager.gifImageView startAnimating];
        manager.pHUD.userInteractionEnabled = enable;
        manager.pHUD.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        manager.pHUD.bezelView.backgroundColor = [UIColor clearColor];
        [manager.pHUD hideAnimated:YES afterDelay:maxDelay];
    });
}

@implementation LFProgressHUD

+ (void)showYTAlert {
    ShowYTAlert(NO);
}

+ (void)showAlert:(NSString *)title {
    ShowAlert(title, NO, minDelay, MBProgressHUDModeText);
}

+ (void)showActivityAlert:(NSString *)title {
    ShowAlert(title, NO, minDelay, MBProgressHUDModeIndeterminate);
}

+ (void)showDisenableAlert:(NSString *)title {
    ShowAlert(title, YES, maxDelay, MBProgressHUDModeIndeterminate);
}

+ (void)hideAlert {
    ProgressHUD *manager = [ProgressHUD sharedManager];
    [manager.pHUD hideAnimated:YES];
    [manager.gifImageView stopAnimating];
}

@end
