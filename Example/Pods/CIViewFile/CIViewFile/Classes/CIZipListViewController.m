//
//  CIZipListViewController.m
//  CIViewFile
//
//  Created by Adam on 2020/4/17.
//

#import "CIZipListViewController.h"
#import "CIFileViewHelper.h"
#import "CIFileViewHelper.h"
#import "CIZipCell.h"

@interface CIZipListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView * tableView;

@end

@implementation CIZipListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_tableView];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    // Do any additional setup after loading the view.
}

-(void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString * name = self.dataArray[indexPath.row];
    NSString * path = [self.documentPath stringByAppendingPathComponent:name];
    NSString * size = [NSString stringWithFormat:@"%.0lldk",[CIFileViewHelper fileSizeAtPath:path]/1024];
    CIZipCell * cell = [[CIZipCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CIZipCell" name:name];
    cell.sizeLabel.text = size;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString * name = self.dataArray[indexPath.row];
    NSString * path = [self.documentPath stringByAppendingPathComponent:name];
    BOOL isDir = [CIFileViewHelper isDirectory:path];
    if (isDir) {
        NSArray * fileList = [CIFileViewHelper obtainZipSubsetWithFilePath:path];
        
    }else {
        
    }
//    NSURL * url = [NSURL fileURLWithPath:path];
//    BOOL res = [CIFileViewHelper canPreviewItem:url];
//    if (res) {
        [CIFileViewHelper showFileWithName:name path:path rootViewController:self];
//    }else {
        
//    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
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
