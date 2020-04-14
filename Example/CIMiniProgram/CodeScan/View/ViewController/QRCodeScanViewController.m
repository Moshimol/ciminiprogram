//
//  QRCodeScanViewController.m
//  CIWallet
//
//  Created by 袁鑫 on 2019/11/14.
//  Copyright © 2019 Ci123. All rights reserved.
//

#import "QRCodeScanViewController.h"
#import <SGQRCode/SGQRCode.h>
#import "MBProgressHUD+CodeScan.h"

#define kScreenWidth    [UIScreen mainScreen].bounds.size.width
#define kScreenHeight   [UIScreen mainScreen].bounds.size.height

@interface QRCodeScanViewController () {
    SGQRCodeObtain *obtain;
}

@property (nonatomic, strong) SGQRCodeScanView *scanView;
@property (nonatomic, assign) BOOL stop;
@property (nonatomic, strong) NSArray<NSString *> *scanType;
@property (nonatomic, strong) NSNumber *onlyFromCamera;
@property (nonatomic, strong) NSString *callBackId;

@end

@implementation QRCodeScanViewController

- (instancetype)initWithScanType:(NSArray<NSString *> *)scanType onlyFromCamera:(NSNumber *)onlyFromCamera callBackId:(NSString *)callBackId {
    if (self = [super init]) {
        _scanType = scanType;
        _onlyFromCamera = onlyFromCamera;
        _callBackId = callBackId;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
    
    if (_stop) {
        [obtain startRunningWithBefore:nil completion:nil];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.scanView addTimer];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.scanView removeTimer];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"扫一扫";
    self.view.backgroundColor = UIColor.blackColor;
    
    if (_onlyFromCamera && [_onlyFromCamera intValue] == 1) {
        [self setupNavigationBar];
    }
    
    obtain = [SGQRCodeObtain QRCodeObtain];
    
    [self setupQRCodeScan];
    [self.view addSubview:self.scanView];
}

- (void)setupNavigationBar {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"相册" style:UIBarButtonItemStyleDone target:self action:@selector(rightBarButtonItemAction)];
}

- (void)rightBarButtonItemAction {
    __weak typeof(self) weakSelf = self;

    [obtain establishAuthorizationQRCodeObtainAlbumWithController:nil];
    if (obtain.isPHAuthorization == YES) {
        [self.scanView removeTimer];
    }
    [obtain setBlockWithQRCodeObtainAlbumDidCancelImagePickerController:^(SGQRCodeObtain *obtain) {
        [weakSelf.view addSubview:weakSelf.scanView];
    }];
    [obtain setBlockWithQRCodeObtainAlbumResult:^(SGQRCodeObtain *obtain, NSString *result) {
        if (result == nil) {
            NSLog(@"暂未识别出二维码");
        } else {
            [weakSelf.delegate scanResult:result codeScanViewController:weakSelf];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    }];
}

- (void)setupQRCodeScan {
    __weak typeof(self) weakSelf = self;
    
    SGQRCodeObtainConfigure *configure = [SGQRCodeObtainConfigure QRCodeObtainConfigure];
    configure.openLog = YES;
    configure.rectOfInterest = CGRectMake(0.05, 0.2, 0.7, 0.6);
    NSArray *array = @[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypePDF417Code];
    configure.metadataObjectTypes = array;
    
    [obtain establishQRCodeObtainScanWithController:self configure:configure];
    [obtain startRunningWithBefore:^{
        [MBProgressHUD cs_showMBProgressHUDWithModifyStyleMessage:@"正在加载..." toView:weakSelf.view];
    } completion:^{
        [MBProgressHUD cs_hideHUDForView:weakSelf.view];
    }];
    [obtain setBlockWithQRCodeObtainScanResult:^(SGQRCodeObtain *obtain, NSString *result) {
        if (result) {
            [obtain stopRunning];
            weakSelf.stop = YES;
            
            [weakSelf.delegate scanResult:result codeScanViewController:weakSelf];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    }];
}

- (SGQRCodeScanView *)scanView {
    if (!_scanView) {
        _scanView = [[SGQRCodeScanView alloc] initWithFrame:CGRectMake(0.0, 0.0, kScreenWidth, kScreenHeight)];
        _scanView.scanImageName = @"QRCodeScanLine";
        _scanView.scanAnimationStyle = ScanAnimationStyleDefault;
        _scanView.cornerLocation = CornerLoactionOutside;
    }
    return _scanView;
}

- (void)removeScanView {
    [self.scanView removeTimer];
    [self.scanView removeFromSuperview];
    self.scanView = nil;
}

@end
