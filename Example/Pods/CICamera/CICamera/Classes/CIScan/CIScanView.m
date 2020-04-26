//
//  CIScanView.m
//  CICamera
//
//  Created by 大大大大_荧🐾 on 2020/2/21.
//  Copyright © 2020 大大大大_荧🐾. All rights reserved.
//

#import "CIScanView.h"
#import "ConfigMacro.h"

@interface CIScanView()

@property (nonatomic, assign) CGFloat scanAreaWidth;
@property (nonatomic, assign) BOOL isStart;
@property (nonatomic, assign) CGFloat scanLineImageViewY;
@property (nonatomic, strong) UIImageView *scanLineImageView;
@property (nonatomic, strong) UILabel *tipLabel;

@end

@implementation CIScanView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.scanAreaWidth = 220.0;
        self.isStart = NO;
        self.scanLineImageViewY = self.center.y - self.scanAreaWidth/2 - 40;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (UIImageView *)scanLineImageView {
    if (!_scanLineImageView) {
        NSBundle *imageBundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:[CIScanView class]] pathForResource: @"CICameraImage" ofType: @"bundle"]];
        NSString *name = @"scanline@2x";
        NSString *imagePath = [imageBundle pathForResource:name ofType:@"png"];
        UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
        if (!image) {
            // 兼容业务方自己设置图片的方式
            name = [name stringByReplacingOccurrencesOfString:@"@2x" withString:@""];
            image = [UIImage imageNamed:name];
        }
        _scanLineImageView = [[UIImageView alloc] initWithImage: image];
        _scanLineImageView.frame = CGRectMake(SCREENWIDTH/2 - self.scanAreaWidth/2, self.center.y - self.scanAreaWidth - 40, self.scanAreaWidth, self.scanAreaWidth);
        _scanLineImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _scanLineImageView;
}

- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, SCREENHEIGHT/2 + self.scanAreaWidth/2 - 40, SCREENWIDTH, self.scanAreaWidth)];
        _tipLabel.text = @"将二维码放入框内，即可自动扫描";
        _tipLabel.textColor = RGBColor(221, 221, 221);
        _tipLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _tipLabel;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef content = UIGraphicsGetCurrentContext();
    CGRect scanRect = CGRectMake(SCREENWIDTH/2 - self.scanAreaWidth/2, SCREENHEIGHT/2 - self.scanAreaWidth/2 - 40, self.scanAreaWidth, self.scanAreaWidth);
    // 背景色
    CGContextSetRGBFillColor(content, 40/255.0, 40/255.0, 40/255.0, 0);
    CGContextFillRect(content, CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT));
    // 中间扫码区域
    CGContextClearRect(content, scanRect);
    // 四条白边
    CGContextStrokeRect(content, scanRect);
    CGContextSetRGBStrokeColor(content, 1, 1, 1, 1);
    CGContextSetLineWidth(content, 0.8);
    CGContextAddRect(content, scanRect);
    CGContextStrokePath(content);
    // 四角红边
//    CGContextSetLineWidth(content, 2);
//    CGContextSetRGBStrokeColor(content, 229, 70, 110, 1);
//    NSArray *pointsTopLeftA = [(CGPointMake(scanRect.origin.x + 0.7, scanRect.origin.y)), (CGPointMake(scanRect.origin.x + 0.7, scanRect.origin.y + 15))];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (!self.isStart) {
        [self addSubview:self.scanLineImageView];
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(scanLineImageViewRun) userInfo:nil repeats:YES];
        [timer fire];
    }
    [self addSubview:self.tipLabel];
}

- (void) scanLineImageViewRun {
    [UIView animateWithDuration:0.02 animations:^{
        CGRect tmpRect = self.scanLineImageView.frame;
        tmpRect.origin.y = self.scanLineImageViewY;
        self.scanLineImageView.frame = tmpRect;
    } completion:^(BOOL finished) {
        if (self.scanLineImageViewY > self.center.y - 40) {
            self.scanLineImageViewY = self.center.y - self.scanAreaWidth - 40;
        }
        self.scanLineImageViewY += 2;
    }];
}

@end
