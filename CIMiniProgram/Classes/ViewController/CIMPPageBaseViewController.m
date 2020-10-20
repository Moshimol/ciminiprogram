//
//  CIMPPageBaseViewController.m
//  CIMiniProgram
//
//  Created by 袁鑫 on 2020/4/10.
//

#import "CIMPPageBaseViewController.h"
#import "CIMPFileMacro.h"
#import "CIMPBaseViewController+Extension.h"
#import "CIMPTabBar.h"
#import "CIMPToastView.h"
#import "CIMPLoadingView.h"
#import "CIMPNavigationView.h"
#import "CIMPDeviceMacro.h"
#import "NSObject+CIMPJson.h"
#import "UITextField+LimitLength.h"
#import "CIScriptMessageHandlerDelegate.h"
#import "CIMPAppManager.h"
#import "CIMPApp.h"
#import "CIMPLog.h"
#import <MJRefresh/MJRefresh.h>
#import <WebKit/WebKit.h>
#import <CICategories/CICategories.h>


@interface CIMPPageBaseViewController () <WKScriptMessageHandler, UIWebViewDelegate, WKUIDelegate, WKNavigationDelegate, UIGestureRecognizerDelegate, UITextFieldDelegate>

@property (nonatomic, assign) BOOL isBack;
@property (nonatomic, assign) BOOL isFirstViewAppear;
// 是否已经加载过onReady
@property (nonatomic, assign) BOOL isSuccessOnReady;
// 是不是第一次加载
@property (nonatomic, assign) BOOL isNotNeedOnShow;

@property (nonatomic, strong) NSMutableArray<CIMPToastView *> *toastViews;
@property (nonatomic, assign) CGPoint keyBoardPoint;
@property (nonatomic, strong) UITextField *inputField;
@property (nonatomic, copy) NSDictionary *inputParam;
@property (nonatomic, assign) CGPoint keyBoardShowContentOffset;

@end

@implementation CIMPPageBaseViewController

#pragma mark - View Life Cycle
#pragma mark -

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isBack = NO;
    self.isFirstViewAppear = YES;
    self.toastViews = @[].mutableCopy;
    
    [self setupViews];
    [self loadData];
    [self viewWillLayoutSubviews];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardShow) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardHidden) name:UIKeyboardWillHideNotification object:nil];
    
    MPLog(@"<page>: %@ did load", [self.pageModel wholePageUrl]);
}

- (void)dealloc {
    MPLog(@"<page>: %@ dealloc", [self.pageModel wholePageUrl]);
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.pageManager activePageWillAppear:self];
    
    [self loadStyle];
    
    if (!self.pageModel.backType) {
        self.pageModel.backType = @"navigateBack";
    }
}
    
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (!_isFirstViewAppear) {
        [self.pageManager activePageDidAppear:self];
    } else {
        _isFirstViewAppear = NO;
    }
    
    self.isBack = YES;
    
    [CIMPLoadingView startAnimationInView:self.view];
    
    if (self.isSuccessOnReady && !self.isNotNeedOnShow) {
        MPLog(@"<page>: %@ onShow", [self.pageModel wholePageUrl]);
        NSString *javascriptString = [NSString stringWithFormat:@"eval(Bridge.LifeCycle.onShow('%@'))", self.pageModel.query];
        [self.webView evaluateJavaScript:javascriptString completionHandler:^(id _Nullable result, NSError * _Nullable error) {
            
        }];
    }
    
    self.isNotNeedOnShow = NO;
   
    MPLog(@"<page>: %@ didAppear", [self.pageModel wholePageUrl]);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (self.inputField.isFirstResponder) {
        [self.inputField resignFirstResponder];
    }
    
    MPLog(@"<page>: %@ onHide", [self.pageModel wholePageUrl]);
    NSString *javascriptString = [NSString stringWithFormat:@"eval(Bridge.LifeCycle.onHide('%@'))", self.pageModel.query];
    [self.webView evaluateJavaScript:javascriptString completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        
    }];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.pageManager activePageDidDisappear:self];
    
    // 防止收不到stopRefresh事件而造成下拉刷新不停止的情况
    if (self.webView.scrollView.mj_header.isRefreshing) {
        [self.webView.scrollView.mj_header endRefreshing];
    }
    
    [CIMPLoadingView stopAnimationInView:self.view];
    MPLog(@"<page>: %@ didDisappear", [self.pageModel wholePageUrl]);
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGFloat w = self.view.bounds.size.width;
    CGFloat h = self.view.bounds.size.height;
    CGFloat webViewTop = 0.0;
    CGFloat naviHeight = 0.0;
    if (!_isTabBarVC) {
        naviHeight = [UIApplication sharedApplication].statusBarFrame.size.height + 44;
        self.naviView.frame = CGRectMake(0.0, 0.0, w, naviHeight);
        webViewTop = self.naviView.frame.origin.y + self.naviView.frame.size.height;
    }
    self.webView.frame = CGRectMake(0.0, webViewTop, w, h - naviHeight);
}

- (void)refresh {
    [self.webView reload];
}

#pragma mark - UI
#pragma mark -

- (void)setupViews {
    self.naviView.hidden = self.isTabBarVC;

    WeakScriptMessageHandlerDelegate *scriptMessageDelegate = [WeakScriptMessageHandlerDelegate new];
    scriptMessageDelegate.scriptDelegate = self;
    
    WKUserContentController *userContentController = [WKUserContentController new];
    [userContentController addScriptMessageHandler:scriptMessageDelegate name:@"native"];
    
    WKWebViewConfiguration *wkWebViewConfiguration = [WKWebViewConfiguration new];
    wkWebViewConfiguration.allowsInlineMediaPlayback = YES;
    wkWebViewConfiguration.userContentController = userContentController;
    
    self.webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:wkWebViewConfiguration];
    self.webView.backgroundColor = UIColor.whiteColor;
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
    self.webView.scrollView.bounces = false;
    
    [self.view addSubview:self.webView];
    
    Class WKContentViewClass = NSClassFromString(@"WKContentView");
    id contentView = nil;
    for (UIView *subView in self.webView.scrollView.subviews) {
        if ([subView isKindOfClass:WKContentViewClass]) {
            contentView = subView;
        }
    }
    
    self.inputField = [[UITextField alloc] init];
    self.inputField.delegate = self;
    self.inputField.inputAccessoryView = nil;
    self.inputField.backgroundColor = UIColor.clearColor;
    [contentView addSubview:self.inputField];
    
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
}

#pragma mark - Load Data
#pragma mark -

- (void)loadData {
    if (!self.pageModel.pagePath || [self.pageModel.pagePath isEqualToString:@"tabBar"]) {
        return;
    }
    
    [self track_open_page];
    
    NSString *url = [self.pageModel wholePageUrl];
    NSArray *urlQueryArray = [url componentsSeparatedByString:@"?"];
    
    NSString *filePath = [NSString stringWithFormat:@"file://%@", urlQueryArray.firstObject];
    NSString *rootPath = [NSString stringWithFormat:@"file://%@", kMiniProgramPath];
    NSError *error = nil;
    NSString *html = [[NSString alloc] initWithContentsOfURL:[NSURL URLWithString: filePath] encoding:NSUTF8StringEncoding error:&error];
    if (html) {
        [_webView loadFileURL:[NSURL URLWithString: filePath] allowingReadAccessToURL:[NSURL URLWithString:rootPath]];
    } else {
        MPLog(@"<page>: %@ laod failure, error: %@", [self.pageModel wholePageUrl], error.localizedDescription);
        [self track_open_page_failure:error.localizedDescription];
    }
}

- (void)loadStyle{
    if (!self.pageModel) {
        return;
    }
    
    //非tabbar中作为childVC存在
    if (!self.isTabBarVC) {
        // 是否隐藏Back按钮
        self.naviView.leftButton.hidden = self.pageModel.pageStyle.disableNavigationBack;
        
        //window 样式
        if (self.pageModel.pageStyle.navigationBarTitleText) {
            self.naviView.title = self.pageModel.pageStyle.navigationBarTitleText;
        } else if (self.pageModel.windowStyle.navigationBarTitleText) {
            self.naviView.title = self.pageModel.windowStyle.navigationBarTitleText;
        }
        
        if (self.pageModel.pageStyle.navigationBarBackgroundColor) {
            self.naviView.backgroundColor = self.pageModel.pageStyle.navigationBarBackgroundColor;
        } else if (self.pageModel.windowStyle.navigationBarBackgroundColor) {
            self.naviView.backgroundColor = self.pageModel.windowStyle.navigationBarBackgroundColor;
        }
        
        NSString *backgroundTextStyle;
        if (self.pageModel.pageStyle.backgroundTextStyle) {
            backgroundTextStyle = self.pageModel.pageStyle.backgroundTextStyle;
        } else if (self.pageModel.windowStyle.backgroundTextStyle) {
            backgroundTextStyle = self.pageModel.windowStyle.backgroundTextStyle;
        }
        
        
        NSString *navigationBarTextStyle;
        if (self.pageModel.pageStyle.navigationBarTextStyle) {
            navigationBarTextStyle = self.pageModel.pageStyle.navigationBarTextStyle;
        } else if (self.pageModel.windowStyle.navigationBarTextStyle) {
            navigationBarTextStyle = self.pageModel.windowStyle.navigationBarTextStyle;
        }
        
        if (navigationBarTextStyle != nil ) {
            if  ([navigationBarTextStyle isEqualToString:@"black"])  {
                self.naviView.titleLabel.textColor =
                self.naviView.leftButton.tintColor =
                self.naviView.moreButton.tintColor =
                self.naviView.exitButton.tintColor = [UIColor blackColor];
            } else {
                self.naviView.titleLabel.textColor =
                self.naviView.leftButton.tintColor =
                self.naviView.moreButton.tintColor =
                self.naviView.exitButton.tintColor = [UIColor whiteColor];
            }
        }
    }
    
    if (self.isRoot) {
        self.naviView.leftButton.hidden = YES;
    }
    
    if (self.pageModel.pageStyle.backgroundColor) {
        self.webView.scrollView.backgroundColor = self.pageModel.pageStyle.backgroundColor;
    } else if (self.pageModel.windowStyle.backgroundColor) {
        self.webView.scrollView.backgroundColor = self.pageModel.windowStyle.backgroundColor;
    }
    
    if (self.pageModel.pageStyle.enablePullDownRefresh) {
        self.webView.scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(onRefreshHeaderPullDown)];
    } else {
        self.webView.scrollView.mj_header = nil;
    }
}

#pragma mark - Keyboard
#pragma mark -

- (void)keyBoardShow {
    self.keyBoardShowContentOffset = self.webView.scrollView.contentOffset;
}

- (void)keyBoardHidden {
    self.webView.scrollView.contentOffset = self.keyBoardPoint;
}

#pragma mark - Loading
#pragma mark -

- (void)showLoading:(NSDictionary *)param callback:(void (^)(NSDictionary * _Nonnull))callback {
    
    
    NSString *titleString = param[@"title"];
    if (!titleString) {
        if (callback) {
            NSDictionary *error = @{@"errMsg": @"fail", @"message": @"title不能为空"};
            callback(error);
            return;
        }
    }
    BOOL mask = param[@"mask"] ? [param[@"mask"] boolValue] : NO;
    [CIMPLoadingView showInView:self.view text:titleString mask:mask];
}

- (void)hideLoading {
    [CIMPLoadingView hideInView:self.view];
}

- (void)showToast:(NSDictionary *)param callback:(void (^)(NSDictionary * _Nonnull))callback {
    NSString *title = param[@"title"];
    NSString *icon = param[@"icon"];
    NSString *imagePath = param[@"image"];
    
    // 默认的时间是1500 毫秒
    int duration = param[@"duration"] ? [param[@"duration"] intValue] : 1500;
    
    BOOL mask = [param[@"mask"] boolValue];
    
    CIMPToastView *toast = [CIMPToastView showInView:self.view text:title icon:icon image:imagePath mask:mask duration:duration];
    [self.toastViews addObject:toast];
    
    if (callback) {
        NSDictionary *success = @{@"errMsg": @"ok"};
        callback(success);
    }
}

- (void)hideToast {
    for (CIMPToastView *toast in self.toastViews) {
        [CIMPToastView hideToast:toast inView:self.view];
    }
}

- (void)showModal:(NSDictionary *)param callback:(void (^)(NSDictionary * _Nonnull))callback {
    NSString *title = param[@"title"];
    NSString *content = param[@"content"];
    BOOL showCancel = param[@"showCancel"] ? [param[@"showCancel"] boolValue] : YES;
    NSString *cancelText = param[@"cancelText"] ? param[@"cancelText"] : @"取消";
    NSString *cancelColor = param[@"cancelColor"] ? param[@"cancelColor"] : @"#000000";
    NSString *confirmText = param[@"confirmText"] ? param[@"confirmText"] : @"确定";
    NSString *confirmColor = param[@"confirmColor"] ? param[@"confirmColor"] : @"#576B95";
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:content preferredStyle:UIAlertControllerStyleAlert];
    
    if (showCancel) {
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelText style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIColor *kCancelColor = [UIColor ColorWithHexString:cancelColor];
        [cancelAction setValue:kCancelColor forKey:@"titleTextColor"];
        [alertController addAction:cancelAction];
    }
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:confirmText style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIColor *kConfirmColor = [UIColor ColorWithHexString:confirmColor];
    [confirmAction setValue:kConfirmColor forKey:@"titleTextColor"];
    [alertController addAction:confirmAction];
    [self presentViewController:alertController animated:YES completion:^{
        if (callback) {
            NSDictionary *success = @{@"errMsg": @"ok"};
            callback(success);
        }
    }];
}

#pragma mark - UIGestureRecognizer Delegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    // 如果为根页面 禁止手势返回 防止手势过程中调用了系统pop方法 导致小程序推出
    if (_isTabBarVC) {
        return ![self.pageManager isRootPage:self.parentViewController];
    }
    return ![self.pageManager isRootPage:self];
}

#pragma mark - 下拉刷新
#pragma mark -

- (void)onRefreshHeaderPullDown {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"onPullDownRefresh" object:@(self.pageModel.pageId)];
}

- (void)stopPullDownRefresh {
    [self.webView.scrollView.mj_header endRefreshing];
}

- (void)startPullDownRefresh {
    [self.webView.scrollView.mj_header beginRefreshing];
}

#pragma mark - Navigation Bar
#pragma mark -

- (void)setNaviFrontColor:(NSString *)frontColor andBgColor:(NSString *)bgColor withAnimationParam:(NSDictionary *)param {
    [self.naviView setNaviFrontColor:frontColor andBgColor:bgColor withAnimationParam:param];
    
    if ([frontColor isEqualToString:@"#000000"]) {
        self.pageModel.pageStyle.navigationBarTextStyle = @"black";
    } else {
        self.pageModel.pageStyle.navigationBarTextStyle = @"white";
    }
    
    self.pageModel.pageStyle.navigationBarBackgroundColor = [UIColor ColorWithHexString:bgColor];
}

#pragma mark - 自定义
#pragma mark -

- (void)setInputPosition:(NSDictionary *)param completion:(void (^)(void))completion {
    NSLog(@"setInputPosition");
    self.inputParam = param;
    [self loadInputStyle];
    if (completion) {
        completion();
    }
}

- (void)updateInputPosition:(NSDictionary *)param completion:(void (^)(void))completion {
    self.inputParam = param;
    [self loadInputStyle];
    if (completion) {
        completion();
    }
}

- (void)setInputValue:(NSDictionary *)param completion:(void (^)(void))completion {
    self.inputField.text = param[@"value"];
    if (completion) {
        completion();
    }
}

- (void)setInputFocus:(NSDictionary *)param completion:(void (^)(void))completion {
    if (!self.inputField.isFirstResponder) {
        [self.inputField becomeFirstResponder];
        self.inputField.hidden = NO;
    }
    if (completion) {
        completion();
    }
}

- (void)setInputBlur:(NSDictionary *)param completion:(void (^)(void))completion {
    if (self.inputField.isFirstResponder) {
        [self.inputField resignFirstResponder];
        self.inputField.hidden = YES;
    }
    if (completion) {
        completion();
    }
}

- (void)loadInputStyle {
    // MARK: - Set Input Position
    NSNumber *height = self.inputParam[@"height"];
    NSNumber *width = self.inputParam[@"width"];
    NSNumber *x = self.inputParam[@"x"];
    NSNumber *y = self.inputParam[@"y"];
    NSNumber *offset = self.inputParam[@"offset"];
    self.inputField.frame = CGRectMake([x floatValue], [y floatValue] + [offset floatValue], [width floatValue], [height floatValue]);
    
    // MARK: - Set Placeholder
    NSString *placeholder = self.inputParam[@"placeholder"];
    if (placeholder) {
        self.inputField.placeholder = placeholder;
    }
    
    // MARK: - Set Input Value
    NSString *value = self.inputParam[@"value"] ? self.inputParam[@"value"] : @"";
    self.inputField.text = value;
    
    // MARK: - Set Input Type
    NSString *type = self.inputParam[@"type"] ? self.inputParam[@"type"] : @"text";
    if ([type isEqualToString:@"text"]) {
        self.inputField.keyboardType = UIKeyboardTypeDefault;
    } else if ([type isEqualToString:@"number"]) {
        self.inputField.keyboardType = UIKeyboardTypeNumberPad;
    } else if ([type isEqualToString:@"digit"]) {
        self.inputField.keyboardType = UIKeyboardTypeDecimalPad;
    }
    
    // MARK: - Set Input SecureTextEntry
    BOOL password = [self.inputParam[@"password"] boolValue];
    self.inputField.secureTextEntry = password;
    
    // MARK: - Set Input MaxLength
    NSNumber *maxlength = self.inputParam[@"maxlength"];
    [self.inputField limitTextLength:[maxlength intValue] block:^(NSString *text) {
        NSLog(@"maxlength block");
    }];
    
    // MARK: - Set Input Confirm Type
    NSString *confirmType = self.inputParam[@"confirm-type"] ? self.inputParam[@"confirm-type"] : @"done";
    if ([confirmType isEqualToString:@"send"]) {
        self.inputField.returnKeyType = UIReturnKeySend;
    } else if ([confirmType isEqualToString:@"search"]) {
        self.inputField.returnKeyType = UIReturnKeySend;
    } else if ([confirmType isEqualToString:@"next"]) {
        self.inputField.returnKeyType = UIReturnKeyNext;
    } else if ([confirmType isEqualToString:@"go"]) {
        self.inputField.returnKeyType = UIReturnKeyGo;
    } else if ([confirmType isEqualToString:@"done"]) {
        self.inputField.returnKeyType = UIReturnKeyDone;
    }
    
    // MARK: - Set Input Font Size
    NSNumber *fontSize = self.inputParam[@"fontSize"];
    self.inputField.font = [UIFont systemFontOfSize:[fontSize floatValue]];
    
    // MARK: - Set Input Text Color
    NSString *color = self.inputParam[@"color"];
    self.inputField.textColor = [UIColor ColorWithHexString:color];
    
    // MARK: - Set Selection
    NSNumber *selectionStart = self.inputParam[@"selection-start"];
    NSNumber *selectionEnd = self.inputParam[@"selection-end"];
    if (selectionStart && selectionEnd) {
        NSUInteger length = [selectionEnd unsignedIntegerValue] - [selectionStart unsignedIntegerValue];
        NSRange range = NSMakeRange([selectionStart unsignedIntegerValue], length);
        UITextPosition *beginning = self.inputField.beginningOfDocument;
        UITextPosition *startPosition = [self.inputField positionFromPosition:beginning offset:range.location];
        UITextPosition *endPosition = [self.inputField positionFromPosition:startPosition offset:range.length];
        UITextRange *textRange = [self.inputField textRangeFromPosition:startPosition toPosition:endPosition];
        [self.inputField setSelectedTextRange:textRange];
    }
}

- (void)hideKeyboard {
    [self.inputField endEditing:YES];
}

- (void)bridgeCallback:(NSString *)callbackId params:(NSDictionary<NSString *,NSObject *> *)params {
    NSString *paramString = [params jsonPrettyStringEncoded];
    NSString *javascriptString = [NSString stringWithFormat:@"serviceBridge.invokeCallbackHandler('%@', %@)", callbackId, paramString];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.webView evaluateJavaScript:javascriptString completionHandler:^(id _Nullable result, NSError * _Nullable error) {
            MPLog(@"callback complete, id is %@", callbackId);
        }];
    });
}

- (void)bridgeEvent:(NSString *)callbackId eventName:(NSString *)eventName params:(NSDictionary<NSString *,NSObject *> *)params {
    NSMutableDictionary *result = params.mutableCopy;
    [result setValue:callbackId forKey:@"callbackId"];
    NSString *paramString = [result jsonPrettyStringEncoded];
    NSString *javascriptString = [NSString stringWithFormat:@"eval(serviceBridge.subscribeHandler('%@', %@))", eventName, paramString];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.webView evaluateJavaScript:javascriptString completionHandler:^(id _Nullable result, NSError * _Nullable error) {
            NSLog(@"eval complete");
        }];
    });
}

#pragma mark - 私有方法

#pragma mark -

#pragma mark - WK Javascript message handler
#pragma mark -

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    NSString *name = message.name;
    id body = message.body;
    
    if ([self.bridge respondsToSelector:@selector(onReceiveJSMessage:body:controller:)]) {
        [self.bridge onReceiveJSMessage:name body:body controller:self];
    }
}

#pragma mark - WKNavigationDelegate
#pragma mark -

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    MPLog(@"<page>WEBVIEW START");
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    if (navigationAction.navigationType == WKNavigationTypeLinkActivated) {
        decisionHandler(WKNavigationActionPolicyCancel);
    } else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView {
    [self.webView reload];
}

#pragma mark - WKUIDelegate
#pragma mark -

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    // WKWebView不支持JS的alert 用此方法进行拦截
    // message为JS中alert显示的信息 可与前端开发约定好信息
    if ([self.bridge respondsToSelector:@selector(onReceiveJSAlert:)]) {
        [self.bridge onReceiveJSAlert:message];
    }
    completionHandler();
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler {
    // 类比alert 拦截JS confirm
    completionHandler(NO);
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [self track_open_page_success];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [self track_open_page_failure:error.localizedDescription];
}

#pragma mark - UI Text field delegate
#pragma mark -

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    NSLog(@"input should begin editing.");
    CGFloat keyboardHeight = IS_IPHONE_X ? 480 : 400;
    if (UIScreen.mainScreen.bounds.size.height - textField.frame.origin.y - textField.frame.size.height < keyboardHeight) {
        CGFloat offsetHeight = keyboardHeight + textField.frame.origin.y + textField.frame.size.height - UIScreen.mainScreen.bounds.size.height;
        self.webView.scrollView.contentOffset = CGPointMake(0.0, offsetHeight);
    }
    return YES;
}          // return NO to disallow editing.

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    NSLog(@"input did begin editing.");
}           // became first responder

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    NSLog(@"input should end editing.");
    BOOL holdKeyboard = [self.inputParam[@"holdKeyboard"] boolValue];
    if (holdKeyboard) {
        return NO;
    }
    
    return YES;
}          // return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end

- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSLog(@"inputField did end editing.");
    NSString *uid = self.inputParam[@"uid"];
    NSDictionary *param = @{@"value": textField.text, @"uid": uid};
    NSString *paramJson = [param jsonPrettyStringEncoded];
    NSString *javascriptString = [NSString stringWithFormat:@"eval(serviceBridge.subscribeHandler('MP-input-blur', %@))", paramJson];
    [self.webView evaluateJavaScript:javascriptString completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        textField.hidden = YES;
    }];
}             // may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//    NSString *currentString = [textField.text stringByReplacingCharactersInRange:range withString:string];
//    NSString *uid = self.inputParam[@"uid"];
//    NSDictionary *param = @{@"value": currentString, @"uid": uid};
//    NSString *paramJson = [param jsonPrettyStringEncoded];
//    NSString *javascriptString = [NSString stringWithFormat:@"eval(serviceBridge.subscribeHandler('MP-input-input', %@))", paramJson];
//    [self.webView evaluateJavaScript:javascriptString completionHandler:^(id _Nullable result, NSError * _Nullable error) {
//        NSLog(@"eval complete");
//    }];
//    NSLog(@"input text is %@", currentString);
    return YES;
}   // return NO to not change text

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    return YES;
}               // called when clear button pressed. return NO to ignore (no notifications)

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSLog(@"input should return.");
    NSString *uid = self.inputParam[@"uid"];
    NSDictionary *param = @{@"value": textField.text, @"uid": uid};
    NSString *paramJson = [param jsonPrettyStringEncoded];
    NSString *javascriptString = [NSString stringWithFormat:@"serviceBridge.subscribeHandler('MP-input-confirm', %@)", paramJson];
    [self.webView evaluateJavaScript:javascriptString completionHandler:^(id _Nullable result, NSError * _Nullable error) {
            
    }];
    BOOL confirmHold = [self.inputParam[@"confirmHold"] boolValue];
    if (confirmHold) {
        return NO;
    }
    
    return [textField resignFirstResponder];
}              // called when 'return' key pressed. return NO to ignore.

#pragma mark - NSKeyValueObserving
#pragma mark -

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        if (self.webView.estimatedProgress >= 1.0) {
            self.webView.scrollView.contentOffset = CGPointMake(0.0, 1.0);
            self.webView.scrollView.contentOffset = CGPointMake(0.0, -1.0);
            MPLog(@"<page>: %@ onReady", [self.pageModel wholePageUrl]);
            NSString *javascriptString = [NSString stringWithFormat:@"eval(Bridge.LifeCycle.onReady('%@'))", self.pageModel.query];
            
            __weak typeof(self) weakSelf = self;
            
            [self.webView evaluateJavaScript:javascriptString completionHandler:^(id _Nullable result, NSError * _Nullable error) {
                weakSelf.isSuccessOnReady = YES;
                weakSelf.isNotNeedOnShow = YES;
            }];
        }
    }
}

@end
