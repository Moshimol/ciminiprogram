//
//  CIMPManager.h
//  CIMiniProgram
//
//  Created by 袁鑫 on 2020/4/9.
//

#import <Foundation/Foundation.h>
#import "CIMPPageManager.h"
#import "CIMPPageApi.h"
#import "CIMPAppInfo.h"


NS_ASSUME_NONNULL_BEGIN

typedef void(^StartCompletion)(BOOL success, NSString *msg);

@interface CIMPManager : NSObject <CIMPManagerProtocol>

@property (nonatomic, strong, nullable) CIMPPageManager *pageManager;
@property (nonatomic, strong, nullable) CIMPPageApi *pageApi;
@property (nonatomic, strong) StartCompletion startRootCompletion;

/**
 设置小程序的入口

 @param controller App的NavigationController
 */
- (void)setupEntrance:(UINavigationController *)controller;

/**
 初始化

 @param appInfo appInfo对象
 @return WDHManager对象
 */
- (instancetype)initWithAppInfo:(CIMPAppInfo *)appInfo;

@end

NS_ASSUME_NONNULL_END
