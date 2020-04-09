//
//  CIURLResponseSerialization.m
//  CINetWorking
//
//  Created by 曹中浩 on 2020/2/17.
//

#import "CIURLResponseSerialization.h"

@implementation CIHTTPResponseSerializer

@end

@implementation CIJSONResponseSerializer

@end

@implementation CIPropertyListResponseSerializer : AFPropertyListResponseSerializer

@end

@implementation CIImageResponseSerializer : AFImageResponseSerializer

@end

@implementation CIXMLParserResponseSerializer : AFXMLParserResponseSerializer

@end

@implementation CICompoundResponseSerializer : AFCompoundResponseSerializer

-(void)setAcceptableStatusCodes:(NSIndexSet *)acceptableStatusCodes{
    for (AFHTTPResponseSerializer * serializer in self.responseSerializers) {
        [serializer setAcceptableStatusCodes:acceptableStatusCodes];
    }
}

@end
