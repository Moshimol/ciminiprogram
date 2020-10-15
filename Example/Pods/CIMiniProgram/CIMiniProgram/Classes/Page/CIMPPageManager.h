//
//  CIMPPageManager.h
//  CIMiniProgram
//
//  Created by 袁鑫 on 2020/4/9.
//

#import <Foundation/Foundation.h>
#import "CIMPManagerProtocol.h"
#import "CIMPPageManagerProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@class CIMPBaseViewController;
@class CIMPPageBaseViewController;

@interface CIMPPageStack : NSObject

@property (nonatomic, assign) NSUInteger initialIndex;

@property (nonatomic, strong) UINavigationController *naviController;

/**
 获取小程序栈顶控制器
 
 @return 小程序栈顶控制器
 */
- (CIMPBaseViewController *)top;

/**
 获取小程序当前显示的页面

 @return 小程序当前显示的页面控制器
 */
- (CIMPBaseViewController *)currentPage;

@end

@interface CIMPPageManager : NSObject <CIMPPageManagerProtocol>

@property (nonatomic, strong) CIMPPageStack *pageStack;

@property (nonatomic, weak) id <CIMPManagerProtocol> mpManager;

@property (nonatomic, strong) UINavigationController *naviController;

@property (nonatomic, strong) NSDictionary *config;

/**
 开启页面

 @param basePath 页面根目录路径
 @param pagePath 页面路径
 @param isRoot 是否为根页面
 */
- (void)startPage:(NSString *)basePath pagePath:(NSString *)pagePath isRoot:(BOOL)isRoot completion:(void (^ __nullable)(void))completion;

/**
 开启页面

 @param basePath 页面根目录路径
 @param pagePath 页面路径
 @param openNewPage 是否开启新页 YES:Push新的ViewController NO:当前Web页面跳转
 */
- (void)startPage:(NSString *)basePath pagePath:(NSString *)pagePath openNewPage:(BOOL)openNewPage completion:(void (^ __nullable)(void))completion;

- (void)startPage:(NSString *)basePath pagePath:(NSString *)pagePath isRoot:(BOOL)isRoot openNewPage:(BOOL)openNewPage completion:(void (^ __nullable)(void))completion;

- (void)startPage:(NSString *)basePath pagePath:(NSString *)pagePath isRoot:(BOOL)isRoot openNewPage:(BOOL)openNewPage isTabPage:(BOOL)isTabPage completion:(void (^ __nullable)(void))completion;

/**
 加载页面配置

 @param webId 页面ID
 @param pageConfig 页面配置信息
 */
- (void)loadPageConfig:(unsigned long long)webId pageConfig:(NSDictionary *)pageConfig;

/**
 获取小程序页面栈长

 @return 小程序页面栈长
 */
- (NSUInteger)stackLength;

/**
 跳转到某一页
 */
- (void)gotoPageAtIndex:(NSUInteger)existPageId ;

/**
 切换Tab

 @param itemInfo tab的info信息
 */
- (void)switchTabbar:(NSDictionary *)itemInfo callback:(void(^)(NSDictionary *))callback;

/**
 设置当前页面Title
 */
- (void)setTopPageTitle:(NSString *)title;

/**
 ViewWillAppear时 激活页面
 */
- (void)activePageWillAppear:(CIMPPageBaseViewController *)vc;
- (void)activePageDidDisappear:(CIMPPageBaseViewController *)vc;
- (void)activePageDidAppear:(CIMPPageBaseViewController *)vc;

/**
 设置NavigationController
 */
- (void)setupWithNaviController:(UINavigationController *)naviController;

/**
 重置NavigationBar隐藏属性
 */
- (void)resetNavigationBarHidden;

@end

NS_ASSUME_NONNULL_END
