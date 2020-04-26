//
//  CIScan.m
//  CICamera
//
//  Created by 大大大大_荧🐾 on 2020/2/20.
//  Copyright © 2020 大大大大_荧🐾. All rights reserved.
//

#import "CIScan.h"
@import AVFoundation;
#import "CIScanViewController.h"

@implementation CIScan

+ (void)showCIScanWith:(UIViewController *)presentViewController completionHandler:(void (^)(NSString * _Nonnull))completionHandler {
    // 获取授权状态，进行筛选
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    if (status == AVAuthorizationStatusAuthorized) {
        CIScanViewController *viewController = [[CIScanViewController alloc] init];
        viewController.completeScanWithReslut = completionHandler;
        viewController.modalPresentationStyle = UIModalPresentationFullScreen;
        [presentViewController presentViewController:viewController animated:YES completion:nil];
    } else if (status == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted == YES) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    CIScanViewController *viewController = [[CIScanViewController alloc] init];
                    viewController.completeScanWithReslut = completionHandler;
                    viewController.modalPresentationStyle = UIModalPresentationFullScreen;
                    [presentViewController presentViewController:viewController animated:YES completion:nil];
                });
            } else {
                NSLog(@"啊哦，您还没有开启权限哦╮(╯▽╰)╭");
            }
        }];
    } else {
        NSLog(@"啊哦，您还没有开启权限哦╮(╯▽╰)╭");
    }
}

@end
