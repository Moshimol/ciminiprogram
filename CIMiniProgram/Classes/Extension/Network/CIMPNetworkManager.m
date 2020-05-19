//
//  CIMPNetworkManager.m
//  CIMiniProgram
//
//  Created by 袁鑫 on 2020/4/27.
//

#import "CIMPNetworkManager.h"

static CIMPNetworkManager *_instance = nil;

@implementation CIMPNetworkManager

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_instance == nil) {
            _instance = [[self alloc] init];
        }
    });
    return _instance;
}

- (void)cancelTask:(NSDictionary *)param {
    NSString *callbackId = param[@"callbackId"];
    NSURLSessionTask *task = [self.tasks objectForKey:callbackId];
    if (task) {
        [task cancel];
    } else {
        NSLog(@"task with Id-%@ not found", callbackId);
    }
    
}

@end
