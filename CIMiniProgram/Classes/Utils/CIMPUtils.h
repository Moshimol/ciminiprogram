//
//  CIMPUtils.h
//  CIMiniProgram
//
//  Created by 袁鑫 on 2020/4/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CIMPUtils : NSObject

+ (UIColor *)SMRGB:(unsigned int)rgbValue;
+ (UIColor *)SMRGBA:(unsigned int)rgbValue alpha:(float)alpha;

//颜色转换如字符串#c60a1e -> UIColor
+ (UIColor *)MP_Color_Conversion:(NSString *)Color_Value;

/**
 获取文本大小

 @param text 文本信息
 @param font 字体类型
 */
+ (CGSize)getTextSize:(NSString *)text font:(UIFont *)font;

/**
 获取文本高度

 @param text 文本信息
 @param font 字体类型
 @param width 字体宽度
 */
+ (CGFloat) getTextHeight:(NSString *)text font:(UIFont *)font width:(CGFloat)width;

/**
 获取文本高度

 @param text 文本信息
 @param font 字体类型
 @param height 字体高度
 */
+ (CGFloat) getTextWidth:(NSString *)text font:(UIFont *)font height:(CGFloat)height;

/**
 压缩图片
 */
+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;

/**
 生产纯色图片
 
 @param rect 图片大小
 */
+ (UIImage *)imageFromColor:(UIColor *)color rect:(CGRect)rect;

@end

NS_ASSUME_NONNULL_END
