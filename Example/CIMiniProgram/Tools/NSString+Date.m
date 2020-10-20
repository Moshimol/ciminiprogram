//
//  NSString+Date.m
//  CIMiniProgram_Example
//
//  Created by lushitong on 2020/10/19.
//  Copyright © 2020 jasonyuan1986. All rights reserved.
//

#import "NSString+Date.h"

@implementation NSString (Date)

+ (NSString *)ciTimestamp {
    return @([[NSDate date] timeIntervalSince1970] * 1000).stringValue;
}

@end
