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
    
   
    [UIView animateWithDuration:2 animations:^{
        [SVProgressHUD showSuccessWithStatus:@"提交成功!"];
    } completion:^(BOOL finished) {
           [self.navigationController popViewControllerAnimated:YES];
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
