//
//  CIMPNetworkManager.h
//  CIMiniProgram
//
//  Created by 袁鑫 on 2020/4/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CIMPNetworkManager : NSObject

@property (nonatomic, strong) NSMutableDictionary<NSString *, NSURLSessionTask *> *tasks;

+ (instancetype)sharedManager;

- (void)cancelTask:(NSDictionary *)param;

@end

NS_ASSUME_NONNULL_END
