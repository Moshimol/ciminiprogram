//
//  CIMPPageBridge.m
//  CIMiniProgram
//
//  Created by 袁鑫 on 2020/4/9.
//

#import "CIMPPageBridge.h"
#import "CIMPPageBaseViewController.h"
#import "CIMPBaseViewController+Extension.h"
#import "CIMPPageModel.h"
#import "CIMPLog.h"

@implementation CIMPPageBridge

// MARK: - 收到JS消息
- (void)onReceiveJSMessage:(NSString *)name body:(id)body controller:(CIMPPageBaseViewController *)controller {
    self.controller = controller;
    
    NSString *pageName = controller.pageModel.pagePath;
    MPLog(@"receive JS message---->desc: %@", @{@"page": pageName, @"param": body});
   
    if (self.manager) {
        [self.manager page_handler:body pageModel:self.controller.pageModel];
    }
}

- (void)onReceiveJSAlert:(NSString *)message {
    
}

- (void)callJS:(NSString *)js controller:(CIMPPageBaseViewController *)controller callback:(void (^)(id))callback {
    NSString *pageName = controller.pageModel.pagePath;
    MPLog(@"eval JS---->: desc: %@", @{@"page": pageName, @"info": js});
    
    [controller.webView evaluateJavaScript:js completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        if (callback) {
            callback(result);
        }
    }];
}

@end
