//
//  CIMPPageManagerProtocol.h
//  CIMiniProgram
//
//  Created by 袁鑫 on 2020/4/9.
//

#ifndef CIMPPageManagerProtocol_h
#define CIMPPageManagerProtocol_h

@class CIMPPageBaseViewController;

@protocol CIMPPageManagerProtocol <NSObject>

//退出栈顶一个页面
- (void)pop;
//退出小程序
- (void)exit;
//点击more按钮
- (void)more;
//页面栈长
- (int)stackLength;
//关闭所有页面，打开到应用内的某个页面
- (void)reLaunch:(NSString *)basePath pagePath:(NSString *)pagePath;

//调js
//- (void)callSubscribeHandlerWithEventName:(NSString *)eventName jsonParam:(NSString *)jsonParam webIds:(NSArray *)webIds;
- (void)callSubscribeHandler:(NSString *)eventName jsonParam:(NSString *)jsonParam webIds:(NSArray *)webIds;

- (void)callPageConfig:(unsigned long long)webId;

- (BOOL)isRootPage:(UIViewController *)page;

//Active View State
- (void)activePageDidDisappear:(CIMPPageBaseViewController *)vc;
- (void)activePageDidAppear:(CIMPPageBaseViewController *)vc;
- (void)activePageWillAppear:(CIMPPageBaseViewController *)vc;

@end

@protocol PageBridgeJSProtocol <NSObject>

//收到js消息
- (void)onReceiveJSMessage:(NSString *)name body:(id)body controller:(CIMPPageBaseViewController *)controller;
    
- (void)onReceiveJSAlert:(NSString *)message;
    
    //调js
- (void)callJS:(NSString *)js controller:(CIMPPageBaseViewController *)controller callback:(void (^)(id result))callback;

@end

#endif /* CIMPPageManagerProtocol_h */
