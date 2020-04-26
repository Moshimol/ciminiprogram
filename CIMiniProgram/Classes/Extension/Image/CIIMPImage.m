//
//  CIIMPImage.m
//  CIMiniProgram
//
//  Created by 袁鑫 on 2020/4/20.
//

#import "CIIMPImage.h"
#import "CIMPFileMacro.h"
#import "CIMPAppManager.h"
#import "CIMPApp.h"
#import <CINetworking/CINetworking.h>
#import <CICategories/CICategories.h>

@implementation CIIMPImage

+ (void)getImageInfo:(NSDictionary *)param callback:(void (^)(NSDictionary * _Nonnull))callback {
    NSString *src = param[@"src"];
    if (!src) {
        if (callback) {
            callback(@{@"errMsg": @"fail", @"message": @"src参数为空"});
        }
        return;
    }
    
    NSString *path = [[kMiniProgramPath stringByAppendingString:[CIMPAppManager sharedManager].currentApp.appInfo.appId] stringByAppendingString:src];
    if ([kFileManager fileExistsAtPath:path]) {
        UIImage *image = [UIImage imageWithContentsOfFile:path];
        if (!image) {
            if (callback) {
                callback(@{@"errMsg": @"fail", @"message": @"路径所指文件不是图片"});
            }
            return;
        }
        CGFloat width = image.size.width;
        CGFloat height = image.size.height;
        NSString *orientation = [self getImageOrientation:image];
        NSString *type = [self getImageType:image];
        if (callback) {
            callback(@{@"errMsg": @"ok", @"width": @(width), @"height": @(height), @"path": path, @"orientation": orientation, @"type": type});
        }
    } else {
        if (!([src hasPrefix:@"http://"] || [src hasSuffix:@"https://"])) {
            if (callback) {
                callback(@{@"errMsg": @"fail", @"message": @"src不是有效的本地路径或网络路径"});
            }
            return;
        }
        [[CINetworking sharedInstance] downloadFile:src parameters:nil progress:nil success:^(id  _Nullable responseObject) {
            UIImage *image = [UIImage imageWithData:responseObject];
            CGFloat width = image.size.width;
            CGFloat height = image.size.height;
            NSString *orientation = [self getImageOrientation:image];
            NSString *type = [self getImageType:image];
            if (callback) {
                callback(@{@"errMsg": @"ok", @"width": @(width), @"height": @(height), @"path": path, @"orientation": orientation, @"type": type});
            }
        } failure:^(NSError * _Nonnull error) {
            if (callback) {
                callback(@{@"errMsg": @"fail", @"message": @"下载图片失败"});
            }
        }];
    }
}

+ (void)compressImage:(NSDictionary *)param callback:(void (^)(NSDictionary * _Nonnull))callback {
    NSString *src = param[@"src"];
    if (!src) {
        if (callback) {
            callback(@{@"errMsg": @"fail", @"message": @"src参数为空"});
        }
        return;
    }
    
    NSString *path = [[kMiniProgramPath stringByAppendingString:[CIMPAppManager sharedManager].currentApp.appInfo.appId] stringByAppendingString:src];
    if (![kFileManager fileExistsAtPath:path]) {
        if (callback) {
            callback(@{@"errMsg": @"fail", @"message": @"指定路径图片不存在"});
        }
    }
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    if (!image) {
        if (callback) {
            callback(@{@"errMsg": @"fail", @"message": @"路径所指文件不是图片"});
        }
        return;
    }
    NSString *type = [self getImageType:image];
    if (![type isEqualToString:@"image/jpeg"]) {
        if (callback) {
            callback(@{@"errMsg": @"fail", @"message": @"图片不是jpg类型"});
        }
        return;
    }
    CGFloat compression = 0.8;
    NSNumber *quality = param[@"quality"];
    if (quality) {
        compression = [quality floatValue] / 100.0;
    }
    
    NSData *data = UIImageJPEGRepresentation(image, compression);
    NSString *appPath = [NSString stringWithFormat:@"%@/%@", kMiniProgramPath, [CIMPAppManager sharedManager].currentApp.appInfo.appId];
    NSString *tempDir = [appPath stringByAppendingString:@"/temp"];
    NSString *fileName = [NSString stringWithFormat:@"%@.jpg", [data md5String]];
    [kFileManager createFileAtPath:[tempDir stringByAppendingString:fileName] contents:data attributes:nil];
    if (callback) {
        callback(@{@"errMsg": @"ok", @"tempFilePath": fileName});
    }
}

+ (NSString *)writeImageToFile:(UIImage *)image {
    NSString *fileName = [UIImagePNGRepresentation(image) md5String];
    NSString *appPath = [NSString stringWithFormat:@"%@/%@", kMiniProgramPath, [CIMPAppManager sharedManager].currentApp.appInfo.appId];
    NSString *tempDir = [appPath stringByAppendingString:@"/temp/"];
    [kFileManager createFileAtPath:[tempDir stringByAppendingString:fileName] contents:UIImagePNGRepresentation(image) attributes:nil];
    return [@"/temp/" stringByAppendingString:fileName];
}

+ (NSString *)getImageType:(UIImage *)image {
    NSData *data = UIImagePNGRepresentation(image);
    uint8_t type;
    [data getBytes:&type length:1];
    switch (type) {
        case 0xFF:
            return @"image/jpeg";
        case 0x89:
            return @"image/png";
        case 0x47:
            return @"image/gif";
        case 0x49:
        case 0x4D:
            return @"image/tiff";
        case 0x52:
            if ([data length] < 12) {
                return nil;
            }
            NSString *testString = [[NSString alloc] initWithData:[data subdataWithRange:NSMakeRange(0, 12)] encoding:NSASCIIStringEncoding];
            if ([testString hasPrefix:@"RIFF"] && [testString hasSuffix:@"WEBP"]) {
                return @"image/webp";
            }
            return nil;
    }
    return nil;
}

+ (NSString *)getImageOrientation:(UIImage *)image {
    switch (image.imageOrientation) {
        case UIImageOrientationUp:
            return @"up";
        case UIImageOrientationUpMirrored:
            return @"up-mirrored";
        case UIImageOrientationDown:
            return @"down";
        case UIImageOrientationDownMirrored:
            return @"down-mirrored";
        case UIImageOrientationLeft:
            return @"left";
        case UIImageOrientationLeftMirrored:
            return @"left-mirrored";
        case UIImageOrientationRight:
            return @"right";
        case UIImageOrientationRightMirrored:
            return @"right-mirrored";
        default:
            return @"";
    }
}

@end
