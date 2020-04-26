//
//  CICameraManager.m
//  CICamera
//
//  Created by 大大大大_荧🐾 on 2020/2/18.
//  Copyright © 2020 大大大大_荧🐾. All rights reserved.
//

#import "CICameraManager.h"
#import "CIScan/CIScan.h"
#import "CIVideo/CIVideo.h"
#import "CIPicture/CIPicture.h"

static CICameraManager* _instance = nil;

@interface CICameraManager()

@property (nonatomic, strong) CIPicture *ciPicture;
@property (nonatomic, strong) CIVideo *ciVideo;

@end

@implementation CICameraManager

+ (instancetype)sharedInstance {
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        if(_instance == nil){
            _instance = [super allocWithZone:NULL];
        }
    });
    
    return _instance;
}

+ (id) allocWithZone:(struct _NSZone *)zone{
    return [CICameraManager sharedInstance];
}

- (CIPicture *)ciPicture {
    if (!_ciPicture) {
        _ciPicture = [[CIPicture alloc] init];
    }
    return _ciPicture;
}

- (CIVideo *)ciVideo {
    if (!_ciVideo) {
        _ciVideo = [[CIVideo alloc] init];
    }
    return _ciVideo;
}

- (void)setMode:(CameraMode) mode With:(UIViewController *)presentViewController {
    switch (mode) {
        case MODE_PICTURE:
            [self.ciPicture showCameraWithPresentViewController:presentViewController];
            self.ciPicture.completeHandler = self.pictureCompleteHandler;
            break;
        case  MODE_VIDEO:
            [self.ciVideo showCIVideo];
            self.savePathString = self.ciVideo.savePathString;
//            [self.ciPicture showCameraWithPresentViewController:presentViewController];
//            self.ciPicture.completeHandler = self.pictureCompleteHandler;
            break;
        default:
            [CIScan showCIScanWith:presentViewController completionHandler:^(NSString * _Nonnull result) {
                self.scanCompletionHandler(result);
            }];
            break;
    }
}

- (void)setZoom {
    
}

- (void)setFlash {
    
}

-(void)setFacing {
    
}

- (void)setVideoMaxSize: (CGSize) maxSize {
    self.ciVideo.outputSize = maxSize;
}

- (void)setVideoMaxDuration: (CGFloat) duration {
    self.ciVideo.maxDuration = duration;
}

- (void)addCameraListener {
    
}

@end
