//
//  CIMPLoadingView.h
//  CIMiniProgram
//
//  Created by 袁鑫 on 2020/4/9.
//  Copyright © 2020 Nanjing Xihui Information & Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CIMPLoadingView : UIView

/**
 显示Loading层
 
 @param view 指定页面
 @param text 文本
 @param mask YES:允许交互 NO:禁止交互
 */
+ (void)showInView:(UIView *)view text:(NSString *)text mask:(BOOL)mask;

/**
 隐藏指定页面的Loading层

 @param view 待移除的页面
 */
+ (void)hideInView:(UIView *)view;

+ (void)stopAnimationInView:(UIView *)view;

+ (void)startAnimationInView:(UIView *)view;

/**
 移除所有Loding
 */
+ (void)removeAllLoading;

@end

NS_ASSUME_NONNULL_END
