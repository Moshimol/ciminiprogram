//
//  CIMPLoadingView.m
//  CIMiniProgram
//
//  Created by 袁鑫 on 2020/4/9.
//  Copyright © 2020 Nanjing Xihui Information & Technology Co., Ltd. All rights reserved.
//

#import "CIMPLoadingView.h"

@interface CIMPLoadingView ()

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, strong) UILabel *loadingLabel;
@property (nonatomic, copy) NSString *loadingText;

@end

static NSMutableArray *loadingQueue = nil;

@implementation CIMPLoadingView

+ (void)initialize {
    if (!loadingQueue) {
        loadingQueue = [NSMutableArray array];
    }
}

- (void)setLoadingText:(NSString *)loadingText {
    _loadingText = loadingText;
    self.loadingLabel.text = loadingText;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _activityIndicatorView = [[UIActivityIndicatorView alloc] init];
        _activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        
        _loadingLabel = [UILabel new];
        _loadingLabel.font = [UIFont boldSystemFontOfSize:12.0];
        _loadingLabel.textColor = [UIColor whiteColor];
        _loadingLabel.textAlignment = NSTextAlignmentCenter;

        [self addSubview:_activityIndicatorView];
        [self addSubview:_loadingLabel];
        
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat w = self.bounds.size.width;
    CGFloat h = self.bounds.size.height;
    
    CGFloat offset = 0;
    if (self.loadingText) {
        offset = 8;
    }

    self.activityIndicatorView.frame = CGRectMake(0.0, 0.0, 34.0, 34.0);
    self.activityIndicatorView.center = CGPointMake(w/2.0, h/2.0 - offset);
    
    CGFloat labelTop = self.activityIndicatorView.frame.origin.y + self.activityIndicatorView.frame.size.height + 10;
    self.loadingLabel.frame = (CGRect){0,labelTop,w,20};
}

// Only override draw() if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
    // Drawing code
     UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:10];
     [[UIColor colorWithWhite:0 alpha:0.6] set];
     [path fill];
}

+ (void)stopAnimationInView:(UIView *)view {
    CIMPLoadingView *loadingView = [view viewWithTag:kLoaddingViewTagId];
    if (loadingView) {
        [loadingView stopLoading];
    }
}

+ (void)startAnimationInView:(UIView *)view {
    CIMPLoadingView *loadingView = [view viewWithTag:kLoaddingViewTagId];
    if (loadingView) {
        [loadingView startLoading];
    }
}

- (void)startLoading {
    if (!self.activityIndicatorView.isAnimating) {
        [self.activityIndicatorView startAnimating];
    }
}

- (void)stopLoading {
    if (self.activityIndicatorView.isAnimating) {
        [self.activityIndicatorView stopAnimating];
    }
    [loadingQueue removeObject:self];
}


static NSInteger kLoaddingViewTagId = 1891008;
+ (void)showInView:(UIView *)view text:(NSString *)text mask:(BOOL)mask {
    CIMPLoadingView *exsistsLoading = [view viewWithTag:kLoaddingViewTagId];
    if (exsistsLoading) {
        [exsistsLoading stopLoading];
        [exsistsLoading removeFromSuperview];
    }
    
    CGFloat w = 100;
    CGFloat h = 100;
    
    CGFloat left = (view.frame.size.width - w)/2;
    left = (CGFloat)(ceilf((CGFloat)left));
    
    CGFloat top = (view.frame.size.height - h)/2;
    top = (CGFloat)(ceilf((CGFloat)top));
    
    CIMPLoadingView *loading = [[CIMPLoadingView alloc] initWithFrame:(CGRect){left,top,w,h}];
    loading.loadingText = text;
    [view addSubview:loading];
    [loading startLoading];
    loading.alpha = 0;
    loading.tag = kLoaddingViewTagId;
    
    [UIView animateWithDuration:0.15 animations:^{
        loading.alpha = 1;
    }];
    
    view.userInteractionEnabled = mask;

    [loadingQueue addObject:loading];
}

+ (void) hideInView:(UIView *)view {
    CIMPLoadingView *loadingView = [view viewWithTag:kLoaddingViewTagId];
    if (!loadingView) {
        loadingView = [loadingQueue firstObject];
    }
    
    if (loadingView) {
        [UIView animateWithDuration:0.15 animations:^{
            loadingView.alpha = 0;
        } completion:^(BOOL finished) {
            [loadingView stopLoading];
            [loadingView removeFromSuperview];
        }];
        
        view.userInteractionEnabled = true;
    }
}

+ (void)removeAllLoading {
    [loadingQueue enumerateObjectsUsingBlock:^(CIMPLoadingView * _Nonnull loadingView, NSUInteger idx, BOOL * _Nonnull stop) {
        [loadingView stopLoading];
        [loadingView removeFromSuperview];
    }];
}

@end
