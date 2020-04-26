//
//  CIPhotoBrowser.m
//  CIPhotoBrowser
//
//  Created by 曹中浩 on 2020/4/10.
//

#import "CIPhotoBrowser.h"

@interface CIPhotoBrowser ()<MWPhotoBrowserDelegate>


@property (nonatomic) NSMutableDictionary * originaIndexes;

@end

@implementation CIPhotoBrowser

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [(UIToolbar *)[self valueForKey:@"_toolbar"] removeFromSuperview];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"完成", nil) style:UIBarButtonItemStylePlain target:self action:@selector(doneButtonPressed:)];
}

- (void)reloadData{
    [super reloadData];
    [(UIToolbar *)[self valueForKey:@"_toolbar"] removeFromSuperview];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"完成", nil) style:UIBarButtonItemStylePlain target:self action:@selector(doneButtonPressed:)];
}

- (instancetype)initWithDataSource:(id<CIPhotoBrowserDataSource>)dataSource{
    self = [super initWithDelegate:self];
    if(self){
        self.dataSource = dataSource;
        self.displayActionButton = NO;
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(displayOriginalImage) name:@"CIPhotoBrowserDisplayOriginalImage" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(save) name:@"CIPhotoBrowserSave" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(more) name:@"CIPhotoBrowserMore" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(manage) name:@"CIPhotoBrowserManage" object:nil];
    }
    return self;
}

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser{
    NSUInteger numberOfPhotos = 0;
    if(self.dataSource){
        numberOfPhotos =  [self.dataSource numberOfPhotosInPhotoBrowser:self];
    };
    return numberOfPhotos;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index{
    CIPhoto * photo;
    if(self.dataSource){
        photo = [self.dataSource photoBrowser:self photoAtIndex:index];
    }
    assert(photo);
    if([self.originaIndexes valueForKey:[NSString stringWithFormat:@"%ld",index]]){
        photo = [[CIPhoto alloc]initWithURL:photo.originalURL];
    }
    return photo;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser thumbPhotoAtIndex:(NSUInteger)index{
    CIPhoto * photo;
    if(self.dataSource){
        photo = [self.dataSource photoBrowser:self photoAtIndex:index];
    }
    return photo;
}

- (MWCaptionView *)photoBrowser:(MWPhotoBrowser *)photoBrowser captionViewForPhotoAtIndex:(NSUInteger)index{
    CIPhoto * photo = [self photoBrowser:self photoAtIndex:index];
    if(self.shouldHideToolBar){
        if([self.dataSource respondsToSelector:@selector(photoBrowser:captionViewForPhotoAtIndex:)]){
            return [self.dataSource photoBrowser:self captionViewForPhotoAtIndex:index];
        }
        else{
            return nil;
        }
    }
    CICaptionView * captionView = [[CICaptionView alloc]initWithPhoto:photo];
    if(!photo.originalURL || [self.originaIndexes valueForKey:[NSString stringWithFormat:@"%ld",index]]){
        captionView.displayOriginalImageButton.hidden = YES;
    }
    return captionView;
}

- (NSString *)photoBrowser:(MWPhotoBrowser *)photoBrowser titleForPhotoAtIndex:(NSUInteger)index{
    if([self.dataSource respondsToSelector:@selector(photoBrowser:titleForPhotoAtIndex:)]){
        return [self.dataSource photoBrowser:self titleForPhotoAtIndex:index];
    }
    return [NSString stringWithFormat:@"%lu/%lu",(unsigned long)[self currentIndex]+1,(unsigned long)[self.dataSource numberOfPhotosInPhotoBrowser:self]];
}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser didDisplayPhotoAtIndex:(NSUInteger)index{
    if([self.dataSource respondsToSelector:@selector(photoBrowser:didDisplayPhotoAtIndex:)]){
        [self.dataSource photoBrowser:self didDisplayPhotoAtIndex:index];
    }
}

- (NSMutableDictionary *)originaIndexes{
    if(!_originaIndexes){
        _originaIndexes = @{}.mutableCopy;
    }
    return _originaIndexes;
}

- (void)displayOriginalImage{
    [self.originaIndexes setValue:@"1" forKey:[NSString stringWithFormat:@"%ld",self.currentIndex]];
    [self reloadData];
}


- (void)save{
    if(self.dataSource && [self.dataSource respondsToSelector:@selector(saveImageAtIndex:)]){
        [self.dataSource saveImageAtIndex:self.currentIndex];
    }
}

- (void)more{
    if(self.dataSource && [self.dataSource respondsToSelector:@selector(handleMoreActionAtIndex:)]){
        [self.dataSource handleMoreActionAtIndex:self.currentIndex];
    }
}

- (void)manage{
    if(self.dataSource){
        [self performSelector:@selector(showGridAnimated)];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
