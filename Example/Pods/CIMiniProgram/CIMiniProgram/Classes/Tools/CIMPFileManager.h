//
//  CIMPFileManager.h
//  CIMiniProgram
//
//  Created by 袁鑫 on 2020/4/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CIMPFileManager : NSObject

/**
 删除文件

 @param path 路径
 @return 是否成功
 */
+ (BOOL)removePath:(NSString *)path;

/**
 复制文件

 @param path 路径
 @param toPath 目标路径
 @return 是否成功
 */
+ (BOOL)copyItemAtPath:(NSString *)path toPath:(NSString *)toPath;

/**
 清除下载的zip文件夹
 */
+ (void)cleanDownloadZipDir;

/**
 framework的根目录

 @return framework的根目录路径
 */
+ (NSString *)frameworkRootPath;

/**
 临时下载的Zip包路径

 @return 临时下载的Zip包路径
 */
+ (NSString *)tempDownloadZipPath;

/**
 临时下载的Zip路径

 @return 路径
 */
+ (NSString *)tempDownloadZipInfoFilePath;

/**
 工程根目录路径

 @return 工程根目录路径
 */
+ (NSString *)projectRootAppsDirPath;

/**
 获取缓存app的列表

 @return 缓存app的列表
 */
+ (NSDictionary *)getCachedAppList;

/**
 获取缓存大小

 @return 缓存大小
 */
+ (UInt64)getCachedSize;

/**
 配置小程序文件目录
 */
+ (void)setupAppDir:(NSString *)appId;

/**
 获取小程序入口文件
 */
+ (NSString *)appServiceEnterencePath:(NSString *)appId;

/**
 获取当前小程序根目录
 */
+ (NSString *)appRootDirPath:(NSString *)appId;

/**
 获取当前小程序根源码目录
 */
+ (NSString *)appSourceDirPath:(NSString *)appId;

/**
 获取当前小程序临时存储目录
 */
+ (NSString *)appTempDirPath:(NSString *)appId;

/**
 获取当前小程序持久化存储目录
 */
+ (NSString *)appPersistentDirPath:(NSString *)appId;

/**
 获取当前小程序本地存储数据目录
 */
+ (NSString *)appStorageDirPath:(NSString *)appId;

@end

NS_ASSUME_NONNULL_END
