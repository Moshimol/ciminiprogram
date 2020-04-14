//
//  CIMPBaseViewController.h
//  CIMiniProgram
//
//  Created by 袁鑫 on 2020/4/9.
//

#import <UIKit/UIKit.h>
#import "CIMPNavigationView.h"
#import "CIMPPageModel.h"
#import "CIMPPageManagerProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface CIMPBaseViewController : UIViewController

@property (nonatomic, strong) CIMPNavigationView *naviView;

@property (nonatomic, strong) CIMPPageModel *pageModel;

@property (nonatomic, weak, nullable) id <CIMPPageManagerProtocol> pageManager;

/**
 内存清理
 */
- (void)cleanMemory;

/**
 展示一个Toast
 
 @param param 配置参数
 */
- (void)showToast:(NSDictionary *)param callback:(void(^)(NSDictionary *))callback;

/**
 隐藏Toast
 */
- (void)hideToast;

/**
 显示Alert
 */
- (void)showModal:(NSDictionary *)param callback:(void(^)(NSDictionary *))callback;

/**
 展示一个Loading

 @param param 配置参数
 */
- (void)showLoading:(NSDictionary *)param callback:(void(^)(NSDictionary *))callback;

/**
 停止Loading
 */
- (void)hideLoading;

/**
 停止下拉刷新
 */
- (void)stopPullDownRefresh;

/**
 开始下拉刷新
 */
- (void)startPullDownRefresh;

// MARK: - NavigationBar
- (void)showNavigationBarLoading:(void(^)(NSDictionary *))callback;

- (void)setNavigationBarTitle:(NSDictionary *)param callback:(void(^)(NSDictionary *))callback;

- (void)setNavigationBarColor:(NSDictionary *)param callback:(void(^)(NSDictionary *))callback;

- (void)hideNavigationBarLoading:(void(^)(NSDictionary *))callback;

- (void)hideHomeButton:(void(^)(NSDictionary *))callback;

// MARK: - TabBar
- (void)showTabBar:(NSDictionary *)param callback:(void(^)(NSDictionary *))callback;

- (void)hideTabBar:(NSDictionary *)param callback:(void(^)(NSDictionary *))callback;

- (void)setTabBarStyle:(NSDictionary *)param callback:(void(^)(NSDictionary *))callback;

// MARK: - 表单

- (void)setInputPosition:(NSDictionary *)param completion:(void(^ __nullable)(void))completion;

- (void)setInputValue:(NSDictionary *)param completion:(void(^ __nullable)(void))completion;

- (void)setInputFocus:(NSDictionary *)param completion:(void(^ __nullable)(void))completion;

- (void)updateInputPosition:(NSDictionary *)param completion:(void(^ __nullable)(void))completion;

- (void)setInputBlur:(NSDictionary *)param completion:(void(^ __nullable)(void))completion;

- (void)hideKeyboard;

// MARK: - JSBridge

- (void)bridgeCallback:(NSString *)callbackId params:(NSDictionary<NSString *,NSObject *> *)params;

@end

NS_ASSUME_NONNULL_END
