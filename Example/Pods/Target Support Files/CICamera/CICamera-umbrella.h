#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "CICamera.h"
#import "CICameraManager.h"
#import "CIGalleryManager.h"
#import "CIPicture.h"
#import "CIScan.h"
#import "CIScanView.h"
#import "CIScanViewController.h"
#import "CIVideo.h"
#import "CICameraMarco.h"
#import "CIGalleryMacro.h"
#import "ConfigMacro.h"
#import "Macro.h"
#import "FLAnimatedImage.h"
#import "FLAnimatedImageView.h"
#import "UIImage+PKShortVideoPlayer.h"
#import "GLProgram.h"
#import "GPUImageContext.h"
#import "GPUImageFramebuffer.h"
#import "GPUImageFramebufferCache.h"
#import "PKShortVideo.h"
#import "PKChatMessagePlayerView.h"
#import "PKColorConversion.h"
#import "PKFullScreenPlayerView.h"
#import "PKFullScreenPlayerViewController.h"
#import "PKPlayerManager.h"
#import "PKPlayerView.h"
#import "PKVideoDecoder.h"
#import "PKRecordShortVideoViewController.h"
#import "PKShortVideoProgressBar.h"
#import "PKShortVideoRecorder.h"
#import "PKShortVideoSession.h"
#import "TZAssetCell.h"
#import "TZAssetModel.h"
#import "TZGifPhotoPreviewController.h"
#import "TZImageCropManager.h"
#import "TZImageManager.h"
#import "TZImagePickerController.h"
#import "TZImageRequestOperation.h"
#import "TZLocationManager.h"
#import "TZPhotoPickerController.h"
#import "TZPhotoPreviewCell.h"
#import "TZPhotoPreviewController.h"
#import "TZProgressView.h"
#import "TZVideoPlayerController.h"
#import "UIView+Layout.h"

FOUNDATION_EXPORT double CICameraVersionNumber;
FOUNDATION_EXPORT const unsigned char CICameraVersionString[];

