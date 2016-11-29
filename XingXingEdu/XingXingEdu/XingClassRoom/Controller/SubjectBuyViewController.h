//
//  SubjectBuyViewController.h
//  XingXingEdu
//
//  Created by codeDing on 16/2/28.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface SubjectBuyViewController : UIViewController

@property(nonatomic,strong) NSArray *numberArray;//下拉选择框
@property(nonatomic,copy)NSString *course_name;
@property(nonatomic,strong) NSMutableArray *dataArr;
@property(nonatomic,copy)NSString *course_Id;
@property(nonatomic,strong) NSMutableArray *infoData;
@end
