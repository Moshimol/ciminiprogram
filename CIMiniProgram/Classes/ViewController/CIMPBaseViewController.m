//
//  CIMPBaseViewController.m
//  CIMiniProgram
//
//  Created by 袁鑫 on 2020/4/9.
//

#import "CIMPBaseViewController.h"
#import "CIMPDeviceMacro.h"
#import "CIMPUtils.h"

@interface CIMPBaseViewController () <UIGestureRecognizerDelegate>

@end

@implementation CIMPBaseViewController

#pragma mark - Life Cycle
#pragma mark -

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    //导航栏
    __weak typeof(self) weakSelf = self;
    CGFloat naviHeight = IS_IPHONE_X ? 88 : 64;
    self.naviView = [[CIMPNavigationView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.bounds.size.width, naviHeight)];
    
    [self.naviView setLeftClick:^(CIMPNavigationView * _Nonnull navigationView) {
        if (weakSelf.pageManager) {
            [weakSelf.pageManager pop];
        }
    }];
    
    [self.naviView setExitClick:^(CIMPNavigationView * _Nonnull navigationView) {
        if (weakSelf.pageManager) {
            [weakSelf.pageManager exit];
        }
    }];
    
    [self.naviView setMoreClick:^(CIMPNavigationView * _Nonnull navigationView) {
        if (weakSelf.pageManager) {
            [weakSelf.pageManager more];
        }
    }];
    
    [self.view addSubview:self.naviView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (!self.navigationController.isNavigationBarHidden) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

#pragma mark - Loading
#pragma mark -

// MARK: - 子类实现

- (void)showToast:(NSDictionary *)param callback:(void (^)(NSDictionary * _Nonnull))callback {
    // 子类实现
}

- (void)hideToast {
    // 子类实现
}

- (void)showModal:(NSDictionary *)param callback:(void (^)(NSDictionary * _Nonnull))callback {
    // 子类实现
}

- (void)showLoading:(NSDictionary *)param callback:(void (^)(NSDictionary * _Nonnull))callback {
    // 子类实现
}


- (void)hideLoading {
    // 子类实现
}

- (void)setInputPosition:(NSDictionary *)param completion:(void (^)(void))completion {
    // 子类实现
}

- (void)setInputFocus:(NSDictionary *)param completion:(void (^)(void))completion {
    // 子类实现
}

- (void)setInputValue:(NSDictionary *)param completion:(void (^)(void))completion {
    // 子类实现
}

- (void)setInputBlur:(NSDictionary *)param completion:(void (^)(void))completion {
    // 子类实现
}

- (void)updateInputPosition:(NSDictionary *)param completion:(void (^)(void))completion {
    // 子类实现
}

- (void)bridgeCallback:(NSString *)callbackId params:(NSDictionary<NSString *,NSObject *> *)params {
    // 子类实现
}

- (void)hideKeyboard {
    // 子类实现
}

#pragma mark - NavigationBar
#pragma mark -

- (void)showNavigationBarLoading:(void (^)(NSDictionary * _Nonnull))callback {
    [self.naviView startLoadingAnimation];
    if (callback) {
        NSDictionary *result = @{@"errMsg": @"ok"};
        callback(result);
    }
}

- (void)setNavigationBarTitle:(NSDictionary *)param callback:(void (^)(NSDictionary * _Nonnull))callback {
    NSString *title = param[@"title"];
    if (!title) {
        if (callback) {
            NSDictionary *error = @{@"errMsg": @"fail", @"message": @"title为空"};
            callback(error);
        }
        return;
    }
    [self.naviView setNavigationTitle:title];
}

- (void)setNavigationBarColor:(NSDictionary *)param callback:(void (^)(NSDictionary * _Nonnull))callback {
    NSString *frontColor = param[@"frontColor"];
    if (!frontColor) {
        if (callback) {
            callback(@{@"errMsg": @"fail", @"message": @"参数frontColor 为空"});
        }
        return;
    }
    
    if (![[frontColor lowercaseString] isEqualToString:@"#ffffff"] && ![frontColor isEqualToString:@"#000000"]){
        if(callback) {
            callback(@{@"errMsg": @"fail", @"message": @"参数frontColor 仅支持#ffffff和#000000"});
        }
        return;
    }
    
    NSString *bgColor = param[@"backgroundColor"];
    if (!bgColor) {
        if (callback) {
            callback(@{@"errMsg": @"参数backgroundColor 为空"});
        }
        return;
    }
    
    NSMutableDictionary *animationParam = [NSMutableDictionary dictionary];
    animationParam[@"duration"] = @0;
    animationParam[@"timingFunc"] = @"linear";

    NSDictionary *animation = param[@"animation"];
    if (animation && [animation isKindOfClass:NSDictionary.class]) {
        if (param[@"durarion"]) {
            animationParam[@"durarion"] = animation[@"durarion"];
        }

        if (param[@"timingFunc"]) {
            animationParam[@"timingFunc"] = animation[@"timingFunc"];
        }
    }
    [self.naviView setNaviFrontColor:frontColor andBgColor:bgColor withAnimationParam:animationParam];
    
    if (callback) {
        NSDictionary *result = @{@"errMsg": @"ok"};
        callback(result);
    }
}

- (void)hideNavigationBarLoading:(void (^)(NSDictionary * _Nonnull))callback {
    [self.naviView hideLoadingAnimation];
    if (callback) {
        NSDictionary *result = @{@"errMsg": @"ok"};
        callback(result);
    }
}

- (void)hideHomeButton:(void (^)(NSDictionary * _Nonnull))callback {
    // 暂不实现，目前没有Home按钮
}

#pragma mark - TabBar
#pragma mark -

- (void)showTabBar:(NSDictionary *)param callback:(void (^)(NSDictionary * _Nonnull))callback {
    // 子类实现
}

- (void)hideTabBar:(NSDictionary *)param callback:(void (^)(NSDictionary * _Nonnull))callback {
    // 子类实现
}

- (void)setTabBarStyle:(NSDictionary *)param callback:(void (^)(NSDictionary * _Nonnull))callback {
    // 子类实现
}

#pragma mark - 下拉刷新
#pragma mark -

- (void)stopPullDownRefresh {
    // 子类实现
}

- (void)startPullDownRefresh {
    // 子类实现
}

#pragma mark - 内存清理

- (void)cleanMemory {
    
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    if (@available(iOS 13.0, *)) {
        return UIStatusBarStyleDarkContent;
    } else {
        // Fallback on earlier versions
        return UIStatusBarStyleDefault;
    }
}

@end
