




//
//  AlbumCollectionViewCell.m
//  XingXingEdu
//
//  Created by Mac on 16/5/11.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "AlbumCollectionViewCell.h"

@implementation AlbumCollectionViewCell

//重写初始化方法
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createSubViews];
        
    }
    
    return self;
}
-(void)createSubViews{
  
    UIImageView *myImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    myImageView.tag = 11;
    [self.contentView addSubview:myImageView];
}

-(void)setImageName:(NSString *)imageName{
    _imageName = imageName;
//    NSLog(@"-----*******%@", imageName);
    UIImageView *iconImageView = [self viewWithTag:11];
    [iconImageView sd_setImageWithURL:[NSURL URLWithString:imageName] placeholderImage:nil];
//    iconImageView.image = [UIImage imageNamed:_imageName];
    
}


@end
