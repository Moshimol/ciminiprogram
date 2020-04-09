#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "CIHTTPSessionManager.h"
#import "CINetworking.h"
#import "CINetworkReachabilityManager.h"
#import "CISecurityPolicy.h"
#import "CIURLRequestSerialization.h"
#import "CIURLResponseSerialization.h"

FOUNDATION_EXPORT double CINetworkingVersionNumber;
FOUNDATION_EXPORT const unsigned char CINetworkingVersionString[];

