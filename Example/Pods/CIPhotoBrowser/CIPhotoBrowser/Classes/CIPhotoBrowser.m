//
//  CIPhotoBrowser.m
//  CIPhotoBrowser
//
//  Created by 曹中浩 on 2020/4/10.
//

#import "CIPhotoBrowser.h"
#import <Masonry/Masonry.h>
#import <CIWebImage/CIWebImage.h>

@interface CIPhotoBrowser () <UIScrollViewDelegate>

@property (nonatomic) NSMutableDictionary * originaIndexes;

@property (nonatomic) UIScrollView * scrollView;

@end

@implementation CIPhotoBrowser

- (instancetype)initWithDataSource:(id<CIPhotoBrowserDataSource>)dataSource{
    self = [super init];
    if(self){
        self.edgesForExtendedLayout = UIRectEdgeNone;
        _dataSource = dataSource;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.scrollView];
}

- (void)viewWillAppear:(BOOL)animated{
    [self reloadData];
}

- (void)reloadData{
    NSInteger number = [self.dataSource numberOfPhotosInPhotoBrowser:self];
    float width =  CGRectGetWidth(self.view.frame);
    float height = CGRectGetHeight(self.view.frame);
    for (int i = 0; i < number; i++) {
        
        UIScrollView * scrollView = [UIScrollView new];
        scrollView.frame = CGRectMake(width * i, 0, width, height);
        scrollView.delegate = self;
        scrollView.maximumZoomScale = 2;
        scrollView.minimumZoomScale = 1;
        
        CIPhoto * photo = [self.dataSource photoBrowser:self photoAtIndex:i];
        UIImageView * imageView = [UIImageView new];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.frame = CGRectMake(0, 0, width, height);
        [imageView ci_downloadImageWithURL:photo.photoURL placeholderImage:photo.image progress:nil completed:^(UIImage * _Nullable image, NSError * _Nullable error, NSURL * _Nullable imageURL) {
            float imageWidth = image.size.width > width ? width : image.size.width;
            float imageHeight = image.size.height / image.size.width * width;
            float x = (width - imageWidth)/2;
            float y = (height - imageHeight)/2;
            if(y < 0){
                y = 0;
            }
            imageView.frame = CGRectMake(x, y, imageWidth, imageHeight);
            if(imageHeight > height){
                scrollView.contentSize = CGSizeMake(width, imageHeight);
            }
        }];


        [scrollView addSubview:imageView];
        [_scrollView addSubview:scrollView];

    }
    self.scrollView.contentSize = CGSizeMake(width * number, 0);
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return scrollView.subviews.firstObject;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    UIImageView *imV = (UIImageView *)[scrollView.subviews firstObject];
    CGFloat delta_x= scrollView.bounds.size.width > scrollView.contentSize.width ? (scrollView.bounds.size.width-scrollView.contentSize.width)/2 : 0;
    CGFloat delta_y= scrollView.bounds.size.height > scrollView.contentSize.height ? (scrollView.bounds.size.height - scrollView.contentSize.height)/2 :0;
    imV.center=CGPointMake(scrollView.contentSize.width/2 + delta_x, scrollView.contentSize.height/2 + delta_y);
}


- (UIScrollView *)scrollView{
    if(!_scrollView){
        _scrollView = [[UIScrollView alloc]initWithFrame:self.view.frame];
        _scrollView.backgroundColor = UIColor.blackColor;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;

    }
    return _scrollView;
}

@end
