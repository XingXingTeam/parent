//
//  StoreHomePageViewController.m
//  XingXingStore
//
//  Created by codeDing on 16/1/20.
//  Copyright © 2016年 codeDing. All rights reserved.
//

#import "StoreHomePageViewController.h"
#import "StoreSettngViewController.h"
#import "ArticleInfoViewController.h"
#import "MoneyPresentedViewController.h"
#import "MoneyHistoryTableViewController.h"
#import "CheckInViewController.h"
#import "ZQCountDownView.h"
#import "StoreArticleBuyViewController.h"
#import "ArticleInfoTableViewCell.h"
#import "FlowersBuyViewController.h"

#define Kmarg 6.0f
#define KLabelX 27.0f
#define KLabelW 62.0f
#define KLabelH 30.0f
#define KButtonW 40.0f
#define KButtonH 20.0f

@interface StoreHomePageViewController () <UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>{
    
    UIScrollView *bgScrollView;//背景
    UIScrollView *imgScrollView;
    UIPageControl *imgPageControl;
    NSInteger  imgCount;
    UIButton *panicBuyBtn;//限时抢购
    UILabel *countdownLabel;//倒计时
    ZQCountDownView *countDownView;//倒计时
    UITableView* myTabelView;
    NSMutableArray *articleArray;
    
    
}

@property (nonatomic, strong) NSTimer *timer;// 创建一个用来引用计时器对象的属性
@end

@implementation StoreHomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self netManage];
    
    articleArray=[NSMutableArray array];
    
    self.view.backgroundColor=[UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.tabBarController.navigationItem.title=@"首页";
    
    imgCount=3;
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(scrollImage) userInfo:nil repeats:YES];
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    [runLoop addTimer:self.timer forMode:NSRunLoopCommonModes];
    
    
    self.tabBarController.navigationItem.title=@"猩猩商城";
    
}

-(void)creatFieldset{
    //背景滑动视图
    bgScrollView = [[UIScrollView alloc] init];
    bgScrollView.frame = CGRectMake(0, 0, kWidth, WinHeight);
    bgScrollView.backgroundColor = [UIColor whiteColor];
    bgScrollView.pagingEnabled = NO;
    bgScrollView.bounces=NO;
    bgScrollView.showsHorizontalScrollIndicator = NO;
    bgScrollView.showsVerticalScrollIndicator  = NO;
    [self.view addSubview:bgScrollView];
    
    
    //图片轮播器
    imgScrollView = [[UIScrollView alloc] init];
    imgScrollView.frame = CGRectMake(0, 0, kWidth, 150);
    imgScrollView.backgroundColor = [UIColor whiteColor];
    imgScrollView.delegate = self;
    [bgScrollView addSubview:imgScrollView];
    
    // 动态创建UIImageView添加到UIimgScrollView中
    CGFloat imgW = kWidth;
    CGFloat imgH = 150;
    CGFloat imgY = 0;
    for (int i = 0; i < imgCount; i++) {
        UIImageView *imgView = [[UIImageView alloc] init];
        NSString *imgName = [NSString stringWithFormat:@"banner0%d.png", i + 1];
        imgView.image = [UIImage imageNamed:imgName];
        CGFloat imgX = i * imgW;
        imgView.frame = CGRectMake(imgX, imgY, imgW, imgH);
        [imgScrollView addSubview:imgView];
    }
    
    CGFloat maxW = imgScrollView.frame.size.width * imgCount;
    imgScrollView.contentSize = CGSizeMake(maxW, 0);
    
    imgScrollView.pagingEnabled = YES;
    imgScrollView.showsHorizontalScrollIndicator = NO;
    imgPageControl=[[UIPageControl alloc]initWithFrame:CGRectMake((kWidth-80)/2, CGRectGetMaxY(imgScrollView.frame) - 60, 80, 80)];
    imgPageControl.numberOfPages = imgCount;
    imgPageControl.currentPageIndicatorTintColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    imgPageControl.pageIndicatorTintColor=[UIColor whiteColor];
    imgPageControl.currentPage=0;
    [bgScrollView addSubview:imgPageControl];
    
    UIView *grayView1=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imgScrollView.frame), kWidth, 7)];
    grayView1.backgroundColor=UIColorFromRGB(229, 232, 233);
    [bgScrollView addSubview:grayView1];
    
    //时钟
    UIImageView *clockIcon = [HHControl createImageViewWithFrame:CGRectMake(Kmarg, CGRectGetMaxY(grayView1.frame) + Kmarg, 24, 24) ImageName:@"抢购倒计时icon"];
    [bgScrollView addSubview:clockIcon];
    
    UILabel *countDown = [HHControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(clockIcon.frame) + Kmarg, CGRectGetMaxY(grayView1.frame) + Kmarg + 2, 50, KButtonH) Font:10 Text:@"抢购倒计时 "];
    [bgScrollView addSubview:countDown];
    
    //倒计时
    countDownView = [[ZQCountDownView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(countDown.frame), CGRectGetMaxY(grayView1.frame) + Kmarg + 2, 80, KButtonH)];
    [bgScrollView addSubview:countDownView];
    //计算出下次能签到的日期
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *now=[NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: now];
    NSDate *nowDate = [now dateByAddingTimeInterval: interval];
    
    NSDate *tomorrow = [NSDate dateWithTimeInterval:60 * 60*24  sinceDate:nowDate];
    NSString *tomorrowStr=[formatter stringFromDate:tomorrow];
    NSString *tomorrowten=[tomorrowStr stringByAppendingString:@" 10:00:00"];
    
    NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
    [formatter2 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *tomorrowtendate=[formatter2 dateFromString:tomorrowten];
    NSDate *todaytendate= [NSDate dateWithTimeInterval:-24*60*60 sinceDate:tomorrowtendate];
    NSDate *todayten= [NSDate dateWithTimeInterval:8*60*60 sinceDate:todaytendate];
    NSDate *nowten= [NSDate dateWithTimeInterval:8*60*60 sinceDate:now];
    NSDate *tomorrowten2= [NSDate dateWithTimeInterval:8*60*60 sinceDate:tomorrowtendate];
    
    
    NSTimeInterval spaceTime;
    if([nowten timeIntervalSinceDate:todayten]<0){
        spaceTime =[todayten timeIntervalSinceDate:nowten];
        
    }else{
        spaceTime=[tomorrowten2 timeIntervalSinceDate:nowten];
    }
    
    countDownView.themeColor = [UIColor whiteColor];
    countDownView.textColor = [UIColor darkGrayColor];
    countDownView.textFont = [UIFont boldSystemFontOfSize:10];
    countDownView.colonColor = [UIColor whiteColor];
    countDownView.countDownTimeInterval = spaceTime;
    
    //立刻签到
    UIButton *checkinBtn = [HHControl createButtonWithFrame:CGRectMake(CGRectGetMaxX(countDownView.frame)+ Kmarg, CGRectGetMaxY(grayView1.frame) + Kmarg,(kWidth - CGRectGetMaxX(countDownView.frame))/3 - 10, KButtonH) backGruondImageName:@"签到送猩币" Target:nil Action:@selector(checkInBtn) Title:@""];
    [bgScrollView addSubview:checkinBtn];
    //猩币转增
    UIButton *xingbizzBtn = [HHControl createButtonWithFrame:CGRectMake(CGRectGetMaxX(checkinBtn.frame) + Kmarg, CGRectGetMaxY(grayView1.frame) + Kmarg , (kWidth - CGRectGetMaxX(countDownView.frame))/3 - 10, KButtonH)backGruondImageName:@"猩币转赠" Target:nil Action:@selector(moneyPresentBtn) Title:@""];
    [bgScrollView addSubview:xingbizzBtn];
    
    //花篮专区
    UIButton *flowerbtn = [HHControl createButtonWithFrame:CGRectMake(CGRectGetMaxX(xingbizzBtn.frame) + Kmarg, CGRectGetMaxY(grayView1.frame) + Kmarg, (kWidth - CGRectGetMaxX(countDownView.frame))/3 - 10, KButtonH) backGruondImageName:@"花篮专区" Target:nil Action:@selector(FlowersPrefecture) Title:@""];
    [bgScrollView addSubview:flowerbtn];
    
    UIView *grayView2=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(xingbizzBtn.frame) + Kmarg, kWidth, 7)];
    grayView2.backgroundColor=UIColorFromRGB(229, 232, 233);
    [bgScrollView addSubview:grayView2];
    
    //本周推荐
    UIImageView *weekrecommend = [HHControl createImageViewFrame:CGRectMake(KLabelX, CGRectGetMaxY(grayView2.frame) + Kmarg *3, kWidth - KLabelX * 2, 14) imageName:@"本周推荐" color:nil];
    [bgScrollView addSubview:weekrecommend];
    
    //tableView
    myTabelView=[[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(weekrecommend.frame) + Kmarg * 3, kWidth, articleArray.count*100)];
    UINib *nib = [UINib nibWithNibName:@"ArticleInfoTableViewCell" bundle:nil];
    [myTabelView registerNib:nib forCellReuseIdentifier:@"cell"];
    myTabelView.delegate=self;
    myTabelView.dataSource=self;
    myTabelView.backgroundColor = [UIColor yellowColor];
    [bgScrollView addSubview:myTabelView];
    
    CGFloat maxH = CGRectGetMaxY(weekrecommend.frame) + Kmarg * 5 + (articleArray.count +1) * 100;
    bgScrollView.contentSize = CGSizeMake(0, maxH);
    
}


-(void)checkInBtn{
    
    [self.navigationController pushViewController:[CheckInViewController alloc] animated:YES];
}

-(void)settingBtn{
    [self.navigationController pushViewController:[StoreSettngViewController alloc] animated:YES];
}

-(void)moneyPresentBtn{
    [self.navigationController pushViewController:[MoneyPresentedViewController alloc] animated:YES];
}

-(void)FlowersPrefecture{
    FlowersBuyViewController *flowerBuyVC =[[FlowersBuyViewController alloc]init];
    [self.navigationController pushViewController:flowerBuyVC animated:YES];
}

-(void)moneyRecord{
    [self.navigationController pushViewController:[MoneyHistoryTableViewController alloc] animated:YES];
}

#pragma mark --scrollView代理
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetX = scrollView.contentOffset.x;
    offsetX = offsetX + (scrollView.frame.size.width * 0.5);
    int page = offsetX / scrollView.frame.size.width;
    imgPageControl.currentPage = page;
    
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.timer invalidate];
    self.timer = nil;
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(scrollImage) userInfo:nil repeats:YES];
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    [runLoop addTimer:self.timer forMode:NSRunLoopCommonModes];
}


- (void)scrollImage
{
    NSInteger page = imgPageControl.currentPage;
    if (page == imgPageControl.numberOfPages - 1) {
        page = 0;
    } else {
        page++;
    }
    CGFloat offsetX = page * imgScrollView.frame.size.width;
    [imgScrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)buyPressed{
    [self.navigationController pushViewController:[StoreArticleBuyViewController alloc] animated:YES];
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return articleArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ArticleInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(cell==nil){
        cell=[[ArticleInfoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        cell.layoutMargins = UIEdgeInsetsZero;
    }
    
    NSArray * tmp=articleArray[indexPath.row];
    cell.img.layer.cornerRadius=5;
    cell.img.layer.masksToBounds=YES;
    [cell.img sd_setImageWithURL:[NSURL URLWithString:tmp[0]] placeholderImage:[UIImage imageNamed:@"sdimg1.png"]];
    
    cell.nameLabel.text=tmp[1];
    
    cell.priceLabel.text= [NSString stringWithFormat:@"￥ %@",tmp[2]];
    
    cell.oldPriceLabel.text= [NSString stringWithFormat:@"原价:￥ %@",tmp[3]];
    
    cell.moneyLabel.text=[NSString stringWithFormat:@"猩币:%@",tmp[4]];
    cell.saleLabel.text= [NSString stringWithFormat:@"销量:%@",tmp[5]];
    
    [cell.buyBtn addTarget:self action:@selector(collectPressed:) forControlEvents:UIControlEventTouchUpInside];
    cell.buyBtn.tag=indexPath.row+1000;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}


-(void)collectPressed:(UIButton *)btn{
    StoreArticleBuyViewController *vc= [[StoreArticleBuyViewController alloc]init];
    int i=(int)btn.tag-1000;
    vc.orderNum=articleArray[i][6];
    vc.xingMoney=articleArray[i][4];
    vc.rmbMoney=articleArray[i][2];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ArticleInfoViewController*vc=  [[ArticleInfoViewController alloc]init];
    vc.orderNum=articleArray[indexPath.row][6];
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark 网络
- (void)netManage
{
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/coin_goods";
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *dict = @{@"appkey":APPKEY,
                           @"backtype":BACKTYPE,
                           @"xid":XID,
                           @"user_id":USER_ID,
                           @"user_type":USER_TYPE,
                           };
    
    // 服务器返回的数据格式
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer]; // 二进制数据
    [mgr POST:urlStr parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         
         if([[NSString stringWithFormat:@"%@",dict[@"code"]]isEqualToString:@"1"] )
         {
             for (NSDictionary *dic in dict[@"data"]) {
                 NSString * goods_pic = [picURL stringByAppendingString:dic[@"goods_pic"]];
                 NSString * title = dic[@"title"];
                 NSString * price = dic[@"price"];
                 NSString * exchange_price = dic[@"exchange_price"];
                 NSString * exchange_coin = dic[@"exchange_coin"];
                 NSString * sale_num = dic[@"sale_num"];
                 NSString *  orderNum = dic[@"id"];
                 NSMutableArray *arr=[NSMutableArray arrayWithObjects:goods_pic, title,exchange_price,price,exchange_coin,sale_num,orderNum,nil];
                 
                 [articleArray addObject:arr];
             }
             [myTabelView reloadData];
             [self creatFieldset];
             
         }else{
             [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"获取商品失败，%@",dict[@"msg"]]];
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"请求失败:%@",error);
         [SVProgressHUD showErrorWithStatus:@"网络不通，请检查网络！"];
         
     }];
}



@end
