//
//  CIURLRequestSerialization.h
//  CINetWorking
//
//  Created by 曹中浩 on 2020/2/17.
//

#import <AFNetworking/AFNetworking.h>

NS_ASSUME_NONNULL_BEGIN

@interface CIHTTPRequestSerializer : AFHTTPRequestSerializer

@end

@interface CIJSONRequestSerializer : AFJSONRequestSerializer

@end

@interface CIPropertyListRequestSerializer : AFPropertyListRequestSerializer

@end
NS_ASSUME_NONNULL_END
