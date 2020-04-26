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

@end

NS_ASSUME_NONNULL_END
