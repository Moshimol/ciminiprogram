//
//  CIMPPageModel.m
//  CIMiniProgram
//
//  Created by 袁鑫 on 2020/4/9.
//

#import "CIMPPageModel.h"
#import <CICategories/CICategories.h>

@implementation CIMPTabbarItemStyle

@end

@implementation CIMPTabbarStyle

@end

@implementation CIMPPageStyle

@end

@implementation CIMPPageModel

- (instancetype)init {
    if (self = [super init]) {
        self.pageId = [self hash];
    }
    return self;
}

- (NSString *) pathKey {
    NSArray *pathArray = [_pagePath componentsSeparatedByString:@"."];
    NSString *pathKey = pathArray.firstObject;
    return pathKey;
}

- (NSString *)wholePageUrl{
    
    return [NSString stringWithFormat:@"%@%@",self.pageRootDir,[self pagePathUrl]];
}

- (NSString *)pagePathUrl {
    NSArray *pathArray = [_pagePath componentsSeparatedByString:@"."];
    if (pathArray.count > 1) {
        return self.pagePath;
    }
    return [self.pagePath stringByAppendingString:@".html"];
}

- (void)updateTitle:(NSString *)title {
    if (self.pageStyle) {
        self.pageStyle.navigationBarTitleText = title;
    }
    
    if (self.windowStyle) {
        self.windowStyle.navigationBarTitleText = title;
    }
}

//解析Style
+ (CIMPPageStyle *) parseWindowStyleData:(NSDictionary *)window {
    CIMPPageStyle *model = [CIMPPageStyle new];
    model.navigationBarBackgroundColor = [UIColor ColorWithHexString:window[@"navigationBarBackgroundColor"]];
    model.backgroundColor = [UIColor ColorWithHexString:window[@"backgroundColor"]];
    model.backgroundTextStyle = window[@"backgroundTextStyle"];
    model.navigationBarTextStyle = window[@"navigationBarTextStyle"];
    model.navigationBarTitleText = window[@"navigationBarTitleText"];
    model.enablePullDownRefresh =  [window[@"enablePullDownRefresh"] boolValue];
    model.disableNavigationBack = [window[@"disableNavigationBack"] boolValue];
    
    return model;
}

+ (CIMPPageStyle *)parsePageStyleData:(NSDictionary *)pages path:(NSString *)path {
    return [CIMPPageModel parseWindowStyleData:pages[path]];
}

@end
