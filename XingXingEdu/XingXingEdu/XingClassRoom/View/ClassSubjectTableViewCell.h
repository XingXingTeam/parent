//
//  ClassSubjectTableViewCell.h
//  XingXingStore
//
//  Created by codeDing on 16/1/28.
//  Copyright © 2016年 codeDing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClassSubjectTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *peopleNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *beginDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *teacherLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceNewLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceOldLabel;

@property (weak, nonatomic) IBOutlet UIButton *collect;
@property (weak, nonatomic) IBOutlet UIButton *NumberPeople;
@property (weak, nonatomic) IBOutlet UIButton *moneyXing;
@property (weak, nonatomic) IBOutlet UIButton *moveBack;



@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;

@property (weak, nonatomic) IBOutlet UIImageView *attestationLabel1;

@property (weak, nonatomic) IBOutlet UIImageView *attestationLabel2;

@property (weak, nonatomic) IBOutlet UIImageView *iconImg;

@property (weak, nonatomic) IBOutlet UIImageView *separator1;
@property (weak, nonatomic) IBOutlet UIImageView *separator2;
@property (weak, nonatomic) IBOutlet UIImageView *separator3;
@property (weak, nonatomic) IBOutlet UIImageView *buttomBackground;

@end
