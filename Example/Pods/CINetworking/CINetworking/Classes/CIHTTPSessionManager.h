//
//  CIHTTPSessionManager.h
//  CINetWorking
//
//  Created by 曹中浩 on 2020/2/17.
//

#import <Foundation/Foundation.h>

#import "CIURLRequestSerialization.h"
#import "CIURLResponseSerialization.h"
#import "CISecurityPolicy.h"
#import "CINetworkReachabilityManager.h"

NS_ASSUME_NONNULL_BEGIN

// 请求方式
typedef NS_ENUM(NSUInteger , CIHTTPMethod) {
    CIHTTPMethodGET,
    CIHTTPMethodHEAD,
    CIHTTPMethodPOST,
    CIHTTPMethodPUT,
    CIHTTPMethodPATCH,
    CIHTTPMethodDELETE,
    CIHTTPMethodOPTIONS,
    CIHTTPMethodTRACE,
    CIHTTPMethodCONNECT
};

@interface CIHTTPSessionManager : NSObject

// sessionManager.baseURL
@property (readonly, nonatomic, strong, nullable) NSURL * baseURL;

// sessionManager.requestSerializer
@property (nonatomic, nonnull) AFHTTPRequestSerializer * requestSerializer;

// sessionManager.responseSerializer
@property (nonatomic, nonnull) AFHTTPResponseSerializer * responseSerializer;

// sessionManager.security.Policy
@property (nonatomic, strong) AFSecurityPolicy * securityPolicy;

// sessionManager
@property AFHTTPSessionManager * sessionManager;

// create manager
+(instancetype)manager;

// initializer
-(instancetype)initWithBaseURL:(nullable NSURL *)url;

-(instancetype)initWithBaseURL:(nullable NSURL *)url sessionConfiguration:(nullable NSURLSessionConfiguration *)configuration;

// request
-(nullable NSURLSessionDataTask *)request:(NSString *)URLString
                                   method:(NSString *)method
                                  timeout:(NSTimeInterval)timeout
                                  headers:(nullable NSDictionary <NSString *, NSString *> *)headers
                               parameters:(nullable id)parameters
                                  success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                                  failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;

// request
-(nullable NSURLSessionDataTask *)request:(NSString *)URLString
                                   method:(CIHTTPMethod)method
                               parameters:(nullable id)parameters
                                  success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                                  failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;

-(nullable NSURLSessionDataTask *)request:(NSString *)URLString
                                   method:(CIHTTPMethod)method
                               parameters:(nullable id)parameters
                                 progress:(nullable void(^)(NSProgress * progress))progress
                                  success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                                  failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;

/// 发起http请求
/// @param URLString 请求地址
/// @param method 请求方式
/// @param headers 请求头
/// @param parameters 请求参数
/// @param progress 进度
/// @param success 成功回调
/// @param failure 错误回调
-(nullable NSURLSessionDataTask *)request:(NSString *)URLString
                                   method:(CIHTTPMethod)method
                                  headers:(nullable NSDictionary <NSString *, NSString *> *)headers
                               parameters:(nullable id)parameters
                                 progress:(nullable void(^)(NSProgress * progress))progress
                                  success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                                  failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;


/// 上传文件
/// @param URLString 上传地址
/// @param parameters 上传参数
/// @param fileParameters 文件参数 @{ @“data” : (NSData*) data, @"name"":(NString*)name, @"fileName":(NSString *)fileName,@"mimeType":(NSString *)mimeType }
/// @param progress 上传进度
/// @param success 成功回调
/// @param failure 失败回调
-(nullable NSURLSessionDataTask *)uploadFile:(NSString *)URLString
                                  parameters:(nullable id)parameters
                              fileParameters:(NSDictionary *)fileParameters
                                    progress:(nullable void(^)(NSProgress * progress))progress
                                     success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                                     failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;

-(nullable NSURLSessionDataTask *)uploadTask:(NSURLRequest *)request
                                    progress:(nullable void(^)(NSProgress * progress))progress
                                     success:(nullable void(^)(NSURLResponse * _Nonnull response, id  _Nullable responseObject))success
                                     failure:(nullable void(^)(NSURLResponse * _Nonnull response,NSError * error))failure;

-(nullable NSURLSessionDataTask *)downloadFile:(NSString *)URLString
                                    parameters:(nullable id)parameters
                                      progress:(nullable void(^)(NSProgress * progress))progress
                                       success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                                       failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;

-(nullable NSURLSessionDownloadTask *)downloadTask:(NSURLRequest *)request
                                        parameters:(nullable NSDictionary *)parameters
                                          progress:(nullable void(^)(NSProgress * progress))progress
                                       destination:(NSURL * (^)(NSURL *targetPath, NSURLResponse *response))destination
                                           success:(nullable void(^)(NSURLResponse * response,NSURL * filePath))success
                                           failure:(nullable void(^)(NSURLResponse * _Nonnull response,NSError * error))failure;

- (nullable NSURLSessionDataTask *)GET:(NSString *)URLString
                            parameters:(nullable id)parameters
                               success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                               failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;

- (nullable NSURLSessionDataTask *)GET:(NSString *)URLString
                            parameters:(nullable id)parameters
                              progress:(nullable void (^)(NSProgress *downloadProgress))downloadProgress
                               success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                               failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;

- (nullable NSURLSessionDataTask *)GET:(NSString *)URLString
                            parameters:(nullable id)parameters
                               headers:(nullable NSDictionary <NSString *, NSString *> *)headers
                              progress:(nullable void (^)(NSProgress *downloadProgress))downloadProgress
                               success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                               failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;


- (nullable NSURLSessionDataTask *)HEAD:(NSString *)URLString
                             parameters:(nullable id)parameters
                                success:(nullable void (^)(NSURLSessionDataTask *task))success
                                failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;

- (nullable NSURLSessionDataTask *)HEAD:(NSString *)URLString
                             parameters:(nullable id)parameters
                                headers:(nullable NSDictionary <NSString *, NSString *> *)headers
                                success:(nullable void (^)(NSURLSessionDataTask *task))success
                                failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;

- (nullable NSURLSessionDataTask *)POST:(NSString *)URLString
                             parameters:(nullable id)parameters
                                success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                                failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure ;

- (nullable NSURLSessionDataTask *)POST:(NSString *)URLString
                             parameters:(nullable id)parameters
                               progress:(nullable void (^)(NSProgress *uploadProgress))uploadProgress
                                success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                                failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;

- (nullable NSURLSessionDataTask *)POST:(NSString *)URLString
                             parameters:(nullable id)parameters
                                headers:(nullable NSDictionary <NSString *, NSString *> *)headers
                               progress:(nullable void (^)(NSProgress *uploadProgress))uploadProgress
                                success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                                failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;

- (nullable NSURLSessionDataTask *)POST:(NSString *)URLString
                             parameters:(nullable id)parameters
              constructingBodyWithBlock:(nullable void (^)(id <AFMultipartFormData> formData))block
                                success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                                failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure ;

- (nullable NSURLSessionDataTask *)POST:(NSString *)URLString
                             parameters:(nullable id)parameters
              constructingBodyWithBlock:(nullable void (^)(id <AFMultipartFormData> formData))block
                               progress:(nullable void (^)(NSProgress *uploadProgress))uploadProgress
                                success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                                failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;

- (nullable NSURLSessionDataTask *)POST:(NSString *)URLString
                             parameters:(nullable id)parameters
                                headers:(nullable NSDictionary <NSString *, NSString *> *)headers
              constructingBodyWithBlock:(nullable void (^)(id <AFMultipartFormData> formData))block
                               progress:(nullable void (^)(NSProgress *uploadProgress))uploadProgress
                                success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                                failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;

- (nullable NSURLSessionDataTask *)PUT:(NSString *)URLString
                            parameters:(nullable id)parameters
                               success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                               failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;

- (nullable NSURLSessionDataTask *)PUT:(NSString *)URLString
                            parameters:(nullable id)parameters
                               headers:(nullable NSDictionary <NSString *, NSString *> *)headers
                               success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                               failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;

- (nullable NSURLSessionDataTask *)PATCH:(NSString *)URLString
                              parameters:(nullable id)parameters
                                 success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                                 failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;

- (nullable NSURLSessionDataTask *)PATCH:(NSString *)URLString
                              parameters:(nullable id)parameters
                                 headers:(nullable NSDictionary <NSString *, NSString *> *)headers
                                 success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                                 failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;

- (nullable NSURLSessionDataTask *)DELETE:(NSString *)URLString
                               parameters:(nullable id)parameters
                                  success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                                  failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;

- (nullable NSURLSessionDataTask *)DELETE:(NSString *)URLString
                               parameters:(nullable id)parameters
                                  headers:(nullable NSDictionary <NSString *, NSString *> *)headers
                                  success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                                  failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;

- (nullable NSURLSessionTask *)OPTIONS:(NSString *)URLString
                            parameters:(nullable id)parameters
                               success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                               failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;

- (nullable NSURLSessionTask *)OPTIONS:(NSString *)URLString
                            parameters:(nullable id)parameters
                               headers:(nullable NSDictionary<NSString *,NSString *> *)headers
                               success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                               failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;

- (nullable NSURLSessionTask *)TRACE:(NSString *)URLString
                          parameters:(nullable id)parameters
                             success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                             failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;

- (nullable NSURLSessionTask *)TRACE:(NSString *)URLString
                          parameters:(nullable id)parameters
                             headers:(nullable NSDictionary<NSString *,NSString *> *)headers
                             success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                             failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;

- (nullable NSURLSessionTask *)CONNECT:(NSString *)URLString
                            parameters:(nullable id)parameters
                               success:(nullable void (^)(NSURLSessionDataTask * task, id _Nullable responseObject))success
                               failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;

- (nullable NSURLSessionTask *)CONNECT:(NSString *)URLString
                            parameters:(nullable id)parameters
                               headers:(nullable NSDictionary<NSString *,NSString *> *)headers
                               success:(nullable void (^)(NSURLSessionDataTask * task, id _Nullable responseObject))success
                               failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;

@end

NS_ASSUME_NONNULL_END
