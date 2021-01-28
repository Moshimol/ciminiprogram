//
//  CIPhoto.m
//  CIPhotoBrowser
//
//  Created by 曹中浩 on 2020/4/10.
//

#import "CIPhoto.h"

@implementation CIPhoto

- (instancetype)initWithImage:(UIImage *)image{
    self = [super init];
    if(self){
        _image = image;
    }
    return self;}

- (instancetype)initWithURL:(NSURL *)url{
    self = [super init];
    if(self){
        _photoURL = url;
    }
    return self;
}

@end
