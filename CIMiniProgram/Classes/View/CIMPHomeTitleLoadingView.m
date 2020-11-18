//
//  CIMPHomeTitleLoadingView.m
//  CIMiniProgram
//
//  Created by lushitong on 2020/10/21.
//

#import "CIMPHomeTitleLoadingView.h"

@implementation CIMPHomeTitleLoadingView {
    dispatch_source_t _timer;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self loadSubviews];
    }
    return self;
}

- (void)loadSubviews {
    [self addSubview:self.iconView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.loadingView];
}

- (CGFloat)layoutViews {
    CGFloat bottom = 0;
    self.iconView.hidden = self.iconView.image == nil;
    if(!self.iconView.hidden) {
        CGFloat imageTop = 14;
        CGFloat imageSize = 44;
        CGFloat imageLeft = (self.bounds.size.width - imageSize) * .5;
        self.iconView.frame = CGRectMake(imageLeft, imageTop, imageSize, imageSize);
        bottom = self.iconView.frame.size.height + self.iconView.frame.origin.y;
    }
    
    self.titleLabel.hidden = self.titleLabel.text == nil;
    
    if(!self.titleLabel.hidden) {
        [self.titleLabel sizeToFit];
        CGFloat lft = (self.bounds.size.width - self.titleLabel.bounds.size.width) / 2;
        if(!self.iconView.hidden) {
            CGFloat titleLabelTop = self.iconView.frame.size.height + self.iconView.frame.origin.y + 15;
            self.titleLabel.frame = CGRectMake(lft, titleLabelTop, self.titleLabel.bounds.size.width, self.titleLabel.bounds.size.height);
        } else {
            CGFloat titleLabelTop = (44 - self.titleLabel.bounds.size.height) / 2;
            self.titleLabel.frame = CGRectMake(lft, titleLabelTop, self.titleLabel.bounds.size.width, self.titleLabel.bounds.size.height);
        }
        bottom = self.titleLabel.frame.size.height + self.titleLabel.frame.origin.y;
    }
    
    CGFloat iconWidth = 6 * 3 + 5 * 2;
    self.loadingView.frame = CGRectMake((self.bounds.size.width - iconWidth) * .5 ,bottom + 22, iconWidth, 10);
    bottom += 22;
    bottom += 10;
    
    return bottom;
}

- (void)startLoad {
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 0.3 * NSEC_PER_SEC, 0.0);
    
    __weak typeof(self) weakSelf = self;
    dispatch_source_set_event_handler(timer, ^{
        NSArray *arr = weakSelf.loadingView.colors;
        UIColor *clr0 = arr[0];
        UIColor *clr1 = arr[1];
        UIColor *clr2 = arr[2];
        NSMutableArray *narr = @[].mutableCopy;
        narr[0] = clr2;
        narr[1] = clr0;
        narr[2] = clr1;
        weakSelf.loadingView.colors = narr;
        [weakSelf.loadingView setNeedsDisplay];
    });
    
    _timer = timer;
    dispatch_resume(timer);
}

- (void)stopLoadWithCompletion:(void (^)(void))completion {
    
    [self performSelector:@selector(hiddenSelf) withObject:nil afterDelay:0.15];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.iconView.frame = CGRectMake(self.bounds.size.width/2, 0, 0, 0);
        CGFloat lft = (self.bounds.size.width - self.titleLabel.bounds.size.width) / 2;
        CGFloat titleLabelTop = (44 - self.titleLabel.bounds.size.height) / 2;
        self.titleLabel.frame = CGRectMake(lft, titleLabelTop, self.titleLabel.bounds.size.width, self.titleLabel.bounds.size.height);
        self.loadingView.alpha = 0;
        self.loadingView.frame = CGRectMake(self.loadingView.frame.origin.x,
                                            self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height + 22,
                                            self.loadingView.frame.size.width,
                                            self.loadingView.frame.size.height);
        dispatch_source_cancel(self->_timer);
    } completion:^(BOOL finished) {
        if(completion) {
            completion();
        }
    }];
}

- (void)hiddenSelf {
    self.hidden = YES;
}

#pragma mark lazy init

- (UIImageView *)iconView {
    if(!_iconView) {
        _iconView = [[UIImageView alloc] init];
        _iconView.layer.cornerRadius = 5.0;
        _iconView.layer.masksToBounds = YES;
    }
    return _iconView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:17.0];
        _titleLabel.textColor = [UIColor blackColor];
    }
    return _titleLabel;
}

- (CIMPHomeTitleView *)loadingView {
    if(!_loadingView) {
        _loadingView = [[CIMPHomeTitleView alloc] init];
        _loadingView.backgroundColor = [UIColor clearColor];
        UIColor *clr0 = [UIColor colorWithRed:205./255. green:205./255. blue:205./255. alpha:1];
        UIColor *clr1 = [UIColor colorWithRed:221./255. green:221./255. blue:221./255. alpha:1];
        UIColor *clr2 = [UIColor colorWithRed:213./255. green:213./255. blue:213./255. alpha:1];
        _loadingView.colors = @[clr0,clr1,clr2];
    }
    return _loadingView;
}

@end
