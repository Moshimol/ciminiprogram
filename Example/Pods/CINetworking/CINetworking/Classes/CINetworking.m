//
//  CINetworking.m
//  CINetWorking
//
//  Created by 曹中浩 on 2020/2/28.
//

#import "CINetworking.h"

static CINetworking * _sharedInstance;
@implementation CINetworking

+(instancetype)sharedInstance{
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[CINetworking alloc] init];
    }) ;
    return _sharedInstance ;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.baseURL = @"";
        self.sessionManager = [[CIHTTPSessionManager alloc]init];
        CIJSONRequestSerializer * jsonRequestSerializer = [[CIJSONRequestSerializer alloc]init];
        CIJSONResponseSerializer * jsonResponseSerializer = [[CIJSONResponseSerializer alloc]init];
        CIHTTPResponseSerializer * httpResponseSerializer = [[CIHTTPResponseSerializer alloc]init];

        self.sessionManager.requestSerializer = jsonRequestSerializer;
        self.sessionManager.responseSerializer = [CICompoundResponseSerializer compoundSerializerWithResponseSerializers:@[jsonResponseSerializer,httpResponseSerializer]];
    }
    return self;
}

- (void)setUsePipelining:(BOOL)UsePipelining{
    self.sessionManager.requestSerializer.HTTPShouldUsePipelining = UsePipelining;
}

- (BOOL)usePipelining{
    return self.sessionManager.requestSerializer.HTTPShouldUsePipelining;
}

- (void)setEncoding:(NSStringEncoding)encoding{
    [self.sessionManager.requestSerializer setStringEncoding:encoding];
}

- (NSStringEncoding)encoding{
    return self.sessionManager.requestSerializer.stringEncoding;
}

- (void)setCachePolicy:(NSURLRequestCachePolicy)cachePolicy{
    [self.sessionManager.requestSerializer setCachePolicy:cachePolicy];
}

- (NSURLRequestCachePolicy)cachePolicy{
    return self.sessionManager.requestSerializer.cachePolicy;
}


- (void)setHandleCookies:(BOOL)handleCookies{
    [self.sessionManager.requestSerializer setHTTPShouldHandleCookies:handleCookies];
}

- (BOOL)handleCookies{
    return self.sessionManager.requestSerializer.HTTPShouldHandleCookies;
}

- (void)setTimeoutInterval:(NSTimeInterval)timeoutInterval{
    [self.sessionManager.requestSerializer setTimeoutInterval:timeoutInterval];
}

- (NSTimeInterval)timeoutInterval{
    return [self.sessionManager.requestSerializer timeoutInterval];
}

- (void)setAllowsCellularAccess:(BOOL)allowsCellularAccess{
    [self.sessionManager.requestSerializer setAllowsCellularAccess:YES];
}

- (BOOL)allowsCellularAccess{
    return self.sessionManager.requestSerializer.allowsCellularAccess;
}

- (void)setNetworkServiceType:(NSURLRequestNetworkServiceType)networkServiceType{
    [self.sessionManager.requestSerializer setNetworkServiceType:networkServiceType];
}

- (NSURLRequestNetworkServiceType)networkServiceType{
    return self.sessionManager.requestSerializer.networkServiceType;
}


- (void)setAcceptableContentTypes:(NSSet<NSString *> *)acceptableContentTypes{
    [self.sessionManager.responseSerializer setAcceptableContentTypes:acceptableContentTypes];
}

- (NSSet<NSString *> *)acceptableContentTypes{
    return self.sessionManager.responseSerializer.acceptableContentTypes;
}

-(void)setAcceptableStatusCodes:(NSIndexSet *)acceptableStatusCodes{
    [self.sessionManager.responseSerializer setAcceptableStatusCodes:acceptableStatusCodes];
}

- (NSIndexSet *)acceptableStatusCodes{
    return self.sessionManager.responseSerializer.acceptableStatusCodes;
}

- (void)setCommonRequestHeaders:(NSDictionary *)commonRequestHeaders{
    for (NSString * key in commonRequestHeaders) {
        [self.sessionManager.requestSerializer setValue:commonRequestHeaders[key]  forHTTPHeaderField:key];
    }
}

-(NSDictionary *)commonRequestHeaders{
    return self.sessionManager.requestSerializer.HTTPRequestHeaders;
}

-(NSDictionary *)combineParameters:(NSDictionary *)parameters{
    NSMutableDictionary * combinedParameters = [NSMutableDictionary dictionaryWithDictionary:self.commonRequestParameters];
    [combinedParameters addEntriesFromDictionary:parameters];
    return combinedParameters.copy;
}

-(NSString *)combineURLString:(NSString *)URLString{
    // relativeToBaseURL
    NSURL * baseURL = [NSURL URLWithString:self.baseURL];
    NSURL * combinedURL = [NSURL URLWithString:URLString relativeToURL:baseURL];
    NSLog(@"%@",[combinedURL absoluteString]);
    return [combinedURL absoluteString];
}

-(nullable NSURLSessionDataTask *)GET:(NSString *)URLString
                           parameters:(nullable NSDictionary *)parameters
                              success:(nullable void(^)(id _Nullable responseObject))success
                              failure:(nullable void(^)(NSError * error))failure{
    URLString = [self combineURLString:URLString];
    parameters = [self combineParameters:parameters];
    return [self.sessionManager request:URLString method:CIHTTPMethodGET parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
        if(self.onSuccess){
            self.onSuccess(responseObject);
        }
        if(success){
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(self.onFailure){
            self.onFailure(error);
        }
        if(failure){
            failure(error);
        }
    }];
}

-(nullable NSURLSessionDataTask *)GET:(NSString *)URLString
                           parameters:(nullable NSDictionary *)parameters
                             progress:(nullable void(^)(NSProgress * progress))progress
                              success:(nullable void(^)(id _Nullable responseObject))success
                              failure:(nullable void(^)(NSError * error))failure{
    URLString = [self combineURLString:URLString];
    parameters = [self combineParameters:parameters];
    //    ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    //    ^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
    
    return [self.sessionManager request:URLString method:CIHTTPMethodGET parameters:parameters progress:progress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(self.onSuccess){
            self.onSuccess(responseObject);
        }
        if(success){
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(self.onFailure){
            self.onFailure(error);
        }
        if(failure){
            failure(error);
        }
    }];
}

-(nullable NSURLSessionDataTask *)GET:(NSString *)URLString
                                  headers:(nullable NSDictionary <NSString *, NSString *> *)headers
                               parameters:(nullable NSDictionary *)parameters
                                 progress:(nullable void(^)(NSProgress * progress))progress
                                  success:(nullable void(^)(id _Nullable responseObject))success
                              failure:(nullable void(^)(NSError * error))failure{
    URLString = [self combineURLString:URLString];
    parameters = [self combineParameters:parameters];

    return [self.sessionManager request:URLString method:CIHTTPMethodGET headers:headers parameters:parameters progress:progress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(self.onSuccess){
            self.onSuccess(responseObject);
        }
        if(success){
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(self.onFailure){
            self.onFailure(error);
        }
        if(failure){
            failure(error);
        }
    }];
}

-(nullable NSURLSessionDataTask *)POST:(NSString *)URLString
                               parameters:(nullable NSDictionary *)parameters
                                  success:(nullable void(^)(id _Nullable responseObject))success
                               failure:(nullable void(^)(NSError * error))failure{
    URLString = [self combineURLString:URLString];
    parameters = [self combineParameters:parameters];


    return [self.sessionManager request:URLString method:CIHTTPMethodPOST parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(self.onSuccess){
            self.onSuccess(responseObject);
        }
        if(success){
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(self.onFailure){
            self.onFailure(error);
        }
        if(failure){
            failure(error);
        }
    }];
}

-(nullable NSURLSessionDataTask *)POST:(NSString *)URLString
                               parameters:(nullable NSDictionary *)parameters
                                 progress:(nullable void(^)(NSProgress * progress))progress
                                  success:(nullable void(^)(id _Nullable responseObject))success
                               failure:(nullable void(^)(NSError * error))failure{
    URLString = [self combineURLString:URLString];
    parameters = [self combineParameters:parameters];

    
    return [self.sessionManager request:URLString method:CIHTTPMethodPOST parameters:parameters progress:progress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(self.onSuccess){
            self.onSuccess(responseObject);
        }
        if(success){
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(self.onFailure){
            self.onFailure(error);
        }
        if(failure){
            failure(error);
        }
    }];
}

-(nullable NSURLSessionDataTask *)POST:(NSString *)URLString
                                  headers:(nullable NSDictionary <NSString *, NSString *> *)headers
                               parameters:(nullable NSDictionary *)parameters
                                 progress:(nullable void(^)(NSProgress * progress))progress
                                  success:(nullable void(^)(id _Nullable responseObject))success
                               failure:(nullable void(^)(NSError * error))failure{
    URLString = [self combineURLString:URLString];
    parameters = [self combineParameters:parameters];

    
    return [self.sessionManager request:URLString method:CIHTTPMethodPOST headers:headers parameters:parameters progress:progress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(self.onSuccess){
            self.onSuccess(responseObject);
        }
        if(success){
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(self.onFailure){
            self.onFailure(error);
        }
        if(failure){
            failure(error);
        }
    }];
}

-(nullable NSURLSessionDataTask *)request:(NSString *)URLString
                                   method:(CIHTTPMethod)method
                               parameters:(nullable NSDictionary *)parameters
                                  success:(nullable void(^)(id _Nullable responseObject))success
                                  failure:(nullable void(^)(NSError * error))failure{
    URLString = [self combineURLString:URLString];
    parameters = [self combineParameters:parameters];

    return [self.sessionManager request:URLString method:method  parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(self.onSuccess){
            self.onSuccess(responseObject);
        }
        if(success){
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(self.onFailure){
            self.onFailure(error);
        }
        if(failure){
            failure(error);
        }
    }];
}

-(nullable NSURLSessionDataTask *)request:(NSString *)URLString
                                   method:(CIHTTPMethod)method
                               parameters:(nullable NSDictionary *)parameters
                                 progress:(nullable void(^)(NSProgress * progress))progress
                                  success:(nullable void(^)(id _Nullable responseObject))success
                                  failure:(nullable void(^)(NSError * error))failure{
    URLString = [self combineURLString:URLString];
    parameters = [self combineParameters:parameters];

    return [self.sessionManager request:URLString method:method parameters:parameters progress:progress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
        if(self.onSuccess){
            self.onSuccess(responseObject);
        }
        if(success){
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(self.onFailure){
            self.onFailure(error);
        }
        if(failure){
            failure(error);
        }
    }];
}

-(nullable NSURLSessionDataTask *)request:(NSString *)URLString
                                   method:(CIHTTPMethod)method
                                  headers:(nullable NSDictionary <NSString *, NSString *> *)headers
                               parameters:(nullable NSDictionary *)parameters
                                 progress:(nullable void(^)(NSProgress * progress))progress
                                  success:(nullable void(^)(id _Nullable responseObject))success
                                  failure:(nullable void(^)(NSError * error))failure{
    URLString = [self combineURLString:URLString];
    parameters = [self combineParameters:parameters];

    return [self.sessionManager request:URLString method:method headers:headers parameters:parameters progress:progress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(self.onSuccess){
            self.onSuccess(responseObject);
        }
        if(success){
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(self.onFailure){
            self.onFailure(error);
        }
        if(failure){
            failure(error);
        }
    }];
}

-(nullable NSURLSessionDataTask *)uploadFile:(NSString *)URLString
                                  parameters:(nullable NSDictionary *)parameters
                              fileParameters:(NSDictionary *)fileParameters
                                    progress:(nullable void(^)(NSProgress * progress))progress
                                     success:(nullable void(^)(id _Nullable responseObject))success
                                     failure:(nullable void(^)(NSError * error))failure{
    URLString = [self combineURLString:URLString];
    parameters = [self combineParameters:parameters];

    return [self.sessionManager uploadFile:URLString parameters:parameters fileParameters:fileParameters progress:progress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(self.onSuccess){
            self.onSuccess(responseObject);
        }
        if(success){
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(self.onFailure){
            self.onFailure(error);
        }
        if(failure){
            failure(error);
        }
    }];
}

-(nullable NSURLSessionDataTask *)uploadTask:(NSURLRequest *)request
                                    progress:(nullable void(^)(NSProgress * progress))progress
                                     success:(nullable void(^)(NSURLResponse * _Nonnull response, id  _Nullable responseObject))success
                                     failure:(nullable void(^)(NSURLResponse * _Nonnull response, NSError * error))failure{
    return [self.sessionManager uploadTask:request progress:progress success:success failure:failure];
}


-(nullable NSURLSessionDataTask *)downloadFile:(NSString *)URLString
                                    parameters:(nullable NSDictionary *)parameters
                                      progress:(nullable void(^)(NSProgress * progress))progress
                                       success:(nullable void(^)(id _Nullable responseObject))success
                                       failure:(nullable void(^)(NSError * error))failure{
    URLString = [self combineURLString:URLString];
    parameters = [self combineParameters:parameters];

    return [self.sessionManager downloadFile:URLString parameters:parameters progress:progress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(self.onSuccess){
            self.onSuccess(responseObject);
        }
        if(success){
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(self.onFailure){
            self.onFailure(error);
        }
        if(failure){
            failure(error);
        }
    }];
}

-(nullable NSURLSessionDownloadTask *)downloadTask:(NSURLRequest *)request
                                    parameters:(nullable NSDictionary *)parameters
                                      progress:(nullable void(^)(NSProgress * progress))progress
                                   destination:(NSURL * (^)(NSURL *targetPath, NSURLResponse *response))destination
                                       success:(nullable void(^)(NSURLResponse * response,NSURL * filePath))success
                                       failure:(nullable void(^)(NSURLResponse * response,NSError * error))failure{
    return [self.sessionManager downloadTask:request parameters:parameters progress:progress destination:destination success:success failure:failure];
}

@end
