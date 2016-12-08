//
//  ReturnOfGoodsViewController.m
//  XingXingEdu
//
//  Created by mac on 16/7/29.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "ReturnOfGoodsViewController.h"
#import "WJCommboxView.h"
#import "WZYTextView.h"

#define kmgar 20.0f
#define klabelW 65.0f
#define klabelH 35.0f

@interface ReturnOfGoodsViewController ()<WJCommboxViewDelegate, UITextViewDelegate, UITextFieldDelegate>{
    
    NSInteger _number;
    NSString *parameterXid;
    NSString *parameterUser_Id;
}

@property(nonatomic,strong)WJCommboxView *relationCombox;//下拉选择框
@property (nonatomic,strong) WZYTextView *textView;
@property (nonatomic, strong) UILabel *myLabel;
@property (nonatomic) NSInteger myLabelTextLength;
@end

@implementation ReturnOfGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }
    self.view.backgroundColor = UIColorFromRGB(241, 242, 241);
    self.title = @"退货理由";
   
    
    [self returnOfGoodsView];
}

-(void)returnOfGoodsView{
    
    UIView *bgHeadView = [HHControl createViewWithFrame:CGRectMake(0, 64, kWidth, 400)];
    bgHeadView.userInteractionEnabled = YES;
    bgHeadView.backgroundColor = UIColorFromRGB(255, 255, 255);
    [self.view addSubview:bgHeadView];
    
    UILabel *returnLabel = [HHControl createLabelWithFrame:CGRectMake(kmgar, kmgar/2, klabelW, klabelH) Font:14 Text:@"退货类型:"];
    [bgHeadView addSubview:returnLabel];
    
    NSArray *relationArray = [[NSArray alloc]initWithObjects:@"实物商品退货",@"虚拟商品退货",nil];
    _relationCombox = [[WJCommboxView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(returnLabel.frame),kmgar/2,kWidth - CGRectGetMaxX(returnLabel.frame) - kmgar *2, klabelH)];
    _relationCombox.textField.placeholder = @"请选择您的退货类型";
    _relationCombox.textField.layer.cornerRadius = 5.0f;
    _relationCombox.textField.layer.borderWidth = 1.0f;
    _relationCombox.textField.layer.borderColor = [[UIColor clearColor]CGColor];
    _relationCombox.textField.textAlignment = NSTextAlignmentCenter;
    _relationCombox.textField.rightView.width = - 15;
    _relationCombox.delegate = self;
    _relationCombox.dataArray = relationArray;
    
    [bgHeadView addSubview:self.relationCombox];
    
    UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(returnLabel.frame) + kmgar /4, kWidth, kmgar/4)];
    line.backgroundColor = UIColorFromRGB(241, 242, 241);
    [bgHeadView addSubview:line];
    
    _textView = [[WZYTextView alloc] initWithFrame:CGRectMake(kmgar, CGRectGetMaxY(line.frame), kWidth - kmgar *2, 200)];
    _textView.alwaysBounceVertical = YES; // 垂直方向上拥有有弹簧效果
    _textView.delegate = self;
    [bgHeadView addSubview:_textView];
    // 2.设置提醒文字（占位文字）
    _textView.placehoder = @"请输入您的退货理由，以及在您的退货包裹上写上订单号(退货运费自理)";
    
    // 3.设置字体
    _textView.font = [UIFont systemFontOfSize:12];
    _myLabel = [[UILabel alloc] initWithFrame:CGRectMake(_textView.size.width - 70, CGRectGetMaxY(_textView.frame) - kmgar *4, klabelW, kmgar)];
    _myLabel.text = @"1/200";
    _myLabel.textColor = [UIColor lightGrayColor];
    _myLabel.font = [UIFont systemFontOfSize:12];
    [_textView addSubview:self.myLabel];
    
    //重写bgHeadView的大小
    bgHeadView.frame = CGRectMake(kmgar/4,64 , kWidth, CGRectGetMaxY(_textView.frame) + kmgar/2);
    
    UIButton *buyBtn = [HHControl createButtonWithFrame:CGRectMake(kmgar, CGRectGetMaxY(bgHeadView.frame) + kmgar, kWidth - kmgar *2, 42) backGruondImageName:@"按钮（big）icon650x84.png" Target:self Action:@selector(returnOfGoodsMessage) Title:@"提交"];
    [buyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:buyBtn];
    
}

-(void)sendSelectCellNum:(NSInteger)num{
    
    _number = num + 1;

}


-(void)returnOfGoodsMessage{
    
    if (_number == 0) {
        [SVProgressHUD showInfoWithStatus:@"请选择退货类型"];
        return;
    }else if (_textView.text.length <= 0){
        [SVProgressHUD showInfoWithStatus:@"请填写退货理由及订单号"];
        return;
    }
    
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/goods_return_action";
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *dict = @{@"appkey":APPKEY,
                           @"backtype":BACKTYPE,
                           @"xid":parameterXid,
                           @"user_id":parameterUser_Id,
                           @"user_type":USER_TYPE,
                           @"order_id":_orderId,
                           @"return_type":[NSString stringWithFormat:@"%ld",(long)_number],
                           @"reason":_textView.text,
                           };
    // 服务器返回的数据格式
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer]; // 二进制数据
    [mgr POST:urlStr parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
      
         if([[NSString stringWithFormat:@"%@",dict[@"code"]]isEqualToString:@"1"] )
         {

             [SVProgressHUD showSuccessWithStatus:@"提交成功"];
             
             [self.navigationController popToRootViewControllerAnimated:YES];
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"请求失败:%@",error);
         [SVProgressHUD showErrorWithStatus:@"网络不通，请检查网络！"];
         
     }];

}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    //    取消第一响应者
    [textField resignFirstResponder];
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView; {
    _textView.text = textView.text;
//    NSLog(@"%@",_textView.text);
}
- (void)textViewDidChange:(UITextView *)textView{
    
    if (textView.text.length <= 200) {
        
         self.myLabel.text = [NSString stringWithFormat:@"%ld/200", textView.text.length];
        
    }else{
        return;
    }
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
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
