//
//  CIGalleryManager.h
//  CICamera
//
//  Created by 大大大大_荧🐾 on 2020/2/18.
//  Copyright © 2020 大大大大_荧🐾. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CIGalleryManager : NSObject

// 选择回调
@property (nonatomic, strong) void (^pictureCompleteHandler)(NSArray<UIImage *> *photos,NSArray *assets, BOOL isSelectOriginalPhoto);
// 视频路径
@property (nonatomic, strong) void(^videoSelectedCompleteHandler)(NSString *videoPathString);
// 视频是否压缩（默认压缩）
@property (nonatomic, assign) BOOL isSelectedVideoCompressed;

// 单例
+ (instancetype) sharedInstance;

// 唤起相册选择界面
- (void) createAlbum: (UIViewController *)presentViewController;

// 配置选择图片数
- (void) setCount: (int) count;

// 设置最小文件大小
- (void) setMinFileSize;

// 设置相册是否包含拍照功能
- (void) setAlbumWithCamera: (BOOL) isOpen;

// 设置相册选择的文件格式（默认都可以选择）
// 是否可以选择视频 or 图片 or gif；
- (void) IsAllowPickingVideo: (BOOL) isAllowPickingVideo IsAllowPickingImage: (BOOL) isAllowPickingImage isAllowPickingGif: (BOOL) isAllowPickingGif;

@end

NS_ASSUME_NONNULL_END
