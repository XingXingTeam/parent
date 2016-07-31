//
//  ModifyAddressViewController.m
//  XingXingEdu
//
//  Created by codeDing on 16/4/27.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "ModifyAddressViewController.h"
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "LMComBoxView.h"
#import "LMContainsLMComboxScrollView.h"
#import "HHControl.h"
#import "SVProgressHUD.h"

#define Kmarg 8.0f
#define KLabelX 20.0f
#define KLabelW 65.0f
#define KLabelH 30.0f
#define kUnderButtonH 64.0f

#define kDropDownListTag 1000
@interface ModifyAddressViewController ()<LMComBoxViewDelegate>{
    LMContainsLMComboxScrollView *bgScrollView;
    NSMutableDictionary *addressDict;   //地址选择字典
    NSDictionary *areaDic;
    NSArray *province;
    NSArray *city;
    NSArray *district;
    
    NSString *selectedProvince;
    NSString *selectedCity;
    NSString *selectedArea;
    
    UITextField *nameText;
    UITextField *phoneText;
    UITextField *addressText;
    UITextField *mailText;
    UIButton * saveBtn;
    UIButton * removeBtn;
    UIButton * collectBtn;
    UIView *view5;
    
    UIView *_view3;
    //所在地区
    UILabel *_areaLabel;
    
    
}



@end

@implementation ModifyAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self resolveCity];
    [self creatFieldset];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped:)];
    [view5 addGestureRecognizer:singleTap];
    
}
-(void)fingerTapped:(UITapGestureRecognizer *)gestureRecognizer

{
    [self.view endEditing:YES];

}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
     [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)creatFieldset{

    //收货人姓名
    UILabel * consignee = [HHControl createLabelWithFrame:CGRectMake(KLabelX, Kmarg, KLabelW, KLabelH) Font:14 Text:@"收货人:"];
    [bgScrollView addSubview:consignee];
    
    nameText=[HHControl createTextFielfFrame:CGRectMake(CGRectGetMaxX(consignee.frame) + Kmarg, Kmarg, kWidth - CGRectGetMaxX(consignee.frame) - KLabelX *2, KLabelH) font:[UIFont fontWithName:@"Arial" size:14] placeholder:@""];
    nameText.text=self.addressName;
    [bgScrollView addSubview:nameText];
    
    UIView *view1=[HHControl createViewWithFrame:CGRectMake(0, CGRectGetMaxY(consignee.frame) + Kmarg, kWidth, 1)];
    view1.backgroundColor=UIColorFromRGB(193, 193, 193);
    [bgScrollView addSubview:view1];
    
    //电话
    [bgScrollView addSubview:[HHControl createLabelWithFrame:CGRectMake(KLabelX, CGRectGetMaxY(view1.frame) + Kmarg , KLabelW, KLabelH) Font:14 Text:@"联系电话:"]];
    phoneText=[HHControl createTextFielfFrame:CGRectMake(CGRectGetMaxX(consignee.frame) + Kmarg, CGRectGetMaxY(view1.frame) + Kmarg, kWidth - CGRectGetMaxX(consignee.frame) - KLabelX *2, KLabelH) font:[UIFont fontWithName:@"Arial" size:14] placeholder:@""];
    phoneText.text=self.addressPhone;
    phoneText.keyboardType=UIKeyboardTypeNumberPad;
    [bgScrollView addSubview:phoneText];
    
    UIView *view2 = [HHControl createViewWithFrame:CGRectMake(0, CGRectGetMaxY(phoneText.frame) + Kmarg, kWidth, 1)];
    view2.backgroundColor=UIColorFromRGB(193, 193, 193);
    [bgScrollView addSubview:view2];
    
    //邮政编码
    [bgScrollView addSubview:[HHControl createLabelWithFrame:CGRectMake(KLabelX, CGRectGetMaxY(view2.frame) + Kmarg, KLabelW, KLabelH) Font:14 Text:@"邮政编码:"]];
    mailText=[HHControl createTextFielfFrame:CGRectMake(CGRectGetMaxX(consignee.frame) + Kmarg, CGRectGetMaxY(view2.frame) + Kmarg, kWidth - CGRectGetMaxX(consignee.frame) - KLabelX *2, KLabelH) font:[UIFont fontWithName:@"Arial" size:14] placeholder:@""];
     mailText.text=self.addressMail;
    mailText.keyboardType=UIKeyboardTypeNumberPad;
    [bgScrollView addSubview:mailText];
    
    _view3 = [HHControl createViewWithFrame:CGRectMake(0, CGRectGetMaxY(mailText.frame) + Kmarg, kWidth, 1)];
    _view3.backgroundColor=UIColorFromRGB(193, 193, 193);
    [bgScrollView addSubview:_view3];
    
    //所在地区
    _areaLabel =  [HHControl createLabelWithFrame:CGRectMake(KLabelX, CGRectGetMaxY(_view3.frame) + Kmarg, KLabelW, KLabelH) Font:14 Text:@"所在地区:"];
    [bgScrollView addSubview:_areaLabel];
    
    
    UIView *view4=[HHControl createViewWithFrame:CGRectMake(0, CGRectGetMaxY(_areaLabel.frame) + Kmarg, kWidth, 1)];
    view4.backgroundColor=UIColorFromRGB(193, 193, 193);
    [bgScrollView addSubview:view4];
    
    //详细地址
    [bgScrollView addSubview:[HHControl createLabelWithFrame:CGRectMake(KLabelX, CGRectGetMaxY(view4.frame) + Kmarg, KLabelW, KLabelH) Font:14 Text:@"详细地址:"]];
    addressText=[HHControl createTextFielfFrame:CGRectMake(CGRectGetMaxX(consignee.frame) + Kmarg, CGRectGetMaxY(view4.frame) + Kmarg, kWidth - CGRectGetMaxX(consignee.frame) - KLabelX *2, KLabelH) font:[UIFont fontWithName:@"Arial" size:14] placeholder:@""];
    addressText.text=self.addressInfo;
    [bgScrollView addSubview:addressText];
    
    view5 = [HHControl createViewWithFrame:CGRectMake(0, CGRectGetMaxY(addressText.frame) + Kmarg, kWidth, kHeight - CGRectGetMaxY(addressText.frame))];
    view5.backgroundColor=UIColorFromRGB(229, 232, 233);
    [bgScrollView addSubview:view5];
    
    UIView *view6=[HHControl createViewWithFrame:CGRectMake(0, CGRectGetMaxY(addressText.frame) + Kmarg, kWidth, 1)];
    view6.backgroundColor=UIColorFromRGB(193, 193, 193);
    [bgScrollView addSubview:view6];
    
    
    saveBtn=[HHControl createButtonWithFrame:CGRectMake(KLabelX, CGRectGetMaxY(view6.frame) + KLabelX *2, kWidth - KLabelX *2, 42) backGruondImageName:@"saveaddress.png" Target:nil Action:@selector(saveBtn) Title:nil];
    [bgScrollView addSubview:saveBtn];
    
    
    collectBtn = [HHControl createButtonWithFrame:CGRectMake(KLabelX, CGRectGetMaxY(saveBtn.frame) + KLabelX, kWidth - KLabelX *2, 42) backGruondImageName:@"setmorenicon.png" Target:nil Action:@selector(collectBtn) Title:nil];
    [bgScrollView addSubview:collectBtn];
    
    removeBtn=[HHControl createButtonWithFrame:CGRectMake(KLabelX, CGRectGetMaxY(collectBtn.frame) + KLabelX, kWidth - KLabelX *2, 42) backGruondImageName:@"deleteAdress.png" Target:nil Action:@selector(removeBtn) Title:nil];
    [bgScrollView addSubview:removeBtn];

}


-(void)saveBtn{
    if ([nameText.text isEqualToString:@""])
    {
        [SVProgressHUD showInfoWithStatus:@"亲,请输入您的姓名"];
        return;
    }
    else if (phoneText.text.length !=11)
    {
        [SVProgressHUD showInfoWithStatus:@"亲,请输入您正确的手机号"];
        return;
    }
    else if (mailText.text.length !=6)
    {
        [SVProgressHUD showInfoWithStatus:@"亲,请输入您正确的邮编"];
        return;
    }
    else if ([addressText.text isEqualToString:@""])
    {
        [SVProgressHUD showInfoWithStatus:@"亲,请输入您的详细地址"];
        return;
    }
    [self modifyAddress];

    
}

-(void)removeBtn{
    
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"确定删除地址？" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *cancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *ok=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
 
        [self deleteAddress];
    }];
    [alert addAction:ok];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
   
}
-(void)collectBtn{
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"确定设为默认地址？" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *cancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *ok=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

         [self setDefaultAddress];
    }];
    [alert addAction:ok];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
   
}



#pragma mark 网络
//修改地址
- (void)modifyAddress
{
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/update_shopping_address";
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *dict = @{@"appkey":APPKEY,
                           @"backtype":BACKTYPE,
                           @"xid":XID,
                           @"user_id":USER_ID,
                           @"user_type":USER_TYPE,
                           @"province":selectedProvince,
                           @"city":selectedCity,
                           @"district":selectedArea,
                           @"address":addressText.text,
                           @"name":nameText.text,
                           @"phone":phoneText.text,
                           @"zip_code":mailText.text,
                           @"address_id":self.addressId,
                          
                           };
    //    NSLog(@"%@",dict);
    
    // 服务器返回的数据格式
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer]; // 二进制数据
    [mgr POST:urlStr parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         //         NSLog(@"%@",dict);
         
         
         if([[NSString stringWithFormat:@"%@",dict[@"code"]]isEqualToString:@"1"] )
         {
             [SVProgressHUD showSuccessWithStatus: @"更改地址成功"];
             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                 [self.navigationController popViewControllerAnimated:YES];
             });
             
         }
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"请求失败:%@",error);
         [SVProgressHUD showErrorWithStatus:@"网络不通，请检查网络！"];
         
     }];
}

//设为默认地址
- (void)setDefaultAddress
{
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/set_default_shopping_address";
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *dict = @{@"appkey":@"U3k8Dgj7e934bh5Y",
                           @"backtype":@"json",
                           @"xid":@"18884982",
                           @"user_id":@"1",
                           @"user_type":@"1",
                           @"address_id":self.addressId,
                           
                           };
    //    NSLog(@"%@",dict);
    
    // 服务器返回的数据格式
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer]; // 二进制数据
    [mgr POST:urlStr parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         
         if([[NSString stringWithFormat:@"%@",dict[@"code"]]isEqualToString:@"1"] )
         {
             [SVProgressHUD showSuccessWithStatus: @"设为默认地址成功"];
             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                 [self.navigationController popViewControllerAnimated:YES];
             });
             
         }
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"请求失败:%@",error);
         [SVProgressHUD showErrorWithStatus:@"网络不通，请检查网络！"];
         
     }];
}


//删除地址
- (void)deleteAddress{
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/delete_shopping_address";
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *dict = @{@"appkey":@"U3k8Dgj7e934bh5Y",
                           @"backtype":@"json",
                           @"xid":@"18884982",
                           @"user_id":@"1",
                           @"user_type":@"1",
                           @"address_id":self.addressId,
                           
                           };
    
    //    NSLog(@"%@",dict);
    
    // 服务器返回的数据格式
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer]; // 二进制数据
    [mgr POST:urlStr parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         //         NSLog(@"%@",dict);
         
         
         if([[NSString stringWithFormat:@"%@",dict[@"code"]]isEqualToString:@"1"] )
         {
             [SVProgressHUD showSuccessWithStatus:@"删除地址成功"];
             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                 [self.navigationController popViewControllerAnimated:YES];
             });
             
         }
         
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"请求失败:%@",error);
         [SVProgressHUD showErrorWithStatus:@"网络不通，请检查网络！"];
         
     }];
}
//解析全国省市区信息
-(void)resolveCity{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"area" ofType:@"plist"];
    areaDic = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    NSArray *components = [areaDic allKeys];
    NSArray *sortedArray = [components sortedArrayUsingComparator: ^(id obj1, id obj2) {
        
        if ([obj1 integerValue] > [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        if ([obj1 integerValue] < [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
    
    NSMutableArray *provinceTmp = [NSMutableArray array];
    for (int i=0; i<[sortedArray count]; i++) {
        NSString *index = [sortedArray objectAtIndex:i];
        NSArray *tmp = [[areaDic objectForKey: index] allKeys];
        [provinceTmp addObject: [tmp objectAtIndex:0]];
    }
    
    province = [NSArray arrayWithArray:provinceTmp];
    
    NSString *index = [sortedArray objectAtIndex:0];
    NSString *selected = [province objectAtIndex:0];
    NSDictionary *dic = [NSDictionary dictionaryWithDictionary: [[areaDic objectForKey:index]objectForKey:selected]];
    
    NSArray *cityArray = [dic allKeys];
    NSDictionary *cityDic = [NSDictionary dictionaryWithDictionary: [dic objectForKey: [cityArray objectAtIndex:0]]];
    city = [NSArray arrayWithArray:[cityDic allKeys]];
    
    selectedCity = [city objectAtIndex:0];
    district = [NSArray arrayWithArray:[cityDic objectForKey:selectedCity]];
    
    addressDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                   province,@"province",
                   city,@"city",
                   district,@"area",nil];
    
    selectedProvince = [province objectAtIndex:0];
    selectedArea = [district objectAtIndex:0];
    
    
    bgScrollView = [[LMContainsLMComboxScrollView alloc]initWithFrame:CGRectMake(0, 0, WinWidth, WinHeight)];
    bgScrollView.backgroundColor = [UIColor whiteColor];
    bgScrollView.showsVerticalScrollIndicator = NO;
    bgScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:bgScrollView];
    
    [self setUpBgScrollView];
}

-(void)setUpBgScrollView
{
    
    NSArray *keys = [NSArray arrayWithObjects:@"province",@"city",@"area", nil];
    for(NSInteger i=0;i<3;i++)
    {
        LMComBoxView *comBox = [[LMComBoxView alloc]initWithFrame:CGRectMake(85+(90+3)*i, 150, (kWidth - 85) / 3, 28)];
        comBox.backgroundColor = [UIColor whiteColor];
        comBox.arrowImgName = @"down_dark0.png";
        NSMutableArray *itemsArray = [NSMutableArray arrayWithArray:[addressDict objectForKey:[keys objectAtIndex:i]]];
        comBox.titlesList = itemsArray;
        comBox.delegate = self;
        comBox.supView = bgScrollView;
        [comBox defaultSettings];
        comBox.tag = kDropDownListTag + i;
        [bgScrollView addSubview:comBox];
    }
}

#pragma mark -LMComBoxViewDelegate
-(void)selectAtIndex:(int)index inCombox:(LMComBoxView *)_combox
{
    NSInteger tag = _combox.tag - kDropDownListTag;
    switch (tag) {
        case 0:
        {
            selectedProvince =  [[addressDict objectForKey:@"province"]objectAtIndex:index];
            //字典操作
            NSDictionary *tmp = [NSDictionary dictionaryWithDictionary: [areaDic objectForKey: [NSString stringWithFormat:@"%d", index]]];
            NSDictionary *dic = [NSDictionary dictionaryWithDictionary: [tmp objectForKey: selectedProvince]];
            NSArray *cityArray = [dic allKeys];
            NSArray *sortedArray = [cityArray sortedArrayUsingComparator: ^(id obj1, id obj2) {
                
                if ([obj1 integerValue] > [obj2 integerValue]) {
                    return (NSComparisonResult)NSOrderedDescending;//递减
                }
                
                if ([obj1 integerValue] < [obj2 integerValue]) {
                    return (NSComparisonResult)NSOrderedAscending;//上升
                }
                return (NSComparisonResult)NSOrderedSame;
            }];
            
            NSMutableArray *array = [[NSMutableArray alloc] init];
            for (int i=0; i<[sortedArray count]; i++) {
                NSString *index = [sortedArray objectAtIndex:i];
                NSArray *temp = [[dic objectForKey: index] allKeys];
                [array addObject: [temp objectAtIndex:0]];
            }
            city = [NSArray arrayWithArray:array];
            
            NSDictionary *cityDic = [dic objectForKey: [sortedArray objectAtIndex: 0]];
            district = [NSArray arrayWithArray:[cityDic objectForKey:[city objectAtIndex:0]]];
            //刷新市、区
            addressDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                           province,@"province",
                           city,@"city",
                           district,@"area",nil];
            LMComBoxView *cityCombox = (LMComBoxView *)[bgScrollView viewWithTag:tag + 1 + kDropDownListTag];
            cityCombox.titlesList = [NSMutableArray arrayWithArray:[addressDict objectForKey:@"city"]];
            [cityCombox reloadData];
            LMComBoxView *areaCombox = (LMComBoxView *)[bgScrollView viewWithTag:tag + 2 + kDropDownListTag];
            areaCombox.titlesList = [NSMutableArray arrayWithArray:[addressDict objectForKey:@"area"]];
            [areaCombox reloadData];
            
            selectedCity = [city objectAtIndex:0];
            selectedArea = [district objectAtIndex:0];
            
            break;
        }
        case 1:
        {
            selectedCity = [[addressDict objectForKey:@"city"]objectAtIndex:index];
            
            NSString *provinceIndex = [NSString stringWithFormat: @"%li", (unsigned long)[province indexOfObject: selectedProvince]];
            NSDictionary *tmp = [NSDictionary dictionaryWithDictionary: [areaDic objectForKey: provinceIndex]];
            NSDictionary *dic = [NSDictionary dictionaryWithDictionary: [tmp objectForKey: selectedProvince]];
            NSArray *dicKeyArray = [dic allKeys];
            NSArray *sortedArray = [dicKeyArray sortedArrayUsingComparator: ^(id obj1, id obj2) {
                
                if ([obj1 integerValue] > [obj2 integerValue]) {
                    return (NSComparisonResult)NSOrderedDescending;
                }
                
                if ([obj1 integerValue] < [obj2 integerValue]) {
                    return (NSComparisonResult)NSOrderedAscending;
                }
                return (NSComparisonResult)NSOrderedSame;
            }];
            
            NSDictionary *cityDic = [NSDictionary dictionaryWithDictionary: [dic objectForKey: [sortedArray objectAtIndex: index]]];
            NSArray *cityKeyArray = [cityDic allKeys];
            district = [NSArray arrayWithArray:[cityDic objectForKey:[cityKeyArray objectAtIndex:0]]];
            //刷新区
            addressDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                           province,@"province",
                           city,@"city",
                           district,@"area",nil];
            LMComBoxView *areaCombox = (LMComBoxView *)[bgScrollView viewWithTag:tag + 1 + kDropDownListTag];
            areaCombox.titlesList = [NSMutableArray arrayWithArray:[addressDict objectForKey:@"area"]];
            [areaCombox reloadData];
            
            selectedArea = [district objectAtIndex:0];
            break;
        }
        case 2:
        {
            selectedArea = [[addressDict objectForKey:@"area"]objectAtIndex:index];
            break;
        }
        default:
            break;
    }
    //    NSLog(@"===%@===%@===%@",selectedProvince,selectedCity,selectedArea);
}



@end
