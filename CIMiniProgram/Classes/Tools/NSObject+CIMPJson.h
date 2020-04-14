//
//  NSObject+CIMPJson.h
//  CIMiniProgram
//
//  Created by 袁鑫 on 2020/4/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (CIMPJson)

- (id)mp_jsonObject;

@end

@interface NSData (CIMPJson)

- (id)mp_jsonObject;

@end

@interface NSDictionary (CIMPJson)

- (NSString *)mp_jsonString;

@end

@interface NSArray (CIMPJson)

- (NSString *)mp_jsonString;

@end

NS_ASSUME_NONNULL_END
