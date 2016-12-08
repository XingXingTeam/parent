//
//  WZYAddBabyViewController.h
//  XingXingEdu
//
//  Created by Mac on 16/5/11.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WZYAddBabyViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UIImageView *sexImageView;


@property (weak, nonatomic) IBOutlet UIImageView *leftImageView1;
@property (weak, nonatomic) IBOutlet UIImageView *leftImageView2;
@property (weak, nonatomic) IBOutlet UIImageView *leftImageView3;
@property (weak, nonatomic) IBOutlet UIImageView *leftImageView4;


@property (weak, nonatomic) IBOutlet UILabel *leftLabel1;
@property (weak, nonatomic) IBOutlet UILabel *leftLabel2;
@property (weak, nonatomic) IBOutlet UILabel *leftLabel3;
@property (weak, nonatomic) IBOutlet UILabel *leftLabel4;


@property (weak, nonatomic) IBOutlet UITextField *rightTextField1;
@property (weak, nonatomic) IBOutlet UITextField *rightTextField2;
@property (weak, nonatomic) IBOutlet UITextField *rightTextField3;
//@property (weak, nonatomic) IBOutlet UITextField *rightTextField4;


@property (weak, nonatomic) IBOutlet UITextView *myTextView;

@property (weak, nonatomic) IBOutlet UIButton *doneBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

@property (nonatomic, copy) NSString *babyId;

@end
