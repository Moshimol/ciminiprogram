//
//  NSObject+CIMPJson.m
//  CIMiniProgram
//
//  Created by 袁鑫 on 2020/4/9.
//

#import "NSObject+CIMPJson.h"

@implementation NSString (CIMPJson)

- (id)mp_jsonObject {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    id object = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    return object;
}

@end

@implementation NSData (CIMPJson)

- (id)mp_jsonObject {
    id object = [NSJSONSerialization JSONObjectWithData:self options:NSJSONReadingMutableContainers error:nil];
    return object;
}

@end

@implementation NSDictionary (CIMPJson)

- (NSString *)mp_jsonString {
    NSData *data = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:nil];
    if (!data) {
        return nil;
    }
    
    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return jsonString;
}

@end

@implementation NSArray (CIMPJson)

- (NSString *)mp_jsonString {
    NSData *data = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:nil];
    if (!data) {
        return nil;
    }
    
    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return jsonString;
}

@end
