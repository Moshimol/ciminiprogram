//
//  CIHTTPSessionManager.m
//  CINetWorking
//
//  Created by 曹中浩 on 2020/2/17.
//

#import "CIHTTPSessionManager.h"

@interface CIHTTPSessionManager ()




@end

@implementation CIHTTPSessionManager


# pragma getter/setter

- (NSURL *)baseURL{
    return self.sessionManager.baseURL;
}

-(AFHTTPRequestSerializer *)requestSerializer{
    return self.sessionManager.requestSerializer;
}

-(void)setRequestSerializer:(CIHTTPRequestSerializer *)requestSerializer{
    self.sessionManager.requestSerializer = requestSerializer;
}

- (AFHTTPResponseSerializer *)responseSerializer{
    return self.sessionManager.responseSerializer;
}

-(void)setResponseSerializer:(CIHTTPResponseSerializer *)responseSerializer{
    self.sessionManager.responseSerializer = responseSerializer;
}

- (AFSecurityPolicy *)securityPolicy{
    return self.sessionManager.securityPolicy;
}

- (void)setSecurityPolicy:(AFSecurityPolicy *)securityPolicy{
    self.sessionManager.securityPolicy = securityPolicy;
}

# pragma creator
+(instancetype)manager{
    return [[[self class]alloc]initWithBaseURL:nil];
}

# pragma initializer
-(instancetype)init{
    return [self initWithBaseURL:nil];
}

-(instancetype)initWithBaseURL:(nullable NSURL *)url{
    return [self initWithBaseURL:url sessionConfiguration:nil];
}

-(instancetype)initWithBaseURL:(nullable NSURL *)url sessionConfiguration:(nullable NSURLSessionConfiguration *)configuration{
    self = [super init];
    if(self){
        _sessionManager = [[AFHTTPSessionManager alloc]initWithBaseURL:url sessionConfiguration:configuration];
        self.requestSerializer = [[CIHTTPRequestSerializer alloc]init];
        self.responseSerializer = [[CIJSONResponseSerializer alloc]init];
    }
    return self;
}


-(nullable NSURLSessionDataTask *)request:(NSString *)URLString
                                   method:(NSString *)method
                                  timeout:(NSTimeInterval)timeout
                                  headers:(nullable NSDictionary <NSString *, NSString *> *)headers
                               parameters:(nullable id)parameters
                                  success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                                  failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure{
    NSError *serializationError = nil;
    // 创建request
    NSString * URL = [[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString];
    if([[method uppercaseString]isEqualToString:@"GET"]&&[parameters isKindOfClass:NSString.class]){
        URL = [URL stringByAppendingFormat:@"?%@",parameters];
        parameters = nil;
    }
    NSMutableURLRequest *request = [self.sessionManager.requestSerializer requestWithMethod:method URLString:URL parameters:parameters error:&serializationError];
    // 设置timeout
    [request setTimeoutInterval:timeout];
    // 设置header
    for (NSString *headerField in headers.keyEnumerator) {
        [request setValue:headers[headerField] forHTTPHeaderField:headerField];
    }
    if (serializationError) {
        if (failure) {
            dispatch_async(self.sessionManager.completionQueue ?: dispatch_get_main_queue(), ^{
                failure(nil, serializationError);
            });
        }
        
        return nil;
    }
    // 创建dataTask
    __block NSURLSessionDataTask *dataTask = nil;
    dataTask = [self.sessionManager dataTaskWithRequest:request
                          uploadProgress:nil
                        downloadProgress:nil
                       completionHandler:^(NSURLResponse * __unused response, id responseObject, NSError *error) {
        if (error) {
            if (failure) {
                failure(dataTask, error);
            }
        } else {
            if (success) {
                success(dataTask, responseObject);
            }
        }
    }];

    return dataTask;
}

# pragma request
-(nullable NSURLSessionDataTask *)request:(NSString *)URLString
                                   method:(CIHTTPMethod)method
                               parameters:(id)parameters
                                  success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                                  failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure
{
    return [self request:URLString method:method headers:nil parameters:parameters progress:nil success:success failure:failure];
}

-(nullable NSURLSessionDataTask *)request:(NSString *)URLString
                                   method:(CIHTTPMethod)method
                               parameters:(id)parameters
                                 progress:(nullable void(^)(NSProgress * progress))progress
                                  success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                                  failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure{
    return [self request:URLString method:method headers:nil parameters:parameters progress:progress success:success failure:failure];
}

-(nullable NSURLSessionDataTask *)request:(NSString *)URLString
                                   method:(CIHTTPMethod)method
                                  headers:(nullable NSDictionary <NSString *, NSString *> *)headers
                               parameters:(id)parameters
                                 progress:(nullable void(^)(NSProgress * progress))progress
                                  success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                                  failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure{
    NSURLSessionDataTask * sessionDataTask;
    switch (method) {
        case CIHTTPMethodGET:{
            sessionDataTask = [self GET:URLString parameters:parameters headers:headers progress:progress success:success failure:failure];
            break;
        }
        case CIHTTPMethodHEAD:{
            sessionDataTask = [self HEAD:URLString parameters:parameters headers:headers success:^(NSURLSessionDataTask * _Nonnull task) {
                if(success){
                    success(task,nil);
                }
            } failure:failure];
            break;
        }
        case CIHTTPMethodPOST:{
            sessionDataTask = [self POST:URLString parameters:parameters headers:headers progress:progress success:success failure:failure];
            break;
        }
        case CIHTTPMethodPUT:{
            sessionDataTask = [self PUT:URLString parameters:parameters headers:headers success:success failure:failure];
            break;
        }
        case CIHTTPMethodPATCH:{
            sessionDataTask = [self PATCH:URLString parameters:parameters headers:headers success:success failure:failure];
            break;
        }
        case CIHTTPMethodDELETE:{
            sessionDataTask = [self DELETE:URLString parameters:parameters headers:headers success:success failure:failure];
            break;
        }
        case CIHTTPMethodOPTIONS:{
            break;
        }
        case CIHTTPMethodCONNECT:{
            break;
        }
        case CIHTTPMethodTRACE:{
            break;
        }
        default:
            break;
    }
    return sessionDataTask;
}

-(nullable NSURLSessionDataTask *)uploadFile:(NSString *)URLString
                                  parameters:(id)parameters
                              fileParameters:(NSDictionary *)fileParameters
                                    progress:(nullable void(^)(NSProgress * progress))progress
                                    success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                                     failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure
{
    NSURLSessionDataTask * sessionDataTask = [self POST:URLString parameters:parameters headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:fileParameters[@"data"] name:fileParameters[@"name"] fileName:fileParameters[@"fileName"] mimeType:fileParameters[@"mimeType"]];
    } progress:progress success:success failure:failure];
    return sessionDataTask;
}

-(nullable NSURLSessionDataTask *)uploadTask:(NSURLRequest *)request
                                    progress:(nullable void(^)(NSProgress * progress))progress
                                     success:(nullable void(^)(NSURLResponse * _Nonnull response, id  _Nullable responseObject))success
                                     failure:(nullable void(^)(NSURLResponse * _Nonnull response, NSError * error))failure{
    return [self.sessionManager uploadTaskWithStreamedRequest:request progress:progress completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if(!error){
            if(success){
                success(response,responseObject);
            }
        }
        else{
            if(failure){
                failure(response,error);
            }
        }
    }];
}

-(nullable NSURLSessionDataTask *)downloadFile:(NSString *)URLString
                                    parameters:(id)parameters
                                      progress:(nullable void(^)(NSProgress * progress))progress
                                       success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                                       failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure
{
    return [self GET:URLString parameters:parameters headers:nil progress:progress success:success failure:failure];
}

-(nullable NSURLSessionDownloadTask *)downloadTask:(NSURLRequest *)request
                                    parameters:(nullable NSDictionary *)parameters
                                      progress:(nullable void(^)(NSProgress * progress))progress
                                   destination:(NSURL * (^)(NSURL *targetPath, NSURLResponse *response))destination
                                       success:(nullable void(^)(NSURLResponse * response,NSURL * filePath))success
                                       failure:(nullable void(^)(NSURLResponse * response,NSError * error))failure{
    return [self.sessionManager downloadTaskWithRequest:request progress:progress destination:destination completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if(!error){
            if(success){
                success(response,filePath);
            }
        }
        else{
            if(failure){
                failure(response,error);
            }
        }
    }];
}

- (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(id)parameters
                      success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                      failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{

    return [self GET:URLString parameters:parameters headers:nil progress:nil success:success failure:failure];
}

- (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(id)parameters
                     progress:(void (^)(NSProgress * _Nonnull))downloadProgress
                      success:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nullable))success
                      failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure
{

    return [self GET:URLString parameters:parameters headers:nil progress:downloadProgress success:success failure:failure];
}

- (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(id)parameters
                      headers:(nullable NSDictionary <NSString *, NSString *> *)headers
                     progress:(void (^)(NSProgress * _Nonnull))downloadProgress
                      success:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nullable))success
                      failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure
{
    
    if([parameters isKindOfClass:NSString.class]){
        URLString = [URLString stringByAppendingFormat:@"?%@",parameters];
        parameters = nil;
    }
    NSURLSessionDataTask *dataTask = [self dataTaskWithHTTPMethod:@"GET"
                                                        URLString:URLString
                                                       parameters:parameters
                                                          headers:headers
                                                   uploadProgress:nil
                                                 downloadProgress:downloadProgress
                                                          success:success
                                                          failure:failure];
    
    [dataTask resume];
    
    return dataTask;
}

- (NSURLSessionDataTask *)HEAD:(NSString *)URLString
                    parameters:(id)parameters
                       success:(void (^)(NSURLSessionDataTask *task))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    return [self HEAD:URLString parameters:parameters headers:nil success:success failure:failure];
}

- (NSURLSessionDataTask *)HEAD:(NSString *)URLString
                    parameters:(id)parameters
                       headers:(NSDictionary<NSString *,NSString *> *)headers
                       success:(void (^)(NSURLSessionDataTask * _Nonnull))success
                       failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure
{
    NSURLSessionDataTask *dataTask = [self dataTaskWithHTTPMethod:@"HEAD" URLString:URLString parameters:parameters headers:headers uploadProgress:nil downloadProgress:nil success:^(NSURLSessionDataTask *task, __unused id responseObject) {
        if (success) {
            success(task);
        }
    } failure:failure];
    
    [dataTask resume];
    
    return dataTask;
}

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    return [self POST:URLString parameters:parameters headers:nil progress:nil success:success failure:failure];
}

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
                      progress:(void (^)(NSProgress * _Nonnull))uploadProgress
                       success:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nullable))success
                       failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure
{
    return [self POST:URLString parameters:parameters headers:nil progress:uploadProgress success:success failure:failure];
}

- (nullable NSURLSessionDataTask *)POST:(NSString *)URLString
                             parameters:(nullable id)parameters
                                headers:(nullable NSDictionary <NSString *, NSString *> *)headers
                               progress:(nullable void (^)(NSProgress *uploadProgress))uploadProgress
                                success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                                failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure
{
    NSURLSessionDataTask *dataTask = [self dataTaskWithHTTPMethod:@"POST" URLString:URLString parameters:parameters headers:headers uploadProgress:uploadProgress downloadProgress:nil success:success failure:failure];
    
    [dataTask resume];
    
    return dataTask;
}

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(nullable id)parameters
     constructingBodyWithBlock:(nullable void (^)(id<AFMultipartFormData> _Nonnull))block
                       success:(nullable void (^)(NSURLSessionDataTask * _Nonnull, id _Nullable))success
                       failure:(nullable void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure
{
    return [self POST:URLString parameters:parameters headers:nil constructingBodyWithBlock:block progress:nil success:success failure:failure];
}

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
     constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                      progress:(nullable void (^)(NSProgress * _Nonnull))uploadProgress
                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    return [self POST:URLString parameters:parameters headers:nil constructingBodyWithBlock:block progress:uploadProgress success:success failure:failure];
}

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
                       headers:(NSDictionary<NSString *,NSString *> *)headers
     constructingBodyWithBlock:(void (^)(id<AFMultipartFormData> _Nonnull))block
                      progress:(void (^)(NSProgress * _Nonnull))uploadProgress
                       success:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nullable))success failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure
{
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [self.requestSerializer multipartFormRequestWithMethod:@"POST" URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters constructingBodyWithBlock:block error:&serializationError];
    for (NSString *headerField in headers.keyEnumerator) {
        [request addValue:headers[headerField] forHTTPHeaderField:headerField];
    }
    if (serializationError) {
        if (failure) {
            dispatch_async(self.sessionManager.completionQueue ?: dispatch_get_main_queue(), ^{
                failure(nil, serializationError);
            });
        }
        
        return nil;
    }
    
    __block NSURLSessionDataTask *task = [self.sessionManager uploadTaskWithStreamedRequest:request progress:uploadProgress completionHandler:^(NSURLResponse * __unused response, id responseObject, NSError *error) {
        if (error) {
            if (failure) {
                failure(task, error);
            }
        } else {
            if (success) {
                success(task, responseObject);
            }
        }
    }];
    
    [task resume];
    
    return task;
}

- (NSURLSessionDataTask *)PUT:(NSString *)URLString
                   parameters:(id)parameters
                      success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                      failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    return [self PUT:URLString parameters:parameters headers:nil success:success failure:failure];
}

- (NSURLSessionDataTask *)PUT:(NSString *)URLString
                   parameters:(id)parameters
                      headers:(NSDictionary<NSString *,NSString *> *)headers
                      success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                      failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    NSURLSessionDataTask *dataTask = [self dataTaskWithHTTPMethod:@"PUT" URLString:URLString parameters:parameters headers:headers uploadProgress:nil downloadProgress:nil success:success failure:failure];
    
    [dataTask resume];
    
    return dataTask;
}

- (NSURLSessionDataTask *)PATCH:(NSString *)URLString
                     parameters:(id)parameters
                        success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                        failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    return [self PATCH:URLString parameters:parameters headers:nil success:success failure:failure];
}

- (NSURLSessionDataTask *)PATCH:(NSString *)URLString
                     parameters:(id)parameters
                        headers:(NSDictionary<NSString *,NSString *> *)headers
                        success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                        failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    NSURLSessionDataTask *dataTask = [self dataTaskWithHTTPMethod:@"PATCH" URLString:URLString parameters:parameters headers:headers uploadProgress:nil downloadProgress:nil success:success failure:failure];
    
    [dataTask resume];
    
    return dataTask;
}

- (NSURLSessionDataTask *)DELETE:(NSString *)URLString
                      parameters:(id)parameters
                         success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                         failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    return [self DELETE:URLString parameters:parameters headers:nil success:success failure:failure];
}

- (NSURLSessionDataTask *)DELETE:(NSString *)URLString
                      parameters:(id)parameters
                         headers:(NSDictionary<NSString *,NSString *> *)headers
                         success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                         failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    NSURLSessionDataTask *dataTask = [self dataTaskWithHTTPMethod:@"DELETE" URLString:URLString parameters:parameters headers:headers uploadProgress:nil downloadProgress:nil success:success failure:failure];
    
    [dataTask resume];
    
    return dataTask;
}

- (NSURLSessionTask *)OPTIONS:(NSString *)URLString
                   parameters:(id)parameters
                      success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                      failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure{
    return [self OPTIONS:URLString parameters:parameters headers:nil success:success failure:failure];
}

- (NSURLSessionTask *)OPTIONS:(NSString *)URLString parameters:(id)parameters
                      headers:(NSDictionary<NSString *,NSString *> *)headers
                      success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                      failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    NSURLSessionDataTask *dataTask = [self dataTaskWithHTTPMethod:@"OPTIONS" URLString:URLString parameters:parameters headers:headers uploadProgress:nil downloadProgress:nil success:success failure:failure];
    
    [dataTask resume];
    
    return dataTask;
}

- (NSURLSessionTask *)TRACE:(NSString *)URLString
                 parameters:(id)parameters
                    success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                    failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure{
    return [self TRACE:URLString parameters:parameters headers:nil success:success failure:failure];
}

- (NSURLSessionTask *)TRACE:(NSString *)URLString
                 parameters:(id)parameters
                    headers:(NSDictionary<NSString *,NSString *> *)headers
                    success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                    failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    NSURLSessionDataTask *dataTask = [self dataTaskWithHTTPMethod:@"TRACE" URLString:URLString parameters:parameters headers:headers uploadProgress:nil downloadProgress:nil success:success failure:failure];
    
    [dataTask resume];
    
    return dataTask;
}

- (NSURLSessionTask *)CONNECT:(NSString *)URLString
                   parameters:(id)parameters
                      success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                      failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    return [self CONNECT:URLString parameters:parameters headers:nil success:success failure:failure];
}

- (NSURLSessionTask *)CONNECT:(NSString *)URLString
                   parameters:(id)parameters
                      headers:(NSDictionary<NSString *,NSString *> *)headers
                      success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                      failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    NSURLSessionDataTask *dataTask = [self dataTaskWithHTTPMethod:@"CONNECT" URLString:URLString parameters:parameters headers:headers uploadProgress:nil downloadProgress:nil success:success failure:failure];
    
    [dataTask resume];
    
    return dataTask;
}

- (NSURLSessionDataTask *)dataTaskWithHTTPMethod:(NSString *)method
                                       URLString:(NSString *)URLString
                                      parameters:(id)parameters
                                         headers:(NSDictionary <NSString *, NSString *> *)headers
                                  uploadProgress:(nullable void (^)(NSProgress *uploadProgress)) uploadProgress
                                downloadProgress:(nullable void (^)(NSProgress *downloadProgress)) downloadProgress
                                         success:(void (^)(NSURLSessionDataTask *, id))success
                                         failure:(void (^)(NSURLSessionDataTask *, NSError *))failure
{
    NSError *serializationError = nil;
    // 创建request
    NSMutableURLRequest *request = [self.sessionManager.requestSerializer requestWithMethod:method URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters error:&serializationError];
    // 设置header
    for (NSString *headerField in headers.keyEnumerator) {
        [request setValue:headers[headerField] forHTTPHeaderField:headerField];
    }
    if (serializationError) {
        if (failure) {
            dispatch_async(self.sessionManager.completionQueue ?: dispatch_get_main_queue(), ^{
                failure(nil, serializationError);
            });
        }

        return nil;
    }
    // 创建dataTask
    __block NSURLSessionDataTask *dataTask = nil;
    dataTask = [self.sessionManager dataTaskWithRequest:request
                          uploadProgress:uploadProgress
                        downloadProgress:downloadProgress
                       completionHandler:^(NSURLResponse * __unused response, id responseObject, NSError *error) {
        if (error) {
            if (failure) {
                failure(dataTask, error);
            }
        } else {
            if (success) {
                success(dataTask, responseObject);
            }
        }
    }];

    return dataTask;
}

@end
