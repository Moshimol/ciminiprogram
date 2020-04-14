//
//  CIMPTabBar.h
//  AFNetworking
//
//  Created by 袁鑫 on 2020/4/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CIMPTabBar : UITabBar

@property (nonatomic, copy) NSString *color;
@property (nonatomic, copy) NSString *selectedColor;
@property (nonatomic, copy) NSString *backgroundColor;
@property (nonatomic, copy) NSString *borderStyle;

- (void)configTabbarItemList:(NSArray *)list;
- (void)selectItemAtIndex:(NSUInteger)itemIndex;
- (void)didTapItem:(void(^)(NSString *pagePath,NSUInteger pageIndex))itemBlock;
- (void)didInitDefaultItem:(void(^)(NSString *pagePath,NSUInteger pageIndex))itemBlock;
- (void)showDefaultTabarItem;
- (void)setStyle;

@end

NS_ASSUME_NONNULL_END
