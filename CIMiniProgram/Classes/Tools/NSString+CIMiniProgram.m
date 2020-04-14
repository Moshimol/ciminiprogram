//
//  NSString+CIMiniProgram.m
//  CIMiniProgram
//
//  Created by 袁鑫 on 2020/4/9.
//

#import "NSString+CIMiniProgram.h"

@implementation NSString (CIMiniProgram)

- (unsigned long long)unsignedLongLongValue {
    unsigned long long ullvalue = strtoull([self UTF8String], NULL, 0);
    return ullvalue;
}

@end
