//
//  WZYAddBabyViewController.m
//  XingXingEdu
//
//  Created by Mac on 16/5/11.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "WZYAddBabyViewController.h"
#import "WJCommboxView.h"
#import "VPImageCropperViewController.h"
#import "SVProgressHUD.h"
#import "HHControl.h"
#import "CheckIDCard.h"

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "WZYTextView.h"

#import "ClassEditViewController.h"


#define ORIGINAL_MAX_WIDTH 640.0f

#define WinWidth [UIScreen mainScreen].bounds.size.width
#define WinHeight [UIScreen mainScreen].bounds.size.height
//#define W(x) WinWidth*x/375.0
//#define H(y) WinHeight*y/667.0

#define awayX 20
#define spaceX 5
#define spaceY 50

#define kScreenWidth self.view.frame.size.width
#define kScreenHeight self.view.frame.size.height

@interface WZYAddBabyViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,VPImageCropperDelegate, UITextViewDelegate, UITextFieldDelegate>
{
    //宝贝描述
    WZYTextView *contentTextView;
    NSString *picUrl;
    
    NSString *parameterXid;
    NSString *parameterUser_Id;
}
@property (nonatomic) NSArray *relationArray;
@property (nonatomic) NSArray *studentIDCardArray;

//与学生关系下拉选择框
@property(nonatomic,strong)WJCommboxView *relationCombox;
@property (nonatomic,strong) UIView *relationComboxBackView;

//学生身份证下拉选择框
@property(nonatomic,strong)WJCommboxView *studentIDCardCombox;
@property (nonatomic,strong) UIView *studentIDCardComboxBackView;

@property (nonatomic,strong) WZYTextView *textView;
@property (nonatomic, strong) UILabel *myLabel;
@property (nonatomic) NSInteger myLabelTextLength;

@property (nonatomic, copy) NSString *flagCodeStr;
//存储 学生的身份证 或者 护照信息
@property (nonatomic) BOOL codeFlag;

@property (nonatomic ,strong) NSMutableArray *babayInfoArray;
@property (nonatomic ,strong) NSMutableArray *babayIdInfoArray;
@property (nonatomic ,strong) NSMutableArray *babayPassportInfoArray;


@end

@implementation WZYAddBabyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(229, 232, 233);
//    _babayInfoArray = [[NSMutableArray alloc] init];
    
    self.iconImageView.userInteractionEnabled = YES;
    

    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }
    picUrl = @"";
    //设置头像
    CGFloat iconWidth = 97.0;
    CGFloat iconHeight = 97.0;

    _iconImageView.layer.cornerRadius = iconWidth / 2;
    _iconImageView.layer.masksToBounds = YES;

    
    self.title = @"添加学生1/2";
    
    //设置 navigationBar 左边 返回
    UIImage *backImage = [UIImage imageNamed:@"返回icon90x38"];
    backImage = [backImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
 
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage: backImage  style:UIBarButtonItemStyleDone target:self action:@selector(backClick)];

    //创建下拉菜单
    [self creatCommbox];
    
    //设置内容
    [self customContent];
    
    //设置  描述信息 UITextView
    [self setupTextView];
    
    //更换头像
   UITapGestureRecognizer *changeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeTapClick:)];
    [self.iconImageView addGestureRecognizer:changeTap];
    
    //确定
    [self.doneBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [self.doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.doneBtn setBackgroundImage:[UIImage imageNamed:@"按钮big650x84"] forState:UIControlStateNormal];
    [self.doneBtn addTarget:self action:@selector(nextBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
//    //完善信息
//    self.nextBtn.backgroundColor = UIColorFromRGB(0, 170, 42);
//    
//    [self.nextBtn setTitle:@"完善信息" forState:UIControlStateNormal];
//    [self.nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [self.nextBtn setBackgroundImage:[UIImage imageNamed:@"按钮big650x84@2x"] forState:UIControlStateNormal];
//    [self.nextBtn addTarget:self action:@selector(nextBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
}

//设置内容
- (void)customContent{
    
    self.iconImageView.image = [UIImage imageNamed:@"头像194x194"];
    self.leftImageView1.image = [UIImage imageNamed:@"必填符号60x60"];
    self.leftImageView2.image = [UIImage imageNamed:@"必填符号60x60"];
    self.leftImageView3.image = [UIImage imageNamed:@"必填符号60x60"];
    self.leftImageView4.image = [UIImage imageNamed:@"必填符号60x60"];
    
    self.leftLabel1.text = @"昵称(选填)";
    self.leftLabel1.layer.cornerRadius = 15;
    self.leftLabel1.layer.masksToBounds = YES;
    self.leftLabel1.backgroundColor = [UIColor whiteColor];
    
    self.leftLabel2.text = @"学生姓名";
    self.leftLabel2.layer.cornerRadius = 15;
    self.leftLabel2.layer.masksToBounds = YES;
    self.leftLabel2.backgroundColor = [UIColor whiteColor];
    
    //    self.leftLabel3.text = @"";
    self.leftLabel4.text = @"与学生关系";
    self.leftLabel4.layer.cornerRadius = 15;
    self.leftLabel4.layer.masksToBounds = YES;
    self.leftLabel4.backgroundColor = [UIColor whiteColor];
    
    self.rightTextField1.placeholder = @"请输入昵称";
    self.rightTextField1.backgroundColor = [UIColor whiteColor];
    self.rightTextField1.layer.cornerRadius = 15;
    self.rightTextField1.layer.masksToBounds = YES;
//    self.rightTextField1.delegate = self;
    self.rightTextField1.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    self.rightTextField2.placeholder = @"请输入学生姓名";
    self.rightTextField2.backgroundColor = [UIColor whiteColor];
    self.rightTextField2.layer.cornerRadius = 15;
    self.rightTextField2.layer.masksToBounds = YES;
//    self.rightTextField2.delegate = self;
    self.rightTextField2.clearButtonMode = UITextFieldViewModeWhileEditing;
    
//    self.rightTextField3.placeholder = @"请您输入学生的身份证号";
    self.rightTextField3.backgroundColor = [UIColor whiteColor];
    self.rightTextField3.layer.cornerRadius = 15;
    self.rightTextField3.layer.masksToBounds = YES;
    self.rightTextField3.delegate = self;
    self.rightTextField3.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    
    self.myTextView.layer.cornerRadius = 10;
    self.myTextView.layer.masksToBounds = YES;

}

- (void)textFieldDidEndEditing:(UITextField *)textField;{
//    textField = self.rightTextField3;
    self.sexImageView.image = nil;
    
        NSString *sexString = self.rightTextField3.text;
//    NSLog(@"===============%@", sexString);
    
    if (_flagCodeStr) {
        if ([_flagCodeStr isEqualToString:@"学生护照"]) {
            if (sexString.length !=9)
            {
                [SVProgressHUD showInfoWithStatus:@"请输入9个字符的护照号码"];
                return;
            }
            
        }else{
        
            if (sexString.length !=18)
            {
                [SVProgressHUD showInfoWithStatus:@"您输入的学生身份证号码格式不正确"];
                return;
            }else if (![CheckIDCard checkIDCard:sexString]){
                [SVProgressHUD showInfoWithStatus:@"您输入的学生身份证号码不存在"];
                return;
            }else if (![[self rangeString:sexString begin:6 length:2] isEqualToString:@"20"]){
                [SVProgressHUD showInfoWithStatus:@"您输入的学生身份证号码不正确"];
                return;
            }else if ([CheckIDCard checkIDCardSexMan:sexString] ) {
                self.sexImageView.image = [UIImage imageNamed:@"男"];
                return;
            }else {
                self.sexImageView.image = [UIImage imageNamed:@"女"];
                return;
            }
        }
    }
    
    
    
}




// 添加输入控件
- (void)setupTextView
{
    // 1.创建输入控件
    contentTextView = [[WZYTextView alloc] init];
    contentTextView.alwaysBounceVertical = YES; // 垂直方向上拥有有弹簧效果
//    textView.frame = self.view.bounds;
//    textView.frame = CGRectMake(17, 408, 340, 100);
    contentTextView.frame = CGRectMake(17, _leftLabel4.frame.origin.y + _leftLabel4.frame.size.height + 20, WinWidth - 18 - 17, 100 * WinWidth / 375);
    contentTextView.delegate = self;
    
    [self.view addSubview:contentTextView];
    self.textView = contentTextView;
    
    // 2.设置提醒文字（占位文字）
    contentTextView.placehoder = @"个人描述:";
    
    // 3.设置字体
    contentTextView.font = [UIFont systemFontOfSize:14];
    
    contentTextView.backgroundColor = [UIColor whiteColor];
    
    self.myLabel = [[UILabel alloc] initWithFrame:CGRectMake(contentTextView.frame.origin.x + contentTextView.frame.size.width - 70, 70, 60, 20)];
    self.myLabel.text = @"0/200";
    self.myLabel.textColor = [UIColor lightGrayColor];
    self.myLabel.font = [UIFont systemFontOfSize:14];
    [contentTextView addSubview:self.myLabel];
}


- (void)textViewDidChange:(UITextView *)textView{
    if (textView == contentTextView) {
        
        if (contentTextView.text.length <= 200) {
            self.myLabel.text=[NSString stringWithFormat:@"%lu/200",(unsigned long)textView.text.length];
        }else{
//            [self showHudWithString:@"最多可输入200个字符"];
            contentTextView.text = [contentTextView.text substringToIndex:200];
        }
//        conStr = contentTextView.text;
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    

    [self.studentIDCardCombox.textField removeObserver:self forKeyPath:@"text"];
}


- (void)backClick{
    [self.navigationController popViewControllerAnimated:YES];

}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    //    取消第一响应者
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    CGRect rect = CGRectMake(0, 667, WinWidth, 258);
    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame = CGRectMake(0, -rect.size.height, WinWidth, WinHeight);
    }];
    
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    [UIView animateWithDuration:0.2 animations:^{
        self.view.frame = CGRectMake(0, 0, WinWidth, WinHeight);
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



#pragma mark --下拉选择框
- (void)creatCommbox{
    //与学生关系
    [self createRelationCombox];
    
    //学生身份证选择
    [self createStudentIDCardCombox];
    
}

//与学生关系
- (void)createRelationCombox{
    
     NSString *sexStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"性别"];
//    NSLog(@"666666666666666666%@", sexStr);
    if ([sexStr isEqualToString:@"0"]) {
        self.relationArray = [[NSArray alloc]initWithObjects:@"妈妈",@"奶奶",@"外婆",@"其他",nil];
    }else if ([sexStr isEqualToString:@"1"]){
        
    self.relationArray = [[NSArray alloc]initWithObjects:@"爸爸",@"爷爷",@"外公",@"其他",nil];
    }else{
    self.relationArray = [[NSArray alloc]initWithObjects:@"爸爸",@"妈妈",@"爷爷",@"奶奶",@"外公",@"外婆",@"其他",nil];
    }
    
//    self.relationArray = [[NSArray alloc]initWithObjects:@"爸爸",@"妈妈",@"爷爷",@"奶奶",@"外公",@"外婆",@"其他",nil];
    self.relationCombox = [[WJCommboxView alloc] initWithFrame:CGRectMake(17 + 130 + 10, 358, WinWidth - 18 - 157, 30)];
    self.relationCombox.textField.placeholder = @"请选择关系";
    self.relationCombox.textField.textAlignment = NSTextAlignmentCenter;
    self.relationCombox.textField.borderStyle = UITextBorderStyleNone;
    self.relationCombox.textField.backgroundColor = [UIColor whiteColor];
    self.relationCombox.textField.layer.cornerRadius = 15;
    self.relationCombox.textField.layer.masksToBounds = YES;
    
    self.relationCombox.dataArray = self.relationArray;
    [self.view addSubview:self.relationCombox];
    
    self.relationComboxBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight +300)];
    self.relationComboxBackView.backgroundColor = [UIColor clearColor];
    self.relationComboxBackView.alpha = 0.5;

}

//学生身份证选择
- (void)createStudentIDCardCombox{
    self.studentIDCardArray = [[NSArray alloc]initWithObjects:@"学生身份证",@"学生护照",nil];
    self.studentIDCardCombox = [[WJCommboxView alloc] initWithFrame:CGRectMake(17, 308, 130, 30)];
    
    self.studentIDCardCombox.textField.text = @"全部";
    self.studentIDCardCombox.textField.textAlignment = NSTextAlignmentCenter;
    self.studentIDCardCombox.textField.font = [UIFont systemFontOfSize:13];
    self.studentIDCardCombox.textField.borderStyle = UITextBorderStyleNone;
    self.studentIDCardCombox.textField.backgroundColor = [UIColor whiteColor];
    
    self.studentIDCardCombox.textField.layer.cornerRadius = 15;
    self.studentIDCardCombox.textField.layer.masksToBounds = YES;
    self.studentIDCardCombox.textField.clipsToBounds = YES;
    
    self.studentIDCardCombox.textField.leftViewMode = UITextFieldViewModeAlways;
    UIImageView *imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(10, 0, 20,20)];
    imageView1.image = [UIImage imageNamed:@"必填符号60x60"];
    self.studentIDCardCombox.textField.leftView = imageView1;
    
    self.studentIDCardCombox.dataArray = self.studentIDCardArray;
    self.studentIDCardCombox.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.studentIDCardCombox];
    
    self.studentIDCardComboxBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight + 300)];
    self.studentIDCardComboxBackView.backgroundColor = [UIColor clearColor];
    self.studentIDCardComboxBackView.alpha = 0.5;

    [self.studentIDCardCombox.textField addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];
    
}



- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"text"]) {
        
        NSString * newName=[change objectForKey:@"new"];
        
//        NSLog(@"%@", newName);
        _flagCodeStr = newName;
        
//        NSLog(@"%@", _flagCodeStr);
        
        if ([newName isEqualToString:@"学生护照"]) {
                 //右边 占位 字符
        self.rightTextField3.placeholder = @"请您输入学生的护照号码";
            
            _codeFlag = YES;
            
        }else {
        
        self.rightTextField3.placeholder = @"请您输入学生的身份证号码";

            _codeFlag = NO;
        }
        
    }

}


//更换头像
- (void)changeTapClick:(UIGestureRecognizer *)tap{
    UIActionSheet *manu = [[UIActionSheet alloc] initWithTitle:@"更改头像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从相册上传", nil];
    manu.delegate=self;
    manu.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    
    [manu showInView:self.view];

}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
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
    UIActionSheet *choiceSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"拍照", @"从相册中选取", nil];
    [choiceSheet showInView:self.view];
}

#pragma mark VPImageCropperDelegate
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    self.portraitImageView.image = editedImage;
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        /////////////////////////////更换头像///////
        /*
         【上传文件】
         接口:
         http://www.xingxingedu.cn/Global/uploadFile
         ★注: 默认传参只要appkey和backtype
         接口类型:2
         传参
         file_type	//文件类型,1图片,2视频 			  (必须)
         page_origin	//页面来源,传数字 			  (必须)
         11//学校食谱
         upload_format	//上传格式, 传数字,1:单个上传  2:批量上传 (必须)
         file		//文件数据的数组名 			  (必须)
         */

        //NSLog(@">>>>>>>>>>>>editedImage>>>>>%@",editedImage);
        NSData *data =UIImagePNGRepresentation(editedImage);
        NSDateFormatter *formatter =[[NSDateFormatter alloc]init];
        formatter.dateFormat =@"yyyyMMddHHmmss";
        NSString *str =[formatter stringFromDate:[NSDate date]];
        NSString *fileName =[NSString stringWithFormat:@"%@.png", str];
        
        NSString *urlStr = @"http://www.xingxingedu.cn/Global/uploadFile";
        NSDictionary *parameter = @{
                                    @"appkey":APPKEY,
                                    @"backtype":BACKTYPE,
                                    @"xid":parameterXid,
                                    @"user_id":parameterUser_Id,
                                    @"user_type":USER_TYPE,
                                    @"file_type":@"1",
                                    @"page_origin":@"1",
                                    @"upload_format":@"1"
                                    };
        
        AFHTTPRequestOperationManager *mgr =[AFHTTPRequestOperationManager manager];
        mgr.responseSerializer.acceptableContentTypes = [mgr.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
        [mgr POST:urlStr parameters:parameter constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            [formData appendPartWithFileData:data name:@"file" fileName:fileName mimeType:@"image/png"];
        } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            NSDictionary *dict =responseObject;
//                        NSLog(@"头像<<<<<<<<<<<<<<<<<<<<<%@",dict);
            if([[NSString stringWithFormat:@"%@",dict[@"code"]]isEqualToString:@"1"] )
            {
//                  NSLog(@"头像================%@",dict[@"data"]);
                picUrl = dict[@"data"];
            }
            
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
//                        NSLog(@"ffff更换头像  失败=======%@", error);
            [SVProgressHUD showErrorWithStatus:@"获取数据失败!"];
        }];
//
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

- (void)nextBtnClick{
    //学生姓名 的判断
    if ([self.rightTextField1.text isEqualToString:@""]){
        [SVProgressHUD showInfoWithStatus:@"亲,请输入学生的昵称"];
        return;
    }else if ([self.rightTextField2.text isEqualToString:@""]){
        [SVProgressHUD showInfoWithStatus:@"亲,请输入学生的姓名"];
        return;
    }else if (self.rightTextField2.text.length >5||self.rightTextField2.text.length <2){
        [SVProgressHUD showInfoWithStatus:@"亲,请输入学生正确的姓名"];
        return;
    }
    
    //判断 身份证 或者 护照
    
    if (_flagCodeStr) {
        if ([_flagCodeStr isEqualToString:@"学生护照"]) {
            //学生 护照 的判断
            if ([self.rightTextField3.text isEqualToString:@""]) {
                [SVProgressHUD showInfoWithStatus:@"亲,请输入学生的护照号码"];
                return;
            }else if ([self.studentIDCardCombox.textField.text isEqualToString:@""]){
                [SVProgressHUD showInfoWithStatus:@"亲,请选择学生与您的关系"];
                return;
            }else if (self.rightTextField3.text.length !=9){
                [SVProgressHUD showInfoWithStatus:@"您输入的护照号码格式不正确"];
                return;
            }
        }else{
            //学生 身份证 的判断
            if ([self.rightTextField3.text isEqualToString:@""]) {
                [SVProgressHUD showInfoWithStatus:@"亲,请输入学生的身份证号"];
                return;
            }else if ([self.studentIDCardCombox.textField.text isEqualToString:@""]){
                [SVProgressHUD showInfoWithStatus:@"亲,请选择学生与您的关系"];
                return;
            }else if (self.rightTextField3.text.length !=18){
                [SVProgressHUD showInfoWithStatus:@"您输入的身份证号码格式不正确"];
                return;
            }else if (![CheckIDCard checkIDCard:self.rightTextField3.text]){
                [SVProgressHUD showInfoWithStatus:@"您输入的学生身份证号码不存在"];
                return;
            }else if (![[self rangeString:self.rightTextField3.text begin:6 length:2] isEqualToString:@"20"]){
                [SVProgressHUD showInfoWithStatus:@"您输入的学生身份证号码不正确"];
                return;
            }
            
            
        }
    }else{
        if ([self.rightTextField3.text isEqualToString:@""]) {
            [SVProgressHUD showInfoWithStatus:@"请输入学生身份证号码或者护照号码"];
            return;
        }
    }
    
    //判断 关系 必须
    if ([self.relationCombox.textField.text isEqualToString:@""]) {
        [SVProgressHUD showInfoWithStatus:@"请选择与宝贝的关系"];
        return;
 
    }

    [self upLoadNetData];
    
}


- (void)upLoadNetData{
    
    ///*
    // 【添加孩子】
    //
    // ★注:后面紧跟着的添加班级,请用baby_study_sch接口
    //
    // 接口:
    // http://www.xingxingedu.cn/Parent/add_baby
    //
    // 传参:
    //	baby_nickname		//孩子昵称(必须)
    //	tname			//真实姓名(必须)
    //	id_card			//身份证
    //	passport		//护照
    //	age			    //年龄
    //	sex			    //性别
    //	relation		//关系(必须)
    //	pdescribe		//个人描述
    //	file			//上传头像 ////
    //  url_group      头像 url
    // */
        //        //路径
    NSString *urlStr = @"http://www.xingxingedu.cn/Parent/add_baby";
    
    //请求参数
    NSDictionary *params = [[NSDictionary alloc] init];
    
    NSString *sexStr;
    NSString *ageStr;
    
//    NSLog(@"picUrl **** %@", picUrl);
    
    
    if (_codeFlag == YES) {
        //护照
        params = @{@"appkey":APPKEY,
                   @"backtype":BACKTYPE,
                   @"xid":parameterXid,
                   @"user_id":parameterUser_Id,
                   @"user_type":USER_TYPE,
                   @"baby_nickname":_rightTextField1.text,
                   @"tname":_rightTextField2.text,
                   @"passport":_rightTextField3.text,
                   @"relation":self.relationCombox.textField.text,
                   @"url_group":picUrl
                   };
        //昵称 /名称 /护照 / 关系
        
    }else if (_codeFlag == NO){
        
        //身份证 信息
        sexStr = [CheckIDCard checkIDCardSex:_rightTextField3.text];
        ageStr = [CheckIDCard checkIDCardAge:_rightTextField3.text];
        
        params = @{@"appkey":APPKEY,
                   @"backtype":BACKTYPE,
                   @"xid":parameterXid,
                   @"user_id":parameterUser_Id,
                   @"user_type":USER_TYPE,
                   @"baby_nickname":_rightTextField1.text,
                   @"tname":_rightTextField2.text,
                   @"id_card":_rightTextField3.text,
                   @"relation":self.relationCombox.textField.text,
                   @"sex":sexStr,
                   @"age":ageStr,
                   @"url_group":picUrl
                   };
        
    }

    
//    NSLog(@"chuancan  === %@", params);
        [WZYHttpTool post:urlStr params:params success:^(id responseObj) {
            NSDictionary *dict =responseObj;
//             NSLog(@"添加孩子*****data======================%@",dict);
            if([[NSString stringWithFormat:@"%@",dict[@"code"]]isEqualToString:@"1"] )
            {
              //进行下一步 完善信息
            ClassEditViewController *ClassEditVC = [[ClassEditViewController alloc] init];
                
                ClassEditVC.addBabyId = responseObj[@"data"][@"baby_id"];
                
            [self.navigationController pushViewController:ClassEditVC animated:YES];
    
            }else if ([[NSString stringWithFormat:@"%@",dict[@"code"]] isEqualToString:@"3"]){
                //该宝贝 已存在
                [SVProgressHUD showErrorWithStatus:@"这个孩子已存在,并且您已经与这个孩子建立过关系!"];
    
            }else if ([[NSString stringWithFormat:@"%@",dict[@"code"]] isEqualToString:@"50"]){
                [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@",dict[@"msg"]]];
            }
            
        } failure:^(NSError *error) {
//               NSLog(@"error====error=================================");
            [SVProgressHUD showErrorWithStatus:@"获取数据失败!"];
//            NSLog(@"%@", error);
        }];
    
}



-(NSString * )rangeString:(NSString *)str begin:(NSInteger )begin  length:(NSInteger)length{
    NSRange r1 = {begin,length};
    return  [str substringWithRange:r1];
}







@end
