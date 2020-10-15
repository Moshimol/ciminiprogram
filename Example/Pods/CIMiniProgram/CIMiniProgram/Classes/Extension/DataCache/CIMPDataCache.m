//
//  CIMPDataCache.m
//  CIMiniProgram
//
//  Created by 袁鑫 on 2020/4/10.
//

#import "CIMPDataCache.h"
#import "CIMPFileManager.h"
#import "CIMPStorageUtil.h"
#import "CIMPFileMacro.h"
#import "CIMPAppManager.h"
#import "CIMPApp.h"

@implementation CIMPDataCache

+ (void)setStorage:(NSDictionary *)param success:(void (^)(NSDictionary * _Nonnull))success fail:(void (^)(NSDictionary * _Nonnull))fail complete:(void (^)(NSDictionary * _Nonnull))complete {
    // 避免Number类型被转换为String类型
    id data = param[@"data"];
    NSString *key = param[@"key"];
    
    if (!key || !data) {
        if (fail) {
            fail(@{@"errMsg": @"fail", @"message": @"参数key为空"});
            return;
        }
    }
    
    // 获取storage目录
    CIMPApp *app = [CIMPAppManager sharedManager].currentApp;
    NSString *storageDirPath = [CIMPFileManager appStorageDirPath:app.appInfo.appId];
    if (![kFileManager fileExistsAtPath:storageDirPath]) {
        [kFileManager createDirectoryAtPath:storageDirPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    // localStorage 以用户维度隔离
    NSString *appId = app.appInfo.appId;
    NSString *filePath = [NSString stringWithFormat:@"%@/storage_%@", storageDirPath, appId];
    
    // 检查是否超出本地存储空间限制
    if ([kFileManager fileExistsAtPath:filePath]) {
        NSDictionary *fileAttributes = [kFileManager attributesOfItemAtPath:filePath error:nil];
        UInt64 fileSize = fileAttributes.fileSize;
        UInt64 currentSize = [CIMPStorageUtil dataWithDictionary:@{key: data}].length;
        if (fileSize + currentSize > STORAGE_LIMIT_SIZE) {
            if (fail) {
                fail(@{@"errMsg": @"fail", @"message": @"本地存储空间超出限制"});
                return;
            }
        }
    }
    
    // 获取当前的storage
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[CIMPStorageUtil dictionaryWithFilePath:filePath]];
    dic[key] = data;
    
    if ([CIMPStorageUtil saveDictionary:dic toPath:filePath]) {
        if (success) {
            success(@{@"errMsg": @"ok", @"message": @"存储数据成功"});
        }
    } else {
        if (fail) {
            fail(@{@"errMsg": @"fail", @"message": @"存储数据失败"});
        }
    }
}

+ (void)removeStorage:(NSDictionary *)param success:(void (^)(NSDictionary * _Nonnull))success fail:(void (^)(NSDictionary * _Nonnull))fail complete:(void (^)(NSDictionary * _Nonnull))complete {
    NSString *key = param[@"key"];
    if (!key) {
        if (fail) {
            fail(@{@"errMsg": @"fail", @"message": @"参数key为空"});
            return;
        }
    }
    
    // 获取当前用户storage文件
    CIMPApp *app = [CIMPAppManager sharedManager].currentApp;
    NSString *storageDirPath = [CIMPFileManager appStorageDirPath:app.appInfo.appId];
    NSString *appId = app.appInfo.appId;
    NSString *filePath = [NSString stringWithFormat:@"%@/storage_%@", storageDirPath, appId];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[CIMPStorageUtil dictionaryWithFilePath:filePath]];
    if (![dic objectForKey:key]) {
        if (fail) {
            fail(@{@"errMsg": @"fail", @"message": @"找不到key对应的数据"});
        }
    } else {
        [dic removeObjectForKey:key];
        BOOL result = [CIMPStorageUtil saveDictionary:dic toPath:filePath];
        if (result) {
            if (success) {
                success(@{@"errMsg": @"ok", @"message": @"删除参数成功"});
            }
        } else {
            if (fail) {
                fail(@{@"errMsg": @"fail", @"message": @"删除指定key失败"});
            }
        }
    }
}

+ (void)getStorageInfo:(NSDictionary *)param success:(void (^)(NSDictionary * _Nonnull))success fail:(void (^)(NSDictionary * _Nonnull))fail complete:(void (^)(NSDictionary * _Nonnull))complete {
    // 获取当前用户storage文件
    CIMPApp *app = [CIMPAppManager sharedManager].currentApp;
    NSString *storageDirPath = [CIMPFileManager appStorageDirPath:app.appInfo.appId];
    NSString *appId = app.appInfo.appId;
    NSString *filePath = [NSString stringWithFormat:@"%@/storage_%@", storageDirPath, appId];
    
    NSUInteger limitSize = STORAGE_LIMIT_SIZE / 1024;
    NSDictionary *dic = [CIMPStorageUtil dictionaryWithFilePath:filePath];
    if (dic.count <= 0) {
        success(@{@"errMsg": @"ok", @"keys": dic.allKeys, @"currentSize": @0, @"limitSize": @(limitSize)});
    } else {
        // 获取当前存储大小 转换为KB 保留两位小数
        NSDictionary *fileAttributes = [kFileManager attributesOfItemAtPath:filePath error:nil];
        UInt64 fileSize = fileAttributes.fileSize;
        float currentSize = [[NSString stringWithFormat:@"%.2f", fileSize / 1024.0] floatValue];
        
        NSDictionary *dic = [CIMPStorageUtil dictionaryWithFilePath:filePath];
        NSArray *keys = dic.allKeys;
        
        success(@{@"errMsg": @"ok", @"keys": keys, @"currentSize": @(currentSize), @"limitSize": @(limitSize)});
    }
}

+ (void)getStorage:(NSDictionary *)param success:(void (^)(NSDictionary * _Nonnull))success fail:(void (^)(NSDictionary * _Nonnull))fail complete:(void (^)(NSDictionary * _Nonnull))complete {
    NSString *key = param[@"key"];
    if (!key) {
        if (fail) {
            fail(@{@"errMsg": @"fail", @"message": @"参数key为空"});
            return;
        }
    }
    
    // 获取当前用户storage文件
    CIMPApp *app = [CIMPAppManager sharedManager].currentApp;
    NSString *storageDirPath = [CIMPFileManager appStorageDirPath:app.appInfo.appId];
    NSString *appId = app.appInfo.appId;
    NSString *filePath = [NSString stringWithFormat:@"%@/storage_%@", storageDirPath, appId];
    
    NSDictionary *dic = [CIMPStorageUtil dictionaryWithFilePath:filePath];
    id data = [dic objectForKey:key];
    
    if (data) {
        NSString *dataType = nil;
        if ([data isKindOfClass:NSNumber.class]) {
            dataType = @"Number";
        } else if ([data isKindOfClass:NSString.class]) {
            dataType = @"String";
        } else if ([data isKindOfClass:NSDictionary.class]) {
            dataType = @"Dictionary";
        } else if ([data isKindOfClass:NSArray.class]) {
            dataType = @"Array";
        } else if ([data isKindOfClass:NSDate.class]) {
            dataType = @"Date";
        } else {
            dataType = @"Undefined";
        }
        
        if (success) {
            success(@{@"errMsg": @"ok", @"data": data, @"dataType": dataType});
        }
    } else {
        if (fail) {
            fail(@{@"errMsg": @"fail", @"message": @"找不到key对应的数据"});
        }
    }
}

+ (void)clearStorage:(NSDictionary *)param success:(void (^)(NSDictionary * _Nonnull))success fail:(void (^)(NSDictionary * _Nonnull))fail complete:(void (^)(NSDictionary * _Nonnull))complete {
    // 获取当前用户storage文件
    CIMPApp *app = [[CIMPAppManager sharedManager] currentApp];
    NSString *storageDirPath = [CIMPFileManager appStorageDirPath:app.appInfo.appId];
    NSString *appId = app.appInfo.appId;
    NSString *filePath = [NSString stringWithFormat:@"%@/storage_%@", storageDirPath, appId];
    
    if ([kFileManager fileExistsAtPath:filePath]) {
        if ([kFileManager removeItemAtPath:filePath error:nil]) {
            if (success) {
                success(@{@"errMsg": @"ok", @"message": @"清理本地数据缓存成功"});
            }
        } else {
            if (fail) {
                fail(@{@"errMsg": @"fail", @"message": @"清理本地数据缓存失败"});
            }
        }
    } else {
        if (success) {
            success(@{@"errMsg": @"ok", @"message": @"清理本地数据缓存成功"});
        }
    }
}

@end
