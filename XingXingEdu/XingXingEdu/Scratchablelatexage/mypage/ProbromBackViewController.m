//
//  ProbromBackViewController.m
//  XingXingEdu
//
//  Created by keenteam on 16/5/11.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "ProbromBackViewController.h"
#import "SVProgressHUD.h"
@interface ProbromBackViewController ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *numLbl;
@property (weak, nonatomic) IBOutlet UITextView *textFid;

@property (weak, nonatomic) IBOutlet UILabel *textLbl;

@end

@implementation ProbromBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"意见反馈";
    // Do any additional setup after loading the view from its nib.
    _textFid.userInteractionEnabled =YES;
    _textFid.delegate =self;
    
}
- (IBAction)submitBtn:(UIButton *)sender {
    
//   
//    [UIView animateWithDuration:2 animations:^{
//        [SVProgressHUD showSuccessWithStatus:@"提交成功!"];
//    } completion:^(BOOL finished) {
//           [self.navigationController popViewControllerAnimated:YES];
//    }];
    
    /*
     【意见反馈(两端通用)】
     
     接口类型:2
     
     接口:
     http://www.xingxingedu.cn/Global/suggestion_sub
     
     传参:
     con	//反馈内容
     */
    //路径
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/suggestion_sub";
    
    //请求参数
    NSDictionary *params = @{@"appkey":APPKEY, @"backtype":BACKTYPE, @"xid":XID, @"user_id":USER_ID, @"user_type":USER_TYPE, @"con":_textFid.text};
    
    [WZYHttpTool post:urlStr params:params success:^(id responseObj) {
        //
//        NSLog(@"反馈 意见  ---  %@", responseObj);
        /*
         反馈 意见  ---  {
         msg = Success!,
         data = ,
         code = 1
         }
         */
        
        
        NSString *codeStr = [NSString stringWithFormat:@"%@", responseObj[@"code"]];
        if ([codeStr isEqualToString:@"1"]) {
            
                [UIView animateWithDuration:2 animations:^{
                    [SVProgressHUD showSuccessWithStatus:@"提交成功!"];
                } completion:^(BOOL finished) {
                       [self.navigationController popViewControllerAnimated:YES];
                }];
        
        }else{
            
        [SVProgressHUD showSuccessWithStatus:@"提交失败!"];
        
        }
        
    } failure:^(NSError *error) {
        //
        NSLog(@"%@", error);
    }];
    
}


- (void)textViewDidBeginEditing:(UITextView *)textView{
    self.textLbl.hidden =YES;

}
- (void)textViewDidChange:(UITextView *)textView{
    _numLbl.text =[NSString stringWithFormat:@"%ld/200",textView.text.length];

}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [self.view endEditing:YES];

}


@end
