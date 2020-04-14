//
//  CIMPPageModel.h
//  CIMiniProgram
//
//  Created by 袁鑫 on 2020/4/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CIMPPageStyle : NSObject

@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, strong) UIColor *navigationBarBackgroundColor;
@property (nonatomic, copy) NSString *backgroundTextStyle;
@property (nonatomic, copy) NSString *navigationBarTextStyle;
@property (nonatomic, copy) NSString * navigationBarTitleText;
@property (nonatomic, assign) BOOL enablePullDownRefresh;
@property (nonatomic, assign) BOOL disableNavigationBack;

@end

@interface CIMPTabbarItemStyle : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *pagePath;
@property (nonatomic, copy) NSString *iconPath;
@property (nonatomic, copy) NSString *selectedIconPath;
@property (nonatomic, assign) BOOL isDefaultPath;

@end

@interface CIMPTabbarStyle : NSObject

@property (nonatomic, copy) NSString *color;
@property (nonatomic, copy) NSString *selectedColor;
@property (nonatomic, copy) NSString *backgroundColor;
@property (nonatomic, copy) NSString *position;
@property (nonatomic, copy) NSString *borderStyle;
@property (nonatomic, copy) NSArray <CIMPTabbarItemStyle *> *list;

@end

@interface CIMPPageModel : NSObject

@property (nonatomic, assign) unsigned long long  pageId;
@property (nonatomic, copy) NSString *pageRootDir;
@property (nonatomic, strong) CIMPPageStyle * pageStyle;
@property (nonatomic, strong, nullable) CIMPPageStyle *windowStyle;
@property (nonatomic, strong) CIMPTabbarStyle *tabbarStyle;
@property (nonatomic, copy) NSString *openType;
@property (nonatomic, copy) NSString * query;
@property (nonatomic, copy) NSString * pagePath;
@property (nonatomic, copy, nullable) NSString *backType;

- (NSString *) pathKey;
- (NSString *) wholePageUrl;
- (NSString *) pagePathUrl;

/**
 更新当前页navigationbar的title
 */
- (void)updateTitle:(NSString *)title;

/**
 解析当前web页容器的样式数据

 @param window 当前页的容器WDHBaseViewController
 */
+ (CIMPPageStyle *) parseWindowStyleData:(NSDictionary *)window;

/**
 解析当前web页的样式数据

 @param pages Web页面
 @param path 页面路径
 */
+ (CIMPPageStyle *)parsePageStyleData:(NSDictionary *)pages path:(NSString *)path;

@end

NS_ASSUME_NONNULL_END
