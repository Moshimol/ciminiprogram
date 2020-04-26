//
//  CIMPNetwork.m
//  CIMiniProgram
//
//  Created by 袁鑫 on 2020/4/10.
//

#import "CIMPNetwork.h"
#import "CIMPAppInfo.h"
#import "CIMPFileMacro.h"
#import "CIMPAppManager.h"
#import "CIMPApp.h"
#import <CINetworking/CINetworking.h>
#import <CoreServices/CoreServices.h>

@implementation CIMPNetwork

+ (void)request:(NSDictionary *)param success:(void (^)(NSDictionary *))success fail:(void (^)(NSDictionary * _Nonnull))fail {
    NSString *urlString = param[@"url"];
    if (!urlString) {
        if (fail) {
            fail(@{@"errMsg": @"fail", @"message": @"url为空"});
        }
        return;
    }
    
    NSString *method = param[@"method"];
    NSDictionary *header = param[@"header"];
    id data = param[@"data"];
    
    CIHTTPSessionManager *manager = [CIHTTPSessionManager manager];
    manager.responseSerializer = [CIHTTPResponseSerializer serializer];
    
    CIHTTPMethod requestMethod;
    
    if ([method.uppercaseString isEqualToString:@"POST"]) {
        requestMethod = CIHTTPMethodPOST;
    } else {
        requestMethod = CIHTTPMethodGET;
    }
    
    if ([method.uppercaseString isEqualToString:@"POST"]) {
        requestMethod = CIHTTPMethodPOST;
    } else {
        requestMethod = CIHTTPMethodGET;
    }
    
    if (header) {
        if (header[@"content-type"]) {
            if ([header[@"content-type"] isEqualToString:@"application/json"]) {
                manager.requestSerializer = [CIJSONRequestSerializer serializer];
            }
        }
    }
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", @"text/plain", nil];
    [manager request:urlString method:requestMethod headers:header parameters:data progress:^(NSProgress * _Nonnull progress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
            NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSDictionary *fields = [response allHeaderFields];
            NSString *cookieString = [[response allHeaderFields] valueForKey:@"Set-Cookie"];
            NSArray *cookies = nil;
            if (cookieString) {
                cookies = [cookieString componentsSeparatedByString:@"&"];
            } else {
                cookies = @[];
            }
            if (success) {
                NSDictionary *result = @{@"errMsg": @"ok", @"data": responseString, @"statusCode": @(response.statusCode), @"header": fields, @"cookies": cookies};
                success(result);
            }
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        NSDictionary *fields = [response allHeaderFields];
        NSString *cookieString = [[response allHeaderFields] valueForKey:@"Set-Cookie"];
        NSArray *cookies = nil;
        if (cookieString) {
            cookies = [cookieString componentsSeparatedByString:@"&"];
        } else {
            cookies = @[];
        }
        if (success) {
            NSDictionary *result = @{@"errMsg": @"ok", @"data": error.localizedDescription, @"statusCode": @(response.statusCode), @"header": fields, @"cookies": cookies};
            success(result);
        }
    }];
}

+ (void)downloadFile:(NSDictionary *)param success:(void (^)(NSDictionary * _Nonnull))success fail:(void (^)(NSDictionary * _Nonnull))fail {
    NSString *urlString = param[@"url"];
    if (!urlString) {
        if (fail) {
            fail(@{@"errMsg": @"fail", @"message": @"url参数为空"});
            return;
        }
    }
    NSDictionary *header = param[@"header"];
    NSNumber *timeout = param[@"timeout"];
    NSString *filePath = param[@"filePath"];
    __block NSString *tempFilePath = @"";
    
    if (timeout) {
        [CINetworking sharedInstance].timeoutInterval = [timeout doubleValue];
    }
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    // Set Header
    if (header) {
        [header enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [request setValue:obj forHTTPHeaderField:key];
        }];
    }
    
    NSURLSessionDownloadTask *downloadTask = [[CINetworking sharedInstance] downloadTask:request parameters:nil progress:^(NSProgress * _Nonnull progress) {
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        CIMPApp *app = [CIMPAppManager sharedManager].currentApp;
        NSString *destination = @"";
        
        if (filePath) {
            destination = [NSString stringWithFormat:@"file://%@/%@/%@", kMiniProgramPath, app.appInfo.appId, filePath];
        } else {
            NSDate *date = [NSDate date];
            NSTimeInterval time = [date timeIntervalSince1970]*1000;
            destination = [NSString stringWithFormat:@"file://%@/%@/temp/%f", kMiniProgramPath, app.appInfo.appId, time];
            
            tempFilePath = [NSString stringWithFormat:@"/temp/%f", time];
        }
        
        return [NSURL URLWithString:destination];
    } success:^(NSURLResponse * _Nonnull response, NSURL * _Nonnull fileDownloadPath) {
        if (success) {
            NSHTTPURLResponse *urlResponse = (NSHTTPURLResponse *)response;
            if (filePath) {
                NSDictionary *result = @{@"errMsg": @"ok", @"filePath": filePath, @"statusCode": @(urlResponse.statusCode)};
                success(result);
            } else {
                NSDictionary *result = @{@"errMsg": @"ok", @"tempFilePath": tempFilePath, @"statusCode": @(urlResponse.statusCode)};
                success(result);
            }
        }
    } failure:^(NSURLResponse * _Nonnull response, NSError * _Nonnull error) {
        if (fail) {
            fail(@{@"errMsg": @"fail", @"message": error.localizedDescription});
        }
    }];
    [downloadTask resume];
}

+ (void)uploadFile:(NSDictionary *)param success:(void (^)(NSDictionary * _Nonnull))success fail:(void (^)(NSDictionary * _Nonnull))fail {
    NSString *urlString = param[@"url"];
    if (!urlString) {
        if (fail) {
            fail(@{@"errMsg": @"fail", @"message": @"url参数为空"});
            return;
        }
    }

    NSString *filePath = param[@"filePath"];
    if (!filePath) {
        if (fail) {
            fail(@{@"errMsg": @"fail", @"message": @"filePath参数为空"});
            return;
        }
    }
    CIMPApp *app = [CIMPAppManager sharedManager].currentApp;
    NSString *fullPath = [kMiniProgramPath stringByAppendingString:[NSString stringWithFormat:@"/%@%@", app.appInfo.appId, filePath]];
    
    if (![kFileManager fileExistsAtPath:fullPath]) {
        if (fail) {
            fail(@{@"errMsg": @"fail", @"message": @"filePath指向的文件不存在"});
            return;
        }
    }

    NSString *name = param[@"name"];
    if (!name) {
        if (fail) {
            fail(@{@"errMsg": @"fail", @"message": @"name参数为空"});
            return;
        }
    }

    NSDictionary *header = param[@"header"];
    NSDictionary *formData = param[@"formData"];
    NSNumber *timeout = param[@"timeout"];

    if (timeout) {
        [CINetworking sharedInstance].timeoutInterval = [timeout doubleValue];
    }

    NSMutableURLRequest *request = [[CIHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:urlString parameters:formData constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSData *fileData = [[NSData alloc] initWithContentsOfFile:fullPath];
        NSArray *pathArray = [fullPath componentsSeparatedByString:@"/"];
        NSString *fileName = pathArray.lastObject;
        NSString *mimeType = [self mimeTypeForFileAtPath:fullPath];
        [formData appendPartWithFileData:fileData name:name fileName:fileName mimeType:mimeType];
    } error:nil];
    
    // Set Header
    if (header) {
        [header enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [request setValue:obj forHTTPHeaderField:key];
        }];
    }
    
    NSURLSessionDataTask *uploadTask = [[CINetworking sharedInstance] uploadTask:request progress:^(NSProgress * _Nonnull progress) {
        
    } success:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject) {
        if (success) {
            success(@{@"errMsg": @"ok"});
        }
    } failure:^(NSURLResponse * _Nonnull response, NSError * _Nonnull error) {
        if (fail) {
            fail(@{@"errMsg": @"fail"});
        }
    }];
    [uploadTask resume];
}

+ (NSString *)mimeTypeForFileAtPath:(NSString *)path {
    
    CFStringRef UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)[path pathExtension], NULL);
    CFStringRef MIMEType = UTTypeCopyPreferredTagWithClass(UTI, kUTTagClassMIMEType);
    CFRelease(UTI);
    if (!MIMEType) {
        return @"application/octet-stream";
    }
    return (__bridge NSString *)(MIMEType);
}

@end
