//
//  UIImage+CIMiniProgram.m
//  CIMiniProgram
//
//  Created by 袁鑫 on 2020/4/14.
//

#import "UIImage+CIMiniProgram.h"

@implementation UIImage (CIMiniProgram)

+ (UIImage *)imageFromBundleWithName:(NSString *)imageName class:(nonnull Class)bundleClass {
    NSBundle *currentBundle = [NSBundle bundleForClass:bundleClass];
    NSDictionary *dic = currentBundle.infoDictionary;
    NSString *bundleName = dic[@"CFBundleExecutable"];
    
    NSInteger scale = UIScreen.mainScreen.scale;
    NSString *imageFullName = [NSString stringWithFormat:@"%@@%zdx.png", imageName, scale];
    NSString *path = [currentBundle pathForResource:imageFullName ofType:nil inDirectory:[NSString stringWithFormat:@"%@.bundle", bundleName]];
    
    return [UIImage imageWithContentsOfFile:path];
}

@end
