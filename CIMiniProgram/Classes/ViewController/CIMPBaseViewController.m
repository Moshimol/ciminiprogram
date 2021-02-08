//
//  CIMPBaseViewController.m
//  CIMiniProgram
//
//  Created by 袁鑫 on 2020/4/9.
//

#import "CIMPBaseViewController.h"
#import "CIMPDeviceMacro.h"
#import "CIIMPImage.h"
#import "CIMPFileMacro.h"
#import "CIMPAppManager.h"
#import "CIMPApp.h"
#import <CIPhotoBrowser/CIPhotoBrowser.h>
#import <CICamera/CICamera.h>
#import <CICategories/CICategories.h>
#import <CIViewFile/CIFileViewHelper.h>
#import <CoreLocation/CoreLocation.h>
#import <Photos/Photos.h>

#define WS(weakSelf) __weak __typeof(&*self)weakSelf = self;

typedef void (^ChooseFileCallback)(NSDictionary * _Nonnull);
typedef void(^GetLocationCallBack)(NSDictionary *result);

@interface CIMPBaseViewController () <UIGestureRecognizerDelegate, CIPhotoBrowserDataSource, UIDocumentPickerDelegate, CLLocationManagerDelegate>

@property (nonatomic, copy) NSArray<NSString *> *urls;
@property (nonatomic, copy) ChooseFileCallback chooseFileCallback;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, strong) NSString *callbackId;
@property (nonatomic, copy) GetLocationCallBack getLocationCallback;

@end

@implementation CIMPBaseViewController

#pragma mark - Life Cycle
#pragma mark -

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    //导航栏
    __weak typeof(self) weakSelf = self;
    CGFloat naviHeight = IS_IPHONE_X ? 88 : 64;
    self.naviView = [[CIMPNavigationView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.bounds.size.width, naviHeight)];
    
    [self.naviView setLeftClick:^(CIMPNavigationView * _Nonnull navigationView) {
        if (weakSelf.pageManager) {
            [weakSelf.pageManager pop];
        }
    }];
    
    [self.naviView setExitClick:^(CIMPNavigationView * _Nonnull navigationView) {
        if (weakSelf.pageManager) {
            [weakSelf.pageManager exit];
        }
    }];
    
    [self.naviView setMoreClick:^(CIMPNavigationView * _Nonnull navigationView) {
        if (weakSelf.pageManager) {
            [weakSelf.pageManager more];
        }
    }];
    
    [self.view addSubview:self.naviView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (!self.navigationController.isNavigationBarHidden) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

#pragma mark - Loading
#pragma mark -

// MARK: - 子类实现

- (void)showToast:(NSDictionary *)param callback:(void (^)(NSDictionary * _Nonnull))callback {
    // 子类实现
}

- (void)hideToast {
    // 子类实现
}

- (void)showModal:(NSDictionary *)param callback:(void (^)(NSDictionary * _Nonnull))callback {
    // 子类实现
}

- (void)showLoading:(NSDictionary *)param callback:(void (^)(NSDictionary * _Nonnull))callback {
    // 子类实现
}


- (void)hideLoading {
    // 子类实现
}

- (void)setInputPosition:(NSDictionary *)param completion:(void (^)(void))completion {
    // 子类实现
}

- (void)setInputFocus:(NSDictionary *)param completion:(void (^)(void))completion {
    // 子类实现
}

- (void)setInputValue:(NSDictionary *)param completion:(void (^)(void))completion {
    // 子类实现
}

- (void)setInputBlur:(NSDictionary *)param completion:(void (^)(void))completion {
    // 子类实现
}

- (void)updateInputPosition:(NSDictionary *)param completion:(void (^)(void))completion {
    // 子类实现
}

- (void)bridgeCallback:(NSString *)callbackId params:(NSDictionary<NSString *,NSObject *> *)params {
    // 子类实现
}

- (void)bridgeEvent:(NSString *)callbackId eventName:(NSString *)eventName params:(NSDictionary<NSString *,NSObject *> *)params {
    // 子类实现
}

- (void)hideKeyboard {
    // 子类实现
}

#pragma mark - NavigationBar
#pragma mark -

- (void)showNavigationBarLoading:(void (^)(NSDictionary * _Nonnull))callback {
    [self.naviView startLoadingAnimation];
    if (callback) {
        NSDictionary *result = @{@"errMsg": @"ok"};
        callback(result);
    }
}

- (void)setNavigationBarTitle:(NSDictionary *)param callback:(void (^)(NSDictionary * _Nonnull))callback {
    NSString *title = param[@"title"];
    if (!title) {
        if (callback) {
            NSDictionary *error = @{@"errMsg": @"fail", @"message": @"title为空"};
            callback(error);
        }
        return;
    }
    [self.naviView setNavigationTitle:title];
}

- (void)setNavigationBarColor:(NSDictionary *)param callback:(void (^)(NSDictionary * _Nonnull))callback {
    NSString *frontColor = param[@"frontColor"];
    if (!frontColor) {
        if (callback) {
            callback(@{@"errMsg": @"fail", @"message": @"参数frontColor 为空"});
        }
        return;
    }
    
    if (![[frontColor lowercaseString] isEqualToString:@"#ffffff"] && ![frontColor isEqualToString:@"#000000"]){
        if(callback) {
            callback(@{@"errMsg": @"fail", @"message": @"参数frontColor 仅支持#ffffff和#000000"});
        }
        return;
    }
    
    NSString *bgColor = param[@"backgroundColor"];
    if (!bgColor) {
        if (callback) {
            callback(@{@"errMsg": @"参数backgroundColor 为空"});
        }
        return;
    }
    
    NSMutableDictionary *animationParam = [NSMutableDictionary dictionary];
    animationParam[@"duration"] = @0;
    animationParam[@"timingFunc"] = @"linear";

    NSDictionary *animation = param[@"animation"];
    if (animation && [animation isKindOfClass:NSDictionary.class]) {
        if (param[@"durarion"]) {
            animationParam[@"durarion"] = animation[@"durarion"];
        }

        if (param[@"timingFunc"]) {
            animationParam[@"timingFunc"] = animation[@"timingFunc"];
        }
    }
    [self.naviView setNaviFrontColor:frontColor andBgColor:bgColor withAnimationParam:animationParam];
    
    if (callback) {
        NSDictionary *result = @{@"errMsg": @"ok"};
        callback(result);
    }
}

- (void)hideNavigationBarLoading:(void (^)(NSDictionary * _Nonnull))callback {
    [self.naviView hideLoadingAnimation];
    if (callback) {
        NSDictionary *result = @{@"errMsg": @"ok"};
        callback(result);
    }
}

- (void)hideHomeButton:(void (^)(NSDictionary * _Nonnull))callback {
    // 暂不实现，目前没有Home按钮
}

#pragma mark - TabBar
#pragma mark -

- (void)showTabBar:(NSDictionary *)param callback:(void (^)(NSDictionary * _Nonnull))callback {
    // 子类实现
}

- (void)hideTabBar:(NSDictionary *)param callback:(void (^)(NSDictionary * _Nonnull))callback {
    // 子类实现
}

- (void)setTabBarStyle:(NSDictionary *)param callback:(void (^)(NSDictionary * _Nonnull))callback {
    // 子类实现
}

#pragma mark - 图片
#pragma mark -

- (void)previewImage:(NSDictionary *)param callback:(void (^)(NSDictionary * _Nonnull))callback {
    self.urls = param[@"urls"];
    
    if (!self.urls || self.urls.count == 0) {
        if (callback) {
            callback(@{@"errMsg": @"fail", @"message": @"urls参数为空"});
        }
    }
    
    CIPhotoBrowser *browser = [[CIPhotoBrowser alloc] initWithDataSource:self];
    browser.shouldHideToolBar = YES;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:browser];
    navigationController.modalPresentationStyle = UIModalPresentationFullScreen;
    navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: UIColor.whiteColor};
    navigationController.navigationBarHidden = YES;
    
    [self presentViewController:navigationController animated:YES completion:^{
        if (callback) {
            callback(@{@"errMsg": @"ok"});
        }
    }];
    
    NSString *current = param[@"current"];
    if (current) {
        NSUInteger index = [self.urls indexOfObject:current];
        [browser setCurrentPhotoIndex:index];
    }
}

- (void)chooseImage:(NSDictionary *)param callback:(void (^)(NSDictionary * _Nonnull))callback {
    NSArray *sourceType = param[@"sourceType"];
    if (!sourceType || ![sourceType isKindOfClass:NSArray.class]) {
        sourceType = @[@"album", @"camera"];
    }

    if (sourceType.count == 1) {
        NSString *type = sourceType[0];
        
        if ([type isEqualToString:@"album"]) {
            NSNumber *count = param[@"count"] ? param[@"count"] : [NSNumber numberWithInteger:9];
            NSArray *sizeType = param[@"sizeType"] ? param[@"sizeType"] : @[@"original", @"compressed"];
            
            // 裁切的设置
            if ([param[@"crop"] boolValue]) {
                // 设置尺寸的大小
                CGFloat x = [param[@"x"] floatValue] ? [param[@"x"] floatValue] : 0.0;
                CGFloat y = [param[@"y"] floatValue] ? [param[@"y"] floatValue] : 0.0;
                
                CGSize screenSize = [UIScreen mainScreen].bounds.size;
                
                // 设置默认的宽高 如果没有设置宽高的话 默认的宽度为屏幕宽度 - 30
                CGFloat width = [param[@"width"] floatValue] ? [param[@"width"] floatValue] : screenSize.width - 30.0;
                CGFloat height = [param[@"height"] floatValue] ? [param[@"height"] floatValue] : screenSize.width - 30.0;
                
                width = MIN(screenSize.width, width);
                height = MIN(screenSize.height, height);
                
                // 是不是中心 ，如果是中间 改变x和y 宽度和高度不能大于当前屏幕宽高
                BOOL isCenter = [param[@"isCenter"] boolValue];
                CGRect rect = CGRectMake(x, y, width, height);
                
                // 设置为中心
                if (isCenter) {
                    rect = CGRectMake((screenSize.width - width)/ 2.0, (screenSize.height - height) / 2.0, width, height);
                }
                
                BOOL needCircleCrop = [param[@"needCircleCrop"] boolValue];
                
                NSInteger circleCropRadius = [param[@"circleCropRadius"] integerValue] ? [param[@"circleCropRadius"] integerValue] : 0;
                
                [self photoCropConfigAllowCrop:YES cropRect:rect needCircleCrop:needCircleCrop circleCropRadius:circleCropRadius];
            }

            WS(ws);
            [self chooseFromAlbum:count sizeType:sizeType completion:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
                [ws cancelPhotoCropConfig];
                NSMutableArray *tempFilePaths = @[].mutableCopy;
                for (int i = 0; i< photos.count; i++) {
                    NSArray *resources = [PHAssetResource assetResourcesForAsset:assets[i]];
                    NSString *orgFilename = ((PHAssetResource*)resources[i]).originalFilename;
                    NSArray *array = [orgFilename componentsSeparatedByString:@"."];
                    
                    NSString *filePath = [CIIMPImage writeImageToFile:(UIImage *)photos[i] fileNameSuffix:array.lastObject];
                    [tempFilePaths addObject:filePath];
                }
                
                if (callback) {
                    NSDictionary *result = @{@"errMsg": @"ok", @"tempFilePaths": tempFilePaths};
                    callback(result);
                }
            }];
        } else if ([type isEqualToString:@"camera"]) {
            [self takePhoto:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
                NSMutableArray *tempFilePaths = @[].mutableCopy;
                for (int i = 0; i< photos.count; i++) {
                    NSArray *resources = [PHAssetResource assetResourcesForAsset:assets[i]];
                    NSString *orgFilename = ((PHAssetResource*)resources[i]).originalFilename;
                    NSArray *array = [orgFilename componentsSeparatedByString:@"."];
                    
                    NSString *filePath = [CIIMPImage writeImageToFile:(UIImage *)photos[i] fileNameSuffix:array.lastObject];
                    [tempFilePaths addObject:filePath];
                }
                if (callback) {
                    NSDictionary *result = @{@"errMsg": @"ok", @"tempFilePaths": tempFilePaths};
                    callback(result);
                }
            }];
        } else {
            if (callback) {
                callback(@{@"errMsg": @"fail", @"message": @"参数sourceType的值不合法"});
            }
            return;
        }
    } else if (sourceType.count == 2) {
        UIAlertController *chooseAction = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *album = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSNumber *count = param[@"count"] ? param[@"count"] : [NSNumber numberWithInteger:9];
            NSArray *sizeType = param[@"sizeType"] ? param[@"sizeType"] : @[@"original", @"compressed"];
            [self chooseFromAlbum:count sizeType:sizeType completion:^(NSArray<UIImage *> * photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
                NSMutableArray *tempFilePaths = @[].mutableCopy;
                for (int i = 0; i< photos.count; i++) {
                    NSArray *resources = [PHAssetResource assetResourcesForAsset:assets[i]];
                    NSString *orgFilename = ((PHAssetResource*)resources[i]).originalFilename;
                    NSArray *array = [orgFilename componentsSeparatedByString:@"."];
                    
                    NSString *filePath = [CIIMPImage writeImageToFile:(UIImage *)photos[i] fileNameSuffix:array.lastObject];
                    [tempFilePaths addObject:filePath];
                }
                if (callback) {
                    NSDictionary *result = @{@"errMsg": @"ok", @"tempFilePaths": tempFilePaths};
                    callback(result);
                }
            }];
        }];
        UIAlertAction *takePhoto = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self takePhoto:^(NSArray<UIImage *> * photos, NSArray * assets, BOOL isSelectOriginalPhoto) {
                NSMutableArray *tempFilePaths = @[].mutableCopy;
                for (int i = 0; i< photos.count; i++) {
                    NSArray *resources = [PHAssetResource assetResourcesForAsset:assets[i]];
                    NSString *orgFilename = ((PHAssetResource*)resources[i]).originalFilename;
                    NSArray *array = [orgFilename componentsSeparatedByString:@"."];
                    
                    NSString *filePath = [CIIMPImage writeImageToFile:(UIImage *)photos[i] fileNameSuffix:array.lastObject];
                    [tempFilePaths addObject:filePath];
                }
                if (callback) {
                    NSDictionary *result = @{@"errMsg": @"ok", @"tempFilePaths": tempFilePaths};
                    callback(result);
                }
            }];
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [chooseAction dismissViewControllerAnimated:YES completion:nil];
        }];
        [chooseAction addAction:album];
        [chooseAction addAction:takePhoto];
        [chooseAction addAction:cancel];
        [self presentViewController:chooseAction animated:YES completion:nil];
    } else {
        if (callback) {
            callback(@{@"errMsg": @"fail", @"message": @"参数sourceType不合法"});
        }
        return;
    }
}

- (void)chooseFile:(NSDictionary *)param callback:(void (^)(NSDictionary * _Nonnull))callback {
    if (callback) {
        self.chooseFileCallback = callback;
    }
    NSArray *types = @[@"public.image", @"public.data"];
    UIDocumentPickerViewController *documentController = [[UIDocumentPickerViewController alloc] initWithDocumentTypes:types inMode:UIDocumentPickerModeOpen];
    documentController.delegate = self;
    documentController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:documentController animated:YES completion:nil];
}

#pragma mark - 视频
#pragma mark -

- (void)chooseVideo:(NSDictionary *)param callback:(void (^)(NSDictionary * _Nonnull))callback {
    NSArray *sourceType = param[@"sourceType"];
    if (!sourceType || ![sourceType isKindOfClass:NSArray.class]) {
        sourceType = @[@"album", @"camera"];
    }

    if (sourceType.count == 1) {
        NSString *type = sourceType[0];
        
        if ([type isEqualToString:@"album"]) {
            BOOL compressed = [param[@"compressed"] boolValue];
            [self chooseVideoFromAlbum:compressed completion:^(NSString * _Nonnull videoPathString) {
                if (callback) {
                    NSDictionary *result = @{@"errMsg": @"ok", @"tempFilePath": videoPathString};
                    callback(result);
                }
            }];
        } else if ([type isEqualToString:@"camera"]) {
            [self takeVideo:^(NSString *savingPath) {
                if (callback) {
                    NSDictionary *result = @{@"errMsg": @"ok", @"tempFilePath": savingPath};
                    callback(result);
                }
            }];
        } else {
            if (callback) {
                callback(@{@"errMsg": @"fail", @"message": @"参数sourceType的值不合法"});
            }
            return;
        }
    } else if (sourceType.count == 2) {
        UIAlertController *chooseAction = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *album = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            BOOL compressed = [param[@"compressed"] boolValue];
            [self chooseVideoFromAlbum:compressed completion:^(NSString * _Nonnull videoPathString) {
                if (callback) {
                    NSDictionary *result = @{@"errMsg": @"ok", @"tempFilePath": videoPathString};
                    callback(result);
                }
            }];
        }];
        UIAlertAction *takePhoto = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self takeVideo:^(NSString *savingPath) {
                if (callback) {
                    NSDictionary *result = @{@"errMsg": @"ok", @"tempFilePath": savingPath};
                    callback(result);
                }
            }];
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [chooseAction dismissViewControllerAnimated:YES completion:nil];
        }];
        [chooseAction addAction:album];
        [chooseAction addAction:takePhoto];
        [chooseAction addAction:cancel];
        [self presentViewController:chooseAction animated:YES completion:nil];
    } else {
        if (callback) {
            callback(@{@"errMsg": @"fail", @"message": @"参数sourceType不合法"});
        }
        return;
    }
}

- (void)chooseMedia:(NSDictionary *)param callback:(void (^)(NSDictionary * _Nonnull))callback {
    NSArray *sourceType = param[@"sourceType"];
    if (!sourceType || ![sourceType isKindOfClass:NSArray.class]) {
        sourceType = @[@"album", @"camera"];
    }

    if (sourceType.count == 1) {
        NSString *type = sourceType[0];
        
        if ([type isEqualToString:@"album"]) {
            NSNumber *count = param[@"count"] ? param[@"count"] : [NSNumber numberWithInteger:9];
            NSArray *sizeType = param[@"sizeType"] ? param[@"sizeType"] : @[@"original", @"compressed"];
            NSArray *mediaType = param[@"mediaType"];
            [self chooseFromAlbum:count sizeType:sizeType mediaType:mediaType completion:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
                NSMutableArray *tempFiles = @[].mutableCopy;
                for (UIImage *image in photos) {
                    NSString *filePath = [CIIMPImage writeImageToFile:image];
                    NSDictionary *tempFilePath = @{@"tempFilePath": filePath};
                    [tempFiles addObject:tempFilePath];
                }
                if (callback) {
                    NSDictionary *result = @{@"errMsg": @"ok", @"tempFiles": tempFiles};
                    callback(result);
                }
            }];
        } else if ([type isEqualToString:@"camera"]) {
            [self takePhoto:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
                NSMutableArray *tempFilePaths = @[].mutableCopy;
                for (UIImage *image in photos) {
                    NSString *filePath = [CIIMPImage writeImageToFile:image];
                    [tempFilePaths addObject:filePath];
                }
                if (callback) {
                    NSDictionary *result = @{@"errMsg": @"ok", @"tempFilePaths": tempFilePaths};
                    callback(result);
                }
            }];
        } else {
            if (callback) {
                callback(@{@"errMsg": @"fail", @"message": @"参数sourceType的值不合法"});
            }
            return;
        }
    } else if (sourceType.count == 2) {
        UIAlertController *chooseAction = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *album = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSNumber *count = param[@"count"] ? param[@"count"] : [NSNumber numberWithInteger:9];
            NSArray *sizeType = param[@"sizeType"] ? param[@"sizeType"] : @[@"original", @"compressed"];
            NSArray *mediaType = param[@"mediaType"];
            [self chooseFromAlbum:count sizeType:sizeType mediaType:mediaType completion:^(NSArray<UIImage *> * photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
                NSMutableArray *tempFiles = @[].mutableCopy;
                for (UIImage *image in photos) {
                    NSString *filePath = [CIIMPImage writeImageToFile:image];
                    NSDictionary *tempFilePath = @{@"tempFilePath": filePath};
                    [tempFiles addObject:tempFilePath];
                }
                if (callback) {
                    NSDictionary *result = @{@"errMsg": @"ok", @"tempFiles": tempFiles};
                    callback(result);
                }
            }];
        }];
        UIAlertAction *takePhoto = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self takePhoto:^(NSArray<UIImage *> * photos, NSArray * assets, BOOL isSelectOriginalPhoto) {
                NSMutableArray *tempFilePaths = @[].mutableCopy;
                for (UIImage *image in photos) {
                    NSString *filePath = [CIIMPImage writeImageToFile:image];
                    [tempFilePaths addObject:filePath];
                }
                if (callback) {
                    NSDictionary *result = @{@"errMsg": @"ok", @"tempFilePaths": tempFilePaths};
                    callback(result);
                }
            }];
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [chooseAction dismissViewControllerAnimated:YES completion:nil];
        }];
        [chooseAction addAction:album];
        [chooseAction addAction:takePhoto];
        [chooseAction addAction:cancel];
        [self presentViewController:chooseAction animated:YES completion:nil];
    } else {
        if (callback) {
            callback(@{@"errMsg": @"fail", @"message": @"参数sourceType不合法"});
        }
        return;
    }
}

#pragma mark - 定位
#pragma mark -

- (void)getLocation:(NSDictionary *)param callback:(void (^)(NSDictionary * _Nonnull))callback {
    self.locationManager = [[CLLocationManager alloc] init];
    [self.locationManager requestWhenInUseAuthorization];
    self.locationManager.delegate = self;
//    self.getLocationParam = param;
    self.getLocationCallback = callback;
    NSString *type = param[@"type"];
    BOOL altitude = [param[@"altitude"] boolValue];
    BOOL isHighAccuracy = [param[@"isHighAccuracy"] boolValue];
    NSNumber *highAccuracyExpireTime = param[@"highAccuracyExpireTime"];
    if (isHighAccuracy) {
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    }
    [self.locationManager requestLocation];
}

#pragma mark - 文件
#pragma mark -

- (void)openDocument:(NSDictionary *)param callback:(void (^)(NSDictionary * _Nonnull))callback {
     NSString *filePath = param[@"filePath"];
    if (!filePath) {
        if (callback) {
            callback(@{@"errMsg": @"fail", @"message": @"filePath参数为空"});
            return;
        }
    }
    NSString *appPath = [kMiniProgramPath stringByAppendingPathComponent:[CIMPAppManager sharedManager].currentApp.appInfo.appId];
    NSString *fullPath = [appPath stringByAppendingPathComponent:filePath];
    NSArray *pathArr = [fullPath componentsSeparatedByString:@"/"];
    NSString *fileName = pathArr.lastObject;
    NSURL *fileURL = [NSURL fileURLWithPath:fullPath];
    BOOL res = [CIFileViewHelper canPreviewItem:fileURL];
    if (res) {
        [CIFileViewHelper showFileWithName:fileName path:fullPath rootViewController:self];
    } else {
        UIDocumentInteractionController *_documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL:fileURL];
        [_documentInteractionController presentOpenInMenuFromRect:CGRectZero inView:self.view animated:YES];
    }
}

#pragma mark - 扫码
#pragma mark -

- (void)scanCode:(NSDictionary *)param callback:(void (^)(NSDictionary * _Nonnull))callback {
    [CICameraManager sharedInstance].scanCompletionHandler = ^(NSString * _Nonnull result) {
        if (callback) {
            callback(@{@"errMsg": @"ok", @"result": result});
        }
    };
    [[CICameraManager sharedInstance] setMode:MODE_SCAN With:self];
}

#pragma mark - 下拉刷新
#pragma mark -

- (void)stopPullDownRefresh {
    // 子类实现
}

- (void)startPullDownRefresh {
    // 子类实现
}

#pragma mark - 内存清理

- (void)cleanMemory {
    
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    if (@available(iOS 13.0, *)) {
        return UIStatusBarStyleDarkContent;
    } else {
        // Fallback on earlier versions
        return UIStatusBarStyleDefault;
    }
}

#pragma mark - CIPhotoCropConfig

// 选择完成之后 应该取消裁切的配置
- (void)photoCropConfigAllowCrop:(BOOL)allowCrop
                        cropRect:(CGRect)cropSize
                  needCircleCrop:(BOOL)needCircleCrop
                circleCropRadius:(NSInteger)circleCropRadius {
    [[CIGalleryManager sharedInstance] allowCrop:allowCrop];
    [[CIGalleryManager sharedInstance] setCropRectSize:cropSize needCircleCrop:needCircleCrop circleCropRadius:circleCropRadius];
}

- (void)cancelPhotoCropConfig {
    [[CIGalleryManager sharedInstance] allowCrop:NO];
}

#pragma mark - CIPhotoBrowserDataSource

- (NSUInteger)numberOfPhotosInPhotoBrowser:(CIPhotoBrowser *)photoBrowser {
    return self.urls.count;
}

- (CIPhoto *)photoBrowser:(CIPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    NSString *urlString = self.urls[index];
    if ([urlString hasPrefix:@"http"] || [urlString hasPrefix:@"https"]) {
        CIPhoto *photo = [[CIPhoto alloc] initWithURL:[NSURL URLWithString:urlString]];
        return photo;
    } else {
        NSString *path = [[kMiniProgramPath stringByAppendingString:[NSString stringWithFormat:@"/%@", [CIMPAppManager sharedManager].currentApp.appInfo.appId]] stringByAppendingString:urlString];
        UIImage *image = [UIImage imageWithContentsOfFile:path];
        CIPhoto *photo = [[CIPhoto alloc] initWithImage:image];
        return photo;
    }
}

- (void)takePhoto:(void (^)(NSArray<UIImage *> *, NSArray *, BOOL))complete {
    [CICameraManager sharedInstance].pictureCompleteHandler = ^(NSArray<UIImage *> * _Nonnull photos, NSArray * _Nonnull assets, BOOL isSelectOriginalPhoto) {
        if (complete) {
            complete(photos, assets, isSelectOriginalPhoto);
        }
    };
    
    [[CICameraManager sharedInstance] setMode:MODE_PICTURE With:self];
}

- (void)takeVideo:(void (^)(NSString *))complete {
    [[CICameraManager sharedInstance] setMode:MODE_VIDEO With:self];
    if (complete) {
        complete([CICameraManager sharedInstance].savePathString);
    }
}

- (void)chooseFromAlbum:(NSNumber *)count sizeType:(NSArray<NSString *> *)sizeType completion:(void (^)(NSArray<UIImage *> *, NSArray *, BOOL))completion {
    [CIGalleryManager sharedInstance].pictureCompleteHandler = ^(NSArray<UIImage *> * _Nonnull photos, NSArray * _Nonnull assets, BOOL isSelectOriginalPhoto) {
        if (completion) {
            completion(photos, assets, isSelectOriginalPhoto);
        }
    };
    [[CIGalleryManager sharedInstance] setAlbumWithCamera:NO];
    [[CIGalleryManager sharedInstance] IsAllowPickingVideo:NO IsAllowPickingImage:YES isAllowPickingGif:YES];
    [[CIGalleryManager sharedInstance] setCount:[count intValue]];
    [[CIGalleryManager sharedInstance] createAlbum:self];
}

- (void)chooseVideoFromAlbum:(BOOL)compressed completion:(void (^)(NSString * _Nonnull videoPathString))completion {
    [CIGalleryManager sharedInstance].pictureCompleteHandler = ^(NSArray<UIImage *> * _Nonnull photos, NSArray * _Nonnull assets, BOOL isSelectOriginalPhoto) {
        
    };
    [CIGalleryManager sharedInstance].videoSelectedCompleteHandler = ^(NSString * _Nonnull videoPathString) {
        if (completion) {
            completion(videoPathString);
        }
    };
    [CIGalleryManager sharedInstance].isSelectedVideoCompressed = NO;
    [[CIGalleryManager sharedInstance] setAlbumWithCamera:NO];
    [[CIGalleryManager sharedInstance] IsAllowPickingVideo:YES IsAllowPickingImage:NO isAllowPickingGif:NO];
    [[CIGalleryManager sharedInstance] createAlbum:self];
}

- (void)chooseFromAlbum:(NSNumber *)count sizeType:(NSArray<NSString *> *)sizeType mediaType:(NSArray<NSString *> *)mediaType completion:(void (^)(NSArray<UIImage *> *, NSArray *, BOOL))completion {
    [CIGalleryManager sharedInstance].pictureCompleteHandler = ^(NSArray<UIImage *> * _Nonnull photos, NSArray * _Nonnull assets, BOOL isSelectOriginalPhoto) {
        if (completion) {
            completion(photos, assets, isSelectOriginalPhoto);
        }
    };
    if (mediaType) {
        if (mediaType.count == 1) {
            NSString *type = mediaType[0];
            if ([type isEqualToString:@"image"]) {
                [[CIGalleryManager sharedInstance] IsAllowPickingVideo:NO IsAllowPickingImage:YES isAllowPickingGif:YES];
            } else if ([type isEqualToString:@"video"]) {
                [[CIGalleryManager sharedInstance] IsAllowPickingVideo:YES IsAllowPickingImage:NO isAllowPickingGif:NO];
            }
        } else {
            [[CIGalleryManager sharedInstance] IsAllowPickingVideo:YES IsAllowPickingImage:YES isAllowPickingGif:YES];
        }
    } else {
        [[CIGalleryManager sharedInstance] IsAllowPickingVideo:YES IsAllowPickingImage:YES isAllowPickingGif:YES];
    }
    [[CIGalleryManager sharedInstance] setAlbumWithCamera:NO];
    
    [[CIGalleryManager sharedInstance] setCount:[count intValue]];
    [[CIGalleryManager sharedInstance] createAlbum:self];
}

#pragma mark - UIDocumentPicker delegate
#pragma mark -

- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentAtURL:(NSURL *)url {
    BOOL canAccessingResource = [url startAccessingSecurityScopedResource];
    if(canAccessingResource) {
        NSFileCoordinator *fileCoordinator = [[NSFileCoordinator alloc] init];
        NSError *error;
        [fileCoordinator coordinateReadingItemAtURL:url options:0 error:&error byAccessor:^(NSURL *newURL) {
            NSData *fileData = [NSData dataWithContentsOfURL:newURL];
            NSString *fileName = [fileData md5String];
            NSString *appPath = [NSString stringWithFormat:@"%@/%@", kMiniProgramPath, [CIMPAppManager sharedManager].currentApp.appInfo.appId];
            NSString *tempDir = [appPath stringByAppendingString:@"/temp/"];
//            [fileData writeToFile:[tempDir stringByAppendingString:fileName] atomically:YES];
            [kFileManager createFileAtPath:[tempDir stringByAppendingString:fileName] contents:fileData attributes:nil];
            if (self.chooseFileCallback) {
                NSDictionary *tempFile = @{@"path": [@"/temp/" stringByAppendingString:fileName]};
                NSDictionary *result = @{@"errMsg": @"ok", @"tempFile": tempFile};
                self.chooseFileCallback(result);
            }
            
        }];
        if (error) {
            // error handing
        }
    } else {
        // startAccessingSecurityScopedResource fail
    }
    [url stopAccessingSecurityScopedResource];
}

#pragma mark - CLLocationManagerDelegate
#pragma mark -

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations {
    for (CLLocation *location in locations) {
        NSLog(@"altitude is %.2f, latitude is %.2f, longitude is %.2f", location.altitude, location.coordinate.latitude, location.coordinate.longitude);
        NSDictionary *result = @{@"errMsg": @"ok", @"latitude": @(location.coordinate.latitude), @"longitude": @(location.coordinate.longitude), @"altitude": @(location.altitude)};
        if (self.getLocationCallback) {
            self.getLocationCallback(result);
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
   
}

@end
