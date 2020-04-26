//
//  CIMPApp.m
//  CIMiniProgram
//
//  Created by 袁鑫 on 2020/4/9.
//

#import "CIMPApp.h"
#import "CIMPManager.h"
#import "CIMPManagerProtocol.h"
#import "CIMPAppManager.h"
#import "CIMPFileMacro.h"
#import "CIMPFileManager.h"
#import <CINetworking/CINetworking.h>
#import <SSZipArchive/SSZipArchive.h>
#import "CIMPLog.h"

@interface CIMPApp ()

@property (nonatomic, strong) CIMPManager *manager;
@property (nonatomic, strong) UINavigationController *entrance;
@property (nonatomic, strong) NSArray<NSString *> *titles;
@property (nonatomic, copy) MoreActionBlock action;

@end

@implementation CIMPApp

- (instancetype)initWithAppInfo:(CIMPAppInfo *)appInfo {
    if (self = [super init]) {
        _appInfo = appInfo;
    }
    return self;
}

#pragma mark - Helper

- (BOOL)isAppRootPage:(UIViewController *)page {
    return [self.manager.pageManager isRootPage:page];
}

- (void)setMoreButton:(NSArray<NSString *> *)titles action:(MoreActionBlock)action {
    self.titles = titles;
    self.action = action;
}

- (NSArray<NSString *> *)getMoreActionSheetTitles {
    return self.titles;
}

- (MoreActionBlock)getMoreActionSheetEvent {
    return self.action;
}

- (void)donwloadApp:(NSString *)url completion:(nonnull void (^)(BOOL, NSString * _Nonnull))completion {
    if (!self.appInfo.appId) {
        if (completion) {
            completion(NO, @"appId为空");
            return;
        }
    }
    
    BOOL isDirectory;
    BOOL existed = [kFileManager fileExistsAtPath:kMiniProgramPath isDirectory:&isDirectory];
    NSError *error;
    if (!(isDirectory && existed)) {
        [kFileManager createDirectoryAtURL:kMiniProgramURL withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            if (completion) {
                completion(NO, [NSString stringWithFormat:@"Create mini program directory error: %@", error]);
            }
            return;
        }
    }
    existed = [kFileManager fileExistsAtPath:kMiniProgramPKGPath isDirectory:&isDirectory];
    if (!(isDirectory && existed)) {
        [kFileManager createDirectoryAtURL:kMiniProgramPKG withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            if (completion) {
                completion(NO, [NSString stringWithFormat:@"Create mini program package directory error: %@", error]);
            }
            return;
        }
    }
    
    NSString *filePath = [NSString stringWithFormat:@"%@/%@", kMiniProgramPKGPath, self.appInfo.appId];
    if ([kFileManager fileExistsAtPath:filePath]) {
        [kFileManager removeItemAtPath:filePath error:nil];
    }
    
    [[CINetworking sharedInstance] downloadFile:url parameters:nil progress:^(NSProgress * _Nonnull progress) {
        MPLog(@"Donwload progress: %.0f%%", progress.fractionCompleted * 100);
    } success:^(id  _Nullable responseObject) {
        NSData *fileData = responseObject;
        BOOL success = [fileData writeToFile:filePath atomically:YES];
        if (success) {
            MPLog(@"保存文件成功");
            NSString *destinamePath = [NSString stringWithFormat:@"%@/%@/Source", kMiniProgramPath, self.appInfo.appId];
            if ([kFileManager fileExistsAtPath:destinamePath]) {
                [kFileManager removeItemAtPath:destinamePath error:nil];
            }
            [kFileManager createDirectoryAtPath:destinamePath withIntermediateDirectories:YES attributes:nil error:nil];
            NSError *unzipFileError;
            [SSZipArchive unzipFileAtPath:filePath toDestination:destinamePath overwrite:YES password:nil error:&unzipFileError];
            if (unzipFileError) {
                NSString *errMsg = [NSString stringWithFormat:@"unzip file error: %@", unzipFileError];
                if (completion) {
                    completion(NO, errMsg);
                }
            } else {
                if (completion) {
                    completion(YES, @"unzip file success");
                }
            }
        } else {
            MPLog(@"保存文件失败");
            if (completion) {
                completion(NO, [NSString stringWithFormat:@"保存文件失败, filePath is %@", filePath]);
            }
        }
    } failure:^(NSError * _Nonnull error) {
        MPLog(@"下载文件失败");
        if (completion) {
            completion(NO, @"下载文件失败");
        }
    }];
}

- (void)deleteApp:(void (^)(BOOL, NSString * _Nonnull))completion {
    NSString *filePath = [NSString stringWithFormat:@"%@/%@", kMiniProgramPath, self.appInfo.appId];
    NSError *error = nil;
    [kFileManager removeItemAtPath:filePath error:&error];
    
    if (error) {
        if (completion) {
            completion(NO, error.localizedDescription);
        }
    } else {
        if (completion) {
            completion(YES, @"remove app successfully");
        }
    }
}

#pragma mark - Life Cycle

- (void)startAppWithEntrance:(UINavigationController *)entrance {
    [self startAppWithEntrance:entrance completion:^(BOOL success, NSString * _Nonnull msg) {
        
    }];
}

- (void)startAppWithEntrance:(UINavigationController *)entrance completion:(void(^)(BOOL success, NSString *msg))completion {
    if (!self.appInfo.appId) {
        if (completion) {
            completion(NO, @"appId is empty");
        }
        return;
    }
        
    // 禁止同时开启两个相同的小程序
    if ([[CIMPAppManager sharedManager] isAppRunning:self.appInfo.appId]) {
        if (completion) {
            completion(NO, @"app is running");
        }
        return;
    }

    if (!self.appInfo.appPath) {
        if (completion) {
            completion(NO, @"appPath is null");
        }
        return;
    }
    NSString *appPath = [NSString stringWithFormat:@"%@/%@", kMiniProgramPath, self.appInfo.appId];
    if ([kFileManager fileExistsAtPath:appPath]) {
        NSString *tmpDir = [appPath stringByAppendingString:@"/temp"];
        [kFileManager createDirectoryAtPath:tmpDir withIntermediateDirectories:YES attributes:nil error:nil];
        _manager = [[CIMPManager alloc] initWithAppInfo:self.appInfo];
        _manager.startRootCompletion = completion;
        [_manager setupEntrance:entrance];
        [_manager startApp];
            
        [[CIMPAppManager sharedManager] addApp:self];
            
        if (completion) {
            completion(YES, @"start app success!");
        }
    } else {
        if (completion) {
            completion(NO, [NSString stringWithFormat:@"MiniProgram App %@ does not exist!", self.appInfo.appId]);
        }
    }
}

- (UIViewController *)getRootPage {
    return self.manager.pageManager.naviController.topViewController;
}

- (void)stopApp {
    [self.manager.pageManager resetNavigationBarHidden];
    [self.manager stopApp];
    [[CIMPAppManager sharedManager] removeApp:self];
}

- (void)onAppEnterBackground {
    [self.manager.pageManager resetNavigationBarHidden];
//    [self.manager.service callSubscribeHandlerWithEvent:@"onAppEnterBackground" jsonParam:[@{@"mode": @"hang"} wdh_jsonString]];
}

- (void)onAppEnterForeground {
    
//    [self.manager.service callSubscribeHandlerWithEvent:@"onAppEnterForeground" jsonParam: @"{}"];
    
    //重置UserAgent
    NSString *userAgent = [[[UIWebView alloc] init] stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    NSString * customUA = [userAgent stringByAppendingFormat:@" Hera(JSBridgeVersion/3.0)"];
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"UserAgent" : customUA}];
}

@end
