//
//  CIURLResponseSerialization.h
//  CINetWorking
//
//  Created by 曹中浩 on 2020/2/17.
//

#import <AFNetworking/AFNetworking.h>

NS_ASSUME_NONNULL_BEGIN

@interface CIHTTPResponseSerializer : AFHTTPResponseSerializer

@end

@interface CIJSONResponseSerializer : AFJSONResponseSerializer

@end

@interface CIPropertyListResponseSerializer : AFPropertyListResponseSerializer

@end

@interface CIImageResponseSerializer : AFImageResponseSerializer

@end

@interface CIXMLParserResponseSerializer : AFXMLParserResponseSerializer

@end

@interface CICompoundResponseSerializer : AFCompoundResponseSerializer

@end
NS_ASSUME_NONNULL_END
