//
//  AddAccountViewController.m
//  XingXingEdu
//
//  Created by keenteam on 16/5/25.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "AddAccountViewController.h"
#import "SVProgressHUD.h"
@interface AddAccountViewController ()<UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *ktTF;
@property (weak, nonatomic) IBOutlet UITextField *KTTF;

@end

@implementation AddAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"添加账号";
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)compliseBtn:(UIButton *)sender {
    
    
    if ([self.KTTF.text isEqualToString:self.ktTF.text]) {
        [SVProgressHUD showSuccessWithStatus:@"添加成功"];
        typeof(self) __weak weak =self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weak.navigationController popViewControllerAnimated:NO];
        });
        
 
    }
    else{
        UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"您的支付宝账号不一致,请重试" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"重试", nil];
        [al show];
    
    }
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {

        
    }else if (buttonIndex == 1)
    {
       
        
    }
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
