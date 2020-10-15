//
//  UIImage+CIMiniProgram.h
//  CIMiniProgram
//
//  Created by 袁鑫 on 2020/4/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (CIMiniProgram)

+ (UIImage *)imageFromBundleWithName:(NSString *)imageName class:(Class)bundleClass;

@end

NS_ASSUME_NONNULL_END
