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
@property (nonatomic, strong) void (^pictureCompleteHandler)(NSArray<UIImage *> *photos,NSArray *assets);

// 单例
+ (instancetype) sharedInstance;

// 唤起相册选择界面
- (void) createAlbum: (UIViewController *)presentViewController;

// 配置选择图片数
- (void) setCount: (int) count;

// 设置最小文件大小
- (void) setMinFileSize;

@end

NS_ASSUME_NONNULL_END
