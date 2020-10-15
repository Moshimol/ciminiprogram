//
//  CIMPNavigationView.m
//  CIMiniProgram
//
//  Created by 袁鑫 on 2020/4/9.
//  Copyright © 2020 Nanjing Xihui Information & Technology Co., Ltd. All rights reserved.
//

#import "CIMPNavigationView.h"
#import "CIMPDeviceMacro.h"
#import "UIImage+CIMiniProgram.h"
#import <CICategories/CICategories.h>


@interface CIMPNavigationView ()

@property (nonatomic, weak) UIActivityIndicatorView *activityView;

@end

@implementation CIMPNavigationView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.leftButton = [UIButton buttonWithType:UIButtonTypeSystem];
        self.moreButton = [UIButton buttonWithType:UIButtonTypeSystem];
        self.exitButton = [UIButton buttonWithType:UIButtonTypeSystem];
        self.titleLabel = [UILabel new];
        self.titleLabel.text = @"标题";
        
        [self addSubview:self.leftButton];
        [self addSubview:self.moreButton];
        [self addSubview:self.exitButton];
        [self addSubview:self.titleLabel];

        self.titleLabel.textColor = UIColor.blackColor;
        self.leftButton.tintColor = UIColor.blackColor;
        
        UIImage *img = [UIImage imageFromBundleWithName:@"MP_back_dark" class:[self class]];
        [self.leftButton setImage:img forState:UIControlStateNormal];
        self.leftButton.imageEdgeInsets = UIEdgeInsetsMake(-4.0, -10.0, 4.0, 10.0);
        
        UIImage *moreImage = [UIImage imageFromBundleWithName:@"MP_menu_more_dark_small" class:[self class]];
        [self.moreButton setImage:[moreImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        
        UIImage *exitImage = [UIImage imageFromBundleWithName:@"MP_menu_exit_dark_small" class:[self class]];
        [self.exitButton setImage:[exitImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        SEL leftAction = @selector(leftButtonAction:);
        SEL moreAction = @selector(moreButtonAction:);
        SEL exitAction = @selector(exitButtonAction:);
        [self.leftButton addTarget:self action:leftAction forControlEvents:UIControlEventTouchUpInside];
        [self.moreButton addTarget:self action:moreAction forControlEvents:UIControlEventTouchUpInside];
        [self.exitButton addTarget:self action:exitAction forControlEvents:UIControlEventTouchUpInside];
    }
    
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];

    CGFloat w = self.bounds.size.width;
    CGFloat h = self.bounds.size.height;
    CGFloat controlTop =  [UIApplication sharedApplication].statusBarFrame.size.height;
    CGFloat controlHeight = h - controlTop;
    CGFloat btnWidth = h;
    self.leftButton.frame = (CGRect){15,(controlHeight-24)/2.0+controlTop,32,32};
    self.moreButton.frame = (CGRect){w-7-86,(controlHeight-28)/2.0+controlTop,43,28};
    self.exitButton.frame = (CGRect){w-7-43,(controlHeight-28)/2.0+controlTop,43,28};
    
    // activityView 宽高默认为20
    if (self.activityView) {
        CGSize textSize = [_titleLabel.text sizeWithAttributes:@{NSFontAttributeName:[_titleLabel font]}];
        CGFloat activityX = (w / 2) - (textSize.width / 2) - 10;
        if (textSize.width > self.titleLabel.bounds.size.width) {
            activityX = btnWidth;
        }
        
        self.activityView.frame = (CGRect){activityX,0,20,20};
        // 与titleLabel保持在同一水平线上
        self.activityView.center = CGPointMake(self.activityView.center.x, self.titleLabel.center.y);
        self.titleLabel.frame = (CGRect){btnWidth + 20, controlTop, w - 2 * btnWidth, controlHeight};
        
    } else {
        self.titleLabel.frame = (CGRect){btnWidth, controlTop, w - 2 * btnWidth, controlHeight};
    }
}

#pragma mark - Setter and Getter

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}

#pragma mark - User Interaction

- (void)leftButtonAction:(UIButton *)btn {
    if (self.leftClick) {
        self.leftClick(self);
    }
}

- (void)moreButtonAction:(UIButton *)btn {
    if (self.moreClick) {
        self.moreClick(self);
    }
}

- (void)exitButtonAction:(UIButton *)btn {
    if (self.exitClick) {
        self.exitClick(self);
    }
}


#pragma mark - Public

- (void)setNavigationTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = _title;
}

- (void)startLoadingAnimation {
    // 防止重复
    if (self.activityView) {
        if (!self.activityView.isAnimating) {
            [self.activityView startAnimating];
        }
        return;
    }
    
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    activityView.color = self.titleLabel.textColor;
    [self addSubview:activityView];
    self.activityView = activityView;
    [self layoutIfNeeded];
    
    [self.activityView startAnimating];
}

- (void)hideLoadingAnimation {
    if (self.activityView) {
        [self.activityView stopAnimating];
        [self.activityView removeFromSuperview];
        self.activityView = nil;
    }
}

- (void)setNaviFrontColor:(NSString *)frontColor andBgColor:(NSString *)bgColor withAnimationParam:(NSDictionary *)param {
    
    UIViewAnimationOptions option;
    NSString *timingFunc = param[@"timingFunc"];
    if (!timingFunc) {
        option = UIViewAnimationOptionCurveLinear;
    } else if ([timingFunc isEqualToString:@"easeIn"]) {
        option = UIViewAnimationOptionCurveEaseIn;
    } else if ([timingFunc isEqualToString:@"easeOut"]) {
        option = UIViewAnimationOptionCurveEaseOut;
    } else if ([timingFunc isEqualToString:@"easeInOut"]) {
        option = UIViewAnimationOptionCurveEaseInOut;
    } else {
        option = UIViewAnimationOptionCurveLinear;
    }
    
    // 此处为毫秒 需要转换
    NSTimeInterval duration = [param[@"duration"] integerValue] / 1000.0;
    
    [UIView animateWithDuration: duration delay:0.0 options:option animations:^{
        // front color
        UIColor *color = [UIColor ColorWithHexString:frontColor];
        self.titleLabel.textColor = color;
        self.activityView.color = color;
        self.leftButton.tintColor = color;
        self.moreButton.tintColor = color;
        self.exitButton.tintColor = color;
        
        // background color
        self.backgroundColor = [UIColor ColorWithHexString:bgColor];
    } completion:^(BOOL finished) {
        
    }];
}

@end
