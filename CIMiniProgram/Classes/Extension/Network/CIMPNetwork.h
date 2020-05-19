//
//  CIMPNetwork.h
//  CIMiniProgram
//
//  Created by 袁鑫 on 2020/4/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CIMPNetwork : NSObject

+ (void)request:(NSDictionary *)param callback:(void(^)(NSDictionary *))callback;

+ (void)downloadFile:(NSDictionary *)param progress:(void(^)(NSString *, NSDictionary *))progress callback:(void(^)(NSDictionary *))callback;

+ (void)uploadFile:(NSDictionary *)param progress:(void(^)(NSString *, NSDictionary *))progress callback:(void(^)(NSDictionary *))callback;

@end

NS_ASSUME_NONNULL_END
