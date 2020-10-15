//
//  CIMPDeviceMacro.h
//  Pods
//
//  Created by 袁鑫 on 2020/4/9.
//

#ifndef CIMPDeviceMacro_h
#define CIMPDeviceMacro_h

#define IS_IPHONE        (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPHONE_4      (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 480.0)
#define IS_IPHONE_5      (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 568.0)
#define IS_IPHONE_6      (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 667.0)
#define IS_IPHONE_6PLUS  (IS_IPHONE && [[UIScreen mainScreen] nativeScale] == 3.0f)
#define IS_IPHONE_6_PLUS (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 736.0)
#define IS_IPHONE_X       (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 812.0)

#endif /* CIMPDeviceMacro_h */
