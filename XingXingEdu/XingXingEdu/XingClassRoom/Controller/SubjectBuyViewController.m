//
//  SubjectBuyViewController.m
//  XingXingEdu
//
//  Created by codeDing on 16/2/28.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "SubjectBuyViewController.h"
#import "PayInformationCell.h"
#import "AlbumViewController.h"
#import "WJCommboxView.h"
#import  "PersonModel.h"
#import "SubjectBuyDetailMessageController.h"
#define DETAIL @"PayInformationCell"
#define kScreenWidth self.view.frame.size.width
#define kScreenHeight self.view.frame.size.height
#define Space 10


#define TextFieldAndLabelH 25.0f
#define KWide 45.0f
#define LabelX 20.0f
#define LabelW 65.0f
#define TextFieldX 120.0f
#define KMarg 10.0f

@interface SubjectBuyViewController ()<UITableViewDataSource,UIGestureRecognizerDelegate,UITableViewDelegate,UITextFieldDelegate>
{
    
    UIView *bgView;
    UITextField *passward;
    UITextField *confirmPassward;
    UILabel *_price;
    BOOL isCollect;
    UITextField *priceLabel;
    UITextField *deductionL;
    NSString *_childName;
    NSString * textStr;
    UILabel *actuallyPriceLabel;//实付金额
    NSString *phoneNumber;
    NSString *_babyName;
    NSString *_babyName1;
    NSString *_babyName2;
    NSString *_babyName3;
    NSString *_babyName4;
    NSString *_babyName5;
    NSMutableArray * infoArray;
    UIButton *landBtn;
    
}
@property (nonatomic) NSMutableArray *pictureArray;
@property (nonatomic) NSMutableArray *titleArray;
@property (nonatomic) NSMutableArray *contentArray;
@property(nonatomic,strong) WJCommboxView *relationCombox;//下拉选择框
@property (nonatomic) UITableView *tableView;
@property (nonatomic) UIImageView *backgroundImageView;
@property (nonatomic) UIImageView *iconImageView;
@property (nonatomic) UIView *lineView;
@end

@implementation SubjectBuyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"请填写购买信息";
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.view.backgroundColor=[UIColor colorWithRed:229/255.0f green:232/255.0f blue:234/255.0f alpha:1];
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    [self createLeftButton];
    textStr = @"1";
    [self createTextFields];
    
    
}

-(void)createLeftButton{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(- 10, 0, 44, 20);
    
    [backBtn setImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(doBack:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
}
-(void)doBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewWillDisappear:(BOOL)animated{
    [self.relationCombox.textField removeObserver:self forKeyPath:@"text"];
}

- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight/3)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.scrollEnabled = YES;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}
-(void)createTextFields{
    
    self.pictureArray =[[NSMutableArray alloc]initWithObjects:@"科目40x40@2x.png", @"人数40x40@2x.png", @"姓名40x40@2x.png", @"联系方式40x40.png", nil];
    self.titleArray =[[NSMutableArray alloc]initWithObjects:@"科目:",@"人数:",@"学生姓名:", @"联系方式:", nil];
    self.contentArray =[[NSMutableArray alloc]initWithObjects:_course_name, @"1", @"", @"",nil];
    [self.view addSubview:self.tableView];
    
    //支付信息栏
    bgView=[[UIView alloc]initWithFrame:CGRectMake(0, _tableView.x + _tableView.size.height + KMarg, kScreenWidth, 160)];
    bgView.layer.cornerRadius=3.0;
    bgView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:bgView];
    //合计
    UILabel *label = [HHControl createLabelWithFrame:CGRectMake(bgView.size.width/2 + KMarg , KMarg, LabelW , TextFieldAndLabelH ) Font:14 Text:@"合计:"];
    label.textColor = [UIColor blackColor];
    label.textAlignment=NSTextAlignmentRight;
    
    _price = [HHControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(label.frame),KMarg,LabelW ,TextFieldAndLabelH) Font:14 Text:[NSString stringWithFormat:@"%.2f",[_infoData[0] floatValue]]];
    _price.textAlignment=NSTextAlignmentLeft;
    
    
    // 猩币抵扣 deduction
    UIButton *iconImageView = [[UIButton alloc] initWithFrame:CGRectMake(bgView.size.width/2 - 55, label.y + label.size.height + 22, 18, 18)];
    
    if ([_infoData[1] isEqual:0]) {
        [SVProgressHUD showErrorWithStatus:@"不允许猩币抵扣"];
        iconImageView.userInteractionEnabled = NO;
    }else{
        iconImageView.userInteractionEnabled = YES;
        [iconImageView setImage:[UIImage imageNamed:@"对勾22x22@2x.png"] forState:UIControlStateNormal];
        [iconImageView addTarget:self action:@selector(clickbtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    [bgView addSubview:iconImageView];
    
    
    priceLabel = [HHControl createTextFielfFrame:CGRectMake(bgView.size.width/2 - 30, label.y + label.size.height + 17,LabelW + KMarg, TextFieldAndLabelH) font:[UIFont systemFontOfSize:10] placeholder:@"输入兑换币数"];
    priceLabel.tag = 10000;
    priceLabel.delegate = self;
    [priceLabel setEnabled:NO];
    priceLabel.clearsOnBeginEditing = YES;
    priceLabel.keyboardType = UIKeyboardTypeNumberPad;
    priceLabel.textColor = UIColorFromRGB(224, 110, 172);
    priceLabel.textAlignment=NSTextAlignmentLeft;
    priceLabel.borderStyle = UITextBorderStyleRoundedRect;
    
    deductionL=[[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(priceLabel.frame), label.y + label.size.height + 18, LabelW * 2,TextFieldAndLabelH )];
    deductionL.userInteractionEnabled = NO;
    
    NSString *longStr = [NSString stringWithFormat:@"个猩币可抵扣%.2f元",[priceLabel.text floatValue]/100];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:longStr];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(6, 1)];
    deductionL.attributedText = str;
    deductionL.textAlignment=NSTextAlignmentLeft;
    deductionL.font=[UIFont systemFontOfSize:10];
    [bgView addSubview:deductionL];
    
    //实付
    UILabel *actuallyPaidLabel = [HHControl createLabelWithFrame:CGRectMake(bgView.size.width/2 + KMarg, deductionL.y + deductionL.size .height + 16, LabelW , TextFieldAndLabelH) Font:14 Text:@"实付:"];
    actuallyPaidLabel.textColor=[UIColor blackColor];
    actuallyPaidLabel.textAlignment=NSTextAlignmentRight;
    
    
    actuallyPriceLabel =[[UILabel alloc]initWithFrame:CGRectMake( actuallyPaidLabel.x + actuallyPaidLabel.size.width,deductionL.y + deductionL.size .height + 16,LabelW ,TextFieldAndLabelH)];
    actuallyPriceLabel.textColor = UIColorFromRGB(224, 110, 172);
    actuallyPriceLabel.text = [NSString stringWithFormat:@"%.2f",[_infoData[0] floatValue]];
    actuallyPriceLabel.textAlignment=NSTextAlignmentLeft;
    actuallyPriceLabel.font=[UIFont systemFontOfSize:14];
    [bgView addSubview:actuallyPriceLabel];
    
    
    UILabel *remarksLabel = [HHControl createLabelWithFrame:CGRectMake( bgView.size.width/2 - 55,actuallyPaidLabel.y + actuallyPaidLabel.size.height + 12, bgView.size.width/2  + 40,TextFieldAndLabelH) Font:12 Text:@"特别说明：发票请到机构前台领取"];
    remarksLabel.textAlignment=NSTextAlignmentRight;
    [bgView addSubview:remarksLabel];
    
    //支付按钮
    landBtn=[self createButtonFrame:CGRectMake(KMarg,CGRectGetMaxY(bgView.frame) + 40,self.view.frame.size.width - 20, 42) backImageName:@"立即支付icon650x84" title:nil titleColor:nil  font:[UIFont systemFontOfSize:17] target:self action:@selector(clickBtn)];
    landBtn.layer.cornerRadius=5.0f;
    
    //间隔线
    for (int i = 1; i < 4; i ++) {
        UIImageView *line=[self createImageViewFrame:CGRectMake(20, bgView.size.height/4 *i, bgView.frame.size.width - 40, 1) imageName:nil color:[UIColor colorWithRed:180/255.0f green:180/255.0f blue:180/255.0f alpha:.3]];
        [bgView addSubview:line];
    }
    [bgView addSubview:label];
    [bgView addSubview:_price];
    [bgView addSubview:passward];
    [bgView addSubview:priceLabel];
    [bgView addSubview:confirmPassward];
    [bgView addSubview:actuallyPaidLabel];
    [self.view addSubview:landBtn];
}

-(void)clickBtn{
 
//    if (_babyName == nil || _babyName == NULL || [_babyName isEqualToString:@""]) {
//        [SVProgressHUD showInfoWithStatus:@"请填写孩子姓名"];
//        return;
//    }
    
    
    if ([textStr intValue]== 1) {
        
        if ([_babyName isEqualToString:@""]) {
             [SVProgressHUD showInfoWithStatus:@"请填写孩子姓名"];
            return;
            }
        
    }else if ([textStr intValue]== 2) {
        if ([_babyName1 isEqualToString:@""] || _babyName1 == nil || _babyName1 == NULL) {
            
            [SVProgressHUD showInfoWithStatus:@"请填写孩子姓名"];
            return;
            
        }else if ([_babyName2 isEqualToString:@""]|| _babyName2 == nil || _babyName2 == NULL){
            [SVProgressHUD showInfoWithStatus:@"请填写孩子姓名"];
            return;
        }else{
            
          _babyName = [NSString stringWithFormat:@"%@,%@",_babyName1,_babyName2];
        }
    }else if ([textStr intValue]== 3) {
        if ([_babyName1 isEqualToString:@""]|| _babyName1 == nil || _babyName1 == NULL) {
            [SVProgressHUD showInfoWithStatus:@"请填写孩子姓名"];
            return;
            
        }else if ([_babyName2 isEqualToString:@""]|| _babyName2 == nil || _babyName2 == NULL){
            [SVProgressHUD showInfoWithStatus:@"请填写孩子姓名"];
            return;

        }else if ([_babyName3 isEqualToString:@""]|| _babyName3 == nil || _babyName3 == NULL){
            [SVProgressHUD showInfoWithStatus:@"请填写孩子姓名"];
            return;
        }else{
         _babyName = [NSString stringWithFormat:@"%@,%@,%@",_babyName1,_babyName2,_babyName3];
        }
    }else if ([textStr intValue]== 4) {
        if ([_babyName1 isEqualToString:@""]|| _babyName1 == nil || _babyName1 == NULL) {
            [SVProgressHUD showInfoWithStatus:@"请填写孩子姓名"];
            return;
        }else if ([_babyName2 isEqualToString:@""]|| _babyName2 == nil || _babyName2 == NULL){
            [SVProgressHUD showInfoWithStatus:@"请填写孩子姓名"];
            return;
        }else if ([_babyName3 isEqualToString:@""]|| _babyName3 == nil || _babyName3 == NULL){
            [SVProgressHUD showInfoWithStatus:@"请填写孩子姓名"];
            return;
        }else if ([_babyName4 isEqualToString:@""]|| _babyName4 == nil || _babyName4 == NULL){
            [SVProgressHUD showInfoWithStatus:@"请填写孩子姓名"];
            return;
        }else{
            
        _babyName = [NSString stringWithFormat:@"%@,%@,%@,%@",_babyName1,_babyName2,_babyName3,_babyName4];
      }
        
    }

    //    提交购买信息
    [self postSubjectBuyInfo];

}

// 确认支付课程(生成订单)请求数据
-(void)postSubjectBuyInfo{
    
    if([phoneNumber isEqualToString:@""] || phoneNumber == nil  || phoneNumber == NULL ||phoneNumber.length !=11){
            [SVProgressHUD showInfoWithStatus:@"请正确填写手机号"];
            return;
        }
    
    infoArray = [NSMutableArray array];
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/xkt_create_course_order";
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    NSString *xid;
    if ([XXEUserInfo user].login) {
        xid = [XXEUserInfo user].xid;
    }else {
        xid = XID;
    }
    NSDictionary *dict = @{@"appkey":APPKEY,
                           @"backtype":BACKTYPE,
                           @"xid":xid,
                           @"user_id":USER_ID,
                           @"user_type":USER_TYPE,
                           @"course_id":_course_Id,
                           @"buy_num":textStr,
                           @"baby_name":_babyName,
                           @"parent_phone":phoneNumber,
                           @"deduct_coin":priceLabel.text,
                           @"deduct_price":[NSString stringWithFormat:@"%2f",[priceLabel.text floatValue]/100],
                           @"pay_price":actuallyPriceLabel.text,
                           };
    
    // 服务器返回的数据格式
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer]; // 二进制数据
    [mgr POST:urlStr parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
//            NSLog(@"+++===========dic==========%@",dict);
         if([[NSString stringWithFormat:@"%@",dict[@"code"]] isEqualToString:@"1"] ){
             NSString *order_index =[NSString stringWithFormat:@"%@",dict[@"data"][@"order_index"]];
             
             SubjectBuyDetailMessageController *SubjectBuyDetailMessageVC = [[SubjectBuyDetailMessageController alloc] init];
             SubjectBuyDetailMessageVC.price = actuallyPriceLabel.text;
             SubjectBuyDetailMessageVC.order_index = order_index;
             SubjectBuyDetailMessageVC.orderId = _course_Id;
             [self.navigationController pushViewController:SubjectBuyDetailMessageVC animated:YES];

         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"请求失败:%@",error);
         [SVProgressHUD showErrorWithStatus:@"网络不通，请检查网络！"];
         
     }];
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    PayInformationCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        NSArray *nib =[[NSBundle mainBundle] loadNibNamed:DETAIL owner:[PayInformationCell class] options:nil];
        cell =(PayInformationCell *)[nib objectAtIndex:0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.lineImageView.backgroundColor = [UIColor colorWithRed:224.0/255 green:224.0/255 blue:224.0/255 alpha:1.0];
    cell.titleLabel.text = self.titleArray[indexPath.row];
    
    cell.contentLabel.text = self.contentArray[indexPath.row];
    cell.contentLabel.borderStyle = UITextBorderStyleNone;
    cell.contentLabel.userInteractionEnabled = YES;
    cell.contentLabel.tag = indexPath.row;
    cell.contentLabel.delegate = self;
    cell.pictureImageView.image = [UIImage imageNamed:self.pictureArray[indexPath.row]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 48;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)clickbtn:(UIButton *)btn{
    if (isCollect==NO) {
        [btn setBackgroundImage:[UIImage imageNamed:@"对勾(H)22x22@2x"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(clickbtn:)forControlEvents:UIControlEventTouchUpInside];
        priceLabel.userInteractionEnabled = YES;
        [priceLabel setEnabled:YES];
        isCollect=!isCollect;
    }
    else  if (isCollect==YES) {
        [btn setBackgroundImage:[UIImage imageNamed:@"对勾22x22@2x.png"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(clickbtn:)forControlEvents:UIControlEventTouchUpInside];
        priceLabel.userInteractionEnabled = NO;
        [priceLabel setEnabled:NO];
        
        actuallyPriceLabel.text = [NSString stringWithFormat:@"%.2f",[_infoData[0] floatValue]*[textStr floatValue]];
        [priceLabel setText:@""];
        
        isCollect=!isCollect;
        
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    if (textField.tag == 1) {
        textStr = textField.text;
        if ([textStr intValue] > 4) {
            [SVProgressHUD showSuccessWithStatus:@"最多只能输入4个人"];
            textStr = [NSString stringWithFormat:@"%d",4];
            return;
        }else{
            
            self.pictureArray =[[NSMutableArray alloc]initWithObjects:@"科目40x40@2x.png", @"人数40x40@2x.png", @"姓名40x40@2x.png", @"联系方式40x40.png", nil];
            self.titleArray =[[NSMutableArray alloc]initWithObjects:@"科目:",@"人数:",@"学生姓名:", @"联系方式:", nil];
            self.contentArray =[[NSMutableArray alloc]initWithObjects:_course_name, textStr, @"", @"",nil];
            
            for (int i = 0; i < [textField.text integerValue] - 1; i++) {
                [self.contentArray replaceObjectAtIndex:1 withObject:textField.text];
                [self.contentArray addObject:@""];
                [self.pictureArray insertObject:@"姓名40x40@2x.png" atIndex:2 + i];
                [self.titleArray insertObject:@"学生姓名:" atIndex:2 + i];
            }
            
            [self.tableView reloadData];
            //合计
            _price.text = [NSString stringWithFormat:@"%.2f",[_infoData[0] floatValue]*[textStr floatValue]];
            actuallyPriceLabel.text = [NSString stringWithFormat:@"%.2f",[_infoData[0] floatValue]*[textStr floatValue]];
            
            [bgView setNeedsDisplay];
            
        }
    }
    if ([textStr intValue]== 1) {
        if (textField.tag == 2) {
            if (![textField.text isEqualToString:@""]) {
                _babyName = textField.text;
            }else{
                 [SVProgressHUD showInfoWithStatus:@"请填写孩子姓名"];
            }
        }
    }
    if ([textStr intValue]== 2) {
        if (textField.tag == 2) {
            
            _babyName1 = textField.text;
            
        }else if (textField.tag == 3){
            _babyName2 = textField.text;
        }
//        _babyName = [NSString stringWithFormat:@"%@,%@",_babyName1,_babyName2];
    }
    if ([textStr intValue]== 3) {
        if (textField.tag == 2) {
            _babyName1 = textField.text;
            
        }else if (textField.tag == 3){
            _babyName2 = textField.text;
        }else if (textField.tag == 4){
            _babyName3 = textField.text;
        }
//        _babyName = [NSString stringWithFormat:@"%@,%@,%@",_babyName1,_babyName2,_babyName3];
    }
    if ([textStr intValue]== 4) {
        if (textField.tag == 2) {
            _babyName1 = textField.text;
            
        }else if (textField.tag == 3){
            _babyName2 = textField.text;
        }else if (textField.tag == 4){
            _babyName3 = textField.text;
        }else if (textField.tag == 5){
            _babyName4 = textField.text;
        }
//        _babyName = [NSString stringWithFormat:@"%@,%@,%@,%@",_babyName1,_babyName2,_babyName3,_babyName4];
    }

 
    if (textField.tag == [textStr integerValue] + 2 ) {
        [self okClick:textField.text];
    }
    if (textField.tag == 10000) {
        float intString = [textField.text floatValue];
        NSInteger colorRange = 0;
        
        if(intString > [_infoData[4] floatValue]){
            
            [SVProgressHUD showErrorWithStatus:@"您的猩币不足"];
            return;
        }else{
            if (intString >= 0 && intString <= 10) {
                colorRange = 1;
            }
            if (intString >= 10 && intString <= 100) {
                colorRange = 2;
            }
            if (intString >= 100 && intString <= 1000) {
                colorRange = 3;
            }
            if (intString >= 1000 && intString <= 10000) {
                colorRange = 4;
            }
            if (intString >= 10000 && intString <= 100000) {
                colorRange = 5;
            }
            if (intString >= 100000 && intString <= 1000000) {
                colorRange = 6;
            }
        }
        NSString *longStr = [NSString stringWithFormat:@"个猩币可抵扣 %.2f 元",intString/100];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:longStr];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(6, colorRange)];
        deductionL.attributedText = str;
        
        
        if (isCollect) {
            //合计
            float a = intString/100;
            float b = [_infoData[0] floatValue];
            if (a > b * [textStr floatValue]) {
                [SVProgressHUD showInfoWithStatus:@"超出抵扣范围,请重新输入"];
                textField.text = @"";
//                landBtn.userInteractionEnabled = NO;
                return;
                
            }else{
                
                landBtn.userInteractionEnabled = YES;
             
                float c = b * [textStr floatValue] - a;
                actuallyPriceLabel.text = [NSString stringWithFormat:@"%.2f",c];
            }
            //实付
         
        }else{
            
            actuallyPriceLabel.text = [NSString stringWithFormat:@"%.2f",[_infoData[0] floatValue]*[textStr floatValue]];
        }
        
        [bgView setNeedsDisplay];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(void)okClick:(NSString*)text{
    if([text isEqualToString:@""] || text == nil  || text == NULL){
        [SVProgressHUD showInfoWithStatus:@"您还未设置手机号"];
        return;
    }
    else if (text.length !=11){
        [SVProgressHUD showInfoWithStatus:@"亲,手机长度是11位哦"];
        return;
    }else if (text.length ==11){
        phoneNumber = text;
        return ;
    }
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

-(UIImageView *)createImageViewFrame:(CGRect)frame imageName:(NSString *)imageName color:(UIColor *)color
{
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:frame];
    
    if (imageName)
    {
        imageView.image=[UIImage imageNamed:imageName];
    }
    if (color)
    {
        imageView.backgroundColor=color;
    }
    
    return imageView;
}

-(UIButton *)createButtonFrame:(CGRect)frame backImageName:(NSString *)imageName title:(NSString *)title titleColor:(UIColor *)color font:(UIFont *)font target:(id)target action:(SEL)action
{
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=frame;
    if (imageName)
    {
        [btn setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    }
    
    if (font)
    {
        btn.titleLabel.font=font;
    }
    
    if (title)
    {
        [btn setTitle:title forState:UIControlStateNormal];
    }
    if (color)
    {
        [btn setTitleColor:color forState:UIControlStateNormal];
    }
    if (target&&action)
    {
        [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    return btn;
}

@end
