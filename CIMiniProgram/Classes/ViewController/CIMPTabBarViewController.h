//
//  CIMPTabBarViewController.h
//  CIMiniProgram
//
//  Created by 袁鑫 on 2020/4/10.
//

#import "CIMPBaseViewController.h"
#import "CIMPPageModel.h"
#import "CIMPBaseViewController.h"
#import "CIMPPageBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface CIMPTabBarViewController : CIMPBaseViewController

@property (nonatomic, weak) CIMPPageBaseViewController *currentController;

@property (nonatomic, strong) CIMPTabbarStyle *tabbarStyle;

@property (nonatomic, strong) NSArray *viewControllers;

/**
 切换tab

 @param pagePath tab页面路径
 */
- (void)switchTabBar:(NSString *)pagePath;

- (void)loadTabStyle;

@end

NS_ASSUME_NONNULL_END
