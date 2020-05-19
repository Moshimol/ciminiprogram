//
//  CIMPVideo.h
//  CIMiniProgram
//
//  Created by 袁鑫 on 2020/5/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CIMPVideo : NSObject

+ (void)getVideoInfo:(NSDictionary *)param callback:(void(^)(NSDictionary *))callback;

@end

NS_ASSUME_NONNULL_END
