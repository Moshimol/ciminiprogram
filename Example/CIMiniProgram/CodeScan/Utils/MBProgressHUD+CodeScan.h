//
//  MBProgressHUD+CodeScan.h
//  MBProgressHUD+CodeScan
//
//  Created by 袁鑫 on 2019/11/19.
//  Copyright © 2015年 Ci123. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>

@interface MBProgressHUD (SGQRCode)

/** MBProgressHUD修改后的样式 添加到self.navigationController.view上，导航栏不能被点击 */
+ (MBProgressHUD *)cs_showMBProgressHUDWithModifyStyleMessage:(NSString *)message toView:(UIView *)view;
/** MBProgressHUD系统自带样式 添加到self.navigationController.view上，导航栏不能被点击 */
+ (MBProgressHUD *)cs_showMBProgressHUDWithSystemComesStyleMessage:(NSString *)message toView:(UIView *)view;
/** 10s之后隐藏 */
+ (MBProgressHUD *)cs_showMBProgressHUD10sHideWithModifyStyleMessage:(NSString *)message toView:(UIView *)view;

/** 显示加载成功的 MBProgressHUD */
+ (void)cs_showMBProgressHUDOfSuccessMessage:(NSString *)message toView:(UIView *)view;

/** 显示加载失败的 MBProgressHUD */
+ (void)cs_showMBProgressHUDOfErrorMessage:(NSString *)message toView:(UIView *)view;

/** 隐藏MBProgressHUD 要与添加的view保持一致 */
+ (void)cs_hideHUDForView:(UIView *)view;

/** 只显示文字的 15 号字体（文字最好不要超过 14 个汉字） MBProgressHUD */
+ (void)cs_showMBProgressHUDWithOnlyMessage:(NSString *)message delayTime:(CGFloat)time;

@end
