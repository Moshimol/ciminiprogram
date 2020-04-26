//
//  CICaptionView.h
//  CIPhotoBrowser
//
//  Created by 曹中浩 on 2020/4/10.
//

#import <MWPhotoBrowser/MWPhotoBrowser.h>
#import "CIPhoto.h"

NS_ASSUME_NONNULL_BEGIN

@interface CICaptionView : MWCaptionView

@property UIButton * displayOriginalImageButton;
@property UIButton * saveButton;
@property UIButton * albumButton;
@property UIButton * moreButton;

@end

NS_ASSUME_NONNULL_END
