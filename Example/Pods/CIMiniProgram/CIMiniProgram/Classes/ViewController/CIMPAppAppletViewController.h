//
//  CIMPAppAppletViewController.h
//  CIMiniProgram
//
//  Created by 袁鑫 on 2020/4/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CIMPAppAppletViewController : UIViewController

@property (nonatomic, assign) BOOL isLoading;

- (void)startLoadingWithImage:(UIImage *)image title:(NSString *)title;

- (void)stopLoadingWithCompletion:(dispatch_block_t)completion;

@end

NS_ASSUME_NONNULL_END
