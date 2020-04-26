//
//  CIMPShowActionSheet.m
//  CIMiniProgram
//
//  Created by 袁鑫 on 2020/4/10.
//

#import "CIMPShowActionSheet.h"
#import <UIKit/UIKit.h>
#import <CICategories/CICategories.h>
#import "CIMPAppManager.h"
#import "CIMPApp.h"


@implementation CIMPShowActionSheet

+ (void)showActionSheet:(NSDictionary *)param success:(void (^)(NSDictionary * _Nonnull))success fail:(void (^)(NSDictionary * _Nonnull))fail {
    NSArray<NSString *> *itemList = param[@"itemList"];
    if (!itemList || itemList.count <= 0 || itemList.count > 6) {
        if (fail) {
            fail(@{@"errMsg": @"fail", @"message": @"参数itemList不合法"});
            return;
        }
    }
    NSString *itemColor = param[@"itemColor"];
    // 如果参数不合法 设为默认值"#000000"
    if (!itemColor || itemColor.length != 7) {
        itemColor = @"#000000";
    }
    
    UIAlertController *alertCtrl = [[UIAlertController alloc] init];
    [itemList enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:obj style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (success) {
                success(@{@"errMsg": @"success", @"tapIndex": @(idx)});
            }
            
        }];
        
        [action setValue:[UIColor ColorWithHexString:itemColor] forKey:@"titleTextColor"];
        [alertCtrl addAction:action];
    }];
    
    // 添加取消action
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (fail) {
            fail(@{@"errMsg": @"fail", @"message": @"showActionSheet:fail cancel"});
        }
        
    }];
    [alertCtrl addAction:cancelAction];
    
    CIMPApp *app = [CIMPAppManager sharedManager].currentApp;
    [[app getRootPage] presentViewController:alertCtrl animated:YES completion:nil];
}

@end
