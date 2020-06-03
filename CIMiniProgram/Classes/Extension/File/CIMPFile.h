//
//  CIMPFile.h
//  CIMiniProgram
//
//  Created by 袁鑫 on 2020/4/28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CIMPFile : NSObject

+ (void)saveFile:(NSDictionary *)param callback:(void(^)(NSDictionary *))callback;

+ (void)removeSavedFile:(NSDictionary *)param callback:(void(^)(NSDictionary *))callback;

+ (void)getSavedFileInfo:(NSDictionary *)param callback:(void(^)(NSDictionary *))callback;

+ (void)getSavedFileList:(NSDictionary *)param callback:(void(^)(NSDictionary *))callback;

+ (void)getFileInfo:(NSDictionary *)param callback:(void(^)(NSDictionary *))callback;

@end

NS_ASSUME_NONNULL_END
