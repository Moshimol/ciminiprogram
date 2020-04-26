//
//  UIButton+CIAdd.h
//
//  Created by ikeyyang on 2016/6/1.
//  Copyright © 2016 com.ci123.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (CIAdd)

@property(nonatomic ,copy)void(^block)(UIButton*);

-(void)addTapBlock:(void(^)(UIButton*btn))block;

@end
