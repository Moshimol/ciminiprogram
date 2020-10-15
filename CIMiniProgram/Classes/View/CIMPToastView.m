//
//  CIMPToastView.m
//  CIMiniProgram
//
//  Created by 袁鑫 on 2020/4/9.
//

#import "CIMPToastView.h"
#import "CIMPFileMacro.h"
#import "CIMPAppManager.h"
#import "UIImage+CIMiniProgram.h"
#import "CIMPApp.h"



@interface CIMPToastView ()

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, copy) NSString *text;

@end

@implementation CIMPToastView

- (void)setText:(NSString *)text {
    _text = text;
    self.label.text = text;
}

- (void)setIcon:(NSString *)icon image:(NSString *)imagePath {
    if (!imagePath || [imagePath isEqualToString:@""]) {
        if ([icon isEqualToString:@"success"]) {
            _iconView.image = [UIImage imageFromBundleWithName:@"MP_toast_success" class:[self class]];
            _iconView.hidden = NO;
        } else if ([icon isEqualToString:@"loading"]) {
            _activityIndicatorView = [[UIActivityIndicatorView alloc] init];
            _activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
            self.activityIndicatorView.frame = CGRectMake(0.0, 0.0, 55.0, 55.0);
            CGFloat w = self.bounds.size.width;
            CGFloat h = self.bounds.size.height;
            self.activityIndicatorView.center = CGPointMake(w/2.0, h/2.0 - 8.0);
            [self addSubview:self.activityIndicatorView];
            [self.activityIndicatorView startAnimating];
        } else if ([icon isEqualToString:@"none"]) {
            self.iconView.frame = CGRectZero;
        }
    } else {
        NSString *iconPath = [NSString stringWithFormat:@"%@/%@/Source/%@", kMiniProgramPath, [CIMPAppManager sharedManager].currentApp.appInfo.appId, imagePath];
        
        // 重新确定路径
        if ([imagePath hasPrefix:@"../.."]) {
            iconPath=[iconPath stringByReplacingOccurrencesOfString:@"../../"withString:@""];
        }
        
        UIImage *customIcon = [UIImage imageWithContentsOfFile:iconPath];
        _iconView.image = customIcon;
        _iconView.hidden = NO;
    }
}

- (void)drawRect:(CGRect)rect {
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:10];
    [[UIColor colorWithWhite:0 alpha:0.8] set];
    [path fill];
}

+ (UIFont *)kTextFont {
    return [UIFont boldSystemFontOfSize:12];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _label = [UILabel new];
        _label.font = [CIMPToastView kTextFont];
        _label.textColor = [UIColor whiteColor];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.numberOfLines = 0;
        //icon 待定
        _iconView = [[UIImageView alloc] init];
        _iconView.hidden = YES;
        
        [self addSubview:_label];
        [self addSubview:_iconView];
        
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat w = self.bounds.size.width;
    CGFloat h = self.bounds.size.height;
    
    self.iconView.frame = CGRectMake(0.0, 0.0, 55.0, 55.0);
    self.iconView.center = CGPointMake(w/2.0, h/2.0 - 8.0);
    
    CGFloat labelTop = self.iconView.frame.origin.y + self.iconView.frame.size.height + 10;
    self.label.frame = (CGRect){0,labelTop,w,20};
}

+ (CIMPToastView *)showInView:(UIView *)view text:(nonnull NSString *)text icon:(nonnull NSString *)icon image:(nullable NSString *)imagePath mask:(BOOL)mask duration:(int)duration {
    CGFloat left = (view.frame.size.width - 116)/2;
    left = (CGFloat)(ceilf((CGFloat)left));
    
    CGFloat top = (view.frame.size.height - 116)/2;
    top = (CGFloat)(ceilf((CGFloat)top));
    
    if (mask) {
        view.userInteractionEnabled = mask;
    }
    
    CIMPToastView *toast = [[CIMPToastView alloc] initWithFrame:CGRectMake(left, top, 116, 116)];
    toast.text = text;
    [toast setIcon:icon image:imagePath];
    [view addSubview:toast];
    toast.alpha = 0;
    [UIView animateWithDuration:0.15 animations:^{
        toast.alpha = 1;
    } completion:^(BOOL finished) {
        CGFloat sec = (float)duration / 1000;
        
        __weak typeof(self) weak_self = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(sec * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weak_self hideToast:toast inView:view];
        });

    }];
    
    return toast;
}

+ (void)hideToast:(CIMPToastView *)toast inView:(UIView *)inView {
    [UIView animateWithDuration:0.15 animations:^{
        toast.alpha = 0;
    } completion:^(BOOL finished) {
        if (toast.activityIndicatorView.isAnimating) {
            [toast.activityIndicatorView stopAnimating];
            [toast.activityIndicatorView removeFromSuperview];
        }
        [toast removeFromSuperview];
    }];

    inView.userInteractionEnabled = true;
}

@end
