//
//  CIMPManagerProtocol.h
//  CIMiniProgram
//
//  Created by 袁鑫 on 2020/4/10.
//

#ifndef CIMPManagerProtocol_h
#define CIMPManagerProtocol_h

@class CIMPPageModel;

@protocol CIMPManagerProtocol <NSObject>

- (void)page_handler:(id)param pageModel:(CIMPPageModel *)pageModel;

- (void)startApp;

- (void)stopApp;

@end

#endif /* CIMPManagerProtocol_h */
