//
//  CIGalleryManager.m
//  CICamera
//
//  Created by 大大大大_荧🐾 on 2020/2/18.
//  Copyright © 2020 大大大大_荧🐾. All rights reserved.
//

#import "CIGalleryManager.h"
#import "CIPicture.h"
#import "Macro.h"

static CIGalleryManager* _instance = nil;

@interface CIGalleryManager()

@property (nonatomic, strong) CIPicture *ciPicture;

@end

@implementation CIGalleryManager

+ (instancetype)sharedInstance {
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        if(_instance == nil){
            _instance = [[CIGalleryManager alloc] init];
        }
    });
    
    return _instance;
}

- (CIPicture *)ciPicture {
    if (!_ciPicture) {
        _ciPicture = [[CIPicture alloc] init];
    }
    return _ciPicture;
}

- (void)setCount:(int) count {
    self.ciPicture.selectedMaxCount = count;
}

- (void)setIsSelectedVideoCompressed:(BOOL)isSelectedVideoCompressed {
    self.ciPicture.isSelectedVideoCompressed = isSelectedVideoCompressed;
}

- (void) IsAllowPickingVideo:(BOOL)isAllowPickingVideo IsAllowPickingImage:(BOOL)isAllowPickingImage isAllowPickingGif:(BOOL)isAllowPickingGif {
    [self.ciPicture IsAllowPickingVideo:isAllowPickingVideo IsAllowPickingImage:isAllowPickingImage isAllowPickingGif:isAllowPickingGif];
}

- (void)createAlbum:(UIViewController *)presentViewController {
    WS(ws);
    self.ciPicture.completeHandler = ^(NSArray<UIImage *> * _Nonnull photos, NSArray * _Nonnull assets, BOOL _isSelectOriginalPhoto) {
        if (ws.pictureCompleteHandler) {
            ws.pictureCompleteHandler(photos, assets, _isSelectOriginalPhoto);
        }
    };
    self.ciPicture.videoSelectedCompleteHandler = ^(NSString * _Nonnull videoPathString) {
        if (ws.videoSelectedCompleteHandler) {
            ws.videoSelectedCompleteHandler(videoPathString);
        }
    };
    [self.ciPicture showAlbumWithPresentViewController: presentViewController];
}

- (void)setAlbumWithCamera:(BOOL)isOpen {
    self.ciPicture.isAlbumWithCamera = isOpen;
}

- (void)setMinFileSize {
    
}

@end
