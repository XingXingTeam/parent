//
//  MyHeadViewController.m
//  XingXingEdu
//
//  Created by keenteam on 16/1/31.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "MyHeadViewController.h"
#import "MyInfomationViewController.h"
#import "HHControl.h"
//#import "ViewController.h"
#import "ClassRoomOrderViewController.h"
#import "HFStretchableTableHeaderView.h"
#import "SaveInfoViewController.h"
#import "PWRViewController.h"
#import "MyHeadInfoCell.h"
#import "RcRootTabbarViewController.h"
//黑名单
#import "VPImageCropperViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

#import "PrivacySettingViewController.h"
#import "MyBlackListViewController.h"
#import "shezhiViewController.h"
#import "MainViewController.h"
#import "FriendsListViewController.h"
#import "WMConversationListViewController.h"
#import "XXEFriendCirclePageViewController.h"
@interface MyHeadViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>
{
     UIImageView *icon;
     UIImageView *headPortraitView;
    UITableView *_tableView;
    NSMutableArray *dataArray;
    NSMutableArray *detailArray;
    UIImageView *imageView;
    NSArray *headArr;
    NSString *urlStr;
    NSString *coin_total;
    NSString *head_img;
    NSString *lv;
    NSString *next_grade_coin;
    NSString *nickname;
    NSString *head_img_type;
    
    YSProgressView *ysView;
    
}
@end
//
@implementation MyHeadViewController
- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController.navigationBar setBarTintColor:UIColorFromRGB(0, 170, 42)];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];

}
- (void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBarHidden =NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadNewData];
    [self createTableView];
    [self addHeadView];
}
- (void)loadNewData{

    urlStr = @"http://www.xingxingedu.cn/Parent/my_personal_center";
    NSDictionary *pragm = @{   @"appkey":APPKEY,
                               @"backtype":BACKTYPE,
                               @"xid":XID,
                               @"user_id":USER_ID,
                               @"user_type":USER_TYPE,
                               };
    
    
    [WZYHttpTool post:urlStr params:pragm success:^(id responseObj) {
        NSDictionary *dict =responseObj;
        
        if([[NSString stringWithFormat:@"%@",dict[@"code"]]isEqualToString:@"1"] )
        {
//NSLog(@"data==========================%@",dict[@"data"]);暂无真实姓名
            
            coin_total =[NSString stringWithFormat:@"%@",[dict[@"data"] objectForKey:@"coin_total"]];
            head_img =[NSString stringWithFormat:@"%@",[dict[@"data"] objectForKey:@"head_img"]];
            head_img_type =[NSString stringWithFormat:@"%@",[dict[@"data"] objectForKey:@"head_img_type"]];
            lv =[NSString stringWithFormat:@"%@",[dict[@"data"] objectForKey:@"lv"]];
            next_grade_coin =[NSString stringWithFormat:@"%@",[dict[@"data"] objectForKey:@"next_grade_coin"]];
            nickname =[NSString stringWithFormat:@"%@",[dict[@"data"] objectForKey:@"nickname"]];
        }
        [self initUI];
        
    } failure:^(NSError *error) {
        
        NSLog(@"%@", error);
        
    }];

}
- (void)createTableView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight) style:UITableViewStyleGrouped];
    _tableView.dataSource =self;
    _tableView.delegate =self;
    [self.view addSubview:_tableView];
    _tableView.separatorStyle =UITableViewCellSeparatorStyleSingleLine;
    dataArray = [[NSMutableArray alloc]init];
    detailArray = [[NSMutableArray alloc]init];
    headArr =[NSArray arrayWithObjects:@"我的资料40x40@2x",@"我的订单40x48@2x",@"我的好友40x44@2x",@"我的聊天40x40@2x",@"我的收藏40x40@2x",@"我的圈子40x40@2x",@"我的黑名单40x40@2x",@"系统设置40x40@2x",@"隐私设置40x40@2x",nil];
      [dataArray addObject:headArr];
    
    NSArray *arr = [NSArray arrayWithObjects:@"我的资料",@"我的订单",@"我的好友",@"我的聊天",@"我的收藏",@"我的圈子",@"我的黑名单",@"系统设置",@"隐私设置",nil];
 
    [dataArray addObject:arr];
   
}
- (void)initUI{
    //用户名
    
    UILabel *nameLbl =[HHControl createLabelWithFrame:CGRectMake(150 * kWidth / 375, 42 * kWidth / 375, 150 * kWidth / 375, 20 * kWidth / 375 ) Font:18 * kWidth / 375 Text:nickname];
    nameLbl.textColor =UIColorFromRGB(255, 255, 255);
    [imageView addSubview:nameLbl];
    
    
    //宝贝 等级
    NSString *lvString = [NSString stringWithFormat:@"LV%@", lv];
    UILabel *lvLabel = [HHControl createLabelWithFrame:CGRectMake(250 * kWidth / 375, 43 * kWidth / 375, 40 * kWidth / 375, 18 * kWidth / 375) Font:12 * kWidth / 375 Text:lvString];
    lvLabel.textColor = UIColorFromRGB(3, 169, 244);
    lvLabel.textAlignment = NSTextAlignmentCenter;
    lvLabel.backgroundColor = [UIColor whiteColor];
    lvLabel.layer.cornerRadius = 5;
    lvLabel.layer.masksToBounds = YES;
    [imageView addSubview:lvLabel];
    
    if ([head_img_type integerValue]==0) {
        icon =[[UIImageView alloc]init];
        [icon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",picURL,head_img]] placeholderImage:[UIImage imageNamed:@"人物头像172x172@2x"]];
        [icon setFrame:CGRectMake(30 * kWidth / 375, 30 * kWidth / 375, 100 * kWidth / 375,100 * kWidth / 375)];
        icon.layer.cornerRadius =50 * kWidth / 375;
        icon.layer.masksToBounds =YES;
        [imageView addSubview:icon];
        icon.userInteractionEnabled =YES;
        //添加性别
        UIImageView *manimage = [[UIImageView alloc]initWithFrame:CGRectMake(40 * kWidth / 375, 75 * kWidth / 375, 20 * kWidth / 375, 20 * kWidth / 375)];
        manimage.image = [UIImage imageNamed:@"man"];
        [icon addSubview:manimage];
        
    }
    else{
        [icon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",head_img]] placeholderImage:[UIImage imageNamed:@"人物头像172x172@2x"]];
        [icon setFrame:CGRectMake(30 * kWidth / 375, 30 * kWidth / 375, 100 * kWidth / 375,100 * kWidth / 375)];
        icon.layer.cornerRadius =50 * kWidth / 375;
        icon.layer.masksToBounds =YES;
        [imageView addSubview:icon];
        icon.userInteractionEnabled =YES;
        //添加性别
        UIImageView *manimage = [[UIImageView alloc]initWithFrame:CGRectMake(40 * kWidth / 375, 75 * kWidth / 375, 20 * kWidth / 375, 20 * kWidth / 375)];
        manimage.image = [UIImage imageNamed:@"man"];
        [icon addSubview:manimage];
    }

    
    //滚动条
    ysView = [[YSProgressView alloc] initWithFrame:CGRectMake(150 * kWidth / 375, 100 * kWidth / 375, 200 * kWidth / 375, 10 * kWidth / 375)];
    ysView.progressHeight = 2;
    ysView.progressTintColor = [UIColor colorWithRed:0.0 / 255 green:0.0 / 255 blue:0.0 / 255 alpha:0.5];
    ysView.trackTintColor = [UIColor whiteColor];
    float b =  [coin_total floatValue]/[next_grade_coin floatValue];
    ysView.progressValue = b * ysView.frame.size.width;
    
    [imageView addSubview:ysView];
    
    UILabel *titleLbl =[HHControl createLabelWithFrame:CGRectMake(150 * kWidth / 375, 70 * kWidth / 375, 220 * kWidth / 375, 20 * kWidth / 375) Font:14 * kWidth / 375 Text:[NSString stringWithFormat:@"还差%ld星币升级到%ld级会员",[next_grade_coin integerValue]-[coin_total integerValue], [lv integerValue]+1]];
    titleLbl.textColor =UIColorFromRGB(255, 255, 255);
    titleLbl.numberOfLines =0;
    [imageView addSubview:titleLbl];
    
    
}

-(void)addHeadView{
    imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 150 * kWidth / 375)];
    imageView.image = [UIImage imageNamed:@"banner"];
    _tableView.tableHeaderView =imageView;
    imageView.userInteractionEnabled =YES;
   
    UIButton *button=[UIButton buttonWithType:UIButtonTypeRoundedRect];
   
    [button setFrame:CGRectMake(icon.frame.origin.x+50 ,icon.frame.size.width+icon.frame.origin.y+10 , 80 * kWidth / 375, 30 * kWidth / 375)];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    UIButton *photoBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [photoBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [photoBtn setFrame:CGRectMake(250 * kWidth / 375,50 * kWidth / 375, 18 * kWidth / 375, 15 * kWidth / 375)];
    [photoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [photoBtn addTarget:self action:@selector(clickWithTap) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:photoBtn];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        return 43;
    }
   else if (indexPath.row>5) {
        return 43;
    }
    else{
      return 43;
    }
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [headArr count];

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
       static  NSString *cellID=@"cellID";
    MyHeadInfoCell *cell =(MyHeadInfoCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        NSArray *nib =[[NSBundle mainBundle]loadNibNamed:@"MyHeadInfoCell" owner:[MyHeadInfoCell class] options:nil];
        cell =(MyHeadInfoCell*)[nib objectAtIndex:0];
    }
      cell.nameLbl.text =dataArray[1][indexPath.row];
      cell.headImagV.image = [UIImage imageNamed:dataArray[0][indexPath.row]];
     // cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // 0@"我的资料",1@"我的订单",2@"我的收藏",3@"我的好友",4@"我的聊天",5@"我的圈子",@"我的黑名单"
    if (indexPath.row ==0) {
        //我的资料
        MyInfomationViewController *myInfomationVC =[[MyInfomationViewController alloc]init];
        myInfomationVC.hidesBottomBarWhenPushed =YES;
        myInfomationVC.lvString = [NSString stringWithFormat:@"LV%@", lv]; 
        [self.navigationController pushViewController:myInfomationVC animated:YES];
        
    }
    else if (indexPath.row ==1){
    //我的订单
        ClassRoomOrderViewController *classRoomVC =[[ClassRoomOrderViewController alloc]init];
         classRoomVC.hidesBottomBarWhenPushed =YES;
        [self.navigationController pushViewController:classRoomVC animated:YES];
    
    }
    else if (indexPath.row ==2){
        //我的好友
        FriendsListViewController *rcRootVC =[[FriendsListViewController alloc]init];
        rcRootVC.hidesBottomBarWhenPushed =YES;
        [self.navigationController pushViewController:rcRootVC animated:YES];
  
    
    }
    else if (indexPath.row ==3){
        // 我的聊天
        WMConversationListViewController *rcRootVC =[[WMConversationListViewController alloc]init];
        rcRootVC.hidesBottomBarWhenPushed =YES;
        rcRootVC.isShowNetworkIndicatorView =NO;
        [self.navigationController pushViewController:rcRootVC animated:YES];
 

    }
    else if (indexPath.row ==4){
        //收藏

        MainViewController *mainVC =[[MainViewController alloc]init];
        mainVC.hidesBottomBarWhenPushed =YES;
        [self.navigationController pushViewController:mainVC animated:YES];
        
    
    }
    else if (indexPath.row ==5){
           //我的圈子
        XXEFriendCirclePageViewController *viewVC = [XXEFriendCirclePageViewController new];
        viewVC.hidesBottomBarWhenPushed =YES;
        [self.navigationController pushViewController:viewVC animated:NO];
        
    }
    else if (indexPath.row ==6){
    //我的黑名单
        MyBlackListViewController *myblacklistVC =[[MyBlackListViewController alloc]init];
           myblacklistVC.hidesBottomBarWhenPushed =YES;
        [self.navigationController pushViewController:myblacklistVC animated:YES];
        
    }
    else if (indexPath.row ==7){
        //系统设置
        shezhiViewController *myblacklistVC =[[shezhiViewController alloc]init];
           myblacklistVC.hidesBottomBarWhenPushed =YES;
        [self.navigationController pushViewController:myblacklistVC animated:YES];
        
    }
    else if (indexPath.row ==8){
        //隐私设置
        PrivacySettingViewController *myblacklistVC =[[PrivacySettingViewController alloc]init];
        myblacklistVC.hidesBottomBarWhenPushed =YES;
        [self.navigationController pushViewController:myblacklistVC animated:YES];
        
    }
    else{
    
    
    }

}

-(void)clickWithTap{
    [self ktLss];
   
}

- (void)ktLss{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *action1 =[UIAlertAction actionWithTitle:@"照相" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
       //        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }];
    UIAlertAction *action2 =[UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self visitktPhoto];
    }];
    UIAlertAction *action3 =[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:action1];
    [alertController addAction:action2];
    [alertController addAction:action3];
    [self presentViewController:alertController animated:YES completion:nil];
    
    
}
#pragma mark -- 访问系统相册
- (void)visitktPhoto{

    UIImagePickerController *imagePick = [[UIImagePickerController alloc] init];
    [self presentViewController:imagePick animated:YES completion:^{
        imagePick.delegate = self;
        imagePick.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }];
    
}

#pragma mark -- UIImagePickerController delegate
// 相册选中后调用
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        //先把图片转成NSData
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        // 转换图片格式,
        NSData *data;
        if (UIImagePNGRepresentation(image) == nil) {
            data = UIImageJPEGRepresentation(image, 1);
        }else{
            
            data = UIImagePNGRepresentation(image);
        }
        
#pragma mark-- 将选中的照片保存到沙盒中供使用
        //这里将图片放在沙盒的documents文件夹中
        
        // 获取doucument路径
        NSArray *array = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        
        NSString *documentsPath = [array lastObject];
        
        
        // 文件管理器
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager createDirectoryAtPath:documentsPath withIntermediateDirectories:YES attributes:nil error:nil];
        //把刚刚图片转换的data对象拷贝至沙盒中 并保存为image.png
        [fileManager createFileAtPath:[documentsPath stringByAppendingPathComponent:@"userIcon.png"] contents:data attributes:nil];
        
        //得到选择后沙盒中图片的完整路径
       // NSString *filePath_icon = [[NSString alloc]initWithFormat:@"%@%@",documentsPath,  @"/userIcon.png"];
        
      
        
      
        //        NSString *iconName = filePath_icon.lastPathComponent;
        
//        [[SustainManage shareInstance] setuserIcon:data];
//        [[SustainManage shareInstance] synchronized];
        
               headPortraitView.image = image;
        
     
               icon.image = [UIImage imageWithData:data];
        
        
        
        
    }
    
    [picker dismissViewControllerAnimated:YES completion:^{
     
    }];
}

// 取消按钮点击事件
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
 

}

#pragma mark -- 调用摄像头
- (void)addUserIcon_camera:(UITapGestureRecognizer *)tapGesture{
   
    //调用摄像头
    [self camera];
    
}

- (void)camera{
    
    UIImagePickerController *imagePick = [[UIImagePickerController alloc] init];
    [self presentViewController:imagePick animated:YES completion:^{
        
        // 判断是否有后置摄像头
        //        UIImagePickerControllerCameraDeviceFront ,为前置摄像头
        BOOL iscamera = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
        if (!iscamera) {
            NSLog(@"没有摄像头");
            return ;
        }
        imagePick.delegate = self;
        imagePick.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePick.allowsEditing = YES; //拍完照可以进行编辑
        
    }];
}



@end
