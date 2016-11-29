//
//  myReleaseTableViewCell.h
//  Homepage
//
//  Created by super on 16/2/18.
//  Copyright © 2016年 Edu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface myReleaseTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *headImage;
@property (strong, nonatomic) IBOutlet UILabel *faBuLabel;
@property (strong, nonatomic) IBOutlet UILabel *pALabel;
@property (strong, nonatomic) IBOutlet UIImageView *zhuangTaiImage;



@property (nonatomic,copy) NSString * touxiangImage;
@property (nonatomic,copy) NSString * fBLabel;
@property (nonatomic,copy) NSString * pABLabel;
@property (nonatomic,copy) NSString * zTImage;

@end
