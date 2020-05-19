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
@property (nonatomic, strong) NSString *savePathString;
@property (nonatomic, assign) BOOL isAlbumWithCamera;
@property (nonatomic, assign) BOOL isSelectOriginalPhoto;

- (void) showAlbumWithPresentViewController: (UIViewController *)presentViewController;
- (void) showCameraWithPresentViewController: (UIViewController *)presentViewController;
- (void) IsAllowPickingVideo: (BOOL) isAllowPickingVideo IsAllowPickingImage: (BOOL) isAllowPickingImage isAllowPickingGif: (BOOL) isAllowPickingGif;

@end

NS_ASSUME_NONNULL_END
