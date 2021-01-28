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
    NSDate *detailDate= [NSDate dateWithTimeIntervalSince1970:[[NSDate date] timeIntervalSince1970]];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init]; //实例化一个NSDateFormatter对象
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];
    NSString *currentDateStr = [dateFormatter stringFromDate: detailDate];
    return currentDateStr;
}

@end
