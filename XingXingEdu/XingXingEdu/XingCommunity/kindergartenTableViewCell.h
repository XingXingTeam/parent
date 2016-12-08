//
//  kindergartenTableViewCell.h
//  XingXingEdu
//
//  Created by super on 16/2/25.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface kindergartenTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *kindergartenImageVIew;

@property (strong, nonatomic) IBOutlet UILabel *kindergartenLabel;
@property (strong, nonatomic) IBOutlet UILabel *KindergartenLabela;



@property (nonatomic,copy) NSString *KindergartenImage;
@property (nonatomic,copy) NSString *KindergartenLabeli;
@property (nonatomic,copy) NSString * KindergartenLabelab;
@end
