//
//  MyInfomationViewController.m
//  XingXingEdu
//
//  Created by keenteam on 16/3/22.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//
#define ORIGINAL_MAX_WIDTH 640.0f
#import "MyInfomationViewController.h"
#import "HFStretchableTableHeaderView.h"
#import "SaveInfoViewController.h"
#import "PWRViewController.h"
#import "PrivacySettingViewController.h"
#import "VPImageCropperViewController.h"
#import "MyInfomationCell.h"
#import "PWRViewController.h"
#import "HHControl.h"
#import "SVProgressHUD.h"
#import "ChangeTeleponeViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "AFNetworking.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "CheckInViewController.h"
#import "ChangeEmailViewController.h"
#import "LandingpageViewController.h"
@interface MyInfomationViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,VPImageCropperDelegate,UITextFieldDelegate,UIAlertViewDelegate>
{
   //头像
    UIImageView *headPortraitView;
    //性别
    UIImageView *manimage;
    //用户名
    UILabel *nameLbl;
    //用户等级
    UILabel *lvLabel;
    //注释
    UILabel *titleLbl;
    //已经签到 多少 天
    UILabel *checkLbl;
    //明天签到 将 ...
    UILabel *checkInLbl;
    
    UITableView *_tableView;
    NSMutableArray *dataArray;
    NSMutableArray *detailArray;
    UIImageView *imageView;
    NSArray *headArr;
    UIAlertView *_alertView;
    NSString *urlStr;
    NSString *babyid;
    NSMutableArray *myFieldArr;
//netdata
//    NSString *age;
//    NSString *coin_total;
//    NSString *continued;
//    NSString *email;
//    NSString *head_img;
//    NSString *head_img_type;
//    NSString *idKT;
//    NSString *lv;
//    NSString *next_get_coin;
//    NSString *next_grade_coin;
//    NSString *nickname;
//    NSString *phone;
//    NSString *reg_tm;
//    NSString *reKT;
//    NSString *sex;
//    NSString *tname;
//    NSString *xid;
    UITextField *nickNameTextFiled;//昵称
    UITextField *emailTextFiled;//邮箱
    
    NSDictionary *parent_myself_info_Dic;
    //
    NSMutableArray *contentArray;
    
    YSProgressView *ysView;
    NSString *parameterXid;
    NSString *parameterUser_Id;
}
@property (nonatomic, strong) UIImageView *portraitImageView;//头像

@end

@implementation MyInfomationViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    
//    NSLog(@"jjjjj %@---- %@", parameterXid, parameterUser_Id);
   [self loadNewData];
    [_tableView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"我的资料";
      self.navigationController.navigationBar.barTintColor =UIColorFromRGB(0, 170, 42);
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    dataArray = [[NSMutableArray alloc]init];
    detailArray = [[NSMutableArray alloc]init];
    headArr =[NSArray arrayWithObjects:@"ID40x40",@"昵称40x44",@"姓名40x40",@"年龄40x46",@"关系40x46",@"联系方式40x40",@"邮箱40x40",nil];
    [dataArray addObject:headArr];
    NSArray *arr = [NSArray arrayWithObjects:@"猩猩ID:",@"昵称:",@"姓名:",@"年龄:",@"关系:",@"手机号:",@"电子邮箱:",nil];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    [dataArray addObject:arr];
    
    parent_myself_info_Dic = [[NSDictionary alloc] init];

    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }

//    NSLog(@"%@---- %@", parameterXid, parameterUser_Id);
    
    [self createTableView];
    
    [self addHeadView];
    
    [self initUI];
    
}
- (void)loadNewData{
    babyid=  [[NSUserDefaults standardUserDefaults] objectForKey:@"BABYID"];
//     NSLog(@"~~~~~~~~~~~~~~~~~~~~~~~~~~~%@",babyid);
    urlStr = @"http://www.xingxingedu.cn/Parent/my_info";
    NSDictionary *pragm = @{   @"appkey":APPKEY,
                               @"backtype":BACKTYPE,
                               @"xid":parameterXid,
                               @"user_id":parameterUser_Id,
                               @"user_type":USER_TYPE,
                               @"baby_id":babyid
                               };
    
    
    [WZYHttpTool post:urlStr params:pragm success:^(id responseObj) {
        
        
//        NSLog(@"wd == %@", responseObj);
        
        if([[NSString stringWithFormat:@"%@",responseObj[@"code"]]isEqualToString:@"1"] )
        {
            NSDictionary *dict = [[NSDictionary alloc] init];
            dict =responseObj[@"data"];
            parent_myself_info_Dic = dict;
        
            contentArray = [[NSMutableArray alloc] initWithObjects:dict[@"xid"], dict[@"nickname"], dict[@"tname"], dict[@"age"], dict[@"relation"], dict[@"phone"],dict[@"email"], nil];
//            NSLog(@"contentArray == %@", contentArray);
            
            
            [self updateViewInfo];

        }else{
            [SVProgressHUD showErrorWithStatus:@"获取数据失败!"];
        }
        [_tableView reloadData];
    } failure:^(NSError *error) {
        
       // NSLog(@"%@", error);
        [SVProgressHUD showErrorWithStatus:@"获取数据失败!"];
    }];

}

#pragma mark ======== 更新界面 数据信息 ======
- (void)updateViewInfo{

  //头像
    NSString *headImage;
    //head_img_type  0:需要加前缀
    if ([parent_myself_info_Dic[@"head_img_type"] integerValue] ==0) {
        headImage = [NSString stringWithFormat:@"%@%@",picURL,parent_myself_info_Dic[@"head_img"]];
    }else if ([parent_myself_info_Dic[@"head_img_type"] integerValue] ==1){
        headImage = [NSString stringWithFormat:@"%@",parent_myself_info_Dic[@"head_img"]];
    }
    [_portraitImageView sd_setImageWithURL:[NSURL URLWithString:headImage] placeholderImage:[UIImage imageNamed:@"人物头像172x172@2x"]];
    
    //性别
    if ([parent_myself_info_Dic[@"sex"] isEqualToString:@"男"]) {
        NSString *sexName =@"man";
        manimage.image = [UIImage imageNamed:sexName];
    }
    else if ([parent_myself_info_Dic[@"sex"] isEqualToString:@"女"]) {
        NSString *sexName =@"women";
        manimage.image = [UIImage imageNamed:sexName];
    }
    //姓名
    nameLbl.text = [NSString stringWithFormat:@"%@", parent_myself_info_Dic[@"nickname"]];
    
    //等级
    lvLabel.text = [NSString stringWithFormat:@"%@", parent_myself_info_Dic[@"lv"]];
    
    //注释 还差 .....
    titleLbl.text = [NSString stringWithFormat:@"还差%ld星币升级到%ld级会员",[parent_myself_info_Dic[@"next_grade_coin"] integerValue]-[parent_myself_info_Dic[@"coin_total"] integerValue], [parent_myself_info_Dic[@"lv"] integerValue] + 1];
    
    //签到按钮
    
    
    //已经连续签到 多少天...
    checkLbl.text = [NSString stringWithFormat:@"已连续签到%@天",parent_myself_info_Dic[@"continued"]];
    
    //明天签到将...
    checkInLbl.text = [NSString stringWithFormat:@"明天继续签到将获得%@个猩币",parent_myself_info_Dic[@"next_get_coin"]];
    
    //进度条
    float b =  [parent_myself_info_Dic[@"coin_total"] floatValue]/[parent_myself_info_Dic[@"next_grade_coin"] floatValue];
    ysView.progressValue = b * ysView.frame.size.width;
}



- (void)initUI{
    _portraitImageView=[[UIImageView alloc]initWithFrame:CGRectMake(20 * kWidth / 375, 30 * kWidth / 375, 100 * kWidth / 375,100 * kWidth / 375)];
    _portraitImageView.layer.cornerRadius = _portraitImageView.frame.size.width / 2;;
    _portraitImageView.layer.masksToBounds =YES;
    _portraitImageView.userInteractionEnabled =YES;
    [imageView addSubview:_portraitImageView];
    //点击更换头像
    CGFloat iconBottom = _portraitImageView.frame.origin.y + _portraitImageView.frame.size.height;
    UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(editPortrait)];
    [_portraitImageView addGestureRecognizer:tap];
    
    //添加性别40, 65, 20, 20
   manimage = [[UIImageView alloc]initWithFrame:CGRectMake(40 * kWidth / 375, 75 * kWidth / 375, 20 * kWidth / 375, 20 * kWidth / 375)];
    [_portraitImageView addSubview:manimage];
    
    
    UIButton *button=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setFrame:CGRectMake(_portraitImageView.frame.origin.x+50 ,_portraitImageView.frame.size.width+_portraitImageView.frame.origin.y+10 , 80 * kWidth / 375, 30 * kWidth / 375)];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    nameLbl =[HHControl createLabelWithFrame:CGRectMake(145 * kWidth / 375, 42 * kWidth / 375, 100 * kWidth / 375, 20 * kWidth / 375) Font:18 * kWidth / 375 Text:@""];//
    nameLbl.textColor =UIColorFromRGB(255, 255, 255);
    [imageView addSubview:nameLbl];
    
    //宝贝 等级
//    NSString *lvString = [NSString stringWithFormat:@"LV%@", lv];
    lvLabel = [HHControl createLabelWithFrame:CGRectMake(250 * kWidth / 375, 43 * kWidth / 375, 40 * kWidth / 375, 18 * kWidth / 375) Font:12 * kWidth / 375 Text:@""];//_lvString
    lvLabel.textColor = UIColorFromRGB(3, 169, 244);
    lvLabel.textAlignment = NSTextAlignmentCenter;
    lvLabel.backgroundColor = [UIColor whiteColor];
    lvLabel.layer.cornerRadius = 5;
    lvLabel.layer.masksToBounds = YES;
    [imageView addSubview:lvLabel];

   //还差多少个猩币....
   titleLbl =[HHControl createLabelWithFrame:CGRectMake(145 * kWidth / 375, 70 * kWidth / 375, 220 * kWidth / 375, 20 * kWidth / 375) Font:14 * kWidth / 375 Text:@""];
    titleLbl.textColor =UIColorFromRGB(255, 255, 255);
    [imageView addSubview:titleLbl];
    
    //滚动条
    ysView = [[YSProgressView alloc] initWithFrame:CGRectMake(145 * kWidth / 375, 100 * kWidth / 375, 200 * kWidth / 375, 10 * kWidth / 375)];
    ysView.progressHeight = 2;
    ysView.progressTintColor = [UIColor colorWithRed:0.0 / 255 green:0.0 / 255 blue:0.0 / 255 alpha:0.5];
    ysView.trackTintColor = [UIColor whiteColor];

    
    [imageView addSubview:ysView];

    
    UIView *bgView =[[UIView alloc]initWithFrame:CGRectMake(0, 140 * kWidth / 375, kWidth, 40 * kWidth / 375)];
    bgView.backgroundColor =UIColorFromRGB(255, 255, 255);
    bgView.alpha =0.1;
    [imageView addSubview:bgView];
    
    
    UIButton *checkBtn =[HHControl createButtonWithFrame:CGRectMake(40 * kWidth / 375, iconBottom + 15, 57 * kWidth / 375, 26 * kWidth / 375) backGruondImageName:@"签到106x48" Target:self Action:@selector(check) Title:@""];
    
    [imageView addSubview:checkBtn];
    
    
    checkLbl =[HHControl createLabelWithFrame:CGRectMake(145 * kWidth / 375, iconBottom + 10, 120 * kWidth / 375, 15 * kWidth / 375) Font:12 * kWidth / 375 Text:@""];
    checkLbl.textColor =UIColorFromRGB(255, 255, 255);
    [imageView addSubview:checkLbl];
    
     checkInLbl =[HHControl createLabelWithFrame:CGRectMake(145 * kWidth / 375, checkLbl.frame.origin.y + checkLbl.frame.size.height + 5, 200 * kWidth / 375, 15 * kWidth / 375) Font:12 * kWidth / 375 Text:@""];
    checkInLbl.textColor =UIColorFromRGB(255, 255, 255);
    [imageView addSubview:checkInLbl];

}


- (void)createTableView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 144 * kWidth / 375, kWidth, kHeight-144 * kWidth / 375) style:UITableViewStyleGrouped];
    _tableView.dataSource =self;
    _tableView.delegate =self;
    [self.view addSubview:_tableView];
    _tableView.separatorStyle =UITableViewCellSeparatorStyleSingleLine;
    
  
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
}
-(void)addHeadView{
    UIImageView *passImageV =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 90)];
    _tableView.tableFooterView =passImageV;
    passImageV.userInteractionEnabled =YES;
      UIButton *outBtn =[HHControl createButtonWithFrame:CGRectMake(25 * kWidth / 375, 0, 325 * kWidth / 375, 42 * kWidth / 375) backGruondImageName:@"按钮big650x84" Target:self Action:@selector(Gout) Title:@"注销登录"];
//    [outBtn setTintColor:UIColorFromRGB(255, 255, 255)];
    [outBtn setTitleColor:UIColorFromRGB(255, 255, 255) forState:UIControlStateNormal];
    
    [passImageV addSubview:outBtn];
    UIButton *passBtn =[HHControl createButtonWithFrame:CGRectMake(25 * kWidth / 375, 50 * kWidth / 375, 325 * kWidth / 375, 42 * kWidth / 375) backGruondImageName:@"按钮big650x84" Target:self Action:@selector(passWord) Title:@"修改密码"];
      [passBtn setTitleColor:UIColorFromRGB(255, 255, 255) forState:UIControlStateNormal];
    [passImageV addSubview:passBtn];
    
    
    imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 64, kWidth, 180 * kWidth / 375)];
    imageView.image = [UIImage imageNamed:@"banner"];
    [self.view addSubview:imageView];
    imageView.userInteractionEnabled =YES;

}
- (void)Gout{
    
    _alertView =[[UIAlertView alloc]initWithTitle:@"提示" message:@"是否确定注销登录?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [_alertView show];
   
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
        {
        
        }
            break;
        case 1:
        {
            
            [[XXEUserInfo user]cleanUserInfo];
            [XXEUserInfo user].login = NO;
            LandingpageViewController *landVC =[[LandingpageViewController alloc]init];
            [self presentViewController:landVC animated:YES completion:nil];
        }
            break;
            
        default:
            break;
    }

}
- (void)passWord{
        PWRViewController *passWordVC =[[PWRViewController alloc]init];
    [self.navigationController pushViewController:passWordVC animated:YES];

}
- (void)check{
      [SVProgressHUD showSuccessWithStatus:@"签到成功!"];
    CheckInViewController *checkInVC =[[CheckInViewController alloc]init];
    [self.navigationController pushViewController:checkInVC animated:YES];
  
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPat{
  
        return 45;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [headArr count];
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //[_tableView endEditing:YES];
    UITextField *textF =(UITextField*)[self.view viewWithTag:101];
    [textF resignFirstResponder];

}
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITextField *textF =(UITextField*)[self.view viewWithTag:101];
    [textF resignFirstResponder];

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static  NSString *cellID=@"cellID";
    MyInfomationCell *cell =(MyInfomationCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        NSArray *nib =[[NSBundle mainBundle]loadNibNamed:@"MyInfomationCell" owner:[MyInfomationCell class] options:nil];
        cell =(MyInfomationCell*)[nib objectAtIndex:0];
    }
    cell.headImageV.image =[UIImage imageNamed:dataArray[0][indexPath.row]];
    cell.MyLabel.text =dataArray[1][indexPath.row];
    if ([contentArray count] != 0) {
       cell.MyTextField.text =contentArray[indexPath.row];
    }
    cell.MyTextField.tag =100+indexPath.row;
    cell.MyTextField.delegate =self;
   
    if (indexPath.row==1) {
       
    }
    else{
    cell.MyTextField.userInteractionEnabled =NO;
    }
    return cell;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
   
    return YES;

}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //@" 猩猩ID:",@"昵称:",@"姓名:",@"关系:",@"年龄:",@"手机号:",@"电子邮箱:",@"隐私设置",@"修改密码",
    if (indexPath.row ==0) {
        //猩猩ID:
        
    }
    else if (indexPath.row ==1){
        //昵称:
        
        
    }
    else if (indexPath.row ==2){
        //姓名:
        
        
    }
    else if (indexPath.row ==3){
         // 年龄:
      
        
    }
    else if (indexPath.row ==4){
         //关系:
        
        
        
    }
    else if (indexPath.row ==5){
        // 手机号:
        NSLog(@"手机号");
        ChangeTeleponeViewController *chengTeleVC =[[ChangeTeleponeViewController alloc]init];
        [self.navigationController pushViewController:chengTeleVC animated:YES];
        
    }
    else if (indexPath.row ==6){
        //电子邮箱:@
        
       ChangeEmailViewController *chengEmailVC =[[ChangeEmailViewController alloc]init];
    
        [chengEmailVC returnText:^(NSString *showText) {
            if (![showText isEqualToString:@""]) {
                
                if ([contentArray count] != 0) {
                    [contentArray insertObject:showText atIndex:6];
                    [_tableView reloadData];
                }
            }
//            else{
//                [dataArray[2] insertObject:@"Keen_Team@163.com" atIndex:6];
//                [_tableView reloadData];
//            
//            }
            
        }];
        
        [self.navigationController pushViewController:chengEmailVC animated:YES];
        
    }
    else{
    //@"修改密码"
    
//        PWRViewController *passWordVC =[[PWRViewController alloc]init];
//             [self.navigationController pushViewController:passWordVC animated:YES];
        
    }
}

- (void)editPortrait {
    UIActionSheet *choiceSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"拍照", @"从相册中选取", nil];
    [choiceSheet showInView:self.view];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
 
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark --更换头像
- (void)loadPortrait {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^ {
        UIImage *protraitImg = [UIImage imageNamed:@"头像194x194"];
        dispatch_sync(dispatch_get_main_queue(), ^{
          _portraitImageView.image = protraitImg;
        });
    });
}

#pragma mark VPImageCropperDelegate
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    _portraitImageView.image = editedImage;
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        // TO DO
        //NSLog(@">>>>>>>>>>>>editedImage>>>>>%@",editedImage);
        NSData *data =UIImagePNGRepresentation(editedImage);
        NSDateFormatter *formatter =[[NSDateFormatter alloc]init];
        formatter.dateFormat =@"yyyyMMddHHmmss";
        NSString *str =[formatter stringFromDate:[NSDate date]];
        NSString *fileName =[NSString stringWithFormat:@"%@.png", str];

        urlStr = @"http://www.xingxingedu.cn/Parent/edit_my_info";
        NSDictionary *prag = @{   @"appkey":APPKEY,
                                   @"backtype":BACKTYPE,
                                   @"xid":parameterXid,
                                   @"user_id":parameterUser_Id,
                                   @"user_type":USER_TYPE,
                                   };
        
        AFHTTPRequestOperationManager *mgr =[AFHTTPRequestOperationManager manager];
        [mgr POST:urlStr parameters:prag constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            [formData appendPartWithFileData:data name:@"file" fileName:fileName mimeType:@"image/png"];
        } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            NSDictionary *dict =responseObject;
          //  NSLog(@"111111<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<%@",dict);
            if([[NSString stringWithFormat:@"%@",dict[@"code"]]isEqualToString:@"1"] )
            {
           //  NSLog(@"2222222=====================================%@",dict[@"data"]);
            }
            
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
      //  NSLog(@"EROOROROOREROOROROOREROOROROOREROOROROOREROOROROORE");
            
          //  NSLog(@"3333333%@", error);
        }];
        
    }];
}
- (void)viewWillDisappear:(BOOL)animated{
    nickNameTextFiled =(UITextField*)[self.view viewWithTag:101];
    emailTextFiled =(UITextField*)[self.view viewWithTag:106];
   
    if (nickNameTextFiled.text ==nil) {
        nickNameTextFiled.text =@"";
    }
    if (emailTextFiled.text ==nil) {
        emailTextFiled.text =@"";
    }
    urlStr = @"http://www.xingxingedu.cn/Parent/edit_my_info";
    NSDictionary *prag = @{   @"appkey":APPKEY,
                              @"backtype":BACKTYPE,
                              @"xid":parameterXid,
                              @"user_id":parameterUser_Id,
                              @"user_type":USER_TYPE,
                              @"nickname":nickNameTextFiled.text,
                              @"email":emailTextFiled.text
                              };
    
    [WZYHttpTool post:urlStr params:prag success:^(id responseObj) {
        NSDictionary *dict =responseObj;
     //    NSLog(@"data=====================================%@",dict);
        if([[NSString stringWithFormat:@"%@",dict[@"code"]]isEqualToString:@"1"] )
        {
           
        }
        else if ([[NSString stringWithFormat:@"%@",dict[@"code"]] isEqualToString:@"50"]){
    [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@",dict[@"msg"]]];
        }
        
    } failure:^(NSError *error) {
     //    NSLog(@"error====error=================================");
    }];

}
- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
    }];
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        // 拍照
        if ([self isCameraAvailable] && [self doesCameraSupportTakingPhotos]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypeCamera;
            if ([self isFrontCameraAvailable]) {
                controller.cameraDevice = UIImagePickerControllerCameraDeviceFront;
            }
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = self;
            [self presentViewController:controller
                               animated:YES
                             completion:^(void){
                             //    NSLog(@"Picker View Controller is presented");
                             }];
        }
        
    } else if (buttonIndex == 1) {
        // 从相册中选取
        if ([self isPhotoLibraryAvailable]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = self;
            [self presentViewController:controller
                               animated:YES
                             completion:^(void){
                              //   NSLog(@"Picker View Controller is presented");
                             }];
        }
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^() {
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        portraitImg = [self imageByScalingToMaxSize:portraitImg];
        // 裁剪
        VPImageCropperViewController *imgEditorVC = [[VPImageCropperViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, 100.0f, self.view.frame.size.width, self.view.frame.size.width) limitScaleRatio:3.0];
        imgEditorVC.delegate = self;
        [self presentViewController:imgEditorVC animated:YES completion:^{
            // TO DO
        }];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^(){
    }];
}
#pragma mark camera utility
- (BOOL) isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isRearCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

- (BOOL) isFrontCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

- (BOOL) doesCameraSupportTakingPhotos {
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickVideosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickPhotosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
}

#pragma mark image scale utility
- (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage {
    if (sourceImage.size.width < ORIGINAL_MAX_WIDTH) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = ORIGINAL_MAX_WIDTH;
        btWidth = sourceImage.size.width * (ORIGINAL_MAX_WIDTH / sourceImage.size.height);
    } else {
        btWidth = ORIGINAL_MAX_WIDTH;
        btHeight = sourceImage.size.height * (ORIGINAL_MAX_WIDTH / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}

- (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
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
