//
//  feedbackViewController.m
//  Homepage
//
//  Created by super on 16/1/20.
//  Copyright © 2016年 Edu. All rights reserved.
//

#import "feedbackViewController.h"
#import "HHControl.h"
#import "AppDelegate.h"
#import "CPTextViewPlaceholder.h"

@interface feedbackViewController ()
{
    UIImageView *back;
    UIButton *submitBtn;
    
}
@property (nonatomic,strong) UITextView * feedbackTextView;
@end

@implementation feedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    back = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    back.image = [UIImage imageNamed:@"background"];
    [self.view addSubview:back];
    [self createTextView];
    [self createButton];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}
-(void)createTextView
{
     _feedbackTextView=[[UITextView alloc]initWithFrame:CGRectMake(40, 100, 300, 200)];
    
    _feedbackTextView.userInteractionEnabled = YES;
    
    [self.view addSubview:_feedbackTextView];
    
}

-(void)createButton
{
    submitBtn = [HHControl createButtonWithFrame:CGRectMake(145, 300, 100, 40) backGruondImageName:@"123"Target:self Action:@selector(onclicksubmit:)Title:@"提交"];
    submitBtn.userInteractionEnabled = YES;
    [submitBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.view addSubview:submitBtn];
    
}
-(void)onclicksubmit:(UIButton *)Btn
{
    UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"谢谢您的建议，我们将尽快解决您提出的建议或意见" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
     [myAlertView show];
}

@end
