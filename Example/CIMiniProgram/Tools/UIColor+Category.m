//
//  UIColor+Category.m
//  CIWallet
//
//  Created by 袁鑫 on 2019/11/18.
//  Copyright © 2019 Ci123. All rights reserved.
//

#import "UIColor+Category.h"

@implementation UIColor (Category)

+ (UIColor *)ColorWithHexString:(NSString *)color {
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    if ([cString length] != 7) {
        return UIColor.clearColor;
    }
    cString = [cString substringFromIndex:1];
    
    if ([cString length] != 6) {
        return UIColor.clearColor;
    }
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    // r
    NSString *rString = [cString substringWithRange:range];
    
    // g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    // b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0) green:((float) g / 255.0) blue:((float) b / 255.0) alpha:1.0];
}

@end
