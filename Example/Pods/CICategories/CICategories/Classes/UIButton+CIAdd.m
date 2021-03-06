//
//  UIButton+CIAdd.m
//  MiAiApp
//
//  Created by ikeyyang on 2016/6/1.
//  Copyright © 2016 com.ci123.cn. All rights reserved.
//

#import "UIButton+CIAdd.h"
#import <objc/runtime.h>

@implementation UIButton (CIAdd)

-(void)setBlock:(void(^)(UIButton*))block
{
    objc_setAssociatedObject(self,@selector(block), block,OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:self action:@selector(click:)forControlEvents:UIControlEventTouchUpInside];
}

-(void(^)(UIButton*))block
{
    return objc_getAssociatedObject(self,@selector(block));
}

-(void)addTapBlock:(void(^)(UIButton*))block
{
    self.block= block;
    [self addTarget:self action:@selector(click:)forControlEvents:UIControlEventTouchUpInside];
}

-(void)click:(UIButton*)btn
{
    if(self.block) {
        self.block(btn);
    }
}
@end
