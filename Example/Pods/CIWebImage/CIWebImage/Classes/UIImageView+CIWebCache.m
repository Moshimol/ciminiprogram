//
//  UIImageView+CIWebCache.m
//  SDWebImageTest
//
//  Created by ikeyyang on 2020/2/14.
//  Copyright © 2020 ikeyyang. All rights reserved.
//

#import "UIImageView+CIWebCache.h"
#import <SDWebImage/SDWebImage.h>

@implementation UIImageView (CIWebCache)

#pragma mark  - URL
-(void)ci_downloadImageWithURL:(nullable NSURL *)url{
    [self ci_downloadImageWithURL:url placeholderImage:nil progress:nil completed:nil];
}

- (void)ci_downloadImageWithURL:(nullable NSURL *)url placeholderImage:(nullable UIImage *)placeholder{
    [self ci_downloadImageWithURL:url placeholderImage:placeholder progress:nil completed:nil];
}

- (void)ci_downloadImageWithURL:(nullable NSURL *)url
                  placeholderImage:(nullable UIImage *)placeholder
                         completed:(nullable CIExternalCompletionBlock)completedBlock{
    [self ci_downloadImageWithURL:url placeholderImage:placeholder progress:nil completed:completedBlock indicator:0];
}

- (void)ci_downloadImageWithURL:(nullable NSURL *)url placeholderImage:(nullable UIImage *)placeholder indicator:(CIWebImageIndicatorType)indicatorType{
     [self ci_downloadImageWithURL:url placeholderImage:placeholder progress:nil completed:nil indicator:indicatorType];
}

- (void)ci_downloadImageWithURL:(nullable NSURL *)url
                  placeholderImage:(nullable UIImage *)placeholder
                         completed:(nullable CIExternalCompletionBlock)completedBlock
                    indicator:(CIWebImageIndicatorType)indicatorType{
    [self ci_downloadImageWithURL:url placeholderImage:placeholder progress:nil completed:completedBlock indicator:indicatorType];
}

- (void)ci_downloadImageWithURL:(nullable NSURL *)url
                  placeholderImage:(nullable UIImage *)placeholder
                          progress:(nullable CIImageLoaderProgressBlock)progressBlock
                         completed:(nullable CIExternalCompletionBlock)completedBlock{
    [self ci_downloadImageWithURL:url placeholderImage:placeholder progress:progressBlock completed:completedBlock indicator:0];
}

- (void)ci_downloadImageWithURL:(nullable NSURL *)url
                  placeholderImage:(nullable UIImage *)placeholder
                          progress:(nullable CIImageLoaderProgressBlock)progressBlock
                         completed:(nullable CIExternalCompletionBlock)completedBlock
                        indicator:(CIWebImageIndicatorType)indicatorType{
    [self setCurrentImageIndicatorType:indicatorType];
    [self sd_setImageWithURL:url placeholderImage:placeholder options:SDWebImageRetryFailed|SDWebImageLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        if(progressBlock){
            progressBlock(receivedSize,expectedSize,targetURL);
        }
    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if(completedBlock){
            completedBlock(image,error,imageURL);
        }
    }];
}

- (void)setCurrentImageIndicatorType:(CIWebImageIndicatorType)type{
    switch (type) {
        case CIWebImageIndicatorGray:
             self.sd_imageIndicator = SDWebImageActivityIndicator.grayIndicator;
            break;
            
        case CIWebImageIndicatorGrayLarge:
         self.sd_imageIndicator = SDWebImageActivityIndicator.grayLargeIndicator;
        break;
        
        case CIWebImageIndicatorWhite:
         self.sd_imageIndicator = SDWebImageActivityIndicator.whiteIndicator;
        break;
            
        case CIWebImageIndicatorWhiteLarge:
         self.sd_imageIndicator = SDWebImageActivityIndicator.whiteLargeIndicator;
        break;
        
//        case CIWebImageIndicatorLarge:
//         self.sd_imageIndicator = CIWebImageActivityIndicator.largeIndicator;
//        break;
//
//        case CIWebImageIndicatorMedium:
//         self.sd_imageIndicator = CIWebImageActivityIndicator.mediumIndicator;
//        break;
        
        case CIWebImageIndicatorProgressdefault:
         self.sd_imageIndicator = SDWebImageProgressIndicator.defaultIndicator;
        break;
        
        case CIWebImageIndicatorProgressbar:
         self.sd_imageIndicator = SDWebImageProgressIndicator.barIndicator;
        break;
            
        default:
            break;
    }
}

#pragma mark  - urlStr
-(void)ci_downloadImageWithURLStr:(nullable NSString *)urlStr{
    [self ci_downloadImageWithURLStr:urlStr placeholder:nil];
}

- (void)ci_downloadImageWithURLStr:(nullable NSString *)urlStr placeholder:(nullable NSString *)imageName{
    [self ci_downloadImageWithURLStr:urlStr placeholder:imageName indicator:0];
}

- (void)ci_downloadImageWithURLStr:(nullable NSString *)urlStr placeholder:(nullable NSString *)imageName indicator:(CIWebImageIndicatorType)indicatorType{
    if(![urlStr isKindOfClass:[NSString class]]){
        NSLog(@"urlStr should be string");
        urlStr = @"";
    }
    
    if(![imageName isKindOfClass:[NSString class]]){
        imageName = @"";
    }
    
    [self ci_downloadImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:imageName] progress:nil completed:nil indicator:indicatorType];
}

#pragma mark  - cancel
-(void)ci_cancelCurrentImageLoad{
    [self sd_cancelCurrentImageLoad];
}

@end
