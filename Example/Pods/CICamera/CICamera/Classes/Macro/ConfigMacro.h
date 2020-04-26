//
//  ConfigMacro.h
//  CICamera
//
//  Created by 大大大大_荧🐾 on 2020/2/21.
//  Copyright © 2020 大大大大_荧🐾. All rights reserved.
//

#ifndef ConfigMacro_h
#define ConfigMacro_h

#define SCREENWIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREENHEIGHT ([[UIScreen mainScreen] bounds].size.height)

#define RGBColor(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]

#define WS(weakSelf) __weak __typeof(&*self)weakSelf = self;

#endif /* ConfigMacro_h */
