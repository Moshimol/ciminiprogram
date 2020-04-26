//
//  CIScanViewController.m
//  CICamera
//
//  Created by 大大大大_荧🐾 on 2020/2/21.
//  Copyright © 2020 大大大大_荧🐾. All rights reserved.
//

#import "CIScanViewController.h"
@import AVFoundation;
#import "CIScanView.h"

@interface CIScanViewController ()<AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, strong) AVCaptureDevice *device;
@property (nonatomic, strong) AVCaptureMetadataOutput *output;
@property (nonatomic, strong) AVCaptureDeviceInput *input;
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *preview;
@property (nonatomic, assign) Boolean isSessionStart;

@end

@implementation CIScanViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isSessionStart = NO;
        self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        self.input = [[AVCaptureDeviceInput alloc] initWithDevice:self.device error:nil];
        self.output = [[AVCaptureMetadataOutput alloc] init];
        self.preview = [[AVCaptureVideoPreviewLayer alloc] init];
        self.session = [[AVCaptureSession alloc] init];
        self.session.sessionPreset = AVCaptureSessionPresetHigh;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    NSLog(@"摄像头初始化中...");
    [self structCIScanCaptureData];
    CIScanView *scanView = [[CIScanView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:scanView];
    [self.session startRunning];
    self.isSessionStart = YES;
    [self structNavigation];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.isSessionStart == YES) {
        [self.session stopRunning];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.isSessionStart == YES) {
        [self.session startRunning];
    }
}

- (void) structCIScanCaptureData {
    if ([self.session canAddInput:self.input]) {
        [self.session addInput:self.input];
    }
    if ([self.session  canAddOutput:self.output]) {
        [self.session addOutput:self.output];
    }
    [self.output setMetadataObjectsDelegate:self queue: dispatch_get_main_queue()];
    if (self.output.availableMetadataObjectTypes.count != 0) {
        self.output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeEAN13Code];
    }
    self.preview = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    self.preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.preview.frame = self.view.layer.bounds;
    [self.view.layer insertSublayer:self.preview atIndex:0];
}

- (void) structNavigation {
    self.title = @"扫码";
    NSBundle *imageBundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:[CIScanView class]] pathForResource: @"CICameraImage" ofType: @"bundle"]];
    NSString *name = @"return_new@2x";
    NSString *imagePath = [imageBundle pathForResource:name ofType:@"png"];
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    if (!image) {
        // 兼容业务方自己设置图片的方式
        name = [name stringByReplacingOccurrencesOfString:@"@2x" withString:@""];
        image = [UIImage imageNamed:name];
    }
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:image forState:UIControlStateNormal];
    [backButton setTitle:@" 返回" forState:UIControlStateNormal];
    [backButton setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
    backButton.frame = CGRectMake(10, [[UIApplication sharedApplication] statusBarFrame].size.height + 20, 80, 40);
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
}

- (void) back {
    [self dismissViewControllerAnimated: YES completion:nil];
}

#pragma mark - 扫码回调

- (void)captureOutput:(AVCaptureOutput *)output didOutputMetadataObjects:(NSArray<__kindof AVMetadataObject *> *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    if (metadataObjects.count > 0) {
        [self.session stopRunning];
        NSString *resultString = @"";
        for (AVMetadataObject *obj in metadataObjects) {
            if ([obj isKindOfClass:[AVMetadataMachineReadableCodeObject class]]) {
                resultString = ((AVMetadataMachineReadableCodeObject *)obj).stringValue;
                if (self.completeScanWithReslut) {
                    self.completeScanWithReslut(resultString);
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
                break;
            }
        }
    } else {
        NSLog(@"二维码扫描失败");
    }
}

@end
