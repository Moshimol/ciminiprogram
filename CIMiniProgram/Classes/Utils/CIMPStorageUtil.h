//
//  CIMPStorageUtil.h
//  CIMiniProgram
//
//  Created by 袁鑫 on 2020/4/10.
//

#import <Foundation/Foundation.h>

// 本地storage空间大小限制 10MB
#define STORAGE_LIMIT_SIZE 10 * 1024 * 1024

// 本地文件存储的大小限制为 10M
#define FILE_LIMIT_SIZE    10 * 1024 * 1024

// 文件路径schema
#define MP_FILE_SCHEMA    @"mpfile://"

NS_ASSUME_NONNULL_BEGIN

@interface CIMPStorageUtil : NSObject

/**
 属性列表转换成data
 
 @param dictionary 属性列表
 @return data
 */
+ (NSData *)dataWithDictionary:(NSDictionary *)dictionary;

/**
 保存属性列表
 
 @param dictionary 属性列表
 @param path 路径
 @return 是否成功
 */
+ (BOOL)saveDictionary:(NSDictionary *)dictionary toPath:(NSString *)path;

/**
 获取属性列表
 
 @param filePath 路径
 @return 属性列表
 */
+ (NSDictionary *)dictionaryWithFilePath:(NSString *)filePath;

@end

NS_ASSUME_NONNULL_END
