//
//  CIViewController.m
//  CIMiniProgram
//
//  Created by jasonyuan1986 on 04/09/2020.
//  Copyright (c) 2020 jasonyuan1986. All rights reserved.
//

#import "CIViewController.h"
#import "UIImage+Category.h"
#import "QRCodeScanViewController.h"
#import <Masonry/Masonry.h>
#import <AVFoundation/AVFoundation.h>
#import <CIMiniProgram/CIMiniProgram.h>

#define kScreenWidth    [UIScreen mainScreen].bounds.size.width
#define kScreenHeight   [UIScreen mainScreen].bounds.size.height
#define kStatusBarHeight UIApplication.sharedApplication.statusBarFrame.size.height

#define kRGB(r,g,b)   [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]
#define kRGBA(r,g,b,a)   [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:(a)]
#define kRGBHex(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define kRGBAHex(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)]

#ifdef DEBUG

#define NSLog(format,...) printf("\n[%s] %s [Line %d] %s\n",__TIME__,__FUNCTION__,__LINE__,[[NSString stringWithFormat:format,##__VA_ARGS__] UTF8String])

#else

#define NSLog(format,...)

#endif

@interface CIViewController () <UITableViewDelegate, UITableViewDataSource, QRCodeScanDelegate>

@property (nonatomic, strong) UITextView *urlTextView;
@property (nonatomic, strong) UITextField *appIdTextField;
@property (nonatomic, strong) UITableView *mpListView;
@property (nonatomic, strong) NSArray *mpList;

@end

@implementation CIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.title = @"小程序测试";
    self.view.backgroundColor = UIColor.whiteColor;
    
    NSString *sharedData = @"{\"token\":\"123456\"}";
    [[NSUserDefaults standardUserDefaults] setValue:sharedData forKey:@"MiniProgram"];
    
    [self setupViews];
}

#pragma mark - Private
#pragma mark -

- (void)setupViews {
    UILabel *urlTitleLabel = [[UILabel alloc] init];
    urlTitleLabel.text = @"小程序包地址";
    urlTitleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:16.0];
    [self.view addSubview:urlTitleLabel];
    
    _urlTextView = [[UITextView alloc] init];
    _urlTextView.backgroundColor = UIColor.whiteColor;
    _urlTextView.textColor = UIColor.blackColor;
    _urlTextView.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14.0];
    _urlTextView.layer.borderColor = UIColor.grayColor.CGColor;
    _urlTextView.layer.cornerRadius = 5.0;
    _urlTextView.layer.borderWidth = 1.0;
    [self.view addSubview:_urlTextView];
    
    _appIdTextField = [[UITextField alloc] init];
    _appIdTextField.backgroundColor = UIColor.whiteColor;
    _appIdTextField.textColor = UIColor.blackColor;
    _appIdTextField.placeholder = @"appId";
    _appIdTextField.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14.0];
    _appIdTextField.layer.borderColor = UIColor.grayColor.CGColor;
    _appIdTextField.layer.cornerRadius = 5.0;
    _appIdTextField.layer.borderWidth = 1.0;
    [self.view addSubview:_appIdTextField];
    
    UIButton *scanButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [scanButton setTitle:@"扫一扫获取地址" forState:UIControlStateNormal];
    [scanButton setTitleColor:kRGBA(255, 255, 255, 0.8) forState:UIControlStateNormal];
    [scanButton setBackgroundImage:[UIImage imageWithColor:kRGB(62, 142, 226)] forState:UIControlStateNormal];
    [scanButton addTarget:self action:@selector(scanBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:scanButton];
    
    UIButton *downloadButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [downloadButton setTitle:@"下载小程序" forState:UIControlStateNormal];
    [downloadButton setTitleColor:kRGBA(255, 255, 255, 0.8) forState:UIControlStateNormal];
    [downloadButton setBackgroundImage:[UIImage imageWithColor:kRGB(62, 142, 226)] forState:UIControlStateNormal];
    [downloadButton addTarget:self action:@selector(downloadBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:downloadButton];
    
    UILabel *miniProgramListLabel = [[UILabel alloc] init];
    miniProgramListLabel.text = @"小程序列表";
    miniProgramListLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:16.0];
    [self.view addSubview:miniProgramListLabel];
    
    _mpListView = [[UITableView alloc] init];
    _mpListView.backgroundColor = UIColor.whiteColor;
    _mpListView.dataSource = self;
    _mpListView.delegate = self;
    [self.view addSubview:_mpListView];
    
    [urlTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10);
        make.top.equalTo(self.view).offset(kStatusBarHeight + 54);
        make.right.equalTo(self.view).offset(-10);
        make.height.mas_equalTo(20);
    }];
    
    [_urlTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(urlTitleLabel.mas_left);
        make.top.equalTo(urlTitleLabel.mas_bottom).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.height.mas_equalTo(60);
    }];
    
    [_appIdTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(urlTitleLabel.mas_left);
        make.top.equalTo(_urlTextView.mas_bottom).offset(5);
        make.right.equalTo(self.view).offset(-10);
        make.height.mas_equalTo(30);
    }];
    
    [scanButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_urlTextView.mas_left);
        make.top.equalTo(_appIdTextField.mas_bottom).offset(10);
        make.right.equalTo(_urlTextView.mas_right);
        make.height.mas_equalTo(30);
    }];
    
    [downloadButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(scanButton.mas_bottom).offset(10);
        make.left.equalTo(scanButton.mas_left);
        make.right.equalTo(scanButton.mas_right);
        make.height.mas_equalTo(30);
    }];
    
    [miniProgramListLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(downloadButton.mas_bottom).offset(10);
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.height.mas_equalTo(20);
    }];
    
    [_mpListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(miniProgramListLabel.mas_bottom);
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.bottom.equalTo(self.view).offset(-49);
    }];
    
    self.mpList = [[CIMPAppManager sharedManager] getApplist];
    [self.mpListView reloadData];
}

- (void)reloadMPList {
    _mpList = [[[CIMPAppManager sharedManager] getApplist] mutableCopy];
    [self.mpListView reloadData];
    
}

- (void)showCodeScan:(QRCodeScanViewController *)codeScanViewController {
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device) {
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        switch (status) {
            case AVAuthorizationStatusNotDetermined: {
                [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                    if (granted) {
                        dispatch_sync(dispatch_get_main_queue(), ^{
                            [self.navigationController pushViewController:codeScanViewController animated:YES];
                        });
                    }
                }];
                break;
            }
            case AVAuthorizationStatusAuthorized: {
                [self.navigationController pushViewController:codeScanViewController animated:YES];
                break;
            }
            case AVAuthorizationStatusDenied: {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请去-> [设置 - 隐私 - 相机] 打开访问开关" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                [alertController addAction:alertAction];
                [self presentViewController:alertController animated:YES completion:nil];
                break;
            }
            case AVAuthorizationStatusRestricted: {
                break;
            }
            default:
                break;
        }
    } else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"未检测到摄像头" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertController addAction:alertAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

#pragma mark - Events
#pragma mark -

- (void)scanBtnClicked:(id)sender {
    QRCodeScanViewController *codeScanViewController = [[QRCodeScanViewController alloc] init];
    codeScanViewController.delegate = self;
    [self showCodeScan:codeScanViewController];
}

- (void)downloadBtnClicked:(id)sender {
//    [CIMPApp createDirectory];
    NSString *downloadURL = self.urlTextView.text;
    CIMPAppInfo *appInfo = [[CIMPAppInfo alloc] init];
    appInfo.appId = _appIdTextField.text;
    CIMPApp *app = [[CIMPApp alloc] initWithAppInfo:appInfo];
    [app donwloadApp:downloadURL completion:^(BOOL success, NSString * _Nonnull errMsg) {
        if (success) {
            self.mpList = [[CIMPAppManager sharedManager] getApplist];
            [self.mpListView reloadData];
        } else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:errMsg preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [alert dismissViewControllerAnimated:YES completion:^{
                    
                }];
            }];
            [alert addAction:ok];
            [self presentViewController:alert animated:YES completion:^{
                
            }];
        }
    }];
}

#pragma mark - QRCodeScanDelegate

- (void)scanResult:(NSString *)result codeScanViewController:(nonnull QRCodeScanViewController *)qrCodeScanViewController {
    _urlTextView.text = result;
}

#pragma mark - UITable view dataSource
#pragma mark -

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MiniProgramListCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MiniProgramListCell"];
    }
    cell.textLabel.text = _mpList[indexPath.row];
    cell.backgroundColor = UIColor.whiteColor;
    cell.textLabel.textColor = UIColor.blackColor;
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _mpList.count;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *name = _mpList[indexPath.row];
    CIMPAppInfo *appInfo = [[CIMPAppInfo alloc] init];
    appInfo.appId = name;
    CIMPApp *app = [[CIMPApp alloc] initWithAppInfo:appInfo];
    [app deleteApp:^(BOOL success, NSString * _Nonnull errMsg) {
        if (success) {
            NSLog(@"%@", errMsg);
            [self reloadMPList];
        } else {
            NSLog(@"%@", errMsg);
        }
    }];
}

#pragma mark - UITable view delegate
#pragma mark -

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CIMPAppInfo *appInfo = [CIMPAppInfo new];
    appInfo.appId = _mpList[indexPath.row];
    appInfo.appPath = @"1234";
    
    CIMPApp *mpApp = [[CIMPApp alloc] initWithAppInfo:appInfo];
    NSArray *titles = @[@"test1", @"test2"];
    [mpApp setMoreButton:titles action:^(NSInteger index) {
        NSLog(@"click button %ld", (long)index);
    }];
    [mpApp startAppWithEntrance:self.navigationController completion:^(BOOL success, NSString * _Nonnull msg) {
        NSLog(@"%@", msg);
    }];
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
