//
//  CIMPPageApi.m
//  CIMiniProgram
//
//  Created by 袁鑫 on 2020/4/9.
//

#import "CIMPPageApi.h"
#import "CIMPPageManager.h"
#import "CIMPPageBaseViewController.h"
#import "CIMPTabBarViewController.h"
#import "CIMPNetwork.h"
#import "CIIMPImage.h"
#import "CIMPVideo.h"
#import "CIMPDataCache.h"
#import "CIMPShowActionSheet.h"
#import "CIMPFileMacro.h"
#import "CIMPFIle.h"
#import "CIMPAppManager.h"
#import "CIMPApp.h"
#import "CIMPLog.h"

@interface CIMPPageApi ()

@property (nonatomic, weak) CIMPPageManager *pageManager;
@property (nonatomic, copy) NSString *callbackId;

@end

@implementation CIMPPageApi

- (instancetype)initWithPageManager:(CIMPPageManager *)pageManager {
    if (self = [super init]) {
        self.pageManager = pageManager;
    }
    return self;
}

- (void)receive:(NSString *)command param:(NSDictionary *)param {
    NSString *callbackId = param[@"callbackId"];
    self.callbackId = callbackId;
    if (!callbackId) {
        CIMPBaseViewController *vc = [self.pageManager.pageStack top];
        [vc bridgeCallback:callbackId params:@{@"errMsg": @"callbackId为空"}];
        return;
    }
    // MARK: - 路由
    if ([command isEqualToString:@"switchTab"]) {
        [self.pageManager switchTabbar:param callback:^(NSDictionary * _Nonnull result) {
            CIMPBaseViewController *vc = [self.pageManager.pageStack top];
            [vc bridgeCallback:callbackId params:result];
        }];
    } else if ([command isEqualToString:@"reLaunch"]) {
        NSString *url = param[@"url"];
        if (!url) {
            CIMPBaseViewController *vc = [self.pageManager.pageStack top];
            NSDictionary *fail = @{@"errMsg": @"fail", @"message": @"url参数为空"};
            [vc bridgeCallback:callbackId params:fail];
        }
        [self.pageManager reLaunch:self.basePath pagePath:url];
    } else if ([command isEqualToString:@"redirectTo"]) {
        NSString *url = param[@"url"];
        if (!url) {
            CIMPBaseViewController *vc = [self.pageManager.pageStack top];
            NSDictionary *fail = @{@"errMsg": @"fail", @"message": @"url参数为空"};
            [vc bridgeCallback:callbackId params:fail];
        }
        [self.pageManager startPage:self.basePath pagePath:param[@"url"] openNewPage:NO completion:^{
            CIMPBaseViewController *vc = [self.pageManager.pageStack top];
            NSDictionary *success = @{@"errMsg": @"ok", @"message": [NSString stringWithFormat:@"redirectTo %@ 成功", url]};
            [vc bridgeCallback:callbackId params:success];
        }];
    } else if ([command isEqualToString:@"navigateTo"]) {
        NSString *url = param[@"url"];
        if (!url) {
            CIMPBaseViewController *vc = [self.pageManager.pageStack top];
            NSDictionary *fail = @{@"errMsg": @"fail", @"message": @"url参数为空"};
            [vc bridgeCallback:callbackId params:fail];
        }
        [self.pageManager startPage:self.basePath pagePath:param[@"url"] openNewPage:YES completion:^{
            CIMPBaseViewController *vc = [self.pageManager.pageStack top];
            NSDictionary *success = @{@"errMsg": @"ok", @"message": [NSString stringWithFormat: @"navigateTo %@ 成功", url]};
            [vc bridgeCallback:callbackId params:success];
        }];
    }  else if ([command isEqualToString:@"navigateBack"]) {
        if (param[@"delta"]) {
            [self.pageManager gotoPageAtIndex:[param[@"delta"] intValue]];
        }
    }
    // MARK: - 界面
    // MARK: - 网络
    else if ([command isEqualToString:@"request"]) {
        [CIMPNetwork request:param callback:^(NSDictionary * _Nonnull result) {
            CIMPBaseViewController *vc = [self.pageManager.pageStack top];
            [vc bridgeCallback:callbackId params:result];
        }];
    } else if ([command isEqualToString:@"downloadFile"]) {
        [CIMPNetwork downloadFile:param progress:^(NSString * _Nonnull eventName, NSDictionary * _Nonnull result) {
            CIMPBaseViewController *vc = [self.pageManager.pageStack top];
            [vc bridgeEvent:callbackId eventName:eventName params:result];
        } callback:^(NSDictionary * _Nonnull result) {
            CIMPBaseViewController *vc = [self.pageManager.pageStack top];
            [vc bridgeCallback:callbackId params:result];
        }];
    } else if ([command isEqualToString:@"uploadFile"]) {
        [CIMPNetwork uploadFile:param progress:^(NSString * _Nonnull eventName, NSDictionary * _Nonnull result) {
            CIMPBaseViewController *vc = [self.pageManager.pageStack top];
            [vc bridgeEvent:callbackId eventName:eventName params:result];
        } callback:^(NSDictionary * _Nonnull result) {
            CIMPBaseViewController *vc = [self.pageManager.pageStack top];
            [vc bridgeCallback:callbackId params:result];
        }];
    }
    // MARK: - 交互
    else if ([command isEqualToString:@"showToast"]) {
        CIMPBaseViewController *vc = [self.pageManager.pageStack top];
        [vc showToast:param callback:^(NSDictionary * _Nonnull result) {
            CIMPBaseViewController *vc = [self.pageManager.pageStack top];
            [vc bridgeCallback:callbackId params:result];
        }];
    } else if ([command isEqualToString:@"showModal"]) {
        CIMPBaseViewController *vc = [self.pageManager.pageStack top];
        [vc showModal:param callback:^(NSDictionary * _Nonnull result) {
            CIMPBaseViewController *vc = [self.pageManager.pageStack top];
            [vc bridgeCallback:callbackId params:result];
        }];
    } else if ([command isEqualToString:@"showLoading"]) {
        CIMPBaseViewController *vc = [self.pageManager.pageStack top];
        [vc showLoading:param callback:^(NSDictionary * _Nonnull result) {
            CIMPBaseViewController *vc = [self.pageManager.pageStack top];
            [vc bridgeCallback:callbackId params:result];
        }];
    }  else if ([command isEqualToString:@"showActionSheet"]) {
        [CIMPShowActionSheet showActionSheet:param success:^(NSDictionary * _Nonnull success) {
            CIMPBaseViewController *vc = [self.pageManager.pageStack top];
            [vc bridgeCallback:callbackId params:success];
        } fail:^(NSDictionary * _Nonnull fail) {
            CIMPBaseViewController *vc = [self.pageManager.pageStack top];
            [vc bridgeCallback:callbackId params:fail];
        }];
    } else if ([command isEqualToString:@"hideToast"]) {
        CIMPBaseViewController *vc = [self.pageManager.pageStack top];
        [vc hideToast];
    } else if ([command isEqualToString:@"hideLoading"]) {
        CIMPBaseViewController *vc = [self.pageManager.pageStack top];
        [vc hideLoading];
    }
    // MARK: - 导航栏
    else if ([command isEqualToString:@"showNavigationBarLoading"]) {
        CIMPBaseViewController *vc = [self.pageManager.pageStack top];
        [vc showNavigationBarLoading:^(NSDictionary * _Nonnull result) {
            CIMPBaseViewController *vc = [self.pageManager.pageStack top];
            [vc bridgeCallback:callbackId params:result];
        }];
    } else if ([command isEqualToString:@"setNavigationBarTitle"]) {
        CIMPBaseViewController *vc = [self.pageManager.pageStack top];
        [vc setNavigationBarTitle:param callback:^(NSDictionary * _Nonnull result) {
            CIMPBaseViewController *vc = [self.pageManager.pageStack top];
            [vc bridgeCallback:callbackId params:result];
        }];
    } else if ([command isEqualToString:@"setNavigationBarColor"]) {
        CIMPBaseViewController *vc = [self.pageManager.pageStack top];
        [vc setNavigationBarColor:param callback:^(NSDictionary * _Nonnull result) {
            CIMPBaseViewController *vc = [self.pageManager.pageStack top];
            [vc bridgeCallback:callbackId params:result];
        }];
    } else if ([command isEqualToString:@"hideNavigationBarLoading"]) {
        CIMPBaseViewController *vc = [self.pageManager.pageStack top];
        [vc hideNavigationBarLoading:^(NSDictionary * _Nonnull result) {
            CIMPBaseViewController *vc = [self.pageManager.pageStack top];
            [vc bridgeCallback:callbackId params:result];
        }];
    }
    // MARK: - Tab Bar
    else if ([command isEqualToString:@"showTabBarRedDot"]) {
        
    } else if ([command isEqualToString:@"showTabBar"]) {
        CIMPBaseViewController *vc = [self.pageManager.pageStack top];
        [vc showTabBar:param callback:^(NSDictionary * _Nonnull result) {
            CIMPBaseViewController *vc = [self.pageManager.pageStack top];
            [vc bridgeCallback:callbackId params:result];
        }];
    } else if ([command isEqualToString:@"setTabBarStyle"]) {
        CIMPBaseViewController *vc = [self.pageManager.pageStack top];
        [vc setTabBarStyle:param callback:^(NSDictionary * _Nonnull result) {
            CIMPBaseViewController *vc = [self.pageManager.pageStack top];
            [vc bridgeCallback:callbackId params:result];
        }];
    } else if ([command isEqualToString:@"setTabBarItem"]) {
        
    } else if ([command isEqualToString:@"setTabBarBadge"]) {
        
    } else if ([command isEqualToString:@"hideTabBarRedDot"]) {
        
    } else if ([command isEqualToString:@"hideTabBar"]) {
        CIMPBaseViewController *vc = [self.pageManager.pageStack top];
        [vc hideTabBar:param callback:^(NSDictionary * _Nonnull result) {
            CIMPBaseViewController *vc = [self.pageManager.pageStack top];
            [vc bridgeCallback:callbackId params:result];
        }];
    }
    // MARK: - 下拉刷新
    else if ([command isEqualToString:@"startPullDownRefresh"]) {
        CIMPBaseViewController *vc = [self.pageManager.pageStack top];
        [vc startPullDownRefresh];
        
    } else if ([command isEqualToString:@"stopPullDownRefresh"]) {
        CIMPBaseViewController *vc = [self.pageManager.pageStack top];
        [vc stopPullDownRefresh];
        
    }
    // MARK: - 键盘
    else if ([command isEqualToString:@"onKeyboardHeightChange"]) {
        
    } else if ([command isEqualToString:@"hideKeyboard"]) {
        [self hideKeyboard];
    } else if ([command isEqualToString:@"getSelectedTextRange"]) {
        
    }
    // MARK: - 数据缓存
    else if ([command isEqualToString:@"setStorageSync"]) {
        CIMPBaseViewController *vc = [self.pageManager.pageStack top];
        [CIMPDataCache setStorage:param success:^(NSDictionary * _Nonnull result) {
            [vc bridgeCallback:callbackId params:result];
        } fail:^(NSDictionary * _Nonnull error) {
            [vc bridgeCallback:callbackId params:error];
        } complete:^(NSDictionary * _Nonnull complete) {
            [vc bridgeCallback:callbackId params:complete];
        }];
    } else if ([command isEqualToString:@"setStorage"]) {
        CIMPBaseViewController *vc = [self.pageManager.pageStack top];
        [CIMPDataCache setStorage:param success:^(NSDictionary * _Nonnull result) {
            [vc bridgeCallback:callbackId params:result];
        } fail:^(NSDictionary * _Nonnull error) {
            [vc bridgeCallback:callbackId params:error];
        } complete:^(NSDictionary * _Nonnull complete) {
            [vc bridgeCallback:callbackId params:complete];
        }];
    } else if ([command isEqualToString:@"removeStorageSync"]) {
        CIMPBaseViewController *vc = [self.pageManager.pageStack top];
        [CIMPDataCache removeStorage:param success:^(NSDictionary * _Nonnull result) {
            [vc bridgeCallback:callbackId params:result];
        } fail:^(NSDictionary * _Nonnull error) {
            [vc bridgeCallback:callbackId params:error];
        } complete:^(NSDictionary * _Nonnull complete) {
            [vc bridgeCallback:callbackId params:complete];
        }];
    } else if ([command isEqualToString:@"removeStorage"]) {
        CIMPBaseViewController *vc = [self.pageManager.pageStack top];
        [CIMPDataCache removeStorage:param success:^(NSDictionary * _Nonnull result) {
            [vc bridgeCallback:callbackId params:result];
        } fail:^(NSDictionary * _Nonnull error) {
            [vc bridgeCallback:callbackId params:error];
        } complete:^(NSDictionary * _Nonnull complete) {
            [vc bridgeCallback:callbackId params:complete];
        }];
    } else if ([command isEqualToString:@"getStorageSync"]) {
        CIMPBaseViewController *vc = [self.pageManager.pageStack top];
        [CIMPDataCache getStorage:param success:^(NSDictionary * _Nonnull result) {
            [vc bridgeCallback:callbackId params:result];
        } fail:^(NSDictionary * _Nonnull error) {
            [vc bridgeCallback:callbackId params:error];
        } complete:^(NSDictionary * _Nonnull complete) {
            [vc bridgeCallback:callbackId params:complete];
        }];
    } else if ([command isEqualToString:@"getStorageInfoSync"]) {
        CIMPBaseViewController *vc = [self.pageManager.pageStack top];
        [CIMPDataCache getStorageInfo:param success:^(NSDictionary * _Nonnull result) {
            [vc bridgeCallback:callbackId params:result];
        } fail:^(NSDictionary * _Nonnull error) {
            [vc bridgeCallback:callbackId params:error];
        } complete:^(NSDictionary * _Nonnull complete) {
            [vc bridgeCallback:callbackId params:complete];
        }];
    } else if ([command isEqualToString:@"getStorageInfo"]) {
        CIMPBaseViewController *vc = [self.pageManager.pageStack top];
        [CIMPDataCache getStorageInfo:param success:^(NSDictionary * _Nonnull result) {
            [vc bridgeCallback:callbackId params:result];
        } fail:^(NSDictionary * _Nonnull error) {
            [vc bridgeCallback:callbackId params:error];
        } complete:^(NSDictionary * _Nonnull complete) {
            [vc bridgeCallback:callbackId params:complete];
        }];
    } else if ([command isEqualToString:@"getStorage"]) {
        CIMPBaseViewController *vc = [self.pageManager.pageStack top];
        [CIMPDataCache getStorage:param success:^(NSDictionary * _Nonnull result) {
            [vc bridgeCallback:callbackId params:result];
        } fail:^(NSDictionary * _Nonnull error) {
            [vc bridgeCallback:callbackId params:error];
        } complete:^(NSDictionary * _Nonnull complete) {
            [vc bridgeCallback:callbackId params:complete];
        }];
    } else if ([command isEqualToString:@"clearStorageSync"]) {
        CIMPBaseViewController *vc = [self.pageManager.pageStack top];
        [CIMPDataCache clearStorage:param success:^(NSDictionary * _Nonnull result) {
            [vc bridgeCallback:callbackId params:result];
        } fail:^(NSDictionary * _Nonnull error) {
            [vc bridgeCallback:callbackId params:error];
        } complete:^(NSDictionary * _Nonnull complete) {
            [vc bridgeCallback:callbackId params:complete];
        }];
    } else if ([command isEqualToString:@"clearStorage"]) {
        CIMPBaseViewController *vc = [self.pageManager.pageStack top];
        [CIMPDataCache clearStorage:param success:^(NSDictionary * _Nonnull result) {
            [vc bridgeCallback:callbackId params:result];
        } fail:^(NSDictionary * _Nonnull error) {
            [vc bridgeCallback:callbackId params:error];
        } complete:^(NSDictionary * _Nonnull complete) {
            [vc bridgeCallback:callbackId params:complete];
        }];
    }
    // MARK: - 媒体
    // MARK: - 图片
    else if ([command isEqualToString:@"previewImage"]) {
        CIMPBaseViewController *vc = [self.pageManager.pageStack top];
        [vc previewImage:param callback:^(NSDictionary * _Nonnull result) {
            CIMPBaseViewController *vc = [self.pageManager.pageStack top];
            [vc bridgeCallback:callbackId params:result];
        }];
    } else if ([command isEqualToString:@"saveImageToPhotosAlbum"]) {
        NSString *filePath = param[@"filePath"];
        if (!filePath) {
            NSDictionary *result = @{@"errMsg": @"fail", @"message": @"filePath参数为空"};
            CIMPBaseViewController *vc = [self.pageManager.pageStack top];
            [vc bridgeCallback:callbackId params:result];
            return;
        }
        NSString *fullPath = [kMiniProgramPath stringByAppendingString:[NSString stringWithFormat:@"/%@%@", [CIMPAppManager sharedManager].currentApp.appInfo.appId, filePath]];
        if (![kFileManager fileExistsAtPath:fullPath]) {
            NSDictionary *result = @{@"errMsg": @"fail", @"message": @"文件不存在"};
            CIMPBaseViewController *vc = [self.pageManager.pageStack top];
            [vc bridgeCallback:callbackId params:result];
            return;
        }
        UIImage *image = [UIImage imageWithContentsOfFile:fullPath];
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
    } else if ([command isEqualToString:@"getImageInfo"]) {
        [CIIMPImage getImageInfo:param callback:^(NSDictionary * _Nonnull result) {
            CIMPBaseViewController *vc = [self.pageManager.pageStack top];
            [vc bridgeCallback:callbackId params:result];
        }];
    } else if ([command isEqualToString:@"compressImage"]) {
        [CIIMPImage compressImage:param callback:^(NSDictionary * _Nonnull result) {
            CIMPBaseViewController *vc = [self.pageManager.pageStack top];
            [vc bridgeCallback:callbackId params:result];
        }];
    } else if ([command isEqualToString:@"chooseImage"]) {
        CIMPBaseViewController *vc = [self.pageManager.pageStack top];
        [vc chooseImage:param callback:^(NSDictionary * _Nonnull result) {
            CIMPBaseViewController *vc = [self.pageManager.pageStack top];
            [vc bridgeCallback:callbackId params:result];
        }];
    } else if ([command isEqualToString:@"chooseFile"]) {
        CIMPBaseViewController *vc = [self.pageManager.pageStack top];
        [vc chooseFile:param callback:^(NSDictionary * _Nonnull result) {
            CIMPBaseViewController *vc = [self.pageManager.pageStack top];
            [vc bridgeCallback:callbackId params:result];
        }];
    }
    // MARK: - 视频
    else if ([command isEqualToString:@"chooseMedia"]) {
        CIMPBaseViewController *vc = [self.pageManager.pageStack top];
        [vc chooseMedia:param callback:^(NSDictionary * _Nonnull result) {
            CIMPBaseViewController *vc = [self.pageManager.pageStack top];
            [vc bridgeCallback:callbackId params:result];
        }];
    } else if ([command isEqualToString:@"chooseVideo"]) {
        CIMPBaseViewController *vc = [self.pageManager.pageStack top];
        [vc chooseVideo:param callback:^(NSDictionary * _Nonnull result) {
            CIMPBaseViewController *vc = [self.pageManager.pageStack top];
            [vc bridgeCallback:callbackId params:result];
        }];
    } else if ([command isEqualToString:@"getVideoInfo"]) {
        [CIMPVideo getVideoInfo:param callback:^(NSDictionary * _Nonnull result) {
            CIMPBaseViewController *vc = [self.pageManager.pageStack top];
            [vc bridgeCallback:callbackId params:result];
        }];
    } else if ([command isEqualToString:@"saveVideoToPhotosAlbum"]) {
        NSString *filePath = param[@"filePath"];
        if (!filePath) {
            NSDictionary *result = @{@"errMsg": @"fail", @"message": @"filePath参数为空"};
            CIMPBaseViewController *vc = [self.pageManager.pageStack top];
            [vc bridgeCallback:callbackId params:result];
            return;
        }
//        NSString *fullPath = [kMiniProgramPath stringByAppendingString:filePath];
        if (![kFileManager fileExistsAtPath:filePath]) {
            NSDictionary *result = @{@"errMsg": @"fail", @"message": @"文件不存在"};
            CIMPBaseViewController *vc = [self.pageManager.pageStack top];
            [vc bridgeCallback:callbackId params:result];
            return;
        }
        BOOL compatible = UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(filePath);
        if (compatible) {
            UISaveVideoAtPathToSavedPhotosAlbum(filePath, self, @selector(video:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
        } else {
            NSDictionary *result = @{@"errMsg": @"fail", @"message": @"文件格式不兼容"};
            CIMPBaseViewController *vc = [self.pageManager.pageStack top];
            [vc bridgeCallback:callbackId params:result];
            return;
        }
    }
    // MARK: - 文件
    else if ([command isEqualToString:@"openDocument"]) {
        CIMPBaseViewController *vc = [self.pageManager.pageStack top];
        [vc openDocument:param callback:^(NSDictionary * _Nonnull result) {
            
        }];
    } else if ([command isEqualToString:@"saveFile"]) {
        [CIMPFile saveFile:param callback:^(NSDictionary * _Nonnull result) {
            CIMPBaseViewController *vc = [self.pageManager.pageStack top];
            [vc bridgeCallback:callbackId params:result];
        }];
    } else if ([command isEqualToString:@"removeSavedFile"]) {
        [CIMPFile removeSavedFile:param callback:^(NSDictionary * _Nonnull result) {
            CIMPBaseViewController *vc = [self.pageManager.pageStack top];
            [vc bridgeCallback:callbackId params:result];
        }];
    } else if ([command isEqualToString:@"getSavedFileInfo"]) {
        [CIMPFile getSavedFileInfo:param callback:^(NSDictionary * _Nonnull result) {
            CIMPBaseViewController *vc = [self.pageManager.pageStack top];
            [vc bridgeCallback:callbackId params:result];
        }];
    } else if ([command isEqualToString:@"getSavedFileList"]) {
        [CIMPFile getSavedFileList:param callback:^(NSDictionary * _Nonnull result) {
            CIMPBaseViewController *vc = [self.pageManager.pageStack top];
            [vc bridgeCallback:callbackId params:result];
        }];
    } else if ([command isEqualToString:@"getFileInfo"]) {
        
    }
    // MARK: - 设备
    // MARK: - 剪贴板
    else if ([command isEqualToString:@"setClipboardData"]) {
        
    }
    // MARK: - 扫码
    else if ([command isEqualToString:@"scanCode"]) {
        CIMPBaseViewController *vc = [self.pageManager.pageStack top];
        [vc scanCode:param callback:^(NSDictionary * _Nonnull result) {
            CIMPBaseViewController *vc = [self.pageManager.pageStack top];
            [vc bridgeCallback:callbackId params:result];
        }];
    }
    // MARK: - 罗盘
    else if ([command isEqualToString:@"startCompass"]) {
        
    } else if ([command isEqualToString:@"stopCompass"]) {
        
    }
    // MARK: - 位置
    else if ([command isEqualToString:@"getLocation"]) {
        CIMPBaseViewController *vc = [self.pageManager.pageStack top];
        [vc getLocation:param callback:^(NSDictionary * _Nonnull result) {
            CIMPBaseViewController *vc = [self.pageManager.pageStack top];
            [vc bridgeCallback:callbackId params:result];
        }];
    } else if ([command isEqualToString:@"startLocationUpdate"]) {
        
    } else if ([command isEqualToString:@"stopLocationUpdate"]) {
        
    } else if ([command isEqualToString:@"startLocationUpdateBackground"]) {
        
    } else if ([command isEqualToString:@"openLocation"]) {
        
    }
    // MARK: - 表单
    else if ([command isEqualToString:@"setInputPosition"]) {
        CIMPBaseViewController *vc = [self.pageManager.pageStack top];
        [vc setInputPosition:param completion:^{
            NSDictionary *success = @{@"errMsg": @"ok", @"message": @"setInputPosition complete"};
            CIMPBaseViewController *weakVC = [self.pageManager.pageStack top];
            [weakVC bridgeCallback:callbackId params:success];
        }];
    }
    else if ([command isEqualToString:@"setInputValue"]) {
        CIMPBaseViewController *vc = [self.pageManager.pageStack top];
        [vc setInputValue:param completion:^{
            NSDictionary *success = @{@"errMsg": @"ok", @"message": @"setInputValue complete"};
            CIMPBaseViewController *weakVC = [self.pageManager.pageStack top];
            [weakVC bridgeCallback:callbackId params:success];
        }];
    } else if ([command isEqualToString:@"setInputFocus"]) {
        CIMPBaseViewController *vc = [self.pageManager.pageStack top];
        [vc setInputFocus:param completion:^{
            NSDictionary *success = @{@"errMsg": @"ok", @"message": @"setInputFocus complete"};
            CIMPBaseViewController *weakVC = [self.pageManager.pageStack top];
            [weakVC bridgeCallback:callbackId params:success];
        }];
    } else if ([command isEqualToString:@"updateInputPosition"]) {
        CIMPBaseViewController *vc = [self.pageManager.pageStack top];
        [vc updateInputPosition:param completion:^{
            CIMPBaseViewController *weakVC = [self.pageManager.pageStack top];
            NSDictionary *success = @{@"errMsg": @"ok", @"message": @"updateInputBlur complete"};
            [weakVC bridgeCallback:callbackId params:success];
        }];
    } else if ([command isEqualToString:@"setInputBlur"]) {
        CIMPBaseViewController *vc = [self.pageManager.pageStack top];
        [vc setInputBlur:param completion:^{
            CIMPBaseViewController *weakVC = [self.pageManager.pageStack top];
            NSDictionary *success = @{@"errMsg": @"ok", @"message": @"setInputBlur complete"};
            [weakVC bridgeCallback:callbackId params:success];
        }];
    } else if ([command isEqualToString:@"showMap"]) {
        
    } else if ([command isEqualToString:@"hideKeyboard"]) {
        [self hideKeyboard];
    } else if ([command isEqualToString:@"setInputValue"]) {
        
    }
    // MARK: - 关闭
    else if ([command isEqualToString:@"closeProgram"]) {
        [self.pageManager exit];
    }
    // MARK: - 从APP获取数据
    else if ([command isEqualToString:@"getAppSharedData"]) {
        NSObject *value = [[NSUserDefaults standardUserDefaults] valueForKey:@"MiniProgram"];
        if (!value) {
            NSDictionary *error = @{@"errMsg": @"fail", @"message": @"App共享数据不存在"};
            CIMPBaseViewController *vc = [self.pageManager.pageStack top];
            [vc bridgeCallback:callbackId params:error];
        } else {
            NSDictionary *success = @{@"errMsg": @"ok", @"value": value};
            CIMPBaseViewController *vc = [self.pageManager.pageStack top];
            [vc bridgeCallback:callbackId params:success];
        }
    }
    // MARK: -
    else {
        MPLog(@"command: %@ not found", command);
    }
}

#pragma mark - 自定义
#pragma mark -

- (void)hideKeyboard {
    CIMPBaseViewController *vc = [self.pageManager.pageStack top];
    [vc hideKeyboard];
}

#pragma mark - 保存图片到相册回调
#pragma mark -

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error) {
        NSDictionary *result = @{@"errMsg": @"fail", @"message": error.localizedDescription};
        CIMPBaseViewController *vc = [self.pageManager.pageStack top];
        [vc bridgeCallback:self.callbackId params:result];
    } else {
        NSDictionary *result = @{@"errMsg": @"ok", @"message": @"保存图片到相册成功"};
        CIMPBaseViewController *vc = [self.pageManager.pageStack top];
        [vc bridgeCallback:self.callbackId params:result];
    }
}

#pragma mark - 保存视频到相册回调
#pragma mark -

- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error) {
        NSDictionary *result = @{@"errMsg": @"fail", @"message": error.localizedDescription};
        CIMPBaseViewController *vc = [self.pageManager.pageStack top];
        [vc bridgeCallback:self.callbackId params:result];
    } else {
        NSDictionary *result = @{@"errMsg": @"ok", @"message": @"保存视频到相册成功"};
        CIMPBaseViewController *vc = [self.pageManager.pageStack top];
        [vc bridgeCallback:self.callbackId params:result];
    }
}

@end
