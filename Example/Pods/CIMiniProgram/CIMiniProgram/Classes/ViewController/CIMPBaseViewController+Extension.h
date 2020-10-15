//
//  CIMPBaseViewController+Extension.h
//  CIMiniProgram
//
//  Created by 袁鑫 on 2020/4/10.
//

#import "CIMPBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

// 该类目的为跟踪页面的行为 输出日志
@interface CIMPBaseViewController (Extension)

// 跟踪页面打开
- (void)track_open_page;

// 跟踪页面是否打开成功
- (void)track_open_page_success;

/**
 跟踪页面打开失败
 
 @param error 错误信息
 */
- (void)track_open_page_failure:(NSString *)error;

/**
 跟踪页面关闭
 
 @param pages 关闭的页面
 */
- (void)track_close_page:(NSString *)pages;


// 跟踪页面是否就绪
- (void)track_page_ready;

// 跟踪页面渲染
- (void)track_renderContainer;

// 跟踪页面渲染成功
- (void)track_renderContainer_success;

/**
 跟踪页面渲染失败
 
 @param error 失败信息
 */
- (void)track_renderContainer_failure:(NSString *)error;

@end

NS_ASSUME_NONNULL_END
