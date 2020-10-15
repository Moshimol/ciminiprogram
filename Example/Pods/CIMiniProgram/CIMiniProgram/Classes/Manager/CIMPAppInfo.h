//
//  CIMPAppInfo.h
//  CIMiniProgram
//
//  Created by 袁鑫 on 2020/4/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CIMPAppInfo : NSObject

@property (nonatomic, copy) NSString *appId;        // AppID小程序唯一标识

@property (nonatomic, copy) NSString *appPath;

@property (nonatomic, copy) NSString *appURL;

@end

NS_ASSUME_NONNULL_END
