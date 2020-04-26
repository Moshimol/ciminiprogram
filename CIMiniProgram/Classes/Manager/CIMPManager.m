//
//  CIMPManager.m
//  CIMiniProgram
//
//  Created by 袁鑫 on 2020/4/9.
//

#import "CIMPManager.h"
#import "CIMPFileMacro.h"
#import "CIMPPageModel.h"
#import "NSObject+CIMPJson.h"
#import "CIMPManagerProtocol.h"
#import "CIMPBaseViewController.h"
#import "CIMPLog.h"

@interface CIMPManager ()

@property (nonatomic, strong) CIMPAppInfo *appInfo;
@property (nonatomic, strong) NSArray *pages;
@property (nonatomic, strong) NSMutableArray *viewControllers;


@end

@implementation CIMPManager

- (void)dealloc
{
    MPLog(@"deinit WDHManager");
}

- (instancetype)initWithAppInfo:(CIMPAppInfo *)appInfo {
    if (self = [super init]) {
        _appInfo = appInfo;
        _pageManager = [CIMPPageManager new];
//        _extensionApi = [[WHHybridExtension alloc] init];
        _pageApi = [[CIMPPageApi alloc] initWithPageManager:_pageManager];
        _pageApi.basePath = [NSString stringWithFormat:@"%@/%@/Source", kMiniProgramPath, _appInfo.appId];
        
        self.pageManager.mpManager = self;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleRefresh:) name:@"onPullDownRefresh" object:nil];
    }
    return self;
}

- (void)handleRefresh:(NSNotification *)notification {
    MPLog(@"%@", notification.object);
//    [self.service callSubscribeHandlerWithEvent:notification.name jsonParam:@"{}" webId:[notification.object unsignedLongLongValue]];
}

- (void)setupEntrance:(UINavigationController *)controller {
    [self.pageManager setupWithNaviController:controller];
}

- (void)startApp {
    MPLog(@"load_miniprogram_app");
    
    NSURL *fileURL = [kMiniProgramURL URLByAppendingPathComponent:[NSString stringWithFormat:@"%@/Source/app-config.json", _appInfo.appId]];
    NSData *appData = [[NSData alloc] initWithContentsOfURL:fileURL];
    NSDictionary *config = [appData mp_jsonObject];

    if (config) {
        self.pageManager.config = config;
        NSString *basePath = [NSString stringWithFormat:@"%@/%@/Source", kMiniProgramPath, _appInfo.appId];
        NSDictionary *tabBar = config[@"tabBar"];
        if (tabBar) {
            [self.pageManager startPage:basePath pagePath:tabBar[@"list"][0][@"pagePath"] isRoot:YES openNewPage:YES isTabPage:YES completion:nil];
        } else {
//            NSArray *pages = config[@"pages"];
            NSString *entryPagePath = config[@"entryPagePath"];
            if (entryPagePath) {
                [self.pageManager startPage:basePath pagePath:entryPagePath isRoot:YES openNewPage:YES isTabPage:NO completion:nil];
            } else {
                MPLog(@"entryPagePath not found, Error!");
            }
        }
    }
}


- (void)stopApp {
    self.pageManager = nil;
    self.pageApi = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)page_handler:(id)param pageModel:(CIMPPageModel *)pageModel {
    NSString *command = param[@"api"];
    [_pageApi receive:command param:param];
}

@end
