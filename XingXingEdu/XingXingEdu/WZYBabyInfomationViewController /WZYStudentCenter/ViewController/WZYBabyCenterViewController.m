

//
//  WZYBabyCenterViewController.m
//  XingXingEdu
//
//  Created by Mac on 16/5/27.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "WZYBabyCenterViewController.h"
#import "WZYHistoryClassesViewController.h"
#import "WZYAddBabyViewController.h"
#import "MBProgressHUD.h"
#import "HHControl.h"
#import "VPImageCropperViewController.h"
#import "LandingpageViewController.h"


#define DETAIL @"WZYStudentCenterTableViewCell"
#define Space 10

#define ORIGINAL_MAX_WIDTH 640.0f

#define WinWidth [UIScreen mainScreen].bounds.size.width
#define WinHeight [UIScreen mainScreen].bounds.size.height
//#define W(x) WinWidth*x/375.0
//#define H(y) WinHeight*y/667.0

#define awayX 20
#define spaceX 5
#define spaceY 50



@interface WZYBabyCenterViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,VPImageCropperDelegate,UITextViewDelegate,UITextFieldDelegate, UIAlertViewDelegate>
{
    MBProgressHUD *HUDDelete;
    MBProgressHUD *HUDDone;
    NSString *parameterXid;
    NSString *parameterUser_Id;

}
@property (nonatomic) NSArray *pictureArray;
@property (nonatomic) NSArray *titleArray;
@property (nonatomic) NSArray *contentArray;

//@property (nonatomic) UITableView *tableView;
@property (nonatomic) UIImageView *backgroundImageView;
@property (nonatomic) UIImageView *iconImageView;
@property (nonatomic) UIView *lineView;
@property (nonatomic) UITextView *myTextView;
@property (nonatomic) UITextField *myTextField;
@property (nonatomic) UILabel *myLabel;

//昵称 textField
@property (nonatomic, strong) UITextField *nicknameTextField;
//签名
@property (nonatomic, strong) UITextField *personal_signTextField;

@property (nonatomic, strong) UIButton *confirmClassesBtn;
@property (nonatomic, strong) UIButton *deleteBtn;

@property (nonatomic, copy) NSString *oldNiChengStr;
@property (nonatomic, copy) NSString *nowNiChengStr;

@property (nonatomic, copy) NSString *head_imgStr;

@end

@implementation WZYBabyCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.confirmClassesBtn.hidden = YES;
    
    self.view.backgroundColor = UIColorFromRGB(229, 232, 233);
    
    [self.navigationController.navigationBar setBarTintColor:UIColorFromRGB(0, 170, 42)];
    self.title = @"学生中心";
    
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }

    
    //3、设置 navigationBar 右边
    //添加宝宝信息
        UIButton *addBtn = [HHControl createButtonWithFrame:CGRectMake(300, 5, 22 * kWidth / 375, 22 * kWidth / 375) backGruondImageName:@"添加icon44x44" Target:self Action:@selector(addBaby) Title:nil];
        UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithCustomView:addBtn];
        //班级历史
        UIButton *deleteBtn = [HHControl createButtonWithFrame:CGRectMake(330, 5, 22 * kWidth / 375, 22 * kWidth / 375) backGruondImageName:@"班级历史44x44" Target:self Action:@selector(historyClassesBtnClick) Title:nil];
        UIBarButtonItem *deleteItem = [[UIBarButtonItem alloc] initWithCustomView:deleteBtn];
        
        self.navigationItem.rightBarButtonItems = @[deleteItem, addItem];
        self.pictureArray =[[NSMutableArray alloc]initWithObjects:@"昵称40x44", @"姓名40x40", @"年龄40x46", @"关系40x46", @"生日40x40", @"学校40x40", @"班级40x40",  @"个性签名40x40", @"个人描述40x40", nil];
        self.titleArray =[[NSMutableArray alloc]initWithObjects:@"昵称:",@"姓名:",@"年龄:", @"关系:", @"生日:", @"学校:", @"班级:", @"个性签名:", @"个人描述:", nil];
    
    //获取数据
    [self fetchNetData];

}


- (void)fetchNetData{
    /*
     接口:
     http://www.xingxingedu.cn/Parent/my_baby_info
     传参:
     baby_id		//孩子id
     */
    //路径
    NSString *urlStr = @"http://www.xingxingedu.cn/Parent/my_baby_info";
    //请求参数
    
//    NSLog(@"ooooooooo%@", _babyId);

    NSDictionary *params = @{@"appkey":APPKEY, @"backtype":BACKTYPE, @"xid":parameterXid, @"user_id":parameterUser_Id, @"user_type":USER_TYPE, @"baby_id":_babyId};
    
    [WZYHttpTool post:urlStr params:params success:^(id responseObj) {
        //
//        NSLog(@"重新获取 头像 信息=================%@", responseObj);

        NSString *codeStr = [NSString stringWithFormat:@"%@", responseObj[@"code"]];
         NSDictionary *dic = responseObj[@"data"];
        if ([codeStr isEqualToString:@"1"]) {
            
            NSString *schoolNameStr = [DEFAULTS objectForKey:@"SCHOOLNAME"];
            
            NSString *gradeAndClassStr = [DEFAULTS objectForKey:@"GRADEANDCLASS"];
            
            self.contentArray =[[NSMutableArray alloc]initWithObjects:dic[@"nickname"], dic[@"tname"], dic[@"age"], dic[@"relation"], dic[@"birthday"], schoolNameStr, gradeAndClassStr,dic[@"personal_sign"],  dic[@"pdescribe"], nil];
            
            _head_imgStr=[picURL stringByAppendingString:dic[@"head_img"]];

                 //创建 头视图
                    [self createHeaderImageView];
            
                 //创建内容
                    [self createContent];
            
                 //创建脚视图
                    [self createFooterImageView];
        
        }else{
             [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"获取数据失败,%@",dic[@"msg"]]];
        
        }
        
    } failure:^(NSError *error) {
        //
        NSLog(@"%@", error);
    }];
    
}

//创建tableView的头视图
- (void)createHeaderImageView{
    _backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, kWidth , 100 * kHeight / 667)];
    _backgroundImageView.backgroundColor = UIColorFromRGB(0, 170, 42);
    _backgroundImageView.userInteractionEnabled = YES;
    //设置头像
    CGFloat iconWidth = 86.0 * kWidth / 375;
    CGFloat iconHeight = 86.0 * kWidth / 375;
    
    _iconImageView = [[UIImageView alloc] init];
    _iconImageView.frame = CGRectMake((kWidth / 2 - iconWidth / 2)* kWidth / 375, (_backgroundImageView.frame.size.height / 2 - iconHeight/2)* kWidth / 375, iconWidth, iconHeight);
//    _iconImageView.image = [UIImage imageNamed:@"头像172x172"];
    
    
//    NSLog(@"%@", _head_imgStr);
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:_head_imgStr] placeholderImage:[UIImage imageNamed:@"头像172x172"]];
    
    
    _iconImageView.layer.cornerRadius = iconWidth / 2;
    _iconImageView.layer.masksToBounds = YES;
    
    _iconImageView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapGest1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap1:)];
    [_iconImageView addGestureRecognizer:tapGest1];
    
    [_backgroundImageView addSubview:_iconImageView];
    
    [self.view addSubview:_backgroundImageView];
}

//创建内容
- (void)createContent{

    //创建 前7 条view
    for (int i = 0; i < 8; i++) {
        UIView *myView = [[UIView alloc] initWithFrame:CGRectMake(0, _backgroundImageView.frame.origin.y + _backgroundImageView.frame.size.height + (40 * i )* kWidth / 375, kWidth, 40 * kWidth / 375)];
        myView.backgroundColor = [UIColor whiteColor];
        
        //创建 左边 icon
        UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 20 * kWidth / 375, 20 * kWidth / 375)];
        icon.image = [UIImage imageNamed:_pictureArray[i]];
        [myView addSubview:icon];
        
        //创建 中间 标题
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20 + 20 + 14, 10, 70 * kWidth / 375, 20 * kWidth / 375)];
        titleLabel.text = _titleArray[i];
        
        titleLabel.font = [UIFont systemFontOfSize:14 * kWidth / 375];
        [myView addSubview:titleLabel];
        
        //创建 右边 内容
        UITextField *contentTextField = [[UITextField alloc] initWithFrame:CGRectMake(20 + 20 + 14 + 70 + 6, 5, 200 * kWidth / 375, 30 * kWidth / 375)];
        contentTextField.text = _contentArray[i];
        contentTextField.delegate = self;
       
        contentTextField.font = [UIFont systemFontOfSize:14 * kWidth / 375];
        [myView addSubview:contentTextField];
        
        //昵称
        if (i == 0) {
            
            _nicknameTextField = contentTextField;
            _nicknameTextField.delegate = self;
//            [_nicknameTextField addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:@"1"];
            
        }else if (i == 7){
            
            _personal_signTextField = contentTextField;
            _personal_signTextField.delegate = self;
//            [_personal_signTextField addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:@"2"];
            
        }
        
        
        if (i == 0 || i == 7) {
            
        contentTextField.borderStyle = UITextBorderStyleRoundedRect;
    
            
        }
        
        //创建分割线
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(5, 39, (kWidth - 5)* kWidth / 375, 1* kWidth / 375)];
        lineView.backgroundColor = UIColorFromRGB(230, 230, 230);
        [myView addSubview:lineView];
        
        
        if (i != 0 && i != 7) {
            contentTextField.enabled = NO;
        }
        
        
        [self.view addSubview:myView];
        
    }
    
    //创建 个人描述
    UIView *descriptionView = [[UIView alloc] initWithFrame:CGRectMake(0, _backgroundImageView.frame.origin.y + _backgroundImageView.frame.size.height + (40 * 8) * kWidth / 375, kWidth , 70 * kWidth / 375)];
    descriptionView.backgroundColor = [UIColor whiteColor];
    
    descriptionView.userInteractionEnabled =YES;
    
    
    //创建 左边 icon
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 20 * kWidth / 375, 20 * kWidth / 375)];
    icon.image = [UIImage imageNamed:[_pictureArray lastObject]];
    [descriptionView addSubview:icon];
    
    //创建 中间 标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20 + 20 + 14, 10, 70 * kWidth / 375, 20 * kWidth / 375)];
    titleLabel.text = [_titleArray lastObject];
    titleLabel.font = [UIFont systemFontOfSize:14 * kWidth / 375];
    [descriptionView addSubview:titleLabel];
    
    //创建 右边 内容
    self.myTextView = [[UITextView alloc] initWithFrame:CGRectMake(20 + 20 + 14 + 70 + 6, 5, 235 * kWidth / 375, 60 * kWidth / 375)];
    self.myTextView.text = [_contentArray lastObject];
    self.myTextView.font = [UIFont systemFontOfSize:14 * kWidth / 375];
    self.myTextView.delegate = self;
    [descriptionView addSubview:self.myTextView];

    
    //输入框 默认 的提示 文字 字数
    self.myLabel = [[UILabel alloc] initWithFrame:CGRectMake(kWidth - 70, 50, 60 * kWidth / 375, 15 * kWidth / 375)];
//    self.myLabel.text = @"1/200";
    self.myLabel.textAlignment = NSTextAlignmentCenter;
    self.myLabel.textColor = [UIColor lightGrayColor];
    self.myLabel.font = [UIFont systemFontOfSize:14 * kWidth / 375];
    [descriptionView addSubview:self.myLabel];

    //创建分割线
//    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(5, 42, kWidth - 5, 1)];
//    lineView1.backgroundColor = UIColorFromRGB(230, 230, 230);
//    [descriptionView addSubview:lineView1];
    
    [self.view addSubview:descriptionView];

}



//创建脚视图
- (void)createFooterImageView{
    UIImageView *footBackground = [[UIImageView alloc] initWithFrame:CGRectMake(0, kHeight - 110, kWidth , 110 * kWidth / 375)];
    footBackground.backgroundColor = UIColorFromRGB(229, 232, 233);
    footBackground.userInteractionEnabled = YES;
    

        //确认
        self.confirmClassesBtn = [HHControl createButtonWithFrame:CGRectMake(20, 10, 325 * kWidth / 375, 42 * kWidth / 375) backGruondImageName:@"按钮big650x84" Target:self Action:@selector(confirmBtnClick) Title:@"确  认"];
        [self.confirmClassesBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        
        //删除
        self.deleteBtn = [HHControl createButtonWithFrame:CGRectMake(20, 60 , 325 * kWidth / 375, 42 * kWidth / 375) backGruondImageName:@"按钮big650x84" Target:self Action:@selector(deleteBaby) Title:@"删  除"];
        [self.deleteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [footBackground addSubview:self.confirmClassesBtn];
        [footBackground addSubview:self.deleteBtn];
        
        [self.view addSubview:footBackground];


}


- (void)textViewDidChange:(UITextView *)textView{
    
//    textView = _myTextView;
    //    NSLog(@"22222222");
    self.myTextView = textView;
    
    self.myLabel.text = [NSString stringWithFormat:@"%ld/200", (unsigned long)textView.text.length];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{

    //    取消第一响应者
    [textField resignFirstResponder];
    return YES;
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField == _personal_signTextField) {
        CGRect rect = CGRectMake(0, kHeight, kWidth, 258 * kWidth / 375);
        [UIView animateWithDuration:0.3 animations:^{
            self.view.frame = CGRectMake(0, -rect.size.height, kWidth, kHeight);
            
        }];
      
    }
  return YES;
}


- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
   
    if (textField == _personal_signTextField) {
        CGRect rect = CGRectMake(0, kHeight, kWidth, 258 * kWidth / 375);
                    [UIView animateWithDuration:0.3 animations:^{
                        self.view.frame = CGRectMake(0, 0, kWidth, kHeight);
        
                    }];

    }
    return YES;
 
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    CGRect rect = CGRectMake(0, kHeight, kWidth, 258 * kWidth / 375);
    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame = CGRectMake(0, -rect.size.height, kWidth, kHeight);
        
    }];
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    [UIView animateWithDuration:0.2 animations:^{
        self.view.frame = CGRectMake(0, 0, kWidth, kHeight);
    }];

    return YES;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//    
    [self.view endEditing:YES];
}

//#warning 更换头像
//更换头像
- (void)tap1:(UIGestureRecognizer *)tap{
    
    UIActionSheet *manu = [[UIActionSheet alloc] initWithTitle:@"更改头像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从相册上传", nil];
    manu.delegate=self;
    manu.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    
    [manu showInView:self.view];
    
}


//添加宝宝
- (void)addBaby{
    if ([XXEUserInfo user].login) {
        WZYAddBabyViewController *WZYAddBabyVC = [[WZYAddBabyViewController alloc] init];
        [self.navigationController pushViewController:WZYAddBabyVC animated:YES];
   }else{
      [SVProgressHUD showInfoWithStatus:@"请用账号登录后查看"];
  }

}

//删除宝宝
- (void)deleteBaby{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"删除该宝贝信息" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"删除", nil];
    
    [alert show];
}

#pragma mark -
#pragma mark delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            //取消
            //                NSLog(@"%ld",buttonIndex);
            break;
        case 1:
        {
            //删除
            //                NSLog(@"%ld",buttonIndex);
            
            [self deleteBabyInfo];
            
            HUDDelete = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:HUDDelete];
            HUDDelete.dimBackground = YES;
            HUDDelete.labelText = @"删除成功";
            
            [HUDDelete showAnimated:YES whileExecutingBlock:^{
                sleep(1);
            } completionBlock:^{
                [HUDDelete removeFromSuperview];
                HUDDelete = nil;
                [self.navigationController popViewControllerAnimated:NO];
            }];
            
            
        }
            
            break;
    }
    
    
}

- (void)deleteBabyInfo{
/*
 【删除孩子】
 ★注:别删除系统中的原有的孩子,因为这些孩子很多表都关联了,还要用于后面的测试. 请先测试添加孩子,再删除自己添加的孩子.
 接口:
 http://www.xingxingedu.cn/Parent/delete_baby
 传参:
	baby_id		//孩子id

 */
    //路径
    NSString *urlStr = @"http://www.xingxingedu.cn/Parent/delete_baby";
    
    //请求参数
    
    NSDictionary *params = @{@"appkey":APPKEY, @"backtype":BACKTYPE, @"xid":parameterXid, @"user_id":parameterUser_Id, @"user_type":USER_TYPE, @"baby_id":_babyId};
    
    [WZYHttpTool post:urlStr params:params success:^(id responseObj) {
        NSDictionary *dict =responseObj;
//    NSLog(@"删除孩子     data=====================%@",dict);
        if([[NSString stringWithFormat:@"%@",dict[@"code"]]isEqualToString:@"1"] )
        {
            
        }else {
            
            [SVProgressHUD showErrorWithStatus:@"获取数据失败!"];
        }
        
    } failure:^(NSError *error) {
        //           NSLog(@"error====error=================================");
    }];
}



//班级历史
- (void)historyClassesBtnClick{
    if ([XXEUserInfo user].login) {
        WZYHistoryClassesViewController *WZYHistoryClassesVC = [[WZYHistoryClassesViewController alloc] init];
        WZYHistoryClassesVC.babyId = _babyId;
        [self.navigationController pushViewController:WZYHistoryClassesVC animated:YES];
    }else{
        [SVProgressHUD showInfoWithStatus:@"请用账号登录后查看"];
    }
}

//确认
- (void)confirmBtnClick{
    
    if ([XXEUserInfo user].login) {
        if (_nicknameTextField.text == nil) {
            _nicknameTextField.text =@"";
            
        }if ([_nicknameTextField.text isEqualToString:@""]) {
            
            [SVProgressHUD showInfoWithStatus:@"昵称不能为空"];
            return;
        }else if(_personal_signTextField.text == nil){
            _personal_signTextField.text = @"";
            
        }else if(_myTextView.text == nil){
            _myTextView.text = @"";
            
        }
        
        [self upLoadNetData];
        HUDDone = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUDDone];
        HUDDone.dimBackground = YES;
        HUDDone.labelText = @"完成";
        
        [HUDDone showAnimated:YES whileExecutingBlock:^{
            sleep(1);
        } completionBlock:^{
            [HUDDone removeFromSuperview];
            HUDDone = nil;
        }];
        
    }else{
        [SVProgressHUD showInfoWithStatus:@"请用账号登录后查看"];
    }
    
    
}

- (void)upLoadNetData{
    
//        /*
    
//    【编辑孩子信息】
//    
//    接口:
//    http://www.xingxingedu.cn/Parent/edit_baby_info
//    
//    传参:
//    baby_id		//孩子id
//    nickname	//昵称
//    personal_sign	//个性签名
//    pdescribe	//个人描述
//    file		//上传头像
//    
//    说明:以上需要修改的3个参数可以传1个,也可以传多个
//
//         */
//        //路径
        NSString *urlStr = @"http://www.xingxingedu.cn/Parent/edit_baby_info";
    
        //请求参数

        NSDictionary *params = @{@"appkey":APPKEY, @"backtype":BACKTYPE, @"xid":parameterXid, @"user_id":parameterUser_Id, @"user_type":USER_TYPE, @"baby_id":_babyId, @"nickname":_nicknameTextField.text, @"personal_sign":_personal_signTextField.text, @"pdescribe":_myTextView.text};
        
    [WZYHttpTool post:urlStr params:params success:^(id responseObj) {
        NSDictionary *dict =responseObj;
//         NSLog(@"data=====================================%@",dict);
        if([[NSString stringWithFormat:@"%@",dict[@"code"]]isEqualToString:@"1"] )
        {
            
        }
        else if ([[NSString stringWithFormat:@"%@",dict[@"code"]] isEqualToString:@"50"]){
            
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@",dict[@"msg"]]];
        }
        
    } failure:^(NSError *error) {
//           NSLog(@"error====error=================================");
    }];
}


#pragma mark --更换头像
- (void)loadPortrait {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^ {
        UIImage *protraitImg = [UIImage imageNamed:@"XX.png"];
        dispatch_sync(dispatch_get_main_queue(), ^{
            self.portraitImageView.image = protraitImg;
        });
    });
}

- (void)editPortrait {
    
    if ([XXEUserInfo user].login) {
        UIActionSheet *choiceSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                 delegate:self
                                                        cancelButtonTitle:@"取消"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"拍照", @"从相册中选取", nil];
        [choiceSheet showInView:self.view];

    }else{
        [SVProgressHUD showInfoWithStatus:@"请用账号登录后查看"];    
    }
    
}

#pragma mark VPImageCropperDelegate
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    self.portraitImageView.image = editedImage;
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        // TO DO
        
        /////////////////////////////更换头像///////
        
        //    【编辑孩子信息】
        //
        //    接口:
        //    http://www.xingxingedu.cn/Parent/edit_baby_info
        //
        //    传参:
        //    baby_id		//孩子id
        //    nickname	//昵称
        //    personal_sign	//个性签名
        //    pdescribe	//个人描述
        //    file		//上传头像
        //
        //    说明:以上需要修改的3个参数可以传1个,也可以传多个
        
        //NSLog(@">>>>>>>>>>>>editedImage>>>>>%@",editedImage);
        NSData *data =UIImagePNGRepresentation(editedImage);
        NSDateFormatter *formatter =[[NSDateFormatter alloc]init];
        formatter.dateFormat =@"yyyyMMddHHmmss";
        NSString *str =[formatter stringFromDate:[NSDate date]];
        NSString *fileName =[NSString stringWithFormat:@"%@.png", str];
        
        NSString *urlStr = @"http://www.xingxingedu.cn/Parent/edit_baby_info";
        NSDictionary *prag = @{   @"appkey":APPKEY,
                                  @"backtype":BACKTYPE,
                                  @"xid":parameterXid,
                                  @"user_id":parameterUser_Id,
                                  @"user_type":USER_TYPE,
                                  @"baby_id":_babyId
                                  };
        
        AFHTTPRequestOperationManager *mgr =[AFHTTPRequestOperationManager manager];
        mgr.responseSerializer.acceptableContentTypes = [mgr.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
        [mgr POST:urlStr parameters:prag constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            [formData appendPartWithFileData:data name:@"file" fileName:fileName mimeType:@"image/png"];
        } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            NSDictionary *dict =responseObject;
//                        NSLog(@"哈哈哈哈啊<<<<<<<<<<<<<<<<<<<<<<<<<<<<<%@",dict);
            if([[NSString stringWithFormat:@"%@",dict[@"code"]]isEqualToString:@"1"] )
            {
//  NSLog(@"data=====================================%@",dict[@"data"]);
            }
            
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            // NSLog(@"EROOROROOREROOROROOREROOROROOREROOROROOREROOROROORE");
//                        NSLog(@"哈哈哈哈哈----更换头像=======%@", error);
            
        }];
    
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
                                 NSLog(@"Picker View Controller is presented");
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
                                 NSLog(@"Picker View Controller is presented");
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

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
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

#pragma mark portraitImageView getter
- (UIImageView *)portraitImageView {
    if (!_iconImageView) {
        //        _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.frame.size.width-80)/2, 90, 80, 80)];
        [_iconImageView.layer setCornerRadius:(_iconImageView.frame.size.height/2)];
        [_iconImageView.layer setMasksToBounds:YES];
        [_iconImageView setContentMode:UIViewContentModeScaleAspectFill];
        [_iconImageView setClipsToBounds:YES];
        _iconImageView.layer.shadowColor = [UIColor blackColor].CGColor;
        _iconImageView.layer.shadowOffset = CGSizeMake(4, 4);
        _iconImageView.layer.shadowOpacity = 0.5;
        _iconImageView.layer.shadowRadius = 2.0;
        _iconImageView.layer.borderColor = [[UIColor clearColor] CGColor];
        _iconImageView.layer.borderWidth = 2.0f;
        _iconImageView.userInteractionEnabled = YES;
        _iconImageView.backgroundColor = [UIColor blackColor];
        UITapGestureRecognizer *portraitTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editPortrait)];
        [_iconImageView addGestureRecognizer:portraitTap];
    }
    return _iconImageView;
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}


@end
