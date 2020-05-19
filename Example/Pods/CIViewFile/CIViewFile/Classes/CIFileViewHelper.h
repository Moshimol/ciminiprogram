//
//  CIFileViewHelper.h
//  CIViewFile_Example
//
//  Created by Adam on 2020/4/17.
//  Copyright © 2020 daijian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuickLook/QuickLook.h>

NS_ASSUME_NONNULL_BEGIN

@interface CIFileViewHelper : NSObject

+(BOOL)canPreviewItem:(id <QLPreviewItem>)item;

+(BOOL)showFileWithName:(NSString *)fileName path:(NSString *)path rootViewController:(UIViewController *)viewController;

+ (long long) fileSizeAtPath:(NSString*) filePath;

+ (BOOL)isDirectory:(NSString *)filePath;

+(NSMutableArray *)obtainZipSubsetWithFilePath:(NSString *)path;

@end

NS_ASSUME_NONNULL_END
