//
//  CIMPAppManager.m
//  AFNetworking
//
//  Created by 袁鑫 on 2020/4/9.
//  Copyright © 2020 Nanjing Xihui Information & Technology Co., Ltd. All rights reserved.
//

#import "CIMPAppManager.h"
#import "CIMPFileMacro.h"
#import "CIMPApp.h"
#import "CIMPLoadingView.h"

@interface CIMPAppManager ()

@property (nonatomic, copy) NSMutableArray<CIMPApp *> *apps;

@end

static CIMPAppManager *_appManager = nil;

@implementation CIMPAppManager

#pragma mark - Init

- (instancetype)init {
    if (self = [super init]) {
        _apps = [NSMutableArray new];
    }
    return self;
}

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_appManager) {
            _appManager = [[CIMPAppManager alloc] init];
        }
    });
    return _appManager;
}

#pragma mark - 小程序栈管理

- (NSArray *)getApplist {
    return [kFileManager contentsOfDirectoryAtPath:kMiniProgramPath error:nil];
}

- (void)setAppSharedData:(NSString *)data {
    if (data) {
        [[NSUserDefaults standardUserDefaults] setValue:data forKey:@"MiniProgram"];
    }
}

- (void)addApp:(CIMPApp *)app {
    if (app) {
        [self.apps addObject:app];
    }
}

- (void)removeApp:(CIMPApp *)app {
    [self.apps removeObject:app];
    
    // 如果全部小程序退出 做清理工作
    if (self.apps.count <= 0) {
        [self cleanMPodoer];
    }
}

- (CIMPApp *)currentApp {
    return [self.apps lastObject];
}

#pragma mark - Helper

- (BOOL)isAppRunning:(NSString *)appId {
    for (CIMPApp *app in self.apps) {
        if ([app.appInfo.appId isEqualToString:appId]) {
            return YES;
        }
    }
    
    return NO;
}

- (void)cleanMPodoer {
    
    // 清理所有loading框
    [CIMPLoadingView removeAllLoading];
    
    // 注销schema拦截
//    [NSURLProtocol wk_unregisterScheme:@"wdfile"];
}

@end
