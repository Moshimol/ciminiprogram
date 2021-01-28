//
//  CIPhotoBrowser.h
//  CIPhotoBrowser
//
//  Created by 曹中浩 on 2020/4/10.
//

#import "CIPhoto.h"

NS_ASSUME_NONNULL_BEGIN
@class CIPhotoBrowser;

@protocol CIPhotoBrowserDataSource <NSObject>

- (NSUInteger)numberOfPhotosInPhotoBrowser:(CIPhotoBrowser *)photoBrowser;

- (CIPhoto *)photoBrowser:(CIPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index;

@optional

- (void)saveImageAtIndex:(NSUInteger)index;

- (void)handleMoreActionAtIndex:(NSUInteger)index;

- (NSString *)photoBrowser:(CIPhotoBrowser *)photoBrowser titleForPhotoAtIndex:(NSUInteger)index;

- (void)photoBrowser:(CIPhotoBrowser *)photoBrowser didDisplayPhotoAtIndex:(NSUInteger)index;

@end

@interface CIPhotoBrowser : UIViewController

@property  (nonatomic, weak) id <CIPhotoBrowserDataSource> dataSource;

-(instancetype)initWithDataSource:(id <CIPhotoBrowserDataSource>)dataSource;

@property (nonatomic) BOOL shouldHideDisplayOriginalButton;
@property (nonatomic) BOOL shouldHideToolBar;

@property (nonatomic) NSInteger currentPhotoIndex;

@end


NS_ASSUME_NONNULL_END
