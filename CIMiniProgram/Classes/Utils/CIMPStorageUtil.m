//
//  CIMPStorageUtil.m
//  CIMiniProgram
//
//  Created by 袁鑫 on 2020/4/10.
//

#import "CIMPStorageUtil.h"

@implementation CIMPStorageUtil

+ (NSData *)dataWithDictionary:(NSDictionary *)dictionary {
    NSData *data = [NSPropertyListSerialization dataWithPropertyList:dictionary format:NSPropertyListBinaryFormat_v1_0 options:0 error:nil];
    return data;
}

+ (BOOL)saveDictionary:(NSDictionary *)dictionary toPath:(NSString *)path {
    NSData *data = [self.class dataWithDictionary:dictionary];
    BOOL isSuccess = [data writeToFile:path atomically:YES];
    return isSuccess;
}

+ (NSDictionary *)dictionaryWithFilePath:(NSString *)filePath {
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    if (!data) {
        return @{};
    }
    NSDictionary *dic = [NSPropertyListSerialization propertyListWithData:data options:0 format:NULL error:nil];
    return dic;
}

@end
