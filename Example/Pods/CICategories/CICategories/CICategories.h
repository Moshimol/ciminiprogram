//
//  CICategories.h
//
//  Created by ikeyyang on 16/3/29.
//  Copyright (c) 2016 com.ci123.cn.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import <UIKit/UIKit.h>

#if __has_include(<CICategories/CICategories.h>)
FOUNDATION_EXPORT double CICategoriesVersionNumber;
FOUNDATION_EXPORT const unsigned char CICategoriesVersionString[];
#import <CICategories/NSData+CIAdd.h>
#import <CICategories/NSString+CIAdd.h>
#import <CICategories/NSArray+CIAdd.h>
#import <CICategories/UIColor+CIAdd.h>
#import <CICategories/NSDictionary+CIAdd.h>
#import <CICategories/NSDate+CIAdd.h>
#import <CICategories/NSNumber+CIAdd.h>
#import <CICategories/UIImage+CIAdd.h>
#import <CICategories/UIView+CIAdd.h>
#import <CICategories/UIButton+CIAdd.h>
#import <CICategories/UIGestureRecognizer+CIAdd.h>
#import <CICategories/CICGUtilities.h>
#else
#import "NSData+CIAdd.h"
#import "NSString+CIAdd.h"
#import "NSArray+CIAdd.h"
#import "UIColor+CIAdd.h"
#import "NSDictionary+CIAdd.h"
#import "NSDate+CIAdd.h"
#import "NSNumber+CIAdd.h"
#import "UIImage+CIAdd.h"
#import "UIView+CIAdd.h"
#import "UIButton+CIAdd.h"
#import "UIGestureRecognizer+CIAdd.h"
#import "CICGUtilities.h"
#endif

