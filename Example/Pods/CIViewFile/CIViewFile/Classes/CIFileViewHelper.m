//
//  CIFileViewHelper.m
//  CIViewFile_Example
//
//  Created by Adam on 2020/4/17.
//  Copyright © 2020 daijian. All rights reserved.
//

#import "CIFileViewHelper.h"
#import "CIFileViewController.h"
#import "SSZipArchive.h"
#import "CIZipListViewController.h"

@implementation CIFileViewHelper

+(BOOL)canPreviewItem:(id <QLPreviewItem>)item {
    return [QLPreviewController canPreviewItem:item];
}

+(BOOL)showFileWithName:(NSString *)fileName path:(NSString *)path rootViewController:(UIViewController *)viewController {
    if ([fileName containsString:@"zip"]) {
        NSString * documentPath = [path stringByReplacingOccurrencesOfString:@".zip" withString:@""];
        if ([CIFileViewHelper fileIsExistsWithPath:documentPath]) {
            NSMutableArray * array = [CIFileViewHelper obtainZipSubsetWithFilePath:documentPath];
            [CIFileViewHelper pushFileListControllerWithArray:array documentPath:documentPath rootViewController:viewController];
            return YES;
            
        }else {
            //解压
            BOOL isSuccess = [SSZipArchive unzipFileAtPath:path toDestination:documentPath];
            if (isSuccess) {
                NSMutableArray * array = [CIFileViewHelper obtainZipSubsetWithFilePath:documentPath];
                [CIFileViewHelper pushFileListControllerWithArray:array documentPath:documentPath rootViewController:viewController];
                return YES;
            }else {
                NSURL * url = [NSURL fileURLWithPath:path];
                UIDocumentInteractionController *_documentInteractionController = [UIDocumentInteractionController
                                                       interactionControllerWithURL:url];
                [_documentInteractionController presentOpenInMenuFromRect:CGRectZero inView:viewController.view animated:YES];
            }
            return NO;
        }
        
    }else {
        if ([CIFileViewHelper canPreviewItem:[NSURL fileURLWithPath:path]]) {
            CIFIleViewController * controller = [[CIFIleViewController alloc] init];
            controller.nameArr = @[fileName].mutableCopy;
            controller.pathArr = @[path].mutableCopy;
            UINavigationController * navi = [[UINavigationController alloc] initWithRootViewController:controller];
            navi.modalPresentationStyle = UIModalPresentationFullScreen;
            [viewController presentViewController:navi animated:YES completion:nil];
            return YES;;
        }else {
            NSURL * url = [NSURL fileURLWithPath:path];
            UIDocumentInteractionController *_documentInteractionController = [UIDocumentInteractionController
                                                   interactionControllerWithURL:url];
            [_documentInteractionController presentOpenInMenuFromRect:CGRectZero inView:viewController.view animated:YES];
        }
    }
    return NO;
}

+(void)pushFileListControllerWithArray:(NSArray *)array documentPath:(NSString *)path rootViewController:(UIViewController *)viewController {
    CIZipListViewController * controller = [[CIZipListViewController alloc] init];
    controller.dataArray = array;
    controller.documentPath = path;
    UINavigationController * navi = [[UINavigationController alloc] initWithRootViewController:controller];
    navi.modalPresentationStyle = UIModalPresentationFullScreen;
    [viewController presentViewController:navi animated:YES completion:nil];
}

+(NSMutableArray *)obtainZipSubsetWithFilePath:(NSString *)path {
    // 读取文件夹内容
    NSError *error = nil;
    NSMutableArray*items = [[[NSFileManager defaultManager]
                             contentsOfDirectoryAtPath:path
                             error:&error] mutableCopy];
    return items;
}

+(BOOL)fileIsExistsWithPath:(NSString *)path {
    BOOL res = [[NSFileManager defaultManager] fileExistsAtPath:path];
    return res;
}

+ (long long) fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

+ (BOOL)isDirectory:(NSString *)filePath {
  BOOL isDirectory = NO;
  [[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDirectory];
  return isDirectory;
}

@end
