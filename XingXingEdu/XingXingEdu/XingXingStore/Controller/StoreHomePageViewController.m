//
//  StoreHomePageViewController.m
//  XingXingStore
//
//  Created by codeDing on 16/1/20.
//  Copyright © 2016年 codeDing. All rights reserved.
//

#import "StoreHomePageViewController.h"
#import "StoreSettngViewController.h"
#import "XXEStoreGoodDetailInfoViewController.h"
#import "MoneyPresentedViewController.h"
#import "MoneyHistoryTableViewController.h"
#import "CheckInViewController.h"
#import "ZQCountDownView.h"
#import "XXEStorePerfectConsigneeAddressViewController.h"
#import "ArticleInfoTableViewCell.h"
#import "FlowersBuyViewController.h"
#import "XXEStoreListModel.h"


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
    NSMutableArray *_dataSourceArray;
    
    UIView *grayView1;
    //占位图
    UIImageView *placeholderImageView;
    
    NSString *parameterXid;
    NSString *parameterUser_Id;
}

@property (nonatomic, strong) NSTimer *timer;// 创建一个用来引用计时器对象的属性
@end

@implementation StoreHomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor= UIColorFromRGB(229, 232, 233);
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.title=@"商城";
    //轮播图 数量
    imgCount=3;
    
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }
    _dataSourceArray = [[NSMutableArray alloc] init];
    //获取 商城 数据
    [self fetchStoreNetData];
    
    //创建 最下层 bgScrollView
    [self createBgScrollView];
    
    //创建 上部 滚动视图
    [self createBrowseView];
    
    //创建 中部 倒计时
    [self createCountDownView];

    //创建 下部 tableView
    [self createTableView];
    
    
}

#pragma mark ########### 创建 最下层 bgScrollView ###
- (void)createBgScrollView{
    //背景滑动视图
    bgScrollView = [[UIScrollView alloc] init];
    bgScrollView.frame = CGRectMake(0, 0, kWidth, WinHeight);
    bgScrollView.backgroundColor = [UIColor whiteColor];
    bgScrollView.pagingEnabled = NO;
    bgScrollView.bounces=NO;
    bgScrollView.showsHorizontalScrollIndicator = NO;
    bgScrollView.showsVerticalScrollIndicator  = NO;
    [self.view addSubview:bgScrollView];
}

#pragma mark ************ 创建 上部 滚动视图 **********
- (void)createBrowseView{
    //初始化 计时器
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(scrollImage) userInfo:nil repeats:YES];
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    [runLoop addTimer:self.timer forMode:NSRunLoopCommonModes];
    
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
    
   grayView1 =[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imgScrollView.frame), kWidth, 7)];
    grayView1.backgroundColor=UIColorFromRGB(229, 232, 233);
    [bgScrollView addSubview:grayView1];
}

#pragma mark &&&&&&&&&&&&&& 创建 中部 倒计时 &&&&&&&&&&
- (void)createCountDownView{
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
    
//    CGFloat maxH = CGRectGetMaxY(weekrecommend.frame) + Kmarg * 5 + (articleArray.count +1) * 100;
//    bgScrollView.contentSize = CGSizeMake(0, maxH);
    
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

#pragma mark $$$$$$$$$$$$ 创建 下部 tableView $$$$$$$$
- (void)createTableView{
    myTabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, 230 * kScreenRatioHeight, KScreenWidth, 320 * kScreenRatioHeight)];
    
    myTabelView.dataSource = self;
    myTabelView.delegate = self;
    
    [bgScrollView addSubview:myTabelView];
    
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _dataSourceArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"cell";
    ArticleInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ArticleInfoTableViewCell" owner:self options:nil]lastObject];
    }
    XXEStoreListModel *model = _dataSourceArray[indexPath.row];
    NSString *head_img = [kXXEPicURL stringByAppendingString:model.goods_pic];
    cell.img.layer.cornerRadius=5;
    cell.img.layer.masksToBounds=YES;
    [cell.img sd_setImageWithURL:[NSURL URLWithString:head_img] placeholderImage:[UIImage imageNamed:@"sdimg1"]];
    
    cell.nameLabel.text=model.title;
    
    cell.priceLabel.text= [NSString stringWithFormat:@"￥ %@",model.exchange_price];
    
    cell.oldPriceLabel.text= [NSString stringWithFormat:@"原价:￥ %@",model.price];
    
    cell.moneyLabel.text=[NSString stringWithFormat:@"猩币:%@",model.exchange_coin];
    cell.saleLabel.text= [NSString stringWithFormat:@"销量:%@",model.sale_num];
    
    [cell.buyBtn addTarget:self action:@selector(buyButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.buyBtn.tag=indexPath.row+1000;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

#pragma mark ******** 购买 ******************
-(void)buyButtonClick:(UIButton *)button{
    
    XXEStoreListModel *model = _dataSourceArray[button.tag - 1000];
    
    XXEStorePerfectConsigneeAddressViewController *perfectConsigneeAddressVC = [[XXEStorePerfectConsigneeAddressViewController alloc] init];
    
    perfectConsigneeAddressVC.xingIconNum = model.exchange_coin;
    perfectConsigneeAddressVC.price = model.exchange_price;
    perfectConsigneeAddressVC.good_id = model.good_id;
    
    [self.navigationController pushViewController:perfectConsigneeAddressVC animated:YES];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    ArticleInfoViewController*vc=  [[ArticleInfoViewController alloc]init];
//
//    XXEStoreListModel *model = _dataSourceArray[indexPath.row];
//    vc.orderNum=model.good_id;
//    [self.navigationController pushViewController:vc animated:YES];
    XXEStoreGoodDetailInfoViewController*storeGoodDetailInfoVC=  [[XXEStoreGoodDetailInfoViewController alloc]init];
    XXEStoreListModel *model = _dataSourceArray[indexPath.row];
    storeGoodDetailInfoVC.orderNum=model.good_id;
    [self.navigationController pushViewController:storeGoodDetailInfoVC animated:YES];
    
}

#pragma mark ============ 获取 商城 数据 ============
- (void)fetchStoreNetData{
   NSString *urlStr = @"http://www.xingxingedu.cn/Global/coin_goods";
   NSDictionary *params = @{@"appkey":APPKEY,
                          @"backtype":BACKTYPE,
                          @"xid":parameterXid,
                          @"user_id":parameterUser_Id,
                          @"user_type":USER_TYPE,
                          };
    [WZYHttpTool post:urlStr params:params success:^(id responseObj) {
        //
//        NSLog(@"kkk %@", responseObj);
        
        if ([responseObj[@"code"] integerValue] == 1) {
            
            NSArray *modelArray = [[NSArray alloc] init];
           modelArray = [XXEStoreListModel parseResondsData:responseObj[@"data"]];
            
            [_dataSourceArray addObjectsFromArray:modelArray];
  
        }
        [self customContent];
    } failure:^(NSError *error) {
        //
        [SVProgressHUD showInfoWithStatus:@"获取数据失败!"];
    }];

}

// 有数据 和 无数据 进行判断
- (void)customContent{
    // 如果 有占位图 先 移除
    [self removePlaceholderImageView];
    
    if (_dataSourceArray.count == 0) {
        myTabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
        // 1、无数据的时候
        [self createPlaceholderView];
        
    }else{
        //2、有数据的时候
    }
    
    [myTabelView reloadData];
    
}


//没有 数据 时,创建 占位图
- (void)createPlaceholderView{
    // 1、无数据的时候
    UIImage *myImage = [UIImage imageNamed:@"人物"];
    CGFloat myImageWidth = myImage.size.width;
    CGFloat myImageHeight = myImage.size.height;
    
    placeholderImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kWidth / 2 - myImageWidth / 2, (kHeight - 64 - 49) / 2 - myImageHeight / 2, myImageWidth, myImageHeight)];
    placeholderImageView.image = myImage;
    [self.view addSubview:placeholderImageView];
}

//去除 占位图
- (void)removePlaceholderImageView{
    if (placeholderImageView != nil) {
        [placeholderImageView removeFromSuperview];
    }
}


@end
