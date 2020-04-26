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

#import "CICategories.h"
#import "CICGUtilities.h"
#import "NSArray+CIAdd.h"
#import "NSData+CIAdd.h"
#import "NSDate+CIAdd.h"
#import "NSDictionary+CIAdd.h"
#import "NSNumber+CIAdd.h"
#import "NSString+CIAdd.h"
#import "UIButton+CIAdd.h"
#import "UIColor+CIAdd.h"
#import "UIGestureRecognizer+CIAdd.h"
#import "UIImage+CIAdd.h"
#import "UIView+CIAdd.h"

FOUNDATION_EXPORT double CICategoriesVersionNumber;
FOUNDATION_EXPORT const unsigned char CICategoriesVersionString[];

