//
//  CIZipCell.m
//  CIViewFile
//
//  Created by Adam on 2020/4/17.
//

#import "CIZipCell.h"

@implementation CIZipCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier name:(NSString *)name {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        ZipFileType type = [self getTypeWithName:name];
        [self setupUIWithType:type name:name];
    }
    return self;
}

-(void)setupUIWithType:(ZipFileType)type name:(NSString *)name {
    CGFloat width = self.contentView.frame.size.width;
    CGFloat height = 60;
    NSLog(@"%@",[NSBundle bundleForClass:[self class]]);
    _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 10, height-20, height-20)];
    
    UIImage * image;
    switch (type) {
        case DOC:
            image = [UIImage imageWithContentsOfFile:[[NSBundle bundleForClass:[self class]] pathForResource:@"docx@2x.png" ofType:nil inDirectory:@"CIViewFile.bundle"]];
            break;
            
         case PPT:
            image = [UIImage imageWithContentsOfFile:[[NSBundle bundleForClass:[self class]] pathForResource:@"ppt@2x.png" ofType:nil inDirectory:@"CIViewFile.bundle"]];
            break;
            
        case XLSX:
            image = [UIImage imageWithContentsOfFile:[[NSBundle bundleForClass:[self class]] pathForResource:@"xlsx@2x.png" ofType:nil inDirectory:@"CIViewFile.bundle"]];
            break;
            
        case PDF:
            image = [UIImage imageWithContentsOfFile:[[NSBundle bundleForClass:[self class]] pathForResource:@"pdf@2x.png" ofType:nil inDirectory:@"CIViewFile.bundle"]];
            break;
            
        case ZIP:
            image = [UIImage imageWithContentsOfFile:[[NSBundle bundleForClass:[self class]] pathForResource:@"zip@2x.png" ofType:nil inDirectory:@"CIViewFile.bundle"]];
            break;
            
        case TXT:
            image = [UIImage imageWithContentsOfFile:[[NSBundle bundleForClass:[self class]] pathForResource:@"txt@2x.png" ofType:nil inDirectory:@"CIViewFile.bundle"]];
            break;
            
        case UNKNOW:
            image = [UIImage imageWithContentsOfFile:[[NSBundle bundleForClass:[self class]] pathForResource:@"unknow@2x.png" ofType:nil inDirectory:@"CIViewFile.bundle"]];
            break;
            
        default:
            break;
    }
    _iconImageView.image = image;
    
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iconImageView.frame)+15, 10, width-CGRectGetMaxX(_iconImageView.frame)-15, height/2-10)];
    _titleLabel.text = name;
    _sizeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iconImageView.frame)+15, height/2, width-CGRectGetMaxX(_iconImageView.frame)-15, height/2-10)];
    _sizeLabel.font = [UIFont systemFontOfSize:12];
    _sizeLabel.textColor = [UIColor colorWithRed:171/255.0 green:171/255.0 blue:171/255.0 alpha:1.0];
    
    [self.contentView addSubview:_iconImageView];
    [self.contentView addSubview:_titleLabel];
    [self.contentView addSubview:_sizeLabel];
}

-(ZipFileType)getTypeWithName:(NSString *)name {
    if ([name containsString:@"doc"]) {
        return DOC;
    }else if ([name containsString:@"xls"]) {
        return XLSX;
    }else if ([name containsString:@"pdf"]) {
        return PDF;
    }else if ([name containsString:@"ppt"]) {
        return PPT;
    }else if ([name containsString:@"txt"]) {
        return TXT;
    }else if ([name containsString:@"zip"]) {
        return ZIP;
    }else {
        return UNKNOW;
    }
    return UNKNOW;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
