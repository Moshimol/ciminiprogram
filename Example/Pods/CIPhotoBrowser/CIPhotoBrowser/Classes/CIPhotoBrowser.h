//
//  CIPhotoBrowser.h
//  CIPhotoBrowser
//
//  Created by 曹中浩 on 2020/4/10.
//

#import "CIPhoto.h"
#import "CICaptionView.h"
#import <MWPhotoBrowser/MWPhotoBrowser.h>

NS_ASSUME_NONNULL_BEGIN
@class CIPhotoBrowser;

@protocol CIPhotoBrowserDataSource <NSObject>

- (NSUInteger)numberOfPhotosInPhotoBrowser:(CIPhotoBrowser *)photoBrowser;

- (id <MWPhoto>)photoBrowser:(CIPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index;

@optional

- (void)saveImageAtIndex:(NSUInteger)index;

- (void)handleMoreActionAtIndex:(NSUInteger)index;

- (NSString *)photoBrowser:(CIPhotoBrowser *)photoBrowser titleForPhotoAtIndex:(NSUInteger)index;

- (MWCaptionView *)photoBrowser:(CIPhotoBrowser *)photoBrowser captionViewForPhotoAtIndex:(NSUInteger)index;

- (void)photoBrowser:(CIPhotoBrowser *)photoBrowser didDisplayPhotoAtIndex:(NSUInteger)index;

@end

@interface CIPhotoBrowser : MWPhotoBrowser

@property  id <CIPhotoBrowserDataSource> dataSource;

-(instancetype)initWithDataSource:(id <CIPhotoBrowserDataSource>)dataSource;

@property BOOL shouldHideDisplayOriginalButton;
@property BOOL shouldHideToolBar;

@end


NS_ASSUME_NONNULL_END
