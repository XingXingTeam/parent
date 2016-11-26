//
//  ClassAlbumViewController.m
//  XingXingEdu
//    ___  _____   ______  __ _   _________
//   / _ \/ __/ | / / __ \/ /| | / / __/ _ \
//  / , _/ _/ | |/ / /_/ / /_| |/ / _// , _/
// /_/|_/___/ |___/\____/____/___/___/_/|_|
//
//  Created by keenteam on 16/1/18.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//
#define kPData     @"SampleCell"
#define kPreviewDataLimit @"Image"
#define data     @"Data"
#define data1     @"Data1"
#define data2     @"Data2"
#define data3     @"Data3"

#define kPreviewData @"Country"
#define kPreview @"Place"
#import "ClassAlbumViewController.h"
#import "SampleCell.h"
#import "ClassAlbumPicCollectionViewController.h"
#import "ClassAlumModel.h"
#import "OtherTeacherViewController.h"
#import "LandingpageViewController.h"


@interface ClassAlbumViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView * _tableView;

}
@property (nonatomic, retain) NSMutableArray* teachNameMArr;
@property (nonatomic, retain) NSMutableArray* picterMArr;
@property (nonatomic, retain) NSMutableArray* dataArr;
@property (nonatomic, retain) NSMutableArray* teacheIDArr;


@end

@implementation ClassAlbumViewController
- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController.navigationBar setBarTintColor:UIColorFromRGB(0, 170, 42)];
}
- (void)viewDidLoad {
   
    [super viewDidLoad];
    self.title =@"相册";
    self.dataArr = [[NSMutableArray alloc]init];

    [self createTableView];
    [self initData];

}
- (void)initData{
    
    self.teachNameMArr = [[NSMutableArray alloc]init];
    self.picterMArr = [[NSMutableArray alloc]init];

    self.teacheIDArr =[[NSMutableArray alloc]init];
    
    /*
     【班级相册->班内所有老师最新照片】
     
     接口:
     http://www.xingxingedu.cn/Parent/class_album_new
     
     传参:
     school_id	//学校id (测试值:1)
     class_id	//班级id (测试值:1)
     */
    
    //路径
    NSString *urlStr = @"http://www.xingxingedu.cn/Parent/class_album_new";
    
    //请求参数
    //获取学校id数组
    NSString *class_idStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"CLASS_ID"];
    NSString *schoolIdStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"SCHOOL_ID"];
    
    NSString *parameterXid;
    NSString *parameterUser_Id;
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }
    
    NSDictionary *params = @{@"appkey":APPKEY, @"backtype":BACKTYPE, @"xid":parameterXid, @"user_id":parameterUser_Id, @"user_type":USER_TYPE, @"school_id":schoolIdStr, @"class_id":class_idStr};
    
//    NSLog(@"%@", params);
    
    [WZYHttpTool post:urlStr params:params success:^(id responseObj) {
        //
//        NSLog(@"%@", responseObj);
        
        NSDictionary *dict = responseObj;
        /*
         {
         msg = Success!,
         data = [
         {
         tname = 梁红水,
         pic_arr = [
         app_upload/text/class/class_a7.jpg,
         app_upload/text/class/class_a6.jpg,
         app_upload/text/class/class_a5.jpg
         ],
         teacher_id = 1
         },
         {
         tname = 李小川,
         pic_arr = [
         app_upload/text/class/class_d5.jpg,
         app_upload/text/class/class_d4.jpg,
         app_upload/text/class/class_d3.jpg
         ],
         teacher_id = 2
         },
         {
         tname = 赵大京,
         pic_arr = [
         app_upload/text/class/class_d4.jpg,
         app_upload/text/class/class_d5.jpg,
         app_upload/text/class/class_b5.jpg
         ],
         teacher_id = 3
         }
         ],
         code = 1
         }
         */
        if([[NSString stringWithFormat:@"%@",dict[@"code"]]isEqualToString:@"1"] ){
            for (NSDictionary *dictItem in dict[@"data"]) {
              
                [_teachNameMArr addObject:dictItem[@"tname"]];
                
                [_teacheIDArr addObject:dictItem[@"teacher_id"]];
                
//                _picterMArr = dictItem[@"pic_arr"];
                [_picterMArr addObject:dictItem[@"pic_arr"]];
            }
        
        
        }else{
        
        
        }

        [self customContent];
    
    } failure:^(NSError *error) {
        //
        NSLog(@"%@", error);
    }];

    
}



//相册 有数据 和 无数据 进行判断
- (void)customContent{
    
    if (_picterMArr.count == 0) {
        // 1、无数据的时候
        UIImage *myImage = [UIImage imageNamed:@"人物"];
        CGFloat myImageWidth = myImage.size.width;
        CGFloat myImageHeight = myImage.size.height;
        
        UIImageView *myImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kWidth / 2 - myImageWidth / 2, (kHeight - 64 - 49) / 2 - myImageHeight / 2, myImageWidth, myImageHeight)];
        myImageView.image = myImage;
        [self.view addSubview:myImageView];
        
    }else{
        //2、有数据的时候
        [_tableView reloadData];
        
    }
    
}


- (void)createTableView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,64, kWidth, kHeight) style:UITableViewStyleGrouped];
    self.automaticallyAdjustsScrollViewInsets =NO;
    _tableView.delegate =self;
    _tableView.dataSource =self;
    [self.view addSubview:_tableView];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section ==0) {
         return 30;
    }
    else{
    return 15;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
 
    return self.teachNameMArr.count;
}
- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
   
    return   self.teachNameMArr[section];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120 ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SampleCell *cell = (SampleCell*) [tableView dequeueReusableCellWithIdentifier:kPData];
    if(cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:kPData owner:[SampleCell class] options:nil];
        cell = (SampleCell *)[nib objectAtIndex:0];
    }
    
//    NSLog(@"%@", _picterMArr[indexPath.section]);
    
    NSArray *pictureArray = _picterMArr[indexPath.section];
    
    CGFloat imageViewWidth = (kWidth - 10 * 2) / 3;
    CGFloat imageViewHeight = 120 * kWidth / 375;
    
    for (int i = 0; i < pictureArray.count; i ++) {

        UIImageView *myImageView = [[UIImageView alloc] initWithFrame:CGRectMake((imageViewWidth + 10) * i , 0, imageViewWidth, imageViewHeight)];

        [myImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", picURL, pictureArray[i]]] placeholderImage:[UIImage imageNamed:@"占位图94x94@2x(1)"]];
        
        [cell.contentView addSubview:myImageView];
        
    }

    
    if (indexPath.row==1) {
        cell.nowlbl.text = @"new";
        cell.nowlbl.font = [UIFont boldSystemFontOfSize:14 * kWidth / 375];
        cell.nowlbl.textColor = [UIColor redColor];
    }
    else if(indexPath.row==3){
        cell.nowlbl.text = @"new";
        cell.nowlbl.textColor = [UIColor redColor];
    
    }
   
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if ([XXEUserInfo user].login){
        OtherTeacherViewController *otherTeacherVC =[[OtherTeacherViewController alloc]init];
        otherTeacherVC.KTitle =self.teachNameMArr[indexPath.section];
        otherTeacherVC.teacherID =self.teacheIDArr[indexPath.section];
        [self.navigationController pushViewController:otherTeacherVC animated:YES];
    }else{
        [SVProgressHUD showInfoWithStatus:@"请用账号登录后查看"];
         }
    
    

  
}


@end
