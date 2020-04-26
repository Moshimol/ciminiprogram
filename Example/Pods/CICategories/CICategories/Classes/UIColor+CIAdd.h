//
//  UIColor+CIAdd.h
//  MyApp_HGB
//
//  Created by ikeyyang on 2017/9/28.
//  Copyright © 2017年 com.ci123.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (CIAdd)
/**
 十六进制色值转为颜色

 @param hexString 色值
 @return color
 */
+ (UIColor *)ColorWithHexString:(NSString *)hexString;

#pragma mark 颜色
/**
 颜色

 @param r 红色
 @param g 绿色
 @param b 蓝色
 @param a 透明度
 @return 颜色
 */
#ifndef RGBAColor
#define RGBAColor(r,g,b,a)  [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#endif
/**
 颜色-不透明

 @param r 红色
 @param g 绿色
 @param b 蓝色
 @return 颜色
 */
#ifndef RGBColor
#define RGBColor(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#endif

@end
