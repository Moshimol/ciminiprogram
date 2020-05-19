//
//  CIFIleViewController.m
//  CIViewFile_Example
//
//  Created by Adam on 2020/4/16.
//  Copyright © 2020 daijian. All rights reserved.
//

#import "CIFileViewController.h"


@interface CIFIleViewController () <QLPreviewControllerDataSource,QLPreviewControllerDelegate>

@property (nonatomic,strong) QLPreviewController * previewController;

@end

@implementation CIFIleViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    _previewController = [[QLPreviewController alloc] init];
//    _previewController.view.frame = self.view.bounds;
    _previewController.delegate = self;
    _previewController.dataSource = self;
    _previewController.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    [self addChildViewController:_previewController];
    [self.view addSubview:_previewController.view];
    
    
    [self setTitle:self.nameArr.firstObject];
    
//    UIButton * btn = [[UIButton alloc] init];
//    [btn setTitle:@"返回" forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    
//    [self presentViewController:_previewController animated:NO completion:nil];
    // Do any additional setup after loading the view.
}

-(void)back {
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller
{
    return self.pathArr.count;
}
 
- (id<QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index
{
    NSString * str = self.pathArr[index];
    NSURL * url = [NSURL fileURLWithPath:str];
    //文件路径，也就是已经下载后的路径
    return url;
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
