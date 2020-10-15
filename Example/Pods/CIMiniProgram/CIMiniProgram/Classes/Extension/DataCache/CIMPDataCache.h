//
//  CIMPDataCache.h
//  CIMiniProgram
//
//  Created by 袁鑫 on 2020/4/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CIMPDataCache : NSObject

+ (void)setStorage:(NSDictionary *)param success:(void(^)(NSDictionary *))success fail:(void(^)(NSDictionary *))fail complete:(void(^)(NSDictionary *))complete;

+ (void)removeStorage:(NSDictionary *)param success:(void(^)(NSDictionary *))success fail:(void(^)(NSDictionary *))fail complete:(void(^)(NSDictionary *))complete;

+ (void)getStorageInfo:(NSDictionary *)param success:(void(^)(NSDictionary *))success fail:(void(^)(NSDictionary *))fail complete:(void(^)(NSDictionary *))complete;

+ (void)getStorage:(NSDictionary *)param success:(void(^)(NSDictionary *))success fail:(void(^)(NSDictionary *))fail complete:(void(^)(NSDictionary *))complete;

+ (void)clearStorage:(NSDictionary *)param success:(void(^)(NSDictionary *))success fail:(void(^)(NSDictionary *))fail complete:(void(^)(NSDictionary *))complete;

@end

NS_ASSUME_NONNULL_END
