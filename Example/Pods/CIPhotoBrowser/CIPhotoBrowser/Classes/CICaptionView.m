//
//  CICaptionView.m
//  CIPhotoBrowser
//
//  Created by 曹中浩 on 2020/4/10.
//

#import "CICaptionView.h"
#import <Masonry/Masonry.h>

@interface CICaptionView ()

@end

@implementation CICaptionView

- (void)setupCaption{
    [super setupCaption];
    
    _displayOriginalImageButton = [[UIButton alloc]init];
    [_displayOriginalImageButton setBackgroundColor:[UIColor colorWithWhite:0x26/255.0 alpha:1.0]];

    NSAttributedString * title = [[NSAttributedString alloc]initWithString:@"查看原图" attributes:@{
        NSFontAttributeName:[UIFont systemFontOfSize:12]
    }];
    [_displayOriginalImageButton setAttributedTitle:title forState:UIControlStateNormal];
    [self addSubview:_displayOriginalImageButton];
    [_displayOriginalImageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self).with.offset(16);
        make.size.mas_equalTo(CGSizeMake(128,32));
    }];
    
    
    _saveButton = [[UIButton alloc]init];
    [_saveButton setImage:[UIImage imageNamed:@"ci_photo_browser_save"] forState:UIControlStateNormal];
    [self addSubview:_saveButton];
    
    _albumButton = [[UIButton alloc]init];
    [_albumButton setImage:[UIImage imageNamed:@"ci_photo_browser_album"] forState:UIControlStateNormal];
    [self addSubview:_albumButton];
    
    _moreButton = [[UIButton alloc]init];
    [_moreButton setImage:[UIImage imageNamed:@"ci_photo_browser_more"] forState:UIControlStateNormal];
    [self addSubview:_moreButton];
    
    [_moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(19);
        make.right.equalTo(self).with.offset(-16);
        make.size.mas_equalTo(CGSizeMake(26, 26));
    }];
    
    [_albumButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(19);
        make.right.equalTo(self.moreButton.mas_left).with.offset(-16);
        make.size.mas_equalTo(CGSizeMake(26, 26));
    }];
    
    [_saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(19);
        make.right.equalTo(self.albumButton.mas_left).with.offset(-16);
        make.size.mas_equalTo(CGSizeMake(26, 26));
    }];
    
    [_displayOriginalImageButton addTarget:self action:@selector(displayOriginalImage) forControlEvents:UIControlEventTouchUpInside];
    [_saveButton addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
    [_albumButton addTarget:self action:@selector(manageAction) forControlEvents:UIControlEventTouchUpInside];
    [_moreButton addTarget:self action:@selector(moreAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.userInteractionEnabled = YES;
}

- (CGSize)sizeThatFits:(CGSize)size{
    int extraHeight = 0;
    if (@available(iOS 11.0, *)) {
        extraHeight = [UIApplication sharedApplication].keyWindow.safeAreaInsets.bottom - 16;
    }
    
    return CGSizeMake(UIScreen.mainScreen.bounds.size.width, 64 + extraHeight);
}

- (void)displayOriginalImage{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"CIPhotoBrowserDisplayOriginalImage" object:nil userInfo:nil];
}

- (void)saveAction{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"CIPhotoBrowserSave" object:nil userInfo:nil];
}

- (void)manageAction{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"CIPhotoBrowserManage" object:nil userInfo:nil];
}

- (void)moreAction{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"CIPhotoBrowserMore" object:nil userInfo:nil];
}
@end
