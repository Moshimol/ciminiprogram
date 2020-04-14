//
//  CIMPLog.m
//  CIMiniProgram
//
//  Created by 袁鑫 on 2020/4/9.
//  Copyright © 2020 Nanjing Xihui Information & Technology Co., Ltd. All rights reserved.
//

#import "CIMPLog.h"
#import "CIMPAppManager.h"
#import "CIMPApp.h"

@implementation CIMPLog

void MPLog(NSString *format, ...) {
    if (![CIMPAppManager sharedManager].enableLog) {
        return;
    }
    
    va_list args;
    va_start(args, format);
    
    NSString *message = [[NSString alloc] initWithFormat:format arguments:args];
    NSString *hodoerMessage = [NSString stringWithFormat:@"~~~~~MiniProgram %@:----->(%@)", [CIMPAppManager sharedManager].currentApp.appInfo.appId, message];
    
    printf("\n[%s] %s\n", __TIME__, [hodoerMessage UTF8String]);
    
    va_end(args);
}

@end
