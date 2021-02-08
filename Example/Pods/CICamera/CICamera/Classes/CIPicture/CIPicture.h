//
//  CIPicture.h
//  CICamera
//
//  Created by 大大大大_荧🐾 on 2020/2/23.
//  Copyright © 2020 大大大大_荧🐾. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CIPicture : NSObject

@property (nonatomic, assign) int selectedMaxCount;
@property (nonatomic, strong) void(^completeHandler)(NSArray<UIImage *> *photos,NSArray *assets, BOOL isSelectOriginalPhoto);
@property (nonatomic, strong) void(^videoSelectedCompleteHandler)(NSString *videoPathString);
@property (nonatomic, strong) NSString *savePathString;
@property (nonatomic, assign) BOOL isAlbumWithCamera;
@property (nonatomic, assign) BOOL isSelectOriginalPhoto;
@property (nonatomic, assign) BOOL isSelectedVideoCompressed;
//是不是可以进行裁切  默认不可以进行裁切
@property (nonatomic, assign) BOOL allowCrop;


- (void) showAlbumWithPresentViewController: (UIViewController *)presentViewController;
- (void) showCameraWithPresentViewController: (UIViewController *)presentViewController;
- (void) IsAllowPickingVideo: (BOOL) isAllowPickingVideo IsAllowPickingImage: (BOOL) isAllowPickingImage isAllowPickingGif: (BOOL) isAllowPickingGif;

// 设置裁切尺寸 是否需要圆切
- (void)setCropRectSize:(CGRect)cropRect needCircleCrop:(BOOL)needCircleCrop circleCropRadius:(NSInteger)circleCropRadius;

@end

NS_ASSUME_NONNULL_END
