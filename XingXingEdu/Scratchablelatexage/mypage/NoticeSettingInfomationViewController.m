//
//  NoticeSettingInfomationViewController.m
//  XingXingEdu
//
//  Created by keenteam on 16/6/14.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "NoticeSettingInfomationViewController.h"

@interface NoticeSettingInfomationViewController ()
@property (weak, nonatomic) IBOutlet UILabel *teacherLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet UITextView *texView;

@end

@implementation NoticeSettingInfomationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.title =@"通知详情";
    // Do any additional setup after loading the view from its nib.
    [self initUI];
}
- (void)initUI{
    self.teacherLbl.text =self.nameStr;
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
