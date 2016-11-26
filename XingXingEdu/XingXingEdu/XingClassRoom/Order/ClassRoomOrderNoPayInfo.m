//
//  ClassRoomOrderNoPayInfo.m
//  XingXingEdu
//
//  Created by codeDing on 16/3/31.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "ClassRoomOrderNoPayInfo.h"
#import "CoreUMeng.h"
#import "SVProgressHUD.h"

#import "SJAvatarBrowser.h"

#define Kmarg 15.0f
#define KLabelX 20.0f
#define KLabelW 65.0f
#define KLabelH 30.0f
#define kUnderButtonH 64.0f
@interface ClassRoomOrderNoPayInfo (){
    NSInteger  imgCount;
    UIScrollView *bgScrollView;
    UIScrollView *scrollView;//课程详情图片滚动
    NSMutableArray *detailedLabelArr;//课程列表数据
    NSString * details;//课程详情
    NSMutableArray *picGroup;//详情图片
    NSString * course_name;//科目名称
    NSMutableArray *_picImageArr;
    BOOL isCollect;
}


@end

@implementation ClassRoomOrderNoPayInfo

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets=YES;
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.view.backgroundColor=[UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    
   
    [self getSubjectInfo:self.courseId];

}

#pragma mark 网络 获取课程详情
//获取课程列表
- (void)getSubjectInfo:(NSString *)courseId
{
    
    detailedLabelArr = [NSMutableArray array];
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/xkt_course_detail";
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *dict = @{@"appkey":APPKEY,
                           @"backtype":BACKTYPE,
                           @"xid":XID,
                           @"user_id":USER_ID,
                           @"user_type":USER_TYPE,
                           @"course_id":courseId,
                           };
    
    // 服务器返回的数据格式
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer]; // 二进制数据
    [mgr POST:urlStr parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         if([[NSString stringWithFormat:@"%@",dict[@"code"]]isEqualToString:@"1"] ){
             
             //1代表收藏过, 2代表未收藏
             if([[NSString stringWithFormat:@"%@",dict[@"data"][@"cheeck_collect"]] isEqualToString:@"1"]){
                 UIButton*rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,22,22)];
                 [rightButton setImage:[UIImage imageNamed:@"commentInfo10.png"]forState:UIControlStateNormal];
                 [rightButton addTarget:self action:@selector(collectbtn:)forControlEvents:UIControlEventTouchUpInside];
                 UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
                 self.navigationItem.rightBarButtonItem= rightItem;
                 isCollect=YES;
                 
                 
             }else if([[NSString stringWithFormat:@"%@",dict[@"data"][@"cheeck_collect"]] isEqualToString:@"2"]){
                 UIButton*rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,22,22)];
                 [rightButton setImage:[UIImage imageNamed:@"commentInfo9.png"]forState:UIControlStateNormal];
                 [rightButton addTarget:self action:@selector(collectbtn:)forControlEvents:UIControlEventTouchUpInside];
                 UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
                 self.navigationItem.rightBarButtonItem= rightItem;
                 isCollect=NO;
                 
             }
             //课程名称
             course_name = dict[@"data"][@"course_name"];
             self.title = course_name;
             //老师名字
             NSString * tname = [NSString stringWithFormat:@"%@",[dict[@"data"][@"teacher_tname"][0] objectForKey:@"tname"]];
             //机构
             NSString * school_name = [NSString stringWithFormat:@"%@",dict[@"data"][@"school_name"]];
             //浏览
             NSString * read_num = [NSString stringWithFormat:@"%@次",dict[@"data"][@"read_num"]];
             //收藏
             NSString * collect_num = [NSString stringWithFormat:@"%@次",dict[@"data"][@"collect_num"]];
             //招生人数
             NSString * need_num =[NSString stringWithFormat:@"%@",dict[@"data"][@"need_num"]];
             //适用人群
             NSString * age =[NSString stringWithFormat:@"%@岁到%@岁",dict[@"data"][@"age_up"],dict[@"data"][@"age_down"]];
             //教学目标
             NSString * teach_goal = [NSString stringWithFormat:@"%@",dict[@"data"][@"teach_goal"]];
             //上课时间
             NSString * course_time_str = [NSString stringWithFormat:@"%@",dict[@"data"][@"course_time_str"]];
             //上课地址
             NSString *  address = [NSString stringWithFormat:@"%@",dict[@"data"][@"address"]];
             //插班规则
             NSString * middle_in_rule =[NSString stringWithFormat:@"%@",dict[@"data"][@"middle_in_rule"]];
             //退班规则
             NSString * quit_rule = [NSString stringWithFormat:@"%@",dict[@"data"][@"quit_rule"]];
             //原价
             NSString * original_price = [NSString stringWithFormat:@"%@元",dict[@"data"][@"original_price"]];
             //现价
             NSString * now_price = [NSString stringWithFormat:@"%@元",dict[@"data"][@"now_price"]];
             //课程详情
             details = [NSString stringWithFormat:@"%@",dict[@"data"][@"details"]];
             //课程详情图片
             picGroup = dict[@"data"][@"course_pic_group"];
             detailedLabelArr = [[NSMutableArray alloc] initWithObjects:tname,school_name,read_num,collect_num,need_num,age,teach_goal,course_time_str,address,middle_in_rule,quit_rule,original_price,now_price,nil];
             
         }
         
         [self scrollViewUI];
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"请求失败:%@",error);
         [SVProgressHUD showErrorWithStatus:@"网络不通，请检查网络！"];
         
     }];
}

-(void)scrollViewUI{
    NSMutableArray *nameLabelArr = [[NSMutableArray alloc] initWithObjects:@"授课老师:",@"机构名称:",@"浏览次数:",@"收藏次数:",@"招生人数:",@"适用人群:",@"教学目标:",@"上课时间:",@"上课地址:",@"插班规则:",@"退班规则:",@"原       价:",@"现       价:",nil];
    
    //背景
    bgScrollView = [[UIScrollView alloc] init];
    bgScrollView.frame = CGRectMake(0, 0, kWidth,kHeight + 64 + 49);
    bgScrollView.backgroundColor = [UIColor whiteColor];
    bgScrollView.pagingEnabled = NO;
    bgScrollView.showsHorizontalScrollIndicator = YES;
    bgScrollView.showsVerticalScrollIndicator  = YES;
    bgScrollView.alwaysBounceVertical = YES;
    [self.view addSubview:bgScrollView];
    
    for (int i = 0; i < nameLabelArr.count; i ++) {
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(KLabelX, KLabelH * i + Kmarg , KLabelW, KLabelH)];
        nameLabel.font = [UIFont systemFontOfSize:14];
        nameLabel.textAlignment = NSTextAlignmentRight;
        nameLabel.text = nameLabelArr[i];
        [bgScrollView addSubview:nameLabel];
        if (i == 7) {
            UITextView *detailedText = [[UITextView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(nameLabel.frame) + Kmarg, KLabelH * 7 + Kmarg , kWidth - CGRectGetMaxX(nameLabel.frame) - KLabelH , 25)];
            detailedText.text = detailedLabelArr[7];
            detailedText.font = [UIFont systemFontOfSize:12];
            detailedText.userInteractionEnabled = YES;
            detailedText.scrollEnabled = YES;
            detailedText.editable = NO;
            detailedText.textColor = [UIColor grayColor];
            [bgScrollView addSubview:detailedText];
        }else{
            UITextField *detailedText = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(nameLabel.frame) + Kmarg, KLabelH * i + Kmarg, kWidth - CGRectGetMaxX(nameLabel.frame) - KLabelH , KLabelH)];
            detailedText.text = detailedLabelArr[i];
            detailedText.borderStyle = UITextBorderStyleNone;
            detailedText.font = [UIFont systemFontOfSize:12];
            detailedText.userInteractionEnabled = NO;
            detailedText.textColor = [UIColor grayColor];
            [bgScrollView addSubview:detailedText];
            
            //判断是否允许插班 退班
            if (i == 9) {
                if ([detailedLabelArr[9] isEqualToString:@"1"]) {
                    detailedText.text = @"是";
                }else{
                    detailedText.text = @"否";
                }
            }
            if (i == 10) {
                if ([detailedLabelArr[10] isEqualToString:@"1"]) {
                    detailedText.text = @"是";
                }else{
                    detailedText.text = @"否";
                }
            }
        }
        UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(KLabelX, KLabelH * (i+1) + 12, kWidth - KLabelX * 2, 1)];
        line.backgroundColor = UIColorFromRGB(204, 204, 204);
        [bgScrollView addSubview:line];
    }
    
    UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, KLabelH * 13 + 12, kWidth , 5)];
    lineView.backgroundColor = UIColorFromRGB(204, 204, 204);
    [bgScrollView addSubview:lineView];
    
    //课程说明
    
    UILabel *subjectSay = [HHControl createLabelWithFrame:CGRectMake(KLabelX, CGRectGetMaxY(lineView.frame) + KLabelX, KLabelW, KLabelH) Font:14 Text:@"课程说明:"];
    [bgScrollView addSubview:subjectSay];
    
    UILabel *xingMoneyLabel = [HHControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(subjectSay.frame) + Kmarg, CGRectGetMaxY(lineView.frame) + KLabelX, 150, KLabelH) Font:12 Text:@"(此课程可抵扣猩币上限1%)"];
    xingMoneyLabel.textColor = [UIColor grayColor];
    //    xingMoneyLabel.backgroundColor = [UIColor redColor];
    [bgScrollView addSubview:xingMoneyLabel];
    
    
    UITextView *subjectSayView = [[UITextView alloc] initWithFrame:CGRectMake(KLabelX, CGRectGetMaxY(subjectSay.frame) + Kmarg, kWidth - KLabelX *2, 120)];
    subjectSayView.text = details;
    subjectSayView.font = [UIFont systemFontOfSize:12];
    subjectSayView.userInteractionEnabled = NO;
    [subjectSayView flashScrollIndicators];   // 闪动滚动条
    //自动适应行高
    static CGFloat maxHeight = 130.0f;
    CGRect frame = subjectSayView.frame;
    CGSize constraintSize = CGSizeMake(frame.size.width, MAXFLOAT);
    CGSize size = [subjectSayView sizeThatFits:constraintSize];
    if (size.height >= maxHeight){
        size.height = maxHeight;
        subjectSayView.scrollEnabled = YES;   // 允许滚动
    }
    else{
        subjectSayView.scrollEnabled = NO;    // 不允许滚动，当textview的大小足以容纳它的text的时候，需要设置scrollEnabed为NO，否则会出现光标乱滚动的情况
    }
    subjectSayView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, size.height);
    [bgScrollView addSubview:subjectSayView];
    
    
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(KLabelX, CGRectGetMaxY(subjectSayView.frame) + Kmarg,kWidth - KLabelX *2 , 120)];
    scrollView.backgroundColor = [UIColor whiteColor];
    CGFloat imgW = kWidth/3;
    CGFloat imgH = scrollView.frame.size.height;
    CGFloat imgY = 0;
    _picImageArr = [NSMutableArray array];
    for (int i = 0; i < picGroup.count; i++) {
        UIImageView *imgView = [[UIImageView alloc] init];
        NSString *imgName = [picURL stringByAppendingString:picGroup[i]];
        [_picImageArr addObject:imgName];
        
        [imgView sd_setImageWithURL:[NSURL URLWithString:imgName] placeholderImage:nil];
        CGFloat imgX = i * imgW;
        imgView.tag = i;
        imgView.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonpress:)];
        [imgView addGestureRecognizer:singleTap1];
        imgView.frame = CGRectMake(imgX, imgY, imgW, imgH);
        [scrollView addSubview:imgView];
    }
    
    CGFloat maxW = imgW * picGroup.count + 20;
    scrollView.contentSize = CGSizeMake(maxW, 0);
    scrollView.pagingEnabled = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    [bgScrollView addSubview:scrollView];
    
    CGFloat maxH =  CGRectGetMaxY(scrollView.frame) + 400;
    bgScrollView.contentSize = CGSizeMake(0, maxH);

    
}
-(void)buttonpress:(UIButton *)sender {
    UITapGestureRecognizer *tap = (UITapGestureRecognizer *)sender;
    int tag = tap.view.tag;
    UIImageView *imgView = [[UIImageView alloc] init];
    [imgView sd_setImageWithURL:[NSURL URLWithString:_picImageArr[tag]] placeholderImage:nil];
    [SJAvatarBrowser showImage:imgView];//调用方法
}


//收藏课程
- (void)collectArticle
{
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/collect";
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *dict = @{@"appkey":APPKEY,
                           @"backtype":BACKTYPE,
                           @"xid":XID,
                           @"user_id":USER_ID,
                           @"user_type":USER_TYPE,
                           @"collect_id":self.courseId,
                           @"collect_type":@"4",
                           
                           };
    //        NSLog(@"======================>%@",dict);
    
    // 服务器返回的数据格式
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer]; // 二进制数据
    [mgr POST:urlStr parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         //                   NSLog(@"======================>%@",responseObject);
         
         if([[NSString stringWithFormat:@"%@",dict[@"code"]]isEqualToString:@"1"] )
         {
             
             [SVProgressHUD showSuccessWithStatus:@"收藏课程成功"];
             UIButton*rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,22,22)];
             [rightButton setBackgroundImage:[UIImage imageNamed:@"commentInfo10.png"] forState:UIControlStateNormal];
             UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
             self.navigationItem.rightBarButtonItem= rightItem;
             [rightButton addTarget:self action:@selector(collectbtn:)forControlEvents:UIControlEventTouchUpInside];
             isCollect=!isCollect;
             
         }
         
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"请求失败:%@",error);
         [SVProgressHUD showErrorWithStatus:@"网络不通，请检查网络！"];
         
     }];
}

//取消收藏课程
- (void)deleteCollectArticle
{
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/deleteCollect";
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *dict = @{@"appkey":APPKEY,
                           @"backtype":BACKTYPE,
                           @"xid":XID,
                           @"user_id":USER_ID,
                           @"user_type":USER_TYPE,
                           @"collect_id":self.courseId,
                           @"collect_type":@"4",
                           
                           };
    
    // 服务器返回的数据格式
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer]; // 二进制数据
    [mgr POST:urlStr parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         
         if([[NSString stringWithFormat:@"%@",dict[@"code"]]isEqualToString:@"1"] ){
             [SVProgressHUD showSuccessWithStatus:@"取消收藏成功"];
             UIButton*rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,22,22)];
             [rightButton setBackgroundImage:[UIImage imageNamed:@"commentInfo9.png"] forState:UIControlStateNormal];
             UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
             self.navigationItem.rightBarButtonItem= rightItem;
             [rightButton addTarget:self action:@selector(collectbtn:)forControlEvents:UIControlEventTouchUpInside];
             isCollect=!isCollect;
         }
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         //         NSLog(@"请求失败:%@",error);
         [SVProgressHUD showErrorWithStatus:@"网络不通，请检查网络！"];
         
     }];
}

//收藏点击事件
-(void)collectbtn:(UIButton *)btn{
    
    if (isCollect== NO) {
        [self collectArticle];
    }
    else  if (isCollect== YES) {
        [self deleteCollectArticle];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
