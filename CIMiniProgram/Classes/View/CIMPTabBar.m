//
//  CIMPTabBar.m
//  AFNetworking
//
//  Created by 袁鑫 on 2020/4/9.
//

#import "CIMPTabBar.h"
#import "CIMPPageModel.h"
#import <CICategories/CICategories.h>

@interface CIMPTabBarItem : UITabBarItem

@property (nonatomic, strong) CIMPTabbarItemStyle *itemStyle;

@end

@implementation CIMPTabBarItem

@end

@interface CIMPTabBar () <UITabBarDelegate>

@property (nonatomic, copy) void (^DidTapItemBlock)(NSString *pagePath,NSUInteger pageIndex);

@property (nonatomic, copy) void (^DidInitDefaultItemBlock)(NSString *pagePath,NSUInteger pageIndex);

@end

@implementation CIMPTabBar

- (void)setBackgroundColor:(NSString *)backgroundColor {
    _backgroundColor = backgroundColor;

    UIColor *bgColor = [UIColor ColorWithHexString:backgroundColor];
    if (bgColor) {
        [self setBackgroundImage:[UIImage imageWithColor:bgColor size:CGSizeMake(1.0, 1.0)]];
    }
}

- (void)configTabbarItemList:(NSArray *)list {
    if (!list) {
        return;
    }
    
    NSMutableArray *items = [NSMutableArray new];
    for (int i = 0; i < list.count; i++) {
        CIMPTabbarItemStyle *dic = list[i];
        CIMPTabBarItem *item = [self addTabbarItem:dic];
        [items addObject:item];
    }
    
    [self setDelegate:self];
    self.items = items;
}

- (CIMPTabBarItem *)addTabbarItem:(CIMPTabbarItemStyle *)itemStyle {
    NSString *title = itemStyle.title;
    NSString *iconPath = itemStyle.iconPath;
    NSString *selectedIconPath = itemStyle.selectedIconPath;
    
    CIMPTabBarItem *barItem = [[CIMPTabBarItem alloc] init];
    barItem.itemStyle = itemStyle;
    barItem.title = title;
    
    UIColor *normalColor = [UIColor ColorWithHexString:_color];
    if (normalColor) {
        [barItem setTitleTextAttributes:@{NSForegroundColorAttributeName: normalColor} forState:UIControlStateNormal];
    }
    
    UIColor *selectedColor = [UIColor ColorWithHexString:_selectedColor];
    if (selectedColor) {
        [barItem setTitleTextAttributes:@{NSForegroundColorAttributeName: selectedColor} forState:UIControlStateSelected];
        self.tintColor = selectedColor;
    }
    
    if (iconPath) {
        barItem.image = [[self imageWithImage:[UIImage imageWithContentsOfFile:iconPath] scaledToSize:CGSizeMake(30, 30)] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }

    if (selectedIconPath) {
        barItem.selectedImage = [[self imageWithImage:[UIImage imageWithContentsOfFile:selectedIconPath] scaledToSize:CGSizeMake(30, 30)] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }

    return barItem;
}

- (void)didTapItem:(void(^)(NSString *pagePath,NSUInteger pageIndex))itemBlock {
    self.DidTapItemBlock = itemBlock;
}

- (void)didInitDefaultItem:(void(^)(NSString *pagePath,NSUInteger pageIndex))itemBlock {
    self.DidInitDefaultItemBlock = itemBlock;
}

- (void)showDefaultTabarItem {
    CIMPTabBarItem *barItem = (CIMPTabBarItem *)self.items[0];
    [self mp_setSelectedItem:barItem];
    if (self.DidInitDefaultItemBlock) {
        self.DidInitDefaultItemBlock(barItem.itemStyle.pagePath,0);
    }
}

- (void)mp_setSelectedItem:(id)tabbarItem {
    [self setSelectedItem:tabbarItem];
}

- (void)selectItemAtIndex:(NSUInteger)itemIndex {
    CIMPTabBarItem *barItem = (CIMPTabBarItem *)self.items[itemIndex];
    [self mp_setSelectedItem:barItem];
    if (self.DidTapItemBlock) {
        self.DidTapItemBlock(barItem.itemStyle.pagePath,itemIndex);
    }
}

- (void)setStyle {
    UIColor *bgColor = [UIColor ColorWithHexString:_backgroundColor];
    if (bgColor) {
        [self setBackgroundImage:[UIImage imageWithColor:bgColor size:CGSizeMake(1.0, 1.0)]];
    }
    
    for (UITabBarItem *barItem in self.items) {
        UIColor *normalColor = [UIColor ColorWithHexString:_color];
        if (normalColor) {
            [barItem setTitleTextAttributes:@{NSForegroundColorAttributeName: normalColor} forState:UIControlStateNormal];
        }
        
        UIColor *selectedColor = [UIColor ColorWithHexString:_selectedColor];
        if (selectedColor) {
            [barItem setTitleTextAttributes:@{NSForegroundColorAttributeName: selectedColor} forState:UIControlStateSelected];
            self.tintColor = selectedColor;
        }
    }
    
    
}

#pragma mark - Callback
#pragma mark -

- (void)didTapTabbarView:(UIButton *)sender {
    [self selectItemAtIndex:sender.tag - 100];
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(CIMPTabBarItem *)item {
    if (self.DidTapItemBlock) {
        self.DidTapItemBlock(item.itemStyle.pagePath,[self.items indexOfObject:item]);
    }
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    CGFloat scale = UIScreen.mainScreen.scale;
    
    UIGraphicsBeginImageContextWithOptions(newSize, NO, scale);
    [image drawInRect:CGRectMake(0.0, 0.0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
