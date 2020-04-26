//
//  CIVideo.h
//  CICamera
//
//  Created by 大大大大_荧🐾 on 2020/2/23.
//  Copyright © 2020 大大大大_荧🐾. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CIVideo : NSObject

@property (nonatomic, strong) NSString *savePathString;
@property (nonatomic, assign) CGSize outputSize;
@property (nonatomic, assign) CGFloat maxDuration;

- (void) showCIVideo;

@end

NS_ASSUME_NONNULL_END
