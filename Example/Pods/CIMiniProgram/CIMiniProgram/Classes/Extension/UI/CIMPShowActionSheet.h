//
//  CIMPShowActionSheet.h
//  CIMiniProgram
//
//  Created by 袁鑫 on 2020/4/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CIMPShowActionSheet : NSObject

+ (void)showActionSheet:(NSDictionary *)param success:(void(^)(NSDictionary *))success fail:(void(^)(NSDictionary *))fail;

@end

NS_ASSUME_NONNULL_END
