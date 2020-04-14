//
//  CIMPPrefixHeader.h
//  CIMiniProgram
//
//  Created by 袁鑫 on 2020/4/9.
//

#ifndef CIMPFileMacro_h
#define CIMPFileMacro_h

#define kScreenWidth UIScreen.mainScreen.bounds.size.width
#define kScreenHeight UIScreen.mainScreen.bounds.size.height
#define kFileManager NSFileManager.defaultManager
#define kDocumentsURL [NSFileManager.defaultManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask][0]
#define kMiniProgramURL [kDocumentsURL URLByAppendingPathComponent:@"MiniProgram"]
#define kMiniProgramPKG [kDocumentsURL URLByAppendingPathComponent:@"MiniProgramPKG"]
#define kDocumentsPath NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0]
#define kMiniProgramPath [kDocumentsPath stringByAppendingPathComponent:@"MiniProgram"]
#define kMiniProgramPKGPath [kDocumentsPath stringByAppendingPathComponent:@"MiniProgramPKG"]

#endif /* CIMPPrefixHeader_h */
