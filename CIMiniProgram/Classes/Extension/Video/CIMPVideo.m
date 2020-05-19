//
//  CIMPVideo.m
//  CIMiniProgram
//
//  Created by 袁鑫 on 2020/5/19.
//

#import "CIMPVideo.h"
#import "CIMPFileMacro.h"
#import "CIMPAppManager.h"
#import "CIMPApp.h"
#import <AVKit/AVKit.h>

@implementation CIMPVideo

+ (void)getVideoInfo:(NSDictionary *)param callback:(void (^)(NSDictionary * _Nonnull))callback {
    NSString *src = param[@"src"];
    if (!src) {
        if (callback) {
            callback(@{@"errMsg": @"fail", @"message": @"src参数为空"});
        }
        return;
    }
    
    NSString *path = [[kMiniProgramPath stringByAppendingString:[NSString stringWithFormat:@"/%@", [CIMPAppManager sharedManager].currentApp.appInfo.appId]] stringByAppendingString:src];
    if ([kFileManager fileExistsAtPath:path]) {
        NSURL *fileUrl = [NSURL fileURLWithPath:path];
        AVURLAsset *asset = [AVURLAsset assetWithURL:fileUrl];
        
        CMTime time = [asset duration];
        double duration = CMTimeGetSeconds(time);
        
        NSArray *videoAssetTracks = [asset tracksWithMediaType:AVMediaTypeVideo];
        AVAssetTrack *videoAssetTrack = videoAssetTracks.firstObject;
        
        CMFormatDescriptionRef desc = (__bridge CMFormatDescriptionRef)videoAssetTrack.formatDescriptions.firstObject;
        CMVideoCodecType codec = CMVideoFormatDescriptionGetCodecType(desc);
    } else {
        callback(@{@"errMsg": @"fail", @"message": @"src所指的文件不存在"});
    }
}

@end
