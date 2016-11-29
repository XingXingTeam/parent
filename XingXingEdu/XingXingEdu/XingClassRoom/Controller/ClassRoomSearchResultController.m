//
//  ClassRoomSearchResultController.m
//  XingXingEdu
//
//  Created by mac on 16/7/26.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "ClassRoomSearchResultController.h"
#import "ClassTeacherTableViewCell.h"
#import "ClassSubjectTableViewCell.h"
#import "ClassSchoolTableViewCell.h"

#import "ClassRoomSubjectInfoViewController.h"
#import "TeleTeachInfoViewController.h"
#import "LogoTabBarController.h"
#define kPData @"ClassSubjectTableViewCell"
@interface ClassRoomSearchResultController ()<UITableViewDelegate,UITableViewDataSource>{
    
     UITableView * _tableView;
    //老师
    NSMutableArray  * _teacherArray;
    //课程
    NSMutableArray * _subjectArray;
    //机构
    NSMutableArray * _schoolArray;
    
    NSString *indexStr;
}
@property (nonatomic, strong) NSMutableArray *schoolIdArray;
@end

@implementation ClassRoomSearchResultController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.view.backgroundColor= UIColorFromRGB(229, 233, 232);
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    self.title = @"搜索结果";
    
    _schoolArray = [NSMutableArray array];
    _subjectArray = [NSMutableArray array];
    _teacherArray = [NSMutableArray array];
    
    if (_seletNum == 0) {
    
        [self getTeacherInfo:@"1"];
    }else if (_seletNum == 1){
    
        [self getSubjectInfo:@"1"];
    }else{
      
         [self getSchoolInfo:@"1"];
    }
    
    [self createTabelView];
    // Do any additional setup after loading the view.
}

-(void)createTabelView{
    //tableView
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, 0, kWidth, kHeight);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //设置分割线距边界的距离
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor = UIColorFromRGB(229, 233, 232);
    [self.view addSubview:_tableView];

}

#pragma mark  tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_seletNum == 0) {
        return _teacherArray.count;
    }
    else if (_seletNum == 1) {
        return _subjectArray.count;
    }
    else  if (_seletNum == 2){
        return _schoolArray.count;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_seletNum == 0) {
        
         ClassTeacherTableViewCell *cell = (ClassTeacherTableViewCell*) [tableView dequeueReusableCellWithIdentifier:@"ClassTeacherTableViewCell"];
        if(cell==nil){
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ClassTeacherTableViewCell" owner:[ClassTeacherTableViewCell class] options:nil];
            cell = (ClassTeacherTableViewCell *)[nib objectAtIndex:0];
            cell.contentView.backgroundColor = [UIColor clearColor];
        }
        
     
        
        NSArray * tmp = _teacherArray[indexPath.row];
        [cell.iconImg sd_setImageWithURL:[NSURL URLWithString:tmp[0]] placeholderImage:[UIImage imageNamed:@"sdimg1.png"]];
        cell.NameLabel.text=tmp[1];
        cell.agelabel.text=tmp[2];
        cell.gradeLabel.text=[NSString stringWithFormat:@"%@分",tmp[3]];;
        cell.courseLabel.text=tmp[4];
        cell.distanceLabel.text=[NSString stringWithFormat:@"%@KM",tmp[5]];
        cell.infoLabel.text=tmp[6];
        if([[NSString stringWithFormat:@"%@",tmp[7]]isEqualToString:@"1"]){
            cell.attestationImg.image=[UIImage imageNamed:@"专业认证icon36x32"];
        }else{
            cell.attestationImg.hidden=YES;
        }
        
        cell.collect.hidden=YES;
        return cell;
        
    }
    else if (_seletNum == 1) {
        
        ClassSubjectTableViewCell *cell = (ClassSubjectTableViewCell*) [tableView dequeueReusableCellWithIdentifier:kPData];
        if(cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:kPData owner:[ClassSubjectTableViewCell class] options:nil];
            cell = (ClassSubjectTableViewCell *)[nib objectAtIndex:0];
            cell.contentView.backgroundColor = [UIColor clearColor];
        }
        
        NSArray * tmp = _subjectArray[indexPath.row];
        
        cell.iconImg.layer.cornerRadius= cell.iconImg.bounds.size.width/2;
        cell.iconImg.layer.masksToBounds=YES;
        [cell.iconImg sd_setImageWithURL:[NSURL URLWithString:tmp[0]] placeholderImage:[UIImage imageNamed:@"sdimg1.png"]];
        
        cell.nameLabel.text=tmp[1];
        
        NSString *teacherName;
        for (NSString * name in tmp[2]) {
            teacherName=name;
        }
        cell.teacherLabel.text = teacherName;
        cell.peopleNumLabel.text = tmp[3];
        cell.beginDateLabel.text=tmp[4];
        //新的对旧的  旧的对现价....
        cell.priceNewLabel.text=tmp[5];
        cell.priceOldLabel.text=tmp[6];
        cell.distanceLabel.text=[NSString stringWithFormat:@"%@KM",tmp[7]];
        
        if([[NSString stringWithFormat:@"%@",tmp[8]]isEqualToString:@"1"]){
            
            [cell.moneyXing  setBackgroundImage:[UIImage imageNamed:@"猩币icon28x30.png"] forState:UIControlStateNormal];
            
        }else{
            cell.moneyXing.hidden=YES;
        }
        
        if([[NSString stringWithFormat:@"%@",tmp[9]]isEqualToString:@"1"]){
            [cell.moveBack  setBackgroundImage:[UIImage imageNamed:@"退icon28x30.png"] forState:UIControlStateNormal];
        }else{
            cell.moveBack.hidden=YES;
        }
        return cell;
        
    }
    else if (_seletNum == 2){
        
        ClassSchoolTableViewCell *cell = (ClassSchoolTableViewCell*) [tableView dequeueReusableCellWithIdentifier:@"ClassSchoolTableViewCell"];
        if(cell==nil){
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ClassSchoolTableViewCell" owner:[ClassSchoolTableViewCell class] options:nil];
            cell = (ClassSchoolTableViewCell *)[nib objectAtIndex:0];
            cell.contentView.backgroundColor = [UIColor clearColor];
        }
        
        
        NSArray * tmp = _schoolArray[indexPath.row];
        
        cell.iconImg.layer.cornerRadius= cell.iconImg.bounds.size.width/2;
        cell.iconImg.layer.masksToBounds=YES;
        [cell.iconImg sd_setImageWithURL:[NSURL URLWithString:tmp[0]] placeholderImage:[UIImage imageNamed:@"sdimg1.png"]];
        cell.nameLabel.text=tmp[1];
        cell.gradeLabel.text=[NSString stringWithFormat:@"%@分",tmp[2]];
        
        cell.studentLabel.text = [NSString stringWithFormat:@"%@   %@",tmp[3],tmp[4]];
        
        cell.distanceLabel.text=[NSString stringWithFormat:@"%@KM",tmp[6]];
        cell.addressLabel.text= [NSString stringWithFormat:@"地址: %@",tmp[7]];
        cell.addressLabel.adjustsFontSizeToFitWidth=YES;
        cell.addressLabel.minimumScaleFactor=0.1;
        return cell;
        
    }
    else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_seletNum == 0) {
        TeleTeachInfoViewController *teleTeachVC =[[TeleTeachInfoViewController alloc]init];
        teleTeachVC.hidesBottomBarWhenPushed =YES;
        teleTeachVC.teacherId = _teacherArray[indexPath.row][8];
        [self.navigationController pushViewController:teleTeachVC animated:YES];
        
    }
    else if (_seletNum == 1) {
        
        ClassRoomSubjectInfoViewController *subjectVC =[[ClassRoomSubjectInfoViewController alloc]init];
        subjectVC.hidesBottomBarWhenPushed =YES;
        subjectVC.courseId = _subjectArray[indexPath.row][10];
        [self.navigationController pushViewController:subjectVC animated:YES];
    }
    else  if (_seletNum == 2){
        
        LogoTabBarController *logoViewController = [[LogoTabBarController alloc] init];
        logoViewController.hidesBottomBarWhenPushed = YES;
        indexStr = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
        [[NSUserDefaults standardUserDefaults] setObject:indexStr forKey:@"indexStr"];
        [self presentViewController:logoViewController animated:YES completion:nil];
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(_seletNum == 0){
        return 110;
    }
    else if (_seletNum == 1){
        
        return 110;
    }
    return 110;
}


#pragma mark 网络 获取老师列表
//获取老师列表
- (void)getTeacherInfo:(NSString *)page
{
    
    NSString *xid;
    if ([XXEUserInfo user].login) {
        xid = [XXEUserInfo user].xid;
    }else {
        xid = XID;
    }
    
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/xkt_teacher";
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *dict = @{@"appkey":APPKEY,
                           @"backtype":BACKTYPE,
                           @"xid":xid,
                           @"user_id":USER_ID,
                           @"user_type":USER_TYPE,
                           @"page":page,
                           @"user_lng":@"121.616636",
                           @"user_lat":@"31.285725",
//                           @"appoint_order":[NSString stringWithFormat:@"%ld",appoint_order],
//                           @"class_str":classStr,
//                           @"filter_distance":filter_distance,
                           @"search_words":_searchWord,
                           
                           };
    
    // 服务器返回的数据格式
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer]; // 二进制数据
    [mgr POST:urlStr parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         
        NSLog(@"~~~~~~~~~~~~~~~~~~~~%@",dict);
         
         if([[NSString stringWithFormat:@"%@",dict[@"code"]]isEqualToString:@"1"] )
         {
             for (NSDictionary *dic in dict[@"data"] ) {
                 //判断是否是第三方头像
                 NSString * head_img;
                 if([[NSString stringWithFormat:@"%@",dic[@"head_img_type"]]isEqualToString:@"0"]){
                     head_img=[picURL stringByAppendingString:dic[@"head_img"]];
                 }else{
                     head_img=dic[@"head_img"];
                 }
                 NSString * tname=dic[@"tname"];
                 NSString * age=[NSString stringWithFormat:@"%@岁",dic[@"age"]];
                 NSString *  score_num=[NSString stringWithFormat:@"%@",dic[@"score_num"]];
                 score_num=[score_num substringWithRange:NSMakeRange(0, 4)];
                 
                 NSString * teach_range=dic[@"teach_range"];
                 NSString * distance=[NSString stringWithFormat:@"%@.000",dic[@"distance"]];
                 
                 distance=[distance substringWithRange:NSMakeRange(0, 4)];
                 NSString * exper_year=[NSString stringWithFormat:@"教龄:%@年",dic[@"exper_year"]];
                 NSString * certification=[NSString stringWithFormat:@"%@",dic[@"certification"]];
                 NSString *teacherId = dic[@"id"];
                 NSMutableArray *arr=[NSMutableArray arrayWithObjects:head_img,tname,age,score_num,teach_range,distance,exper_year,certification,teacherId,nil];
                 
                 [_teacherArray addObject:arr];
             }
             
             [_tableView reloadData];
         }else{
             
             [SVProgressHUD showErrorWithStatus:@"没有更多数据了"];
         }
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"请求失败:%@",error);
         [SVProgressHUD showErrorWithStatus:@"网络不通，请检查网络！"];
         
     }];
}


#pragma mark 网络 获取课程列表
//获取课程列表
- (void)getSubjectInfo:(NSString *)page
{
    NSString *xid;
    if ([XXEUserInfo user].login) {
        xid = [XXEUserInfo user].xid;
    }else {
        xid = XID;
    }
    
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/xkt_course";
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *dict = @{@"appkey":APPKEY,
                           @"backtype":BACKTYPE,
                           @"xid":xid,
                           @"user_id":USER_ID,
                           @"user_type":USER_TYPE,
                           @"page":page,
                           @"user_lng":@"121.616636",
                           @"user_lat":@"31.285725",
//                           @"appoint_order":[NSString stringWithFormat:@"%ld",appoint_order],
//                           @"class_str":classStr,
//                           @"filter_distance":filter_distance,
                           @"search_words":_searchWord,
                           
                           };
    
    // 服务器返回的数据格式
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer]; // 二进制数据
    [mgr POST:urlStr parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         
                           NSLog(@"—————————————————————————————课程详情———%@",dict);
         
         if([[NSString stringWithFormat:@"%@",dict[@"code"]]isEqualToString:@"1"] )
         {
             
             for (NSDictionary *dic in dict[@"data"] ) {
                 
                 NSString * pic = [picURL stringByAppendingString:dic[@"pic"]];
                 NSString * course_name = dic[@"course_name"];
                 
                 NSMutableArray *teacher_tname_group=[NSMutableArray array];
                 for (NSString * name in dic[@"teacher_tname_group"]) {
                     [teacher_tname_group addObject:name];
                 }
                 NSString * need_num=[NSString stringWithFormat:@"%@人班",dic[@"need_num"]];
                 NSString *  now_num=[NSString stringWithFormat:@"%@",dic[@"now_num"]];
                 
                 NSString * original_price=[NSString stringWithFormat:@"%@",dic[@"original_price"]];
                 NSString *  now_price=[NSString stringWithFormat:@"%@",dic[@"now_price"]];
                 NSString * distance=[NSString stringWithFormat:@"%@.00",dic[@"distance"]];
                 
                 distance=[distance substringWithRange:NSMakeRange(0, 4)];
                 NSString * coin=[NSString stringWithFormat:@"%@",dic[@"coin"]];
                 NSString * allow_return=[NSString stringWithFormat:@"%@",dic[@"allow_return"]];
                 NSString *courseId = [NSString stringWithFormat:@"%@",dic[@"id"]];
                 
                 NSMutableArray *arr=[NSMutableArray arrayWithObjects:pic, course_name,teacher_tname_group,need_num,now_num,original_price,now_price,distance,coin,allow_return,courseId,nil];
                 
                 [_subjectArray addObject:arr];
             }
             
             [_tableView reloadData];
             
         }else{
             
             [SVProgressHUD showErrorWithStatus:@"没有更多数据了"];
         }
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"请求失败:%@",error);
         [SVProgressHUD showErrorWithStatus:@"网络不通，请检查网络！"];
         
     }];
}



#pragma mark 网络 获取机构列表
//获取机构列表
- (void)getSchoolInfo:(NSString *)page
{
    NSString *xid;
    if ([XXEUserInfo user].login) {
        xid = [XXEUserInfo user].xid;
    }else {
        xid = XID;
    }
    
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/xkt_school";
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *dict = @{@"appkey":APPKEY,
                           @"backtype":BACKTYPE,
                           @"xid":xid,
                           @"user_id":USER_ID,
                           @"user_type":USER_TYPE,
                           @"page":page,
                           @"user_lng":@"121.616636",
                           @"user_lat":@"31.285725",
//                           @"appoint_order":[NSString stringWithFormat:@"%ld",appoint_order],
//                           @"class_str":classStr,
//                           @"filter_distance":filter_distance,
                            @"search_words":_searchWord,
                           };
    
    // 服务器返回的数据格式
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer]; // 二进制数据
    [mgr POST:urlStr parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         
                      NSLog(@"机构列表================%@",dict);
         
         if([[NSString stringWithFormat:@"%@",dict[@"code"]]isEqualToString:@"1"] )
         {
             
             for (NSDictionary *dic in dict[@"data"] ) {
                 
                 NSString *schoolId = dic[@"id"];
                 [_schoolIdArray addObject:schoolId];
                 
                 NSString * logo=[picURL stringByAppendingString:dic[@"logo"]];
                 NSString * name=dic[@"name"];
                 NSString * score_num=[NSString stringWithFormat:@"%@",dic[@"score_num"]];
                 score_num=[score_num substringWithRange:NSMakeRange(0, 4)];
                 NSString *  baby_count=[NSString stringWithFormat:@"%@位学生",dic[@"baby_count"]];
                 
                 NSString * teacher_count=[NSString stringWithFormat:@"%@位老师",dic[@"teacher_count"]];
                 NSString *  comment_num=[NSString stringWithFormat:@"%@条评论",dic[@"comment_num"]];
                 NSString * distance=[NSString stringWithFormat:@"%@.000",dic[@"distance"]];
                 
                 distance=[distance substringWithRange:NSMakeRange(0, 4)];
                 
                 NSString * address=[NSString string];
                 address=[address stringByAppendingString:dic[@"province"]];
                 address=[address stringByAppendingString:dic[@"city"]];
                 address=[address stringByAppendingString:dic[@"district"]];
                 address=[address stringByAppendingString:dic[@"address"]];
                 
                 
                 NSMutableArray *arr=[NSMutableArray arrayWithObjects:logo,name,score_num,baby_count, teacher_count,comment_num,distance,address,nil];
                 
                 [_schoolArray addObject:arr];
             }
             
             [_tableView reloadData];
             
             //使用沙河存储 _schoolIdArray
             [[NSUserDefaults standardUserDefaults] setObject:_schoolIdArray forKey:@"_schoolIdArray"];
         }else{
             
             [SVProgressHUD showErrorWithStatus:@"没有更多数据了"];
         }
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"请求失败:%@",error);
         [SVProgressHUD showErrorWithStatus:@"网络不通，请检查网络！"];
         
     }];
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
