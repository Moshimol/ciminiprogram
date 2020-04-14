//
//  CIMPNetwork.h
//  CIMiniProgram
//
//  Created by 袁鑫 on 2020/4/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CIMPNetwork : NSObject

+ (void)request:(NSDictionary *)param success:(void(^)(NSDictionary *))success fail:(void(^)(NSDictionary *))fail;

+ (void)downloadFile:(NSDictionary *)param success:(void(^)(NSDictionary *))success fail:(void(^)(NSDictionary *))fail;

+ (void)uploadFile:(NSDictionary *)param success:(void(^)(NSDictionary *))success fail:(void(^)(NSDictionary *))fail;

@end

NS_ASSUME_NONNULL_END
