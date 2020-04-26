//
//  CICameraManager.h
//  CICamera
//
//  Created by 大大大大_荧🐾 on 2020/2/18.
//  Copyright © 2020 大大大大_荧🐾. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CICamera/CICameraMarco.h>

NS_ASSUME_NONNULL_BEGIN

@interface CICameraManager : NSObject

//  回调
@property (nonatomic, strong) void (^pictureCompleteHandler)(NSArray<UIImage *> *photos,NSArray *assets);
@property (nonatomic, strong) NSString *savePathString;
@property (nonatomic, strong) void (^scanCompletionHandler)(NSString *result);

// 单例
+ (instancetype) sharedInstance;

// 前后摄像头切换
- (void) setFacing;

// 闪光灯开关
- (void) setFlash;

// 缩放控制
- (void) setZoom;

// 视频最大内存
- (void) setVideoMaxSize: (CGSize) maxSize;

// 视频最大长度， 默认15s
- (void) setVideoMaxDuration: (CGFloat) duration;

// （picture, video, scan)
- (void) setMode:(CameraMode) mode With: (UIViewController *)presentViewController;

@end

NS_ASSUME_NONNULL_END
