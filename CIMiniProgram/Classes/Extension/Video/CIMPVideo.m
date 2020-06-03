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
    if ([kFileManager fileExistsAtPath:src]) {
        NSURL *fileUrl = [NSURL fileURLWithPath:src];
        AVURLAsset *asset = [AVURLAsset assetWithURL:fileUrl];
        
        NSInteger size = [kFileManager attributesOfItemAtPath:path error:nil].fileSize;
        
        CMTime time = [asset duration];
        double duration = CMTimeGetSeconds(time);
        
        NSArray *videoAssetTracks = [asset tracksWithMediaType:AVMediaTypeVideo];
        AVAssetTrack *videoAssetTrack = videoAssetTracks.firstObject;
        CGSize videoSize = videoAssetTrack.naturalSize;
        NSString *orientation;
        CGAffineTransform t = videoAssetTrack.preferredTransform;
        if(t.a == 0 && t.b == 1.0 && t.c == -1.0 && t.d == 0){
            // Portrait
            orientation = @"up";
        }else if(t.a == 0 && t.b == -1.0 && t.c == 1.0 && t.d == 0){
            // PortraitUpsideDown
            orientation = @"down";
        }else if(t.a == 1.0 && t.b == 0 && t.c == 0 && t.d == 1.0){
            // LandscapeRight
            orientation = @"right";
        }else if(t.a == -1.0 && t.b == 0 && t.c == 0 && t.d == -1.0){
            // LandscapeLeft
            orientation = @"left";
        }
        
        CMFormatDescriptionRef desc = (__bridge CMFormatDescriptionRef)videoAssetTrack.formatDescriptions.firstObject;
        CMVideoCodecType codec = CMVideoFormatDescriptionGetCodecType(desc);
        CGFloat fps = videoAssetTrack.nominalFrameRate;
        CGFloat bps = size * 8 / duration / 1000;
        NSDictionary *result = @{@"errMsg": @"ok", @"type": @(codec), @"duration": @(duration), @"size": @(size), @"height": @(videoSize.height), @"width": @(videoSize.width), @"orientation": orientation, @"fps": @(fps), @"bitrate": @(bps)};
        if (callback) {
            callback(result);
        }
    } else {
        callback(@{@"errMsg": @"fail", @"message": @"src所指的文件不存在"});
    }
}

@end
