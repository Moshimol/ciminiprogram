//
//  CIMPFile.m
//  CIMiniProgram
//
//  Created by 袁鑫 on 2020/4/28.
//

#import "CIMPFile.h"
#import "CIMPFileMacro.h"
#import "CIMPAppManager.h"
#import "CIMPApp.h"

@implementation CIMPFile

+ (void)saveFile:(NSDictionary *)param callback:(void (^)(NSDictionary * _Nonnull))callback {
    NSString *tempFilePath = param[@"tempFilePath"];
    if (!tempFilePath) {
        NSDictionary *error = @{@"errMsg": @"fail", @"message": @"tempFilePath为空"};
        if (callback) {
            callback(error);
        }
    }
    
    NSString *currentAppPath = [kMiniProgramPath stringByAppendingPathComponent:[CIMPAppManager sharedManager].currentApp.appInfo.appId];
    NSString *fullPath = [currentAppPath stringByAppendingPathComponent:tempFilePath];
    if ([kFileManager fileExistsAtPath:fullPath]) {
        NSError *error = nil;
        NSString *fileFolderPath = [currentAppPath stringByAppendingPathComponent:@"/SavedFiles"];
        BOOL isDirectory;
        if (![kFileManager fileExistsAtPath:fileFolderPath isDirectory:&isDirectory]) {
            [kFileManager createDirectoryAtPath:fileFolderPath withIntermediateDirectories:YES attributes:nil error:nil];
        } else {
            if (!isDirectory) {
                [kFileManager removeItemAtPath:fileFolderPath error:nil];
                [kFileManager createDirectoryAtPath:fileFolderPath withIntermediateDirectories:YES attributes:nil error:nil];
            }
        }
        NSString *savedFilePath = [fileFolderPath stringByAppendingPathComponent:[fullPath lastPathComponent]];
        [kFileManager moveItemAtPath:fullPath toPath:savedFilePath error:&error];
        if (error) {
            NSDictionary *result = @{@"errMsg": @"fail", @"message": error.localizedDescription};
            if (callback) {
                callback(result);
            }
        } else {
            NSString *filePath = [@"SavedFiles" stringByAppendingPathComponent:[fullPath lastPathComponent]];
            NSDictionary *result = @{@"errMsg": @"ok", @"message": @"文件保存成功", @"savedFilePath": filePath};
            if (callback) {
                callback(result);
            }
        }
    } else {
        NSDictionary *error = @{@"errMsg": @"fail", @"message": @"tempFilePath所指文件不存在"};
        if (callback) {
            callback(error);
        }
    }
}

+ (void)removeSavedFile:(NSDictionary *)param callback:(void (^)(NSDictionary * _Nonnull))callback {
    NSString *filePath = param[@"filePath"];
    if (!filePath) {
        if (callback) {
            NSDictionary *error = @{@"errMsg": @"fail", @"message": @"filePath为空"};
            callback(error);
        }
    }
    
    NSString *currentAppPath = [kMiniProgramPath stringByAppendingPathComponent:[CIMPAppManager sharedManager].currentApp.appInfo.appId];
    NSString *fullPath = [currentAppPath stringByAppendingPathComponent:filePath];
    if ([kFileManager fileExistsAtPath:fullPath]) {
        NSError *error = nil;
        [kFileManager removeItemAtPath:fullPath error:&error];
        if (callback) {
            if (error) {
                NSDictionary *result = @{@"errMsg": @"fail", @"message": error.localizedDescription};
                callback(result);
            } else {
                NSDictionary *result = @{@"errMsg": @"ok", @"message": @"删除本地文件成功"};
                callback(result);
            }
        }
    } else {
        if (callback) {
            NSDictionary *result = @{@"errMsg": @"fail", @"message": @"filePath所指文件不存在"};
            callback(result);
        }
    }
}

+ (void)getSavedFileInfo:(NSDictionary *)param callback:(void (^)(NSDictionary * _Nonnull))callback {
    NSString *filePath = param[@"filePath"];
    if (!filePath) {
        if (callback) {
            NSDictionary *error = @{@"errMsg": @"fail", @"message": @"filePath为空"};
            callback(error);
        }
    }
    
    NSString *currentAppPath = [kMiniProgramPath stringByAppendingPathComponent:[CIMPAppManager sharedManager].currentApp.appInfo.appId];
    NSString *fullPath = [currentAppPath stringByAppendingPathComponent:filePath];
    if ([kFileManager fileExistsAtPath:fullPath]) {
        NSError *error = nil;
        NSDictionary *fileAttributes = [kFileManager attributesOfItemAtPath:fullPath error:&error];
        if (fileAttributes && !error) {
            NSNumber *fileSize = [fileAttributes objectForKey:NSFileSize];
            NSDate *creationDate = [fileAttributes objectForKey:NSFileCreationDate];
            NSDate *modificationDate = [fileAttributes objectForKey:NSFileModificationDate];
            NSTimeInterval creationTimeInterval = [creationDate timeIntervalSince1970];
            NSTimeInterval modTimeInterval = [modificationDate timeIntervalSince1970];
            NSDictionary *result = @{@"errMsg": @"ok", @"size": fileSize, @"createTime": @(creationTimeInterval), @"modificationTime": @(modTimeInterval)};
            if (callback) {
                callback(result);
            }
        } else {
            NSDictionary *result = @{@"errMsg": @"fail", @"message": error.localizedDescription};
            if (callback) {
                callback(result);
            }
        }
    } else {
        if (callback) {
            NSDictionary *result = @{@"errMsg": @"fail", @"message": @"filePath所指文件不存在"};
            callback(result);
        }
    }
}

+ (void)getSavedFileList:(NSDictionary *)param callback:(void (^)(NSDictionary * _Nonnull))callback {
    NSString *currentAppPath = [kMiniProgramPath stringByAppendingPathComponent:[CIMPAppManager sharedManager].currentApp.appInfo.appId];
    NSString *savedFilesPath = [currentAppPath stringByAppendingPathComponent:@"SavedFiles"];
    NSArray *contents = [kFileManager contentsOfDirectoryAtPath:savedFilesPath error:nil];
    NSMutableArray *fileList = @[].mutableCopy;
    for (NSString *name in contents) {
        NSString *filePath = [savedFilesPath stringByAppendingPathComponent:name];
        NSDictionary *fileAttributes = [kFileManager attributesOfItemAtPath:filePath error:nil];
        NSNumber *fileSize = [fileAttributes objectForKey:NSFileSize];
        NSDate *creationDate = [fileAttributes objectForKey:NSFileCreationDate];
        NSTimeInterval creationTimeInterval = [creationDate timeIntervalSince1970];
        NSString *path = [@"SavedFiles" stringByAppendingPathComponent:name];
        NSDictionary *fileInfo = @{@"filePath": path, @"size": fileSize, @"createTime": @(creationTimeInterval)};
        [fileList addObject:fileInfo];
    }
    NSDictionary *result = @{@"errMsg": @"ok", @"fileList": fileList};
    if (callback) {
        callback(result);
    }
}

+ (void)getFileInfo:(NSDictionary *)param callback:(void (^)(NSDictionary * _Nonnull))callback {
    NSString *filePath = param[@"filePath"];
    if (!filePath) {
        if (callback) {
            NSDictionary *error = @{@"errMsg": @"fail", @"message": @"filePath为空"};
            callback(error);
        }
    }
    
    NSString *digestAlgorithm = @"md5";
    if (param[@"digestAlgorithm"]) {
        digestAlgorithm = param[@"digestAlgorithm"];
    }
}

@end
