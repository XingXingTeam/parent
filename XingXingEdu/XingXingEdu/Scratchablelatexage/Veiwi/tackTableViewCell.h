//
//  tackTableViewCell.h
//  Homepage
//
//  Created by super on 16/1/29.
//  Copyright © 2016年 Edu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface tackTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *Iphone;
@property (strong, nonatomic) IBOutlet UILabel *Iclass;
@property (strong, nonatomic) IBOutlet UILabel *Ischool;

@property (strong, nonatomic) IBOutlet UILabel *iteacher;
@property (strong, nonatomic) IBOutlet UILabel *izhuangtai;



@property (nonatomic,copy)NSString *phone;
@property (nonatomic,copy)NSString *classname;
@property (nonatomic,copy)NSString *school;
@property (nonatomic,copy)NSString *teacher;
@property (nonatomic,copy)NSString *zhuangtai;




@end
