//
//  CIMPHomeTitleView.m
//  CIMiniProgram
//
//  Created by lushitong on 2020/10/21.
//

#import "CIMPHomeTitleView.h"

@implementation CIMPHomeTitleView

- (void)drawRect:(CGRect)rect {
    CGFloat size = 6;
    CGFloat padding = 5;
    CGFloat left = (self.bounds.size.width - 3 * size - 2 * padding) / 2;
    CGFloat top = 0;
    for (NSInteger i = 0 ; i < self.colors.count; i++) {
        [self.colors[i] setFill];
        [[UIBezierPath bezierPathWithOvalInRect:CGRectMake(left, top, size, size)] fill];
        left += size;
        left += padding;
    }
}

@end
