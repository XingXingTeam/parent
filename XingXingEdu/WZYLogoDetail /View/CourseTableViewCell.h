//
//  CourseTableViewCell.h
//  XingXingEdu
//
//  Created by Mac on 16/5/10.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CourseTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *bookIconImage;
@property (weak, nonatomic) IBOutlet UILabel *courseNameLabel;


@property (weak, nonatomic) IBOutlet UILabel *totalNumberLabel;

@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

@property (weak, nonatomic) IBOutlet UILabel *oldPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *nowPriceLbl;

@property (weak, nonatomic) IBOutlet UIImageView *coinImageView;

@property (weak, nonatomic) IBOutlet UIImageView *reduceImageView;
@property (weak, nonatomic) IBOutlet UIImageView *saveImageView;

@property (weak, nonatomic) IBOutlet UIImageView *fullImageView;
//@property (weak, nonatomic) IBOutlet UIImageView *lineImageView;
@property (weak, nonatomic) IBOutlet UIImageView *lineImageView;
@property (weak, nonatomic) IBOutlet UIImageView *separateImageViewOne;
@property (weak, nonatomic) IBOutlet UIImageView *separateImageViewTwo;
@property (weak, nonatomic) IBOutlet UIImageView *separateImageViewThree;





@end
