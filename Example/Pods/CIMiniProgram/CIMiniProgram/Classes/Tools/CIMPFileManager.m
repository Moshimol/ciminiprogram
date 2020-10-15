//
//  CICIMPFileManager.m
//  CIMiniProgram
//
//  Created by 袁鑫 on 2020/4/10.
//

#import "CIMPFileManager.h"
#import "CIMPAppInfo.h"
#import "CIMPLog.h"

static NSString *APP_CRC32_Cached_Key = @"MPCBundleZip";
static NSString *FRAMEWORK_CRC32_Cached_Key = @"MPCBundleZip_framework";
static NSString *PROJECT_ROOT = @"MPCRoot";
static NSString *PROJECT_ROOT_App = @"app";
static NSString *PROJECT_ROOT_Framework = @"framework";

@interface NSString (CICIMPFileManager)

- (UInt64)getFileSize;

@end

@implementation NSString (CICIMPFileManager)

- (UInt64)getFileSize  {
    UInt64 size = 0;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = false;
    BOOL isExists = [fileManager fileExistsAtPath:self isDirectory:&isDir];
    // 判断文件存在
    if (isExists) {
        // 是否为文件夹
        if (isDir) {
            // 迭代器 存放文件夹下的所有文件名
            NSDirectoryEnumerator *enumerator = [fileManager enumeratorAtPath:self];
            NSString *file = nil;
            while (file = [enumerator nextObject]) {
                NSString *fullPath = [self stringByAppendingPathComponent:file];
                NSDictionary *attr = [fileManager attributesOfItemAtPath:fullPath error:nil];
                size += [attr[NSFileSize] unsignedLongLongValue];
            }
        } else {    // 单文件
            NSDictionary *attr = [fileManager attributesOfItemAtPath:self error:nil];
            size += [attr[NSFileSize] unsignedLongLongValue];
        }
    }
    return size;
}

@end

@implementation CIMPFileManager

#pragma mark - 文件操作
#pragma mark -

+ (void)setupAppDir:(NSString *)appId {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    //创建目录
    NSString *rootPath = [CIMPFileManager projectRootAppsDirPath];
    NSString *appDirPath = [CIMPFileManager appRootDirPath:appId];
    
    if (![fileManager fileExistsAtPath:appDirPath]) {
        [fileManager createDirectoryAtPath:appDirPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    if (![fileManager fileExistsAtPath:[CIMPFileManager unzipTempDir]]) {
        [fileManager createDirectoryAtPath:[CIMPFileManager unzipTempDir] withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    //创建必须的文件夹
    NSString *temp = @"Temp";
    NSString *tempDirPath = [rootPath stringByAppendingPathComponent:temp];
    if (![fileManager fileExistsAtPath:tempDirPath]) {
        [fileManager createDirectoryAtPath:tempDirPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

+ (void)cleanDownloadZipDir {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *downloadZip = [CIMPFileManager tempDownloadZipPath];
    NSString *downloadZipInfoPath = [CIMPFileManager tempDownloadZipInfoFilePath];
    
    if ([fileManager fileExistsAtPath:downloadZip]) {
        [CIMPFileManager removePath:downloadZip];
        [CIMPFileManager removePath:downloadZipInfoPath];
    }
}

+ (NSDictionary *)getCachedAppList {
    NSString *path = [CIMPFileManager projectRootAppsDirPath];
    NSString * appListName = @"apps.list";
    NSString * appListPath = [path stringByAppendingFormat:@"/%@",appListName];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:appListPath]) {
        return [[NSDictionary alloc] initWithContentsOfFile:appListPath];
    }
    
    return nil;
}

+ (BOOL)saveAppInfo:(NSDictionary *)info {
    NSString *path = [CIMPFileManager projectRootAppsDirPath];
    NSString *appListName = @"apps.list";
    NSString *appListPath = [path stringByAppendingPathComponent:appListName];
    return [info writeToFile:appListPath atomically:YES];
}

+ (BOOL)copyItemAtPath:(NSString *)path toPath:(NSString *)toPath {
    BOOL success = [[NSFileManager defaultManager] copyItemAtPath:path toPath:toPath error:nil];
    
    return success;

}

+ (BOOL)removePath:(NSString *)path {
    BOOL success = true;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        success = [fileManager removeItemAtPath:path error:nil];
    }
    
    return success;
}

+ (UInt64)getCachedSize{
    __block UInt64 cacheSize = 0;
    NSDictionary *appList = [CIMPFileManager getCachedAppList];
    [appList enumerateKeysAndObjectsUsingBlock:^(NSString *appid, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSString *rootPath = [CIMPFileManager projectRootAppsDirPath];
        NSString *appDirPath = [rootPath stringByAppendingPathComponent:appid];
        cacheSize += [appDirPath getFileSize];
    }];
    
    return cacheSize;
}

#pragma mark - 公共路径
#pragma mark -

+ (NSString *)projectRootDirPath{
    NSString *rootPath = [NSTemporaryDirectory() stringByAppendingPathComponent:PROJECT_ROOT];
    return rootPath;
}

+ (NSString *)projectRootAppsDirPath {
    NSString * rootPath = [[CIMPFileManager projectRootDirPath] stringByAppendingFormat:@"/%@",PROJECT_ROOT_App];
    return rootPath;
}

+ (NSString *)frameworkRootPath {
    NSString * rootPath = [[CIMPFileManager projectRootDirPath] stringByAppendingFormat:@"/%@",PROJECT_ROOT_Framework];
    return rootPath;
}

+ (NSString *)unzipTempDir {
    NSString * rootPath = [NSTemporaryDirectory() stringByAppendingFormat:@"%@_Temp",PROJECT_ROOT];
    NSString *temp = @"Temp";
    NSString * tempDirPath = [rootPath stringByAppendingPathComponent:temp];
    return tempDirPath;
}

+ (NSString *)tempZipPath {
    NSString *zipTempPath = [[self unzipTempDir] stringByAppendingPathComponent:@"TempZip.zip"];
    return zipTempPath;
}

+ (NSString *)tempDownloadZipPath {
    NSString *zipTempPath = [[self unzipTempDir] stringByAppendingPathComponent:@"DownloadZip.zip"];
    return zipTempPath;
}

+ (NSString *)tempDownloadZipInfoFilePath{
    NSString *zipTempPath = [[self unzipTempDir] stringByAppendingPathComponent:@"DownloadZip"];
    return zipTempPath;
}

#pragma mark - 小程序内部路径
#pragma mark -


/**
 获取当前小程序根路径
 
 @return 获取当前小程序根路径
 */
+ (NSString *)appRootDirPath:(NSString *)appId {
    NSString *rootPath = [CIMPFileManager projectRootAppsDirPath];
    NSString *appDirPath = [rootPath stringByAppendingPathComponent:appId];
    return appDirPath;
}

/**
 小程序源码文件夹路径
 */
+ (NSString *)appSourceDirPath:(NSString *)appId {
    NSString *sourceDir = [[CIMPFileManager appRootDirPath:appId] stringByAppendingPathComponent:@"Source"];
    return sourceDir;
}

/**
 小程序临时存储目录

 @return NSString *
 */
+ (NSString *)appTempDirPath:(NSString *)appId {
    NSString *tempFileCachePath = [[CIMPFileManager appRootDirPath:appId] stringByAppendingPathComponent:@"Temp"];
    return tempFileCachePath;
}

/**
 小程序持久化存储目录

 @return NSString *
 */
+ (NSString *)appPersistentDirPath:(NSString *)appId {
    NSString *persistentDirPath = [[CIMPFileManager appRootDirPath:appId] stringByAppendingPathComponent:@"Persistent"];
    return persistentDirPath;
}

/**
 小程序本地缓存目录
 
 @return NSString *
 */
+ (NSString *)appStorageDirPath:(NSString *)appId {
    NSString *storageDirPath = [[CIMPFileManager appRootDirPath:appId] stringByAppendingPathComponent:@"Storage"];
    return storageDirPath;
}


/// 获取小程序的service入口文件
+ (NSString *)appServiceEnterencePath:(NSString *)appId {
    NSString *serviceHtml = [[CIMPFileManager appSourceDirPath:appId] stringByAppendingPathComponent:@"service.html"];
    return serviceHtml;
}

@end
