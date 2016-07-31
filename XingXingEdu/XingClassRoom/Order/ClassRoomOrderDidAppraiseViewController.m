//
//  ClassRoomOrderDidAppraiseViewController.m
//  XingXingEdu
//
//  Created by codeDing on 16/5/16.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "ClassRoomOrderDidAppraiseViewController.h"
#import "SJAvatarBrowser.h"
@interface ClassRoomOrderDidAppraiseViewController (){
    NSMutableArray *_picGroup;//详情图片
    NSMutableArray *_picImage;
}

@end

@implementation ClassRoomOrderDidAppraiseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.view.backgroundColor=[UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    
    _picGroup = [NSMutableArray array];
    [self getinfoAppraise];
}

-(void)getinfoAppraise{
    
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/course_comment_detail";
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *dict = @{@"appkey":APPKEY,
                           @"backtype":BACKTYPE,
                           @"xid":XID,
                           @"user_id":USER_ID,
                           @"user_type":USER_TYPE,
                           @"comment_id":_comment_id,
                           };
    
    
    // 服务器返回的数据格式
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer]; // 二进制数据
    [mgr POST:urlStr parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
//    NSLog(@"+++===========dic==========%@",dict);
         if([[NSString stringWithFormat:@"%@",dict[@"code"]] isEqualToString:@"1"] ){
             
             //教学质量评分
             NSString * c_score_quality = [NSString stringWithFormat:@"%@",dict[@"data"][@"c_score_quality"]];
             //教学环境评分
             NSString * c_score_env = [NSString stringWithFormat:@"%@",dict[@"data"][@"c_score_env"]];
             //教师态度评分
             NSString * t_score_attitude = [NSString stringWithFormat:@"%@",dict[@"data"][@"t_score_attitude"]];
             //课程评价分
             NSString * t_score_cult = [NSString stringWithFormat:@"%@",dict[@"data"][@"t_score_cult"]];
             //评论内容
             NSString * con = [NSString stringWithFormat:@"%@",dict[@"data"][@"con"]];
             
             _picGroup = dict[@"data"][@"pic"];

               //教学环境评分
             if ([c_score_env isEqualToString:@"1.00"]) {
                 self.imgview1.image=[UIImage imageNamed:@"starShow1"];
             }else if ([c_score_env isEqualToString:@"2.00"]){
                 self.imgview1.image=[UIImage imageNamed:@"starShow2"];
             }else if ([c_score_env isEqualToString:@"3.00"]){
                 self.imgview1.image=[UIImage imageNamed:@"starShow3"];
             }else if ([c_score_env isEqualToString:@"4.00"]){
                 self.imgview1.image=[UIImage imageNamed:@"starShow4"];
             }else if ([c_score_env isEqualToString:@"5.00"]){
                 self.imgview1.image=[UIImage imageNamed:@"starShow5"];
             }
             self.imgview1.contentMode = UIViewContentModeScaleAspectFit;
             
             //教学质量评分
             if ([c_score_quality isEqualToString:@"1.00"]) {
                 self.imgview2.image=[UIImage imageNamed:@"starShow1"];
             }else if ([c_score_quality isEqualToString:@"2.00"]){
                 self.imgview2.image=[UIImage imageNamed:@"starShow2"];
             }else if ([c_score_quality isEqualToString:@"3.00"]){
                 self.imgview2.image=[UIImage imageNamed:@"starShow3"];
             }else if ([c_score_quality isEqualToString:@"4.00"]){
                 self.imgview2.image=[UIImage imageNamed:@"starShow4"];
             }else if ([c_score_quality isEqualToString:@"5.00"]){
                 self.imgview2.image=[UIImage imageNamed:@"starShow5"];
             }
             self.imgview2.contentMode = UIViewContentModeScaleAspectFit;
             //课程评价分
             if ([t_score_cult isEqualToString:@"1.00"]) {
                 self.imgview3.image=[UIImage imageNamed:@"starShow1"];
             }else if ([t_score_cult isEqualToString:@"2.00"]){
                 self.imgview3.image=[UIImage imageNamed:@"starShow2"];
             }else if ([t_score_cult isEqualToString:@"3.00"]){
                 self.imgview3.image=[UIImage imageNamed:@"starShow3"];
             }else if ([t_score_cult isEqualToString:@"4.00"]){
                 self.imgview3.image=[UIImage imageNamed:@"starShow4"];
             }else if ([t_score_cult isEqualToString:@"5.00"]){
                 self.imgview3.image=[UIImage imageNamed:@"starShow5"];
             }
             self.imgview3.contentMode = UIViewContentModeScaleAspectFit;
             
             //教师态度评分
             if ([t_score_attitude isEqualToString:@"1.00"]) {
                 self.imgview4.image=[UIImage imageNamed:@"starShow1"];
             }else if ([t_score_attitude isEqualToString:@"2.00"]){
                 self.imgview4.image=[UIImage imageNamed:@"starShow2"];
             }else if ([t_score_attitude isEqualToString:@"3.00"]){
                 self.imgview4.image=[UIImage imageNamed:@"starShow3"];
             }else if ([t_score_attitude isEqualToString:@"4.00"]){
                 self.imgview4.image=[UIImage imageNamed:@"starShow4"];
             }else if ([t_score_attitude isEqualToString:@"5.00"]){
                 self.imgview4.image=[UIImage imageNamed:@"starShow5"];
             }
             self.imgview4.contentMode = UIViewContentModeScaleAspectFit;
            //评论
             _appraiseCon.text = con;
             _appraiseCon.userInteractionEnabled = NO;
             
            //评论照片
           UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(40, CGRectGetMaxY(_appraiseCon.frame) + 20,280, 80)];
             scrollView.backgroundColor = [UIColor whiteColor];
             CGFloat imgW = kWidth/3;
             CGFloat imgH = scrollView.frame.size.height;
             CGFloat imgY = 0;
             
             _picImage = [NSMutableArray array];
            
             if (_picGroup.count > 0) {
                 for (int i = 0; i < _picGroup.count; i++) {
                     UIImageView *imgView = [[UIImageView alloc] init];
                     
                     NSString *imgName = [picURL stringByAppendingString:_picGroup[i]];
                     [_picImage addObject:imgName];
                     
                     [imgView sd_setImageWithURL:[NSURL URLWithString:imgName] placeholderImage:nil];
                     CGFloat imgX = i * imgW;
                     imgView.tag = i;
                     imgView.userInteractionEnabled = YES;
                     UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonpress:)];
                     [imgView addGestureRecognizer:singleTap1];
                     imgView.frame = CGRectMake(imgX, imgY, imgW, imgH);
                     [scrollView addSubview:imgView];
                 }
                 
                 CGFloat maxW = imgW * _picGroup.count + 20;
                 scrollView.contentSize = CGSizeMake(maxW, 0);
                 scrollView.pagingEnabled = NO;
                 scrollView.showsHorizontalScrollIndicator = NO;
                 [self.view addSubview:scrollView];

             }else{
                 return ;
             }
             
         }
         
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"请求失败:%@",error);
         [SVProgressHUD showErrorWithStatus:@"网络不通，请检查网络！"];
         
     }];
}

-(void)buttonpress:(UIButton *)sender {
    UITapGestureRecognizer *tap = (UITapGestureRecognizer *)sender;
    int tag = tap.view.tag;
    UIImageView *imgView = [[UIImageView alloc] init];
    [imgView sd_setImageWithURL:[NSURL URLWithString:_picImage[tag]] placeholderImage:nil];
    [SJAvatarBrowser showImage:imgView];//调用方法
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
