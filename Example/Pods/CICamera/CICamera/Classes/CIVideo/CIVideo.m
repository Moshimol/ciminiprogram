//
//  CIVideo.m
//  CICamera
//
//  Created by 大大大大_荧🐾 on 2020/2/23.
//  Copyright © 2020 大大大大_荧🐾. All rights reserved.
//

#import "CIVideo.h"
#import "PKShortVideo.h"
#import "Macro.h"

@interface CIVideo() <PKRecordShortVideoDelegate>

@property (nonatomic, strong) PKRecordShortVideoViewController *videoViewController;

@end

@implementation CIVideo

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.maxDuration = 30;
        self.outputSize = CGSizeMake(640, 480);
        NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        NSString *filePath = [path stringByAppendingPathComponent:@"shortVideo.mp4"];
        self.savePathString = filePath;
    }
    return self;
}

- (PKRecordShortVideoViewController *)videoViewController {
    if (!_videoViewController) {
        _videoViewController = [[PKRecordShortVideoViewController alloc] initWithOutputFilePath:self.savePathString outputSize:self.outputSize themeColor: RGBColor(0, 153, 255)];
        _videoViewController.delegate = self;
        _videoViewController.videoMinimumDuration = 0;
        _videoViewController.videoMaximumDuration = self.maxDuration;
    }
    return _videoViewController;
}

- (void)showCIVideo {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:self.videoViewController animated:YES completion:nil];
    });
}

- (void)didFinishRecordingToOutputFilePath:(NSString *)outputFilePath {
    if (outputFilePath) {
        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(outputFilePath)) {
            UISaveVideoAtPathToSavedPhotosAlbum(outputFilePath, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
        }
    }
}

- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error) {
        NSLog(@"保存视频失败%@", error.localizedDescription);
    } else {
        NSLog(@"保存视频成功");
    }
}

@end
