//
//  CIMPPageManager.m
//  CIMiniProgram
//
//  Created by 袁鑫 on 2020/4/9.
//

#import "CIMPPageManager.h"
#import "CIMPPageBridge.h"
#import "CIMPBaseViewController+Extension.h"
#import "CIMPTabBarViewController.h"
#import "CIMPAppAppletViewController.h"
#import "NSString+CIMiniProgram.h"
#import "CIMPAppManager.h"
#import "CIMPApp.h"
#import "CIMPLog.h"

@implementation CIMPPageStack

- (void)setNaviController:(UINavigationController *)naviController {
    _naviController = naviController;
    
    self.initialIndex = _naviController.viewControllers.count;
}

- (BOOL)isExist:(CIMPBaseViewController *)page {
    BOOL exists = NO;
    NSArray *nodes = [self nodes];
    
    //如果为TabBarVC则比较对象  如果为PageVC则比较页面路径
    if ([page isKindOfClass:CIMPPageBaseViewController.class]) {
       CIMPPageBaseViewController *thePage = (CIMPPageBaseViewController *)page;
        for (CIMPBaseViewController *vc in nodes) {
            if ([vc isKindOfClass:CIMPPageBaseViewController.class]) {
                CIMPPageBaseViewController *pageVC = (CIMPPageBaseViewController *)vc;
                if (pageVC.pageModel.pagePath == thePage.pageModel.pagePath) {
                    exists = YES;
                    break;
                }
            } else if ([vc isKindOfClass:CIMPTabBarViewController.class]) {
                for (CIMPPageBaseViewController *subVC in vc.childViewControllers) {
                    if (subVC.pageModel.pagePath == thePage.pageModel.pagePath) {
                        exists = YES;
                        break;
                    }
                }
            }
        }
    } else if ([page isKindOfClass:CIMPTabBarViewController.class]) {
        exists = [nodes containsObject:page];
    }
    
    return exists;
}

/**
 获取小程序栈顶视图控制器

 @return 小程序栈顶视图控制器
 */
- (CIMPBaseViewController *)top {
    __block CIMPBaseViewController *theTop = nil;
    
    [self.naviController.viewControllers enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(__kindof UIViewController * _Nonnull vc, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([vc isKindOfClass:CIMPBaseViewController.class]) {
            theTop = vc;
            *stop = YES;
        }
    }];
    
    return theTop;
}

/**
 获取小程序当前显示的页面
 如果为TabBarVC 则为当前显示的ChildViewController
 
 @return 小程序当前显示的页面
 */
- (CIMPBaseViewController *)currentPage {
    CIMPPageBaseViewController *page = nil;
    CIMPBaseViewController *topVC = [self top];
    
    if ([topVC isKindOfClass:CIMPPageBaseViewController.class]) {
        page = (CIMPPageBaseViewController *)topVC;
    } else if ([topVC isKindOfClass:CIMPTabBarViewController.class]){
        page = [(CIMPTabBarViewController *)topVC currentController];
    }
    return page;
}

- (CIMPPageBaseViewController *)nodeAtIndex:(NSUInteger)atIndex {
    NSUInteger index = self.initialIndex + atIndex;
    
    if (index < self.naviController.viewControllers.count) {
        if ([self.naviController.viewControllers[index] isKindOfClass:[CIMPPageBaseViewController class]]) {
            return (CIMPPageBaseViewController *)self.naviController.viewControllers[index];
        }
    }
    return nil;
}


/**
 获取小程序所有页面
 TabBarController的计算为ChildViewController

 @return 小程序所有页面
 */
- (NSArray <CIMPPageBaseViewController *> *)nodes {
    NSMutableArray *arr = [NSMutableArray new];
    for (CIMPPageBaseViewController *cell in [self stack]) {
        if ([cell isKindOfClass:[CIMPPageBaseViewController class]]) {
            [arr addObject:cell];
        } else if ([cell isKindOfClass:[CIMPTabBarViewController class]]) {
            for (CIMPPageBaseViewController *tabBarCell in [(CIMPTabBarViewController *)cell childViewControllers]) {
                [arr addObject:tabBarCell];
            }
        }
    }
    return [arr copy];
}


/**
 获取小程序页面控制器栈

 @return 程序页面控制器栈
 */
- (NSArray <CIMPBaseViewController *> *)stack {
    NSMutableArray *arr = [NSMutableArray new];
    
    NSArray *viewControllers = self.naviController.viewControllers;
    NSUInteger index = [viewControllers indexOfObject:[self top]];
    if (index != NSNotFound) {
        for (NSInteger i = index; i >= 0; i--) {
            UIViewController *vc = [viewControllers objectAtIndex:i];
            if (![vc isKindOfClass:CIMPBaseViewController.class]) {
                break;
            }
            
            [arr insertObject:vc atIndex:0];
        }
    }
    return [arr copy];
}

// MARK: - Action
- (void)push:(CIMPBaseViewController *)page {
    [self.naviController pushViewController:page animated:YES];
}

- (CIMPBaseViewController *)pop {
    NSArray *pages = [self stack];
    if (pages.count > 0) {
        CIMPBaseViewController *popedVC = (CIMPBaseViewController *)[self.naviController popViewControllerAnimated:YES];
        
        CIMPBaseViewController *lastPage = self.naviController.viewControllers.lastObject;
        if ([lastPage isKindOfClass:[CIMPPageBaseViewController class]]) {
            [(CIMPPageBaseViewController *)lastPage pageModel].backType = @"navigateBack";
        }else if ([lastPage isKindOfClass:[CIMPTabBarViewController class]]) {
            CIMPTabBarViewController *tabBar = (CIMPTabBarViewController *)lastPage;
            tabBar.pageModel.backType = @"navigateBack";
        }
        return popedVC;
    }
    return nil;
}

- (void)popToPage:(CIMPBaseViewController *)toPage {
    NSArray *pages = [self stack];
    [pages enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(CIMPBaseViewController *  _Nonnull page, NSUInteger idx, BOOL * _Nonnull stop) {
        if (page == toPage) {
            if ([page isKindOfClass:CIMPPageBaseViewController.class]) {
                [(CIMPPageBaseViewController *)page pageModel].backType = @"navigateBack";
            } else if ([page isKindOfClass:CIMPTabBarViewController.class]) {
                [(CIMPTabBarViewController *)page pageModel].backType = @"navigateBack";
            }
            [self.naviController popToViewController:page animated:YES];
            *stop = YES;
        }
    }];
}

- (UIViewController *)popToRoot {
    NSArray *pages = [self stack];
    if (pages.count > 0) {
        CIMPBaseViewController *rootPage = [pages firstObject];
        if ([rootPage isKindOfClass:CIMPPageBaseViewController.class]) {
            [(CIMPPageBaseViewController *)rootPage pageModel].backType = @"navigateBack";
        } else if ([rootPage isKindOfClass:CIMPTabBarViewController.class]) {
            [(CIMPTabBarViewController *)rootPage pageModel].backType = @"navigateBack";
        }
        [self.naviController popToViewController:rootPage animated:YES];
        
        return rootPage;
    }
    return nil;
}

- (NSUInteger)length{
    return [self stack].count;
}

@end

@interface CIMPPageManager ()

/// start page后页面栈的长度
@property (nonatomic, assign) int lastStackLength;

@property (nonatomic, assign) BOOL originNavigationBarHidden;

/// 小程序根试图控制器
@property (nonatomic, strong) CIMPBaseViewController *rootViewController;

@end

@implementation CIMPPageManager

- (void)setupWithNaviController:(UINavigationController *)naviController {
    _originNavigationBarHidden = naviController.isNavigationBarHidden;
    self.naviController = naviController;
//    self.pageStack.naviController = naviController;
}

- (void)resetNavigationBarHidden {
    [self.pageStack.naviController setNavigationBarHidden:_originNavigationBarHidden animated:NO];
}

- (instancetype)init {
    if (self = [super init]) {
        self.pageStack = [CIMPPageStack new];
    }
    return self;
}

// MARK: - 开启一个页面
- (void)startPage:(NSString *)basePath pagePath:(NSString *)pagePath isRoot:(BOOL)isRoot completion:(void (^ _Nullable)(void))completion  {
    [self startPage:basePath pagePath:pagePath isRoot:isRoot openNewPage:YES completion:completion];
}

- (void)startPage:(NSString *)basePath pagePath:(NSString *)pagePath openNewPage:(BOOL)openNewPage completion:(void (^ _Nullable)(void))completion {
    [self startPage:basePath pagePath:pagePath isRoot:NO openNewPage:openNewPage completion:completion];
}

- (void)startPage:(NSString *)basePath pagePath:(NSString *)pagePath isRoot:(BOOL)isRoot openNewPage:(BOOL)openNewPage completion:(void (^ _Nullable)(void))completion {
    [self startPage:basePath pagePath:pagePath isRoot:isRoot openNewPage:openNewPage isTabPage:NO completion:completion];
}

- (void)startPage:(NSString *)basePath pagePath:(NSString *)pagePath isRoot:(BOOL)isRoot openNewPage:(BOOL)openNewPage isTabPage:(BOOL)isTabPage completion:(void (^ _Nullable)(void))completion {
    NSString *openType;
    NSDictionary *config = _config;
    if (isRoot) {
        openType = @"appLaunch";
    } else if (openNewPage) {
        openType = @"navigateTo";
    } else {
        openType = @"redirectTo";
    }
    
    if (isTabPage) {
        //配置tabbar
        NSDictionary *tabBar = config[@"tabBar"];
        CIMPTabbarStyle *style = [[CIMPTabbarStyle alloc] init];
        style.color = tabBar[@"color"];
        style.selectedColor = tabBar[@"selectedColor"];
        style.backgroundColor = tabBar[@"backgroundColor"];
        style.position = tabBar[@"position"];
        style.borderStyle = tabBar[@"borderStyle"];
        NSMutableArray *list = [NSMutableArray new];
        for (NSDictionary *item in tabBar[@"list"]) {
            CIMPTabbarItemStyle *itemStyle = [[CIMPTabbarItemStyle alloc] init];
            itemStyle.title = item[@"text"];
            itemStyle.pagePath = item[@"pagePath"];
            if ([itemStyle.pagePath isEqualToString:pagePath]) {
                itemStyle.isDefaultPath = YES;
            }
            
            if (item[@"iconPath"]) {
                itemStyle.iconPath = [basePath stringByAppendingPathComponent:item[@"iconPath"]];
            }
            
            if (item[@"selectedIconPath"]) {
                itemStyle.selectedIconPath = [basePath stringByAppendingPathComponent:item[@"selectedIconPath"]];
            }
            
            [list addObject:itemStyle];
        }
        style.list = list;
        
        NSDictionary *page = config[@"page"];
        NSMutableArray *controllers = [NSMutableArray new];
        for (CIMPTabbarItemStyle *itemStyle in list) {
            CIMPPageModel *model = [CIMPPageModel new];
            NSString *visitPagePath = pagePath;
            NSArray *pagePathArray = [visitPagePath componentsSeparatedByString:@"?"];
            if (pagePathArray.count >= 2) {
                pagePath = pagePathArray.firstObject;
                model.query = pagePathArray[1];
            }
            
            NSDictionary *pageConfig = page[pagePath][@"window"];
            CIMPPageStyle *pageStyle = [CIMPPageStyle new];
            pageStyle.navigationBarTitleText = pageConfig[@"navigationBarTitleText"];
            pageStyle.navigationBarTextStyle = pageConfig[@"navigationBarTextStyle"];
            pageStyle.backgroundColor = pageConfig[@"backgroundColor"];
            pageStyle.backgroundTextStyle = pageConfig[@"backgroundTextStyle"];
            pageStyle.navigationBarBackgroundColor = pageConfig[@"navigationBarBackgroundColor"];
            pageStyle.disableNavigationBack = [pageConfig[@"disableNavigationBack"] boolValue];
            pageStyle.enablePullDownRefresh = [pageConfig[@"enablePullDownRefresh"] boolValue];
            
            model.pagePath = itemStyle.pagePath;
            model.pageStyle = pageStyle;
            model.pageRootDir = basePath;
            model.openType = openType;
            
//            [self parseConfig:self.config model:model];
            
            CIMPPageBaseViewController *vc = [self createPage:model];
            vc.isTabBarVC = YES;
            [controllers addObject:vc];
        }
        
        if (openNewPage) {
            CIMPTabBarViewController *vc = [[CIMPTabBarViewController alloc] init];
            vc.pageManager = self;
            vc.viewControllers = [controllers copy];
            vc.tabbarStyle = style;
            [vc loadTabStyle];
            if (isRoot) {
                [self startRootPage:YES page:vc completion:completion];
            } else {
                [self gotoPage:vc completion:completion];
            }
        } else {
            CIMPTabBarViewController * topVC = (CIMPTabBarViewController *)[self.pageStack currentPage];
            if ([topVC isKindOfClass:CIMPTabBarViewController.class]) {
                topVC.viewControllers = [controllers copy];
                topVC.tabbarStyle = style;
                [topVC loadTabStyle];
            }
        }
    } else {
        CIMPPageModel *model = [CIMPPageModel new];
        NSString *visitPagePath = pagePath;
        
        NSArray *pagePathArray = [visitPagePath componentsSeparatedByString:@"?"];
        
        if (pagePathArray.count >= 2) {
            // 如果有参数 则需要改变pagePath 参数会导致key的不同
            pagePath = pagePathArray.firstObject;
            model.query = pagePathArray[1];
        }
        
        NSDictionary *page = config[@"page"];
        NSDictionary *pageConfig = page[pagePath][@"window"];
        CIMPPageStyle *pageStyle = [CIMPPageStyle new];
        pageStyle.navigationBarTitleText = pageConfig[@"navigationBarTitleText"];
        pageStyle.navigationBarTextStyle = pageConfig[@"navigationBarTextStyle"];
        pageStyle.backgroundColor = pageConfig[@"backgroundColor"];
        pageStyle.backgroundTextStyle = pageConfig[@"backgroundTextStyle"];
        pageStyle.navigationBarBackgroundColor = pageConfig[@"navigationBarBackgroundColor"];
        pageStyle.disableNavigationBack = [pageConfig[@"disableNavigationBack"] boolValue];
        pageStyle.enablePullDownRefresh = [pageConfig[@"enablePullDownRefresh"] boolValue];
        
        model.pagePath = pagePathArray[0];
        model.pageStyle = pageStyle;
        model.pageRootDir = basePath;
        model.openType = openType;
        model.appName = config[@"extend"] ? config[@"extend"][@"appName"] : @"";
        model.appIconName = config[@"extend"] ? config[@"extend"][@"appIcon"] : @"";
        
//        [self parseConfig:config model:model];
        
        if (!openNewPage) {
            CIMPPageBaseViewController *topVC = (CIMPPageBaseViewController *)[self.pageStack currentPage];
            if ([topVC isKindOfClass:CIMPPageBaseViewController.class]) {
                topVC.pageModel = model;
                [topVC loadData];
                [topVC loadStyle];
            }
        } else {
            CIMPPageBaseViewController *vc = [self createPage:model];
            if (isRoot) {
                vc.isRoot = YES;
                vc.isNeedLoading = config[@"extend"] ? [config[@"extend"][@"loading"] boolValue] : NO;
                [self startRootPage:NO page:vc completion:completion];
            } else {
                [self gotoPage:vc completion:completion];
            }
        }
    }
}

- (void)reLaunch:(NSString *)basePath pagePath:(NSString *)pagePath {
    if ([self.pageStack.naviController.viewControllers[0] isKindOfClass:CIMPTabBarViewController.class]) {
        CIMPTabBarViewController *rootViewController = self.pageStack.naviController.viewControllers[0];
        BOOL reLaunchToTabBar = NO;
        for (CIMPTabbarItemStyle *tabBarItemStyle in rootViewController.tabbarStyle.list) {
            if ([pagePath isEqualToString:tabBarItemStyle.pagePath]) {
                reLaunchToTabBar = YES;
                [rootViewController switchTabBar:pagePath];
                break;
            }
        }
        
        if (reLaunchToTabBar) {
            [self.pageStack.naviController popToRootViewControllerAnimated:NO];
        } else {
            NSArray *pages = _config[@"pages"];
            for (NSString *page in pages) {
                if ([pagePath isEqualToString:page]) {
                    break;
                } else {
                    MPLog(@"reLaunch url not found!");
                    return;
                }
            }
            CIMPPageModel *model = [CIMPPageModel new];
            NSString *visitPagePath = pagePath;
            
            NSArray *pagePathArray = [visitPagePath componentsSeparatedByString:@"?"];
            if (pagePathArray.count >= 2) {
                model.query = pagePathArray[1];
            }
            
            model.pagePath = pagePath;
            model.pageRootDir = basePath;
            model.openType = @"appLaunch";
            
            CIMPPageBaseViewController *topVC = [self createPage:model];
            [topVC loadData];
            [topVC loadStyle];
            [self.pageStack.naviController setViewControllers:@[topVC] animated:NO];
        }
    } else {
        NSArray *pages = _config[@"pages"];
        for (NSString *page in pages) {
            if ([pagePath isEqualToString:page]) {
                break;
            } else {
                MPLog(@"reLaunch url not found!");
                return;
            }
        }
        CIMPPageModel *model = [CIMPPageModel new];
        NSString *visitPagePath = pagePath;
        
        NSArray *pagePathArray = [visitPagePath componentsSeparatedByString:@"?"];
        if (pagePathArray.count >= 2) {
            model.query = pagePathArray[1];
        }
        
        model.pagePath = pagePath;
        model.pageRootDir = basePath;
        model.openType = @"appLaunch";
        
        CIMPPageBaseViewController *topVC = [self createPage:model];
        [topVC loadData];
        [topVC loadStyle];
        [self.pageStack.naviController setViewControllers:@[topVC] animated:NO];
    }
}

- (void)parseConfig:(NSDictionary *)data model:(CIMPPageModel *)model {
    if (data[@"window"]) {
        model.windowStyle = [CIMPPageModel parseWindowStyleData:data[@"window"]];
        
        if (data[@"window"][@"pages"]) {
            model.pageStyle = [CIMPPageModel parsePageStyleData:data[@"window"][@"pages"] path:[model pathKey]];
        } else {
            model.pageStyle = [CIMPPageStyle new];
        }
    } else {
        model.windowStyle = [CIMPPageStyle new];
    }
}

- (void)gotoPageAtIndex:(NSUInteger)atIndexFromTop {
    NSArray *pages = [self.pageStack stack];
    NSInteger index = pages.count - atIndexFromTop - 1;
    if (index < 0 || index >= pages.count) {
        [self.pageStack popToRoot];
    } else {
        [self.pageStack popToPage:[pages objectAtIndex:index]];
    }
}

- (void)setTopPageTitle:(NSString *)title {
    CIMPBaseViewController *vc = [self.pageStack currentPage];
    [vc.pageModel updateTitle:title];
    if([vc isKindOfClass: [CIMPPageBaseViewController class]]) {
        CIMPPageBaseViewController *pvc = (CIMPPageBaseViewController *)vc;
        [pvc loadStyle];
    }
}

- (void)startRootPage:(BOOL)isTabPage page:(CIMPBaseViewController *)page completion:(void (^ __nullable)(void))completion {
    UINavigationController *naviController = [[UINavigationController alloc] initWithRootViewController:page];
    naviController.modalPresentationStyle = UIModalPresentationFullScreen;
    self.pageStack.naviController = naviController;
    [self.naviController presentViewController:naviController animated:YES completion:^{
        if (completion) {
            completion();
        }
    }];
    self.rootViewController = page;
}

- (void)gotoPage:(CIMPBaseViewController *)page completion:(void (^ __nullable)(void))completion {
    if ([self.pageStack isExist:page]) {
        [self.pageStack popToPage:page];
    } else {
        BOOL resetPage = NO;
        if (self.pageStack.naviController.viewControllers.count > 0 && [self.pageStack.naviController.viewControllers.lastObject isKindOfClass:CIMPAppAppletViewController.class]) {
            CIMPAppAppletViewController *home = self.pageStack.naviController.viewControllers.lastObject;
            NSString *pid = [home valueForKey:@"mp_applet_page_id"];
            if ([pid isKindOfClass:NSString.class] && [pid isEqualToString:@"Mini_Program_Applet_Page"]) {
                NSMutableArray *viewControllers = @[].mutableCopy;
                NSInteger count = self.pageStack.naviController.viewControllers.count;
                [self.pageStack.naviController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if (idx < count - 1) {
                        [viewControllers addObject:obj];
                    }
                }];
                [viewControllers addObject:page];
                
                if (home.isLoading) {
                    [home stopLoadingWithCompletion:^{
                        [self.pageStack.naviController setViewControllers:viewControllers];
                    }];
                } else {
                    [self.pageStack.naviController setViewControllers:viewControllers];
                }
                resetPage = YES;
            }
        }
        
        if (!resetPage) {
            [self.pageStack push:page];
        }
    }
    if (completion) {
        completion();
    }
}

//创建页面，并连接page bridge
- (CIMPPageBaseViewController *)createPage:(CIMPPageModel *)model {
    CIMPPageBaseViewController *vc = [CIMPPageBaseViewController new];
    vc.pageModel = model;
    vc.pageManager = self;
    
    CIMPPageBridge *bridge = [CIMPPageBridge new];
    bridge.manager = self.mpManager;
    vc.bridge =  (id <PageBridgeJSProtocol>)bridge;
    
    return vc;
}

//MARK: - 实现协议
//page appear or disappear

- (void)activePageDidDisappear:(CIMPPageBaseViewController *)vc {
    
}

- (void)activePageWillAppear:(CIMPPageBaseViewController *)vc {
    
}

- (void)activePageDidAppear:(CIMPPageBaseViewController *)vc {
    CIMPPageModel *topModel = vc.pageModel;
    if (topModel.backType) {
        CIMPPageModel *model = [CIMPPageModel new];
        
        if (topModel) {
            model.pagePath = topModel.pagePath;
            model.query = topModel.query;
            model.pageId = topModel.pageId;
            model.pageRootDir = topModel.pageRootDir;
            model.openType = topModel.backType;
        }
        
        topModel.backType = nil;
        
//        [self.whManager page_publishHandler:@"custom_event_DOMContentLoaded" param:@"" pageModel:model callbackId:@""];
    }
}

- (void)pop {
    [self.pageStack pop];
}

- (void)exit {
    [self.naviController dismissViewControllerAnimated:YES completion:nil];
    CIMPApp *app = [CIMPAppManager sharedManager].currentApp;
    [app stopApp];
}

- (void)more {
    CIMPApp *app = [CIMPAppManager sharedManager].currentApp;
    NSArray<NSString *> *titles = [app getMoreActionSheetTitles];
    MoreActionBlock actionBlock = [app getMoreActionSheetEvent];
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
    
    for (NSInteger i = 0; i < titles.count; i++) {
        NSString *title = titles[i];
        UIAlertAction *action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (actionBlock) {
                actionBlock(i);
            }
        }];
        [actionSheet addAction:action];
    }
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [actionSheet addAction:actionCancel];
    [[self.pageStack top] presentViewController:actionSheet animated:YES completion:nil];
}

- (void)callSubscribeHandler:(NSString *)eventName jsonParam:(NSString *)jsonParam webIds:(NSArray *)webIds {
    for (NSString *webId in webIds) {
        unsigned long long index = [webId unsignedLongLongValue];
        for (CIMPPageBaseViewController *vc in [self.pageStack nodes]) {
            if (vc.pageModel.pageId == index) {
                NSString *js = [NSString stringWithFormat:@"Bridge.response(%@, %@)", eventName, jsonParam];
                [vc.bridge callJS:js controller:vc callback:nil];
            }
        }
    }
}

- (void)callPageConfig:(unsigned long long)webId {
    void(^trackLoadConfig) (CIMPPageModel *model, CIMPPageBaseViewController *vc) = ^(CIMPPageModel *model, CIMPPageBaseViewController *vc) {
        if (model.windowStyle != nil) {
            [vc track_renderContainer_success];
        } else {
            [vc track_open_page_failure:@"config解析window节点失败"];
        }
    };
    
    for (CIMPPageBaseViewController *pvc in [self.pageStack nodes]) {
        if (pvc.pageModel.pageId == webId) {
            NSString *js = @"__wxConfig";
            [pvc.bridge callJS:js controller:pvc callback:^(id result) {
                if ([result isKindOfClass:[NSDictionary class]]) {
                    [pvc track_renderContainer];
                    [self parseConfig:result model:pvc.pageModel];
                    trackLoadConfig(pvc.pageModel, pvc);
                    
                    [pvc loadStyle];
                }
                
            }];
        }
    }
}

- (void)switchTabbar:(NSDictionary *)itemInfo callback:(void(^)(NSDictionary *))callback {
    MPLog(@"itemInfo:%@",itemInfo);
    __block BOOL success = NO;
    NSArray *arr = self.pageStack.naviController.viewControllers;
    [arr enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(CIMPTabBarViewController  *controller, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([controller isKindOfClass:[CIMPTabBarViewController class]]) {
            [self.pageStack popToRoot];
            [controller switchTabBar:itemInfo[@"url"]];
            success = YES;
            *stop = YES;
        }
    }];
    NSString *errMsg = success ? @"ok" : @"fail";
    NSDictionary *result = @{@"errMsg": errMsg};
    if (callback) {
        callback(result);
    }
}

/**
加载页面配置

@param webId 页面ID
@param pageConfig 页面配置信息
*/
- (void)loadPageConfig:(unsigned long long)webId pageConfig:(NSDictionary *)pageConfig {
    void(^trackLoadConfig)(CIMPPageModel *model, CIMPPageBaseViewController *vc) = ^(CIMPPageModel *model, CIMPPageBaseViewController *vc){
        if (model.windowStyle != nil) {
            [vc track_renderContainer_success];
        } else {
            [vc track_open_page_failure:@"config解析window节点失败"];
        }
    };
    
    for (CIMPPageBaseViewController *controller in [self.pageStack nodes]) {
        if (controller.pageModel.pageId == webId) {
            [controller track_renderContainer];
            [self parseConfig:pageConfig[@"data"] model:controller.pageModel];
            trackLoadConfig(controller.pageModel,controller);
            [controller loadStyle];
        }
    }
}
 
- (NSUInteger)stackLength {
    return [self.pageStack length];
}

- (BOOL)isRootPage:(UIViewController *)page {
    if (!page || ![page isKindOfClass:CIMPBaseViewController.class]) {
        return NO;
    }
    
    if (!self.rootViewController) {
        return NO;
    }
    
    return page == self.rootViewController;
}

@end
