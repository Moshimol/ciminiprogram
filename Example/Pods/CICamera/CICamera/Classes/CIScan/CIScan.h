//
//  CIScan.h
//  CICamera
//
//  Created by 大大大大_荧🐾 on 2020/2/20.
//  Copyright © 2020 大大大大_荧🐾. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CIScan : NSObject

+ (void) showCIScanWith:(UIViewController *) presentViewController  completionHandler:(void (^)(NSString *result)) completionHandler;

@end

NS_ASSUME_NONNULL_END
