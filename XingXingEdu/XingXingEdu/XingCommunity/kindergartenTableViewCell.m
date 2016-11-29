//
//  kindergartenTableViewCell.m
//  XingXingEdu
//
//  Created by super on 16/2/25.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "kindergartenTableViewCell.h"
#import "WebViewController.h"
@implementation kindergartenTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)setKindergartenImage:(NSString *)KindergartenImage
{
    _KindergartenImage = KindergartenImage;
    self.kindergartenImageVIew.image = [UIImage imageNamed:KindergartenImage];
}
-(void)setKindergartenLabeli:(NSString *)KindergartenLabeli
{
    _KindergartenLabeli = KindergartenLabeli;
    self.kindergartenLabel.text = KindergartenLabeli;
}
-(void)setKindergartenLabelab:(NSString *)KindergartenLabelab
{
    _KindergartenLabelab = KindergartenLabelab;
    self.KindergartenLabela.text = KindergartenLabelab;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
