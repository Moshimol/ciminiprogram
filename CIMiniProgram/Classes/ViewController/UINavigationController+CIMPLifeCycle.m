//
//  UINavigationController+CIMPLifeCycle.m
//  CIMiniProgram
//
//  Created by 袁鑫 on 2020/4/10.
//

#import "UINavigationController+CIMPLifeCycle.h"
#import "CIMPBaseViewController.h"
#import "CIMPAppManager.h"
#import "CIMPApp.h"
#import <objc/runtime.h>

@implementation UINavigationController (CIMPLifeCycle)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        swizzleMethod([self class], @selector(popViewControllerAnimated:), @selector(mp_popViewControllerAnimated:));
        swizzleMethod([self class], @selector(popToViewController:animated:), @selector(mp_popToViewController:animated:));
        swizzleMethod([self class], @selector(popToRootViewControllerAnimated:), @selector(mp_popToRootViewControllerAnimated:));
        swizzleMethod([self class], @selector(pushViewController:animated:), @selector(mp_pushViewController:animated:));
    });
}

// MARK: - 监控被推出的页面
- (void)mp_handlePopPages:(NSArray *)popedControllers {
    // 被推出的页面是否全部为非小程序页面
    BOOL isAllNormalPage = YES;
    
    // 是否包含小程序根页面
    BOOL isContainAppRootPage = NO;
    
    // 如果小程序根页面被推出了，则说明小程序退出了
    for (UIViewController *vc in popedControllers) {
        if ([vc isKindOfClass:CIMPBaseViewController.class]) {
            isAllNormalPage = NO;
            CIMPApp *app = [CIMPAppManager sharedManager].currentApp;
            if ([app isAppRootPage:(CIMPBaseViewController *)vc]) {
                [app stopApp];
                isContainAppRootPage = YES;
            }
        }
    }
    
    // 如果返回到小程序，则小程序进入前台
    UIViewController *topVC = self.topViewController;
    if ([topVC isKindOfClass:CIMPBaseViewController.class] && (isAllNormalPage || isContainAppRootPage)) {
        CIMPApp *app = [CIMPAppManager sharedManager].currentApp;
        [app onAppEnterForeground];
    }
}

// MARK: - 监控被push的页面
- (void)mp_handlePushPage:(UIViewController *)viewController {
    UIViewController *topVC = [self topViewController];
    // 判断当前是否在小程序页面
    if ([topVC isKindOfClass:CIMPBaseViewController.class]) {
        // 如果将要展示的页面不是小程序页面 则认为小程序进入后台
        if (viewController && ![viewController isKindOfClass:CIMPBaseViewController.class]) {
            CIMPApp *app = [CIMPAppManager sharedManager].currentApp;
            [app onAppEnterBackground];
        }
    }
}

#pragma mark - Pop
#pragma mark -

- (NSArray *)mp_popToRootViewControllerAnimated:(BOOL)animated {
    NSArray *array = [self mp_popToRootViewControllerAnimated:animated];
    [self mp_handlePopPages:array];
    return array;
}

- (UIViewController *)mp_popViewControllerAnimated:(BOOL)animated {
    UIViewController *vc = [self mp_popViewControllerAnimated:animated];
    if (vc) {
        [self mp_handlePopPages:@[vc]];
    }
    return vc;
}

- (NSArray *)mp_popToViewController:(UIViewController *)controller animated:(BOOL)animated {
    NSArray *array = [self mp_popToViewController:controller animated:animated];
    [self mp_handlePopPages:array];
    return array;
}

#pragma mark - Push
#pragma mark -

- (void)mp_pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [self mp_handlePushPage:viewController];
    [self mp_pushViewController:viewController animated:animated];
}

#pragma mark - Helper
#pragma mark -

void swizzleMethod(Class class, SEL originalSelector, SEL swizzledSelector) {
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

@end
