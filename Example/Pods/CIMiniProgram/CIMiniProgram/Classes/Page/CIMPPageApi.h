//
//  CIMPPageApi.h
//  CIMiniProgram
//
//  Created by 袁鑫 on 2020/4/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class CIMPPageManager;

@interface CIMPPageApi : NSObject

@property (nonatomic, copy) NSString *basePath;

- (instancetype)initWithPageManager:(CIMPPageManager *)pageManager;

/**
 收到内部API请求

 @param command api名
 @param param 参数
 */
- (void)receive:(NSString *)command param:(NSDictionary *)param;

@end

NS_ASSUME_NONNULL_END
