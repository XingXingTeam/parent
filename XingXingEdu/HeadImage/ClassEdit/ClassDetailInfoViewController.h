//
//  ClassDetailInfoViewController.h
//  XingXingEdu
//
//  Created by Mac on 16/7/2.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClassDetailInfoViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *provinceLabel;

@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *areaLabel;
@property (weak, nonatomic) IBOutlet UILabel *schoolTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *schoolNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *gradeLabel;
@property (weak, nonatomic) IBOutlet UILabel *classLabel;
@property (weak, nonatomic) IBOutlet UILabel *checkLabel;

@property (nonatomic, copy) NSString *provinceStr;
@property (nonatomic, copy) NSString *cityStr;
@property (nonatomic, copy) NSString *areaStr;

@property (nonatomic, copy) NSString *schoolTypeStr;

@property (nonatomic, copy) NSString *schoolNameStr;

@property (nonatomic, copy) NSString *gradeStr;

@property (nonatomic, copy) NSString *classStr;

@property (nonatomic, copy) NSString *checkStr;



@end
