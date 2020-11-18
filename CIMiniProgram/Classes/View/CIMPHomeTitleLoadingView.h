//
//  CIMPHomeTitleLoadingView.h
//  CIMiniProgram
//
//  Created by lushitong on 2020/10/21.
//

#import <UIKit/UIKit.h>
#import "CIMPHomeTitleView.h"

NS_ASSUME_NONNULL_BEGIN

@interface CIMPHomeTitleLoadingView : UIView

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) CIMPHomeTitleView *loadingView;
@property (nonatomic, copy) dispatch_block_t completion;

// 开始加载
- (void)startLoad;

- (CGFloat)layoutViews;

- (void)stopLoadWithCompletion:(void(^)(void))completion;

@end

NS_ASSUME_NONNULL_END
