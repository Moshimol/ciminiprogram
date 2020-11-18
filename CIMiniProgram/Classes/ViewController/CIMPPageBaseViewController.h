//
//  CIMPPageBaseViewController.h
//  CIMiniProgram
//
//  Created by 袁鑫 on 2020/4/10.
//

#import "CIMPBaseViewController.h"
#import "CIMPBaseViewController.h"
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CIMPPageBaseViewController : CIMPBaseViewController

@property (nonatomic, strong) WKWebView *webView;

@property (nonatomic, strong) id <PageBridgeJSProtocol> bridge;

@property (nonatomic, assign) BOOL isTabBarVC;

@property (nonatomic, assign) BOOL isNeedLoading;

@property (nonatomic, assign) BOOL isRoot;

//

- (void)loadData;

- (void)loadStyle;

@end

NS_ASSUME_NONNULL_END
