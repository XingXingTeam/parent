//
//  myReleaseTableViewCell.m
//  Homepage
//
//  Created by super on 16/2/18.
//  Copyright © 2016年 Edu. All rights reserved.
//

#import "myReleaseTableViewCell.h"

@implementation myReleaseTableViewCell
{
    
}
- (void)awakeFromNib {
    // Initialization code
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setTouxiangImage:(NSString *)touxiangImage
{
    _touxiangImage = touxiangImage;
    self.headImage.image=[UIImage  imageNamed:touxiangImage];
}
-(void)setFBLabel:(NSString *)fBLabel
{
    _fBLabel = fBLabel;
    self.faBuLabel .text = fBLabel;
}
-(void)setPABLabel:(NSString *)pABLabel
{
    _pABLabel = pABLabel;
    self.pALabel.text = pABLabel;
}

-(void)setZTImage:(NSString *)zTImage
{
    _zTImage = zTImage;
    self.zhuangTaiImage.image=[UIImage imageNamed:zTImage];
}
@end
