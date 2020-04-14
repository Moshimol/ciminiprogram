//
//  CIMPToastView.h
//  CIMiniProgram
//
//  Created by 袁鑫 on 2020/4/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CIMPToastView : UIView

+ (CIMPToastView *)showInView:(UIView *)view text:(NSString *)text icon:(NSString *)icon image:(nullable NSString *)imagePath mask:(BOOL)mask duration:(int)duration;

+ (void)hideToast:(CIMPToastView *)toast inView:(UIView *)inView;

@end

NS_ASSUME_NONNULL_END
