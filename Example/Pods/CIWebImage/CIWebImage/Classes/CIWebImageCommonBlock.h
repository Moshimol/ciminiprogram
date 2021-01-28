//
//  CIWebCommonBlock.h
//  Pods
//
//  Created by ikeyyang on 2020/3/1.
//

#ifndef CIWebCommonBlock_h
#define CIWebCommonBlock_h


/// IndicatorType
typedef NS_ENUM(NSUInteger, CIWebImageIndicatorType) {
    //indicator none
    CIWebImageIndicatorNone = 0,
    
    //indicator gray
    CIWebImageIndicatorGray,
    
    //indicator gray larger
    CIWebImageIndicatorGrayLarge,
    
    //indicator white
    CIWebImageIndicatorWhite,
    
    //indicator white larger
    CIWebImageIndicatorWhiteLarge,
    
    //indicator larger
    //CIWebImageIndicatorLarge,
    
    //indicator medium
    //CIWebImageIndicatorMedium,
    
    //progress
    CIWebImageIndicatorProgressdefault,
    
    //progressbar
    CIWebImageIndicatorProgressbar,
};

typedef void(^CIExternalCompletionBlock)(UIImage * _Nullable image, NSError * _Nullable error, NSURL * _Nullable imageURL);

typedef void(^CIImageLoaderProgressBlock)(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL);


#endif /* CIWebCommonBlock_h */
