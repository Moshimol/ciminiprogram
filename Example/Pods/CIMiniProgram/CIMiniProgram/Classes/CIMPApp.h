//
//  CIMPApp.h
//  CIMiniProgram
//
//  Created by 袁鑫 on 2020/4/9.
//

#import <Foundation/Foundation.h>
#import "CIMPAppInfo.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^MoreActionBlock)(NSInteger);

@class UINavigationController;
@class UIViewController;

@interface CIMPApp : NSObject

/**
 小程序配置信息
 */
@property (nonatomic, strong) CIMPAppInfo *appInfo;

/**
 初始化
 
 @param appInfo 小程序信息
 @return 小程序实例
 */
- (instancetype)initWithAppInfo:(CIMPAppInfo *)appInfo;

/**
 配置more按钮
 @param titles ActionSheet按钮文本
 @param action ActionSheet按钮点击事件
 */
- (void)setMoreButton:(NSArray<NSString *> *)titles action:(MoreActionBlock)action;

/**
 获取more按钮弹出ActionSheet的按钮文本
 */
- (NSArray<NSString *> *)getMoreActionSheetTitles;

/**
 获取more按钮弹出ActionSheet的点击事件
 */
- (MoreActionBlock)getMoreActionSheetEvent;

/**
 下载小程序
 
 @param url 小程序包下载地址
 */
- (void)donwloadApp:(NSString *)url completion:(void (^)(BOOL success, NSString *errMsg))completion;

/**
 删除小程序
 */
- (void)deleteApp:(void (^)(BOOL success, NSString *errMsg))completion;

/**
 开启小程序
 */
- (void)startAppWithEntrance:(UINavigationController *)entrance;

/**
 获取Root
 */
- (UIViewController *)getRootPage;

/**
 开启小程序
 */
- (void)startAppWithEntrance:(UINavigationController *)entrance completion:(void(^)(BOOL success, NSString *msg))completion;

/**
 停止小程序
 */
- (void)stopApp;

/**
 小程序进入前台
 如果从非小程序页面进入小程序页面 则认为小程序进入前台 初始化进入除外
 */
- (void)onAppEnterForeground;

/**
 小程序进入后台
 如果将要展示的页面不是小程序页面 则认为小程序进入后台
 */
- (void)onAppEnterBackground;

/**
 判断是否为小程序根页面

 @return YES:是 NO:否
 */
- (BOOL)isAppRootPage:(UIViewController *)page;

@end

NS_ASSUME_NONNULL_END
