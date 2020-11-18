//
//  CIMPNavigationView.h
//  CIMiniProgram
//
//  Created by 袁鑫 on 2020/4/9.
//  Copyright © 2020 Nanjing Xihui Information & Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class CIMPNavigationView;

typedef void(^ButtonClickBlock)(CIMPNavigationView *);

@interface CIMPNavigationView : UIView

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *moreButton;
@property (nonatomic, strong) UIButton *exitButton;

@property (nonatomic, copy) ButtonClickBlock leftClick;
@property (nonatomic, copy) ButtonClickBlock moreClick;
@property (nonatomic, copy) ButtonClickBlock exitClick;

// 隐藏titile的标题
- (void)changeTitleHidden:(BOOL)hidden;


/**
 设置标题
 
 @param title 标题
 */
- (void)setNavigationTitle:(NSString *)title;

/**
 开始旋转菊花图动画
 */
- (void)startLoadingAnimation;

/**
 隐藏菊花图旋转动画
 */
- (void)hideLoadingAnimation;

/**
 设置Bar颜色

 @param frontColor 文字等颜色
 @param bgColor 背景色
 @param param 动画参数
 */
- (void)setNaviFrontColor:(NSString *)frontColor andBgColor:(NSString *)bgColor withAnimationParam:(NSDictionary *)param;

@end

NS_ASSUME_NONNULL_END
