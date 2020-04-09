//
//  CINetworking.h
//  CINetWorking
//
//  Created by 曹中浩 on 2020/2/28.
//

#import <Foundation/Foundation.h>
#import "CIHTTPSessionManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface CINetworking : NSObject

+(instancetype)sharedInstance;

@property CIHTTPSessionManager* sessionManager;

@property NSString * baseURL;

@property (nonatomic) NSDictionary * commonRequestHeaders;

@property (nonatomic) NSDictionary * commonRequestParameters;

@property BOOL usePipelining;

@property NSStringEncoding encoding;

@property NSURLRequestCachePolicy cachePolicy;

@property BOOL handleCookies;

@property NSTimeInterval timeoutInterval;

@property BOOL allowsCellularAccess;

@property NSIndexSet * acceptableStatusCodes;

@property NSSet<NSString *> * acceptableContentTypes;

@property NSURLRequestNetworkServiceType networkServiceType;

@property void(^onSuccess)(id _Nullable responseObject);
@property void(^onFailure)(NSError * error);


-(nullable NSURLSessionDataTask *)GET:(NSString *)URLString
                               parameters:(nullable NSDictionary *)parameters
                                  success:(nullable void(^)(id _Nullable responseObject))success
                                  failure:(nullable void(^)(NSError * error))failure;

-(nullable NSURLSessionDataTask *)GET:(NSString *)URLString
                               parameters:(nullable NSDictionary *)parameters
                                 progress:(nullable void(^)(NSProgress * progress))progress
                                  success:(nullable void(^)(id _Nullable responseObject))success
                                  failure:(nullable void(^)(NSError * error))failure;

-(nullable NSURLSessionDataTask *)GET:(NSString *)URLString
                                  headers:(nullable NSDictionary <NSString *, NSString *> *)headers
                               parameters:(nullable NSDictionary *)parameters
                                 progress:(nullable void(^)(NSProgress * progress))progress
                                  success:(nullable void(^)(id _Nullable responseObject))success
                                  failure:(nullable void(^)(NSError * error))failure;

-(nullable NSURLSessionDataTask *)POST:(NSString *)URLString
                               parameters:(nullable NSDictionary *)parameters
                                  success:(nullable void(^)(id _Nullable responseObject))success
                                  failure:(nullable void(^)(NSError * error))failure;

-(nullable NSURLSessionDataTask *)POST:(NSString *)URLString
                               parameters:(nullable NSDictionary *)parameters
                                 progress:(nullable void(^)(NSProgress * progress))progress
                                  success:(nullable void(^)(id _Nullable responseObject))success
                                  failure:(nullable void(^)(NSError * error))failure;

-(nullable NSURLSessionDataTask *)POST:(NSString *)URLString
                                  headers:(nullable NSDictionary <NSString *, NSString *> *)headers
                               parameters:(nullable NSDictionary *)parameters
                                 progress:(nullable void(^)(NSProgress * progress))progress
                                  success:(nullable void(^)(id _Nullable responseObject))success
                                  failure:(nullable void(^)(NSError * error))failure;

-(nullable NSURLSessionDataTask *)request:(NSString *)URLString
                                   method:(CIHTTPMethod)method
                               parameters:(nullable NSDictionary *)parameters
                                  success:(nullable void(^)(id _Nullable responseObject))success
                                  failure:(nullable void(^)(NSError * error))failure;

-(nullable NSURLSessionDataTask *)request:(NSString *)URLString
                                   method:(CIHTTPMethod)method
                               parameters:(nullable NSDictionary *)parameters
                                 progress:(nullable void(^)(NSProgress * progress))progress
                                  success:(nullable void(^)(id _Nullable responseObject))success
                                  failure:(nullable void(^)(NSError * error))failure;

-(nullable NSURLSessionDataTask *)request:(NSString *)URLString
                                   method:(CIHTTPMethod)method
                                  headers:(nullable NSDictionary <NSString *, NSString *> *)headers
                               parameters:(nullable NSDictionary *)parameters
                                 progress:(nullable void(^)(NSProgress * progress))progress
                                  success:(nullable void(^)(id _Nullable responseObject))success
                                  failure:(nullable void(^)(NSError * error))failure;

-(nullable NSURLSessionDataTask *)uploadFile:(NSString *)URLString
                                  parameters:(nullable NSDictionary *)parameters
                              fileParameters:(NSDictionary *)fileParameters
                                    progress:(nullable void(^)(NSProgress * progress))progress
                                     success:(nullable void(^)(id _Nullable responseObject))success
                                     failure:(nullable void(^)(NSError * error))failure;

-(nullable NSURLSessionDataTask *)uploadTask:(NSURLRequest *)request
                                    progress:(nullable void(^)(NSProgress * progress))progress
                                     success:(nullable void(^)(NSURLResponse * _Nonnull response, id  _Nullable responseObject))success
                                     failure:(nullable void(^)(NSURLResponse * _Nonnull response,NSError * error))failure;

-(nullable NSURLSessionDataTask *)downloadFile:(NSString *)URLString
                                    parameters:(nullable NSDictionary *)parameters
                                      progress:(nullable void(^)(NSProgress * progress))progress
                                       success:(nullable void(^)(id _Nullable responseObject))success
                                       failure:(nullable void(^)(NSError * error))failure;

-(nullable NSURLSessionDownloadTask *)downloadTask:(NSURLRequest *)request
                                        parameters:(nullable NSDictionary *)parameters
                                          progress:(nullable void(^)(NSProgress * progress))progress
                                       destination:(NSURL * (^)(NSURL *targetPath, NSURLResponse *response))destination
                                           success:(nullable void(^)(NSURLResponse * response,NSURL * filePath))success
                                           failure:(nullable void(^)(NSURLResponse * _Nonnull response,NSError * error))failure;
@end

NS_ASSUME_NONNULL_END
