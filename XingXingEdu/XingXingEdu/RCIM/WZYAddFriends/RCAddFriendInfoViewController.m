//
//  RCAddFriendInfoViewController.m
//  XingXingEdu
//
//  Created by codeDing on 16/4/3.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "RCAddFriendInfoViewController.h"
#import "ReportPicViewController.h"
@interface RCAddFriendInfoViewController (){
    NSString *reply;
}

@end

@implementation RCAddFriendInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self settingContent];
    
    // Do any additional setup after loading the view from its nib.
    self.replyLabel.hidden=YES;
    self.replyInfoLabel.hidden=YES;
}

- (void)settingContent{

    _iconImageView.layer.cornerRadius = 30;
    _iconImageView.layer.masksToBounds = YES;
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:_iconStr] placeholderImage:[UIImage imageNamed:@"人物头像172x172"]];
    
    _nameLabel.text = _nicknameStr;
    

}

- (IBAction)recordbtn:(id)sender {
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"回复" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        
        //        textField.backgroundColor = [UIColor orangeColor];
        textField.placeholder=@"回复";
        
//        NSLog(@"  textField.text  %@", textField.text);
//        reply=textField.text;
       
    }];
    UIAlertAction *cancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *ok=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.replyLabel.hidden=NO;
        self.replyInfoLabel.hidden=NO;
        
//        NSLog(@" 回复 %@", alert.textFields[0].text);
        self.replyLabel.text=alert.textFields[0].text;
        [SVProgressHUD showSuccessWithStatus:@"回复成功"];
        
    }];
    [alert addAction:ok];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)passbtn:(id)sender {
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"确定通过验证？" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *cancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *ok=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [SVProgressHUD showSuccessWithStatus:@"加入好友成功"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    }];
    [alert addAction:ok];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)toblackbtn:(id)sender {
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"确定加入黑名单？" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *cancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *ok=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [SVProgressHUD showSuccessWithStatus:@"加入黑名单成功"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    }];
    [alert addAction:ok];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)complaintbtn:(id)sender {
    ReportPicViewController * vc=[[ReportPicViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    
}




@end
