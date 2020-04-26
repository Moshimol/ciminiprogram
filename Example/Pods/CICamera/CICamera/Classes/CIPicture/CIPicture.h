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
@property (nonatomic, strong) void(^completeHandler)(NSArray<UIImage *> *photos,NSArray *assets);
@property (nonatomic, strong) NSString *savePathString;

- (void) showAlbumWithPresentViewController: (UIViewController *)presentViewController;
- (void) showCameraWithPresentViewController: (UIViewController *)presentViewController;

@end

NS_ASSUME_NONNULL_END
