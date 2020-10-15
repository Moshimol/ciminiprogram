//
//  CIMPBaseViewController+Extension.m
//  CIMiniProgram
//
//  Created by 袁鑫 on 2020/4/10.
//

#import "CIMPBaseViewController+Extension.h"
#import "CIMPPageModel.h"
#import "CIMPLog.h"

@implementation CIMPBaseViewController (Extension)

- (void)track_open_page {
    if (self.pageModel) {
        MPLog(@"open_page--->desc: %@",
              @{@"page": self.pageModel.pagePath, @"openType": self.pageModel.openType});
    }
}

- (void)track_open_page_success {
    if (self.pageModel) {
        MPLog(@"open_page_success--->desc: %@",
              @{@"page": self.pageModel.pagePath, @"openType": self.pageModel.openType});
    }
}

- (void)track_open_page_failure:(NSString *)error {
    if (self.pageModel) {
        MPLog(@"open_page_failure--->desc: %@",
              @{@"page": self.pageModel.pagePath, @"error": error});
    }
}

- (void)track_close_page:(NSString *)pages {
    MPLog(@"close_page--->page: %@", pages);
}

- (void)track_page_ready {
    MPLog(@"page_ready--->desc: %@",
          @{@"page": self.pageModel.pagePath, @"openType": self.pageModel.openType});
}

- (void)track_renderContainer {
    if (self.pageModel) {
        MPLog(@"renderContainer--->desc: %@",
              @{@"page": self.pageModel.pagePath, @"openType": self.pageModel.openType});
    }
}

- (void)track_renderContainer_success {
    if (self.pageModel) {
        MPLog(@"renderContainer_success--->desc: %@",
              @{@"page": self.pageModel.pagePath, @"openType": self.pageModel.openType});
    }
}

- (void)track_renderContainer_failure:(NSString *)error {
    if (self.pageModel) {
        MPLog(@"renderContainer_failure--->desc: %@",
              @{@"page": self.pageModel.pagePath, @"error": error});
    }
}

@end
