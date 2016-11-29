//
//  NoticeInfomationViewController.m
//  XingXingEdu
//
//  Created by keenteam on 16/5/12.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "NoticeInfomationViewController.h"

@interface NoticeInfomationViewController ()
{
    NSDictionary *dict;
}
@property (weak, nonatomic) IBOutlet UILabel *teacherLbl;
@property (weak, nonatomic) IBOutlet UILabel *auditLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet UITextView *texView;


@end

@implementation NoticeInfomationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title =@"通知详情";
    dict =[[NSDictionary alloc]initWithObjectsAndKeys:@"班级通知",@"1",@"学校通知",@"2", nil];
    
    [self initUI];
}
- (void)initUI{

    self.teacherLbl.text =self.nameStr;
    self.auditLbl.text =[dict objectForKey:self.locationStr];
    self.timeLbl.text =self.dateStr;
    self.texView.text =self.conStr;

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
