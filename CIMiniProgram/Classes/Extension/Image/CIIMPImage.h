//
//  CIIMPImage.h
//  CIMiniProgram
//
//  Created by 袁鑫 on 2020/4/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CIIMPImage : NSObject

+ (void)getImageInfo:(NSDictionary *)param callback:(void(^)(NSDictionary *))callback;

+ (void)compressImage:(NSDictionary *)param callback:(void(^)(NSDictionary *))callback;

+ (NSString *)writeImageToFile:(UIImage *)image;

// 写文件并且写入后缀
+ (NSString *)writeImageToFile:(UIImage *)image fileNameSuffix:(NSString *)suffixName;

// 得到全路径的image
+ (NSString *)getFullImagePathImageName:(NSString *)imageName;

@end

NS_ASSUME_NONNULL_END
