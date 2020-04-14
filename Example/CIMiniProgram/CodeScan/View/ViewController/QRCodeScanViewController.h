//
//  QRCodeScanViewController.h
//  CIWallet
//
//  Created by 袁鑫 on 2019/11/14.
//  Copyright © 2019 Ci123. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class QRCodeScanViewController;

@protocol QRCodeScanDelegate <NSObject>

- (void)scanResult:(NSString *)result codeScanViewController:(QRCodeScanViewController *)qrCodeScanViewController;

@end

@interface QRCodeScanViewController : UIViewController

- (instancetype)initWithScanType:(nullable NSArray<NSString *> *)scanType onlyFromCamera:(nullable NSNumber *)onlyFromCamera callBackId:(NSString *)callBackId;

@property (nonatomic, weak) id <QRCodeScanDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
