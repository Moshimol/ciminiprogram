//
//  CIMPTabBarViewController.m
//  CIMiniProgram
//
//  Created by 袁鑫 on 2020/4/10.
//

#import "CIMPTabBarViewController.h"
#import "CIMPTabBar.h"
#import "CIMPNavigationView.h"
#import "CIMPDeviceMacro.h"
#import "CIMPLog.h"
#import "NSObject+CIMPJson.h"
#import <CICategories/CICategories.h>

@interface CIMPTabBarViewController ()

@property (nonatomic, strong) CIMPTabBar *tabbar;

@end

#define TabBarViewTag 20

@implementation CIMPTabBarViewController

#pragma mark - Getter & Setter
#pragma mark -

- (void)setPageModel:(CIMPPageModel *)pageModel {
    self.currentController.pageModel = pageModel;
}

- (CIMPPageModel *)pageModel {
    return self.currentController.pageModel;
}

- (void)setViewControllers:(NSArray *)viewControllers {
    _viewControllers = viewControllers;
    for (UIViewController *vc in viewControllers) {
        [self addChildViewController:vc];
    }
}

#pragma mark - View Life Cycle
#pragma mark -

- (void)dealloc {
    MPLog(@"deinit TabBarViewController");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.whiteColor;
    
    [self createTab];
    
    [self viewDidLayoutSubviews];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGFloat w = self.view.bounds.size.width;
    CGFloat h = self.view.bounds.size.height;
    CGFloat naviHeight = CGRectGetMaxY(self.naviView.frame);
    
    CGRect tabbarFrame = CGRectZero;
    if (self.tabbar) {
        CGFloat tabbarHeight = IS_IPHONE_X ? 83 : 49;
        tabbarFrame = CGRectMake(0.0, h - tabbarHeight, w, tabbarHeight);
    }
    self.tabbar.frame = tabbarFrame;
    
    UIView *vc = [self.view viewWithTag:TabBarViewTag];
    CGFloat webViewTop = self.naviView.bounds.size.height;
    if (self.tabbar.isHidden) {
        vc.frame = CGRectMake(0.0, webViewTop, w, h - naviHeight - 1);
    } else {
        vc.frame = CGRectMake(0.0, webViewTop, w, h - naviHeight - tabbarFrame.size.height - 1);
    }
}

- (void)createTab {
    CIMPTabbarStyle *style = self.tabbarStyle;
    _tabbar = [[CIMPTabBar alloc] init];
    _tabbar.color = style.color;
    _tabbar.selectedColor = style.selectedColor;
    _tabbar.backgroundColor = style.backgroundColor;
    _tabbar.borderStyle = style.borderStyle;
    [_tabbar configTabbarItemList:style.list];
    [self.view addSubview:_tabbar];
    
    [_tabbar setStyle];
    
    __weak typeof(self) weakSelf = self;
    [_tabbar didTapItem:^(NSString * _Nonnull pagePath, NSUInteger pageIndex) {
        [weakSelf startPage:pagePath pageIndex:pageIndex];
    }];
    
    [_tabbar didInitDefaultItem:^(NSString * _Nonnull pagePath, NSUInteger pageIndex) {
        [weakSelf startRootPage:pagePath pageIndex:pageIndex];
    }];
    
//    [self.tabbar showDefaultTabarItem];
    [self.tabbar selectItemAtIndex:0];
}

#pragma mark - Load Data
#pragma mark -

- (void)loadTabStyle {
    [self createTab];
}

- (void)loadStyle:(CIMPPageModel *)pageModel {
    //window 样式
    self.naviView.leftButton.hidden = YES; //pageModel.pageStyle.disableNavigationBack;
    
    if (pageModel.pageStyle.navigationBarTitleText) {
        self.naviView.title = pageModel.pageStyle.navigationBarTitleText;
    }
    if (pageModel.pageStyle.navigationBarTitleText ) {
        self.naviView.title = pageModel.pageStyle.navigationBarTitleText;
    } else if (pageModel.windowStyle.navigationBarTitleText) {
        self.naviView.title = pageModel.windowStyle.navigationBarTitleText;
    }
    
    if (pageModel.pageStyle.navigationBarBackgroundColor) {
        self.naviView.backgroundColor = pageModel.pageStyle.navigationBarBackgroundColor;
    } else if (pageModel.windowStyle.navigationBarBackgroundColor) {
        self.naviView.backgroundColor = pageModel.windowStyle.navigationBarBackgroundColor;
    }
    
    
    NSString *backgroundTextStyle;
    if (pageModel.pageStyle.backgroundTextStyle) {
        backgroundTextStyle = pageModel.pageStyle.backgroundTextStyle;
    } else if (pageModel.windowStyle.backgroundTextStyle) {
        backgroundTextStyle = pageModel.windowStyle.backgroundTextStyle;
    }
    
    
    NSString *navigationBarTextStyle;
    if (pageModel.pageStyle.navigationBarTextStyle) {
        navigationBarTextStyle = pageModel.pageStyle.navigationBarTextStyle;
    } else if (pageModel.windowStyle.navigationBarTextStyle) {
        navigationBarTextStyle = pageModel.windowStyle.navigationBarTextStyle;
    }
    
    if (navigationBarTextStyle != nil ) {
        if  ([navigationBarTextStyle isEqualToString:@"black"])  {
            self.naviView.titleLabel.textColor = [UIColor blackColor];
            self.naviView.leftButton.tintColor = [UIColor blackColor];
            self.naviView.moreButton.tintColor = [UIColor blackColor];
            self.naviView.exitButton.tintColor = [UIColor blackColor];
        } else {
            self.naviView.titleLabel.textColor = UIColor.whiteColor;
            self.naviView.leftButton.tintColor = [UIColor whiteColor];
            self.naviView.moreButton.tintColor = [UIColor whiteColor];
            self.naviView.exitButton.tintColor = [UIColor blackColor];
        }
    }
}

#pragma mark - 页面管理
#pragma mark -

- (void)startRootPage:(NSString *)pagePath pageIndex:(NSUInteger)pageIndex {
    if(self.childViewControllers.count <= pageIndex) {
        return;
    }
    [[self.view viewWithTag:TabBarViewTag] removeFromSuperview];
    CIMPPageBaseViewController *vc = self.childViewControllers[pageIndex];
    vc.view.tag = TabBarViewTag;
    vc.pageModel.openType = @"appLaunch";
    [self loadStyle:vc.pageModel];
    [self.view addSubview:vc.view];
    
    _currentController = vc;
}

- (void)startPage:(NSString *)pagePath pageIndex:(NSUInteger)pageIndex {
    if (self.childViewControllers.count <= pageIndex) {
        return;
    }
    MPLog(@"<switchTap>----->startPage:%lu",(unsigned long)pageIndex);
    [_currentController viewWillDisappear:YES];
    [_currentController viewDidDisappear:YES];
    
    [[self.view viewWithTag:TabBarViewTag] removeFromSuperview];
    CIMPPageBaseViewController *vc = self.childViewControllers[pageIndex];
    vc.view.tag = TabBarViewTag;
    vc.pageModel.openType = @"switchTab";
    vc.pageModel.backType = @"switchTab";
    [self loadStyle:vc.pageModel];
    [self.view addSubview:vc.view];
    
    _currentController = vc;
}

- (void)switchTabBar:(NSString *)pagePath {
    for (int i = 0; i < self.childViewControllers.count; i++) {
        CIMPPageBaseViewController *vc = self.childViewControllers[i];
        if ([vc isKindOfClass:CIMPPageBaseViewController.class]) {
            if ([pagePath isEqualToString:vc.pageModel.pagePath] || [pagePath isEqualToString:[vc.pageModel.pagePath stringByAppendingString:@".html"]]) {
                [self.tabbar selectItemAtIndex:i];
            }
        }
    }
}

#pragma mark - Private
#pragma mark -

- (void)setTabBar:(NSDictionary *)param {
    NSString *color = param[@"color"];
    NSString *selectedColor = param[@"selectedColor"];
    NSString *backgroundColor = param[@"backgroundColor"];
    NSString *borderStyle = param[@"borderStyle"];

    if (color) {
        self.tabbarStyle.color = color;
    }
    if (selectedColor) {
        self.tabbarStyle.selectedColor = selectedColor;
    }
    if (backgroundColor) {
        self.tabbarStyle.backgroundColor = backgroundColor;
    }
    if (borderStyle) {
        self.tabbarStyle.borderStyle = borderStyle;
    }
    
    self.tabbar.backgroundColor = self.tabbarStyle.backgroundColor;
    self.tabbar.color = self.tabbarStyle.color;
    self.tabbar.selectedColor = self.tabbarStyle.selectedColor;
    self.tabbar.borderStyle = self.tabbarStyle.borderStyle;
    [self.tabbar setStyle];
    
    NSString *callbackId = param[@"callbackId"];
    NSString *javascriptString = [NSString stringWithFormat:@"eval(serviceBridge.invokeCallbackHandler('%@', {}))", callbackId];
    [self.currentController.webView evaluateJavaScript:javascriptString completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        MPLog(@"callback complete, id is %@", callbackId);
    }];
}

#pragma mark - Loading
#pragma mark -

- (void)showLoading:(NSDictionary *)param callback:(void (^)(NSDictionary * _Nonnull))callback {
    
}

- (void)hideLoading {
    
}

- (void)showToast:(NSDictionary *)param callback:(void (^)(NSDictionary * _Nonnull))callback {
    
}

- (void)hideToast {
    
}

- (void)showModal:(NSDictionary *)param callback:(void (^)(NSDictionary * _Nonnull))callback {
    
}

#pragma mark - TabBar
#pragma mark -

- (void)showTabBar:(NSDictionary *)param callback:(void (^)(NSDictionary * _Nonnull))callback {
    BOOL animation = param[@"animation"] ? [param[@"animation"] boolValue] : NO;
    if (self.tabbar.isHidden) {
        [self.tabbar setHidden:NO];
        UIView *vc = [self.view viewWithTag:TabBarViewTag];
        vc.frame = CGRectMake(vc.frame.origin.x, vc.frame.origin.y, vc.frame.size.width, vc.frame.size.height + self.tabbar.frame.size.height);
    }
    
    if (callback) {
        NSDictionary *result = @{@"errMsg": @"ok"};
        callback(result);
    }
}

- (void)hideTabBar:(NSDictionary *)param callback:(void (^)(NSDictionary * _Nonnull))callback {
    BOOL animation = param[@"animation"] ? [param[@"animation"] boolValue] : NO;
    if (!self.tabbar.isHidden) {
        [self.tabbar setHidden:YES];
        UIView *vc = [self.view viewWithTag:TabBarViewTag];
        vc.frame = CGRectMake(vc.frame.origin.x, vc.frame.origin.y, vc.frame.size.width, vc.frame.size.height - self.tabbar.frame.size.height);
    }
    
    if (callback) {
        NSDictionary *result = @{@"errMsg": @"ok"};
        callback(result);
    }
}

- (void)setTabBarStyle:(NSDictionary *)param callback:(void (^)(NSDictionary * _Nonnull))callback {
    NSString *color = param[@"color"];
    NSString *selectedColor = param[@"selectedColor"];
    NSString *backgroundColor = param[@"backgroundColor"];
    NSString *borderStyle = param[@"borderStyle"];

    if (color) {
        self.tabbarStyle.color = color;
    }
    if (selectedColor) {
        self.tabbarStyle.selectedColor = selectedColor;
    }
    if (backgroundColor) {
        self.tabbarStyle.backgroundColor = backgroundColor;
    }
    if (borderStyle) {
        self.tabbarStyle.borderStyle = borderStyle;
    }
    
    self.tabbar.backgroundColor = self.tabbarStyle.backgroundColor;
    self.tabbar.color = self.tabbarStyle.color;
    self.tabbar.selectedColor = self.tabbarStyle.selectedColor;
    self.tabbar.borderStyle = self.tabbarStyle.borderStyle;
    [self.tabbar setStyle];
    
    if (callback) {
        NSDictionary *result = @{@"errMsg": @"ok"};
        callback(result);
    }
}

#pragma mark - 下拉刷新
#pragma mark -

- (void)startPullDownRefresh {
    [self.currentController startPullDownRefresh];
}

- (void)stopPullDownRefresh {
    [self.currentController stopPullDownRefresh];
}

#pragma mark - NavigationBar
#pragma mark -

- (void)setNaviFrontColor:(NSString *)frontColor andBgColor:(NSString *)bgColor withAnimationParam:(NSDictionary *)param {
    [self.naviView setNaviFrontColor:frontColor andBgColor:bgColor withAnimationParam:param];
    
    if ([frontColor isEqualToString:@"#000000"]) {
        self.currentController.pageModel.pageStyle.navigationBarTextStyle = @"black";
    } else {
        self.currentController.pageModel.pageStyle.navigationBarTextStyle = @"white";
    }
    
    self.currentController.pageModel.pageStyle.navigationBarBackgroundColor = [UIColor ColorWithHexString:bgColor];
}

@end
