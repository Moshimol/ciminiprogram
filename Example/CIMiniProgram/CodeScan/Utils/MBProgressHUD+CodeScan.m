//
//  MBProgressHUD+CodeScan.m
//  MBProgressHUD+CodeScan
//
//  Created by 袁鑫 on 2019/11/14.
//  Copyright © 2015年 Ci123. All rights reserved.
//

#import "MBProgressHUD+CodeScan.h"

@implementation MBProgressHUD (SGQRCode)

/** MBProgressHUD 修改后的样式 */
+ (MBProgressHUD *)cs_showMBProgressHUDWithModifyStyleMessage:(NSString *)message toView:(UIView *)view {
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = message;
    hud.labelFont = [UIFont systemFontOfSize:15];
    
    // bezelView.color 自定义progress背景色（默认为白色）
    hud.backgroundColor = [UIColor blackColor];
    // 内容的颜色
    hud.color = [UIColor whiteColor];
    
    [hud hide:YES afterDelay:5];
    // 隐藏时从父控件上移除
    hud.removeFromSuperViewOnHide = YES;
    return hud;
}
/** MBProgressHUD 自带样式 */
+ (MBProgressHUD *)cs_showMBProgressHUDWithSystemComesStyleMessage:(NSString *)message toView:(UIView *)view {
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = message;
    hud.labelFont = [UIFont systemFontOfSize:15];
    [hud hide:YES afterDelay:5];
    // 隐藏时从父控件上移除
    hud.removeFromSuperViewOnHide = YES;
    return hud;
}

#pragma mark - - - 显示信息
+ (void)showMessage:(NSString *)message icon:(NSString *)icon toView:(UIView *)view {
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = message;
    hud.labelFont = [UIFont systemFontOfSize:15];
    
    // bezelView.color 自定义progress背景色（默认为白色）
    hud.backgroundColor = [UIColor blackColor];
    // 内容的颜色
    hud.color = [UIColor whiteColor];
    
    // 设置图片
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@", icon]]];
    
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    // 1秒之后再消失
    [hud hide:YES afterDelay:1.0];
}

/** 显示加载成功的 MBProgressHUD */
+ (void)cs_showMBProgressHUDOfSuccessMessage:(NSString *)message toView:(UIView *)view {
    [self showMessage:message icon:@"success" toView:view];
}

/** 显示加载失败的 MBProgressHUD */
+ (void)cs_showMBProgressHUDOfErrorMessage:(NSString *)message toView:(UIView *)view {
    [self showMessage:message icon:@"error" toView:view];
}

#pragma mark - - - 隐藏MBProgressHUD
/** 隐藏 MBProgressHUD */
+ (void)cs_hideHUDForView:(UIView *)view {
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    [self hideHUDForView:view animated:YES];
}

/** MBProgressHUD 修改后的样式 (10s) */
+ (MBProgressHUD *)cs_showMBProgressHUD10sHideWithModifyStyleMessage:(NSString *)message toView:(UIView *)view {
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = message;
    hud.labelFont = [UIFont systemFontOfSize:15];
    
    // bezelView.color 自定义progress背景色（默认为白色）
    hud.backgroundColor = [UIColor blackColor];
    // 内容的颜色
    hud.color = [UIColor whiteColor];
    
    [hud hide:YES afterDelay:10];
    // 隐藏时从父控件上移除
    hud.removeFromSuperViewOnHide = YES;
    return hud;
}


/** 只显示文字的 15 号字体（文字最好不要超过 14 个汉字） MBProgressHUD */
+ (void)cs_showMBProgressHUDWithOnlyMessage:(NSString *)message delayTime:(CGFloat)time {
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:[[[UIApplication sharedApplication] delegate] window]] ;
    hud.mode = MBProgressHUDModeText;
    hud.labelText = message;
    hud.labelFont = [UIFont systemFontOfSize:15.0];
    hud.removeFromSuperViewOnHide = YES;
    hud.backgroundColor = [UIColor blackColor];
    hud.color = [UIColor whiteColor];
    [hud showAnimated:YES whileExecutingBlock:nil];
    
    [[[[UIApplication sharedApplication] delegate] window] addSubview:hud];
    [hud hide:YES afterDelay:time];
}

@end
