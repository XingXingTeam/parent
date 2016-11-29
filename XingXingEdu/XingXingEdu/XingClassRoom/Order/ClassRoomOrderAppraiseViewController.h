//
//  ClassRoomOrderAppraiseViewController.h
//  XingXingEdu
//
//  Created by codeDing on 16/3/31.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClassRoomOrderAppraiseViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *courseL;
@property (weak, nonatomic) IBOutlet UILabel *teachL;
@property (weak, nonatomic) IBOutlet UILabel *teacherL;
@property (weak, nonatomic) IBOutlet UILabel *attitudeL;

@property (weak, nonatomic) IBOutlet UIView *starView1;
@property (weak, nonatomic) IBOutlet UIView *starView2;
@property (weak, nonatomic) IBOutlet UIView *photoView;
@property (weak, nonatomic) IBOutlet UIView *starView3;
@property (weak, nonatomic) IBOutlet UIView *starView4;
- (IBAction)goBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *sureBtton;
@property (weak, nonatomic) IBOutlet UITextView *assessTextT;

@property(nonatomic,copy)NSString *orderId;

@end
