//
//  CIMPPageBridge.h
//  CIMiniProgram
//
//  Created by 袁鑫 on 2020/4/9.
//

#import <Foundation/Foundation.h>
#import "CIMPManagerProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@class CIMPPageBaseViewController;

@interface CIMPPageBridge : NSObject

@property (nonatomic, weak) id <CIMPManagerProtocol> manager;

@property (nonatomic, weak) CIMPPageBaseViewController *controller;

@end

NS_ASSUME_NONNULL_END
