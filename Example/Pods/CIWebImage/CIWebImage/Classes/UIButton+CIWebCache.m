//
//  UIButton+CIWebCache.m
//  CIWebImage_Example
//
//  Created by ikeyyang on 2020/2/14.
//  Copyright © 2020 ikeyyang. All rights reserved.
//

#import "UIButton+CIWebCache.h"
#import <SDWebImage/SDWebImage.h>

@implementation UIButton (CIWebCache)

#pragma mark - Image

- (nullable NSURL *)ci_currentImageURL {
    NSURL *url = [self sd_currentImageURL];
    return url;
}

- (nullable NSURL *)ci_imageURLForState:(UIControlState)state {
    return [self sd_imageURLForState:state];
}


- (void)ci_downloadImageWithURL:(nullable NSURL *)url
                  forState:(UIControlState)state{
    [self ci_downloadImageWithURL:url forState:state placeholderImage:nil progress:nil completed:nil];
}


- (void)ci_downloadImageWithURL:(nullable NSURL *)url
                  forState:(UIControlState)state
          placeholderImage:(nullable UIImage *)placeholder{
     [self ci_downloadImageWithURL:url forState:state placeholderImage:placeholder progress:nil completed:nil];
}


- (void)ci_downloadImageWithURL:(nullable NSURL *)url
                  forState:(UIControlState)state
                 completed:(nullable CIExternalCompletionBlock)completedBlock{
    [self ci_downloadImageWithURL:url forState:state placeholderImage:nil progress:nil completed:completedBlock];
}


- (void)ci_downloadImageWithURL:(nullable NSURL *)url
                  forState:(UIControlState)state
          placeholderImage:(nullable UIImage *)placeholder
                 completed:(nullable CIExternalCompletionBlock)completedBlock{
    [self ci_downloadImageWithURL:url forState:state placeholderImage:placeholder progress:nil completed:completedBlock];
}


- (void)ci_downloadImageWithURL:(nullable NSURL *)url
                  forState:(UIControlState)state
          placeholderImage:(nullable UIImage *)placeholder
                  progress:(nullable CIImageLoaderProgressBlock)progressBlock
                 completed:(nullable CIExternalCompletionBlock)completedBlock{
    [self sd_setImageWithURL:url forState:state placeholderImage:placeholder options:SDWebImageRetryFailed|SDWebImageLowPriority context:nil progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        if(progressBlock){
            progressBlock(receivedSize,expectedSize,targetURL);
        }
    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if(completedBlock){
            completedBlock(image,error,imageURL);
        }
    }];
}


#pragma mark - Background Image
- (nullable NSURL *)ci_currentBackgroundImageURL {
    return [self sd_currentBackgroundImageURL];
}

- (nullable NSURL *)ci_backgroundImageURLForState:(UIControlState)state {
    return [self sd_backgroundImageURLForState:state];
}


- (void)ci_downloadBackgroundImageWithURL:(nullable NSURL *)url
                            forState:(UIControlState)state{
    [self ci_downloadBackgroundImageWithURL:url forState:state placeholderImage:nil progress:nil completed:nil];
}

- (void)ci_downloadBackgroundImageWithURL:(nullable NSURL *)url
                            forState:(UIControlState)state
                    placeholderImage:(nullable UIImage *)placeholder{
    [self ci_downloadBackgroundImageWithURL:url forState:state placeholderImage:placeholder progress:nil completed:nil];
}


- (void)ci_downloadBackgroundImageWithURL:(nullable NSURL *)url
                            forState:(UIControlState)state
                           completed:(nullable CIExternalCompletionBlock)completedBlock{
    [self ci_downloadBackgroundImageWithURL:url forState:state placeholderImage:nil progress:nil completed:completedBlock];
}


- (void)ci_downloadBackgroundImageWithURL:(nullable NSURL *)url
                            forState:(UIControlState)state
                    placeholderImage:(nullable UIImage *)placeholder
                           completed:(nullable CIExternalCompletionBlock)completedBlock{
    [self ci_downloadBackgroundImageWithURL:url forState:state placeholderImage:nil progress:nil completed:completedBlock];
}


- (void)ci_downloadBackgroundImageWithURL:(nullable NSURL *)url
                            forState:(UIControlState)state
                    placeholderImage:(nullable UIImage *)placeholder
                            progress:(nullable CIImageLoaderProgressBlock)progressBlock
                           completed:(nullable CIExternalCompletionBlock)completedBlock{
    [self sd_setBackgroundImageWithURL:url forState:state placeholderImage:placeholder options:SDWebImageRetryFailed|SDWebImageLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        if(progressBlock){
            progressBlock(receivedSize,expectedSize,targetURL);
        }
    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if(completedBlock){
            completedBlock(image,error,imageURL);
        }
    }];
}

#pragma mark - Cancel


- (void)ci_cancelImageLoadForState:(UIControlState)state{
    [self sd_cancelImageLoadForState:state];
}


- (void)ci_cancelBackgroundImageLoadForState:(UIControlState)state{
    [self sd_cancelBackgroundImageLoadForState:state];
}

@end
