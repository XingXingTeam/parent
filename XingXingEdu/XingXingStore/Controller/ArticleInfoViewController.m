//
//  ArticleInfoViewController.m
//  XingXingStore
//
//  Created by codeDing on 16/1/21.
//  Copyright © 2016年 codeDing. All rights reserved.
//

#import "ArticleInfoViewController.h"
#import "CoreUMeng.h"
#import "StoreArticleBuyViewController.h"

#define kMarg 25.0f
#define kLabelH 25.0f
#define kLabelW 65.0f

@interface ArticleInfoViewController ()<UIScrollViewDelegate>{
    UIScrollView *imgScrollView;
    NSInteger  imgCount;
    
    UIPageControl *imgPageControl;
    NSMutableArray *articleArray;
    NSArray *imgcountarr;
    
    BOOL isCollect;
}


@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *priceImage;

@property (weak, nonatomic) IBOutlet UILabel *xingbiLabel;
@property (weak, nonatomic) IBOutlet UILabel *xingMoneyLabel;
@property (weak, nonatomic) IBOutlet UITextView *infoTextView;
@property (weak, nonatomic) IBOutlet UIView *LineImageView;

- (IBAction)shareBtn:(id)sender;
- (IBAction)buyBtn:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *oldPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *oldLabel;


@property (weak, nonatomic) IBOutlet UILabel *allsaleLabel;
@property (weak, nonatomic) IBOutlet UILabel *didsaleLabel;
@property (weak, nonatomic) IBOutlet UILabel *LineView;

@property (nonatomic, strong) NSTimer *timer;// 创建一个用来引用计时器对象的属性
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIButton *buybutton;


@end

@implementation ArticleInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self netManage];
    
}

//收藏
-(void)collectbtn:(UIButton *)btn{
    
    if (isCollect==NO) {
        
        [self collectArticle];
        
    }
    else  if (isCollect==YES) {
        [self deleteCollectArticle];
        
    }
    
}


-(void)creatFieldset{
    
    //    self.titleLabel.text=articleArray[0];
    if ([articleArray[4] count] > 0) {
        imgcountarr = articleArray[4];
        imgCount = imgcountarr.count;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(scrollImage) userInfo:nil repeats:YES];
        NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
        [runLoop addTimer:self.timer forMode:NSRunLoopCommonModes];
        
        //图片轮播器
        imgScrollView = [[UIScrollView alloc] init];
        imgScrollView.frame = CGRectMake(0, 0, WinWidth, kHeight * 0.5);
        imgScrollView.backgroundColor = [UIColor whiteColor];
        imgScrollView.delegate = self;
        [self.view addSubview:imgScrollView];
        
        // 动态创建UIImageView添加到UIimgScrollView中
        CGFloat imgW = WinWidth;
        CGFloat imgH = kHeight * 0.5;
        CGFloat imgY = 0;
        for (int i = 0; i < imgCount; i++) {
            UIImageView *imgView = [[UIImageView alloc] init];
            [imgView sd_setImageWithURL:[NSURL URLWithString:imgcountarr[i]] placeholderImage:[UIImage imageNamed:@"sdimg1.png"]];
            CGFloat imgX = i * imgW;
            imgView.frame = CGRectMake(imgX, imgY, imgW, imgH);
            [imgScrollView addSubview:imgView];
        }
        
        CGFloat maxW = imgScrollView.frame.size.width * imgCount;
        imgScrollView.contentSize = CGSizeMake(maxW, 0);
        imgScrollView.pagingEnabled = YES;
        
        imgScrollView.showsHorizontalScrollIndicator = NO;
        imgPageControl=[[UIPageControl alloc]initWithFrame:CGRectMake((kWidth-80)/2, CGRectGetMaxY(imgScrollView.frame) - 80, 80, 80)];
        imgPageControl.numberOfPages = imgCount;
        imgPageControl.currentPageIndicatorTintColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        imgPageControl.pageIndicatorTintColor=[UIColor whiteColor];
        imgPageControl.currentPage=0;
        [self.view addSubview:imgPageControl];
    }
    
    
    
    _priceLabel.text=articleArray[1];
    _oldPriceLabel.text = [NSString stringWithFormat:@"￥%@",articleArray[2]];
    _xingMoneyLabel.text=articleArray[3];
    _infoTextView.text=articleArray[5];;
    _didsaleLabel.text = [NSString stringWithFormat:@"已售%@件",articleArray[6]];
    _allsaleLabel.text=[NSString stringWithFormat:@"还剩%@件",articleArray[7]];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)shareBtn:(id)sender {
    [CoreUmengShare show:self text:@"http://www.baidu.com" image:[UIImage imageNamed:@"store2.jpg"]];
    
}

- (IBAction)buyBtn:(id)sender {
    StoreArticleBuyViewController *vc= [[StoreArticleBuyViewController alloc]init];
    vc.orderNum=self.orderNum;
    vc.xingMoney=articleArray[3];
    vc.rmbMoney=articleArray[1];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark 网络
- (void)netManage
{
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/coin_goods_detailed";
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *dict = @{@"appkey":APPKEY,
                           @"backtype":BACKTYPE,
                           @"xid":XID,
                           @"user_id":USER_ID,
                           @"user_type":USER_TYPE,
                           @"goods_id":self.orderNum,
                           
                           };
    //    NSLog(@"%@",dict);
    
    // 服务器返回的数据格式
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer]; // 二进制数据
    [mgr POST:urlStr parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         
         if([[NSString stringWithFormat:@"%@",dict[@"code"]]isEqualToString:@"1"] )
         {
             //1代表收藏过, 2代表未收藏
             if([[NSString stringWithFormat:@"%@",dict[@"data"][@"collect_condit"]] isEqualToString:@"1"]){
                 UIButton*rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,22,22)];
                 [rightButton setImage:[UIImage imageNamed:@"commentInfo10.png"]forState:UIControlStateNormal];
                 [rightButton addTarget:self action:@selector(collectbtn:)forControlEvents:UIControlEventTouchUpInside];
                 UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
                 self.navigationItem.rightBarButtonItem= rightItem;
                 isCollect=YES;
                 
                 
             }else if([[NSString stringWithFormat:@"%@",dict[@"data"][@"collect_condit"]] isEqualToString:@"2"]){
                 UIButton*rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,22,22)];
                 [rightButton setImage:[UIImage imageNamed:@"commentInfo9.png"]forState:UIControlStateNormal];
                 [rightButton addTarget:self action:@selector(collectbtn:)forControlEvents:UIControlEventTouchUpInside];
                 UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
                 self.navigationItem.rightBarButtonItem= rightItem;
                 isCollect=NO;
                 
             }
             
             NSString * title=dict[@"data"][@"title"];
             NSString * price=dict[@"data"][@"price"];
             NSString * exchange_price=dict[@"data"][@"exchange_price"];
             NSString * exchange_coin=dict[@"data"][@"exchange_coin"];
             NSString * con=dict[@"data"][@"con"];
             NSString * goods_num=dict[@"data"][@"goods_num"];
             NSString * sale_num=dict[@"data"][@"sale_num"];
             
             //图片数组
             NSMutableArray *imgArray=[NSMutableArray array];
             for (NSString *imgStr in dict[@"data"][@"pic_arr"]) {
                 NSString * pic=[picURL stringByAppendingString:imgStr];
                 [imgArray addObject:pic];
             }
             
             articleArray=[NSMutableArray arrayWithObjects: title,exchange_price,price,exchange_coin,imgArray,con,sale_num,goods_num,nil];
             
             [self creatFieldset];
             
         }
         
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"请求失败:%@",error);
         [SVProgressHUD showErrorWithStatus:@"网络不通，请检查网络！"];
         
     }];
}

//收藏商品
- (void)collectArticle
{
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/collect";
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *dict = @{@"appkey":APPKEY,
                           @"backtype":BACKTYPE,
                           @"xid":XID,
                           @"user_id":USER_ID,
                           @"user_type":USER_TYPE,
                           @"collect_id":self.orderNum,
                           @"collect_type":@"1",
                           
                           };
    //    NSLog(@"%@",dict);
    
    // 服务器返回的数据格式
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer]; // 二进制数据
    [mgr POST:urlStr parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         //                  NSLog(@"%@",dict);
         //        NSLog(@"%@",dict[@"code"]);
         
         
         
         if([[NSString stringWithFormat:@"%@",dict[@"code"]]isEqualToString:@"1"] )
         {
             [SVProgressHUD showSuccessWithStatus:@"收藏商品成功"];
             UIButton*rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,22,22)];
             [rightButton setBackgroundImage:[UIImage imageNamed:@"commentInfo10.png"] forState:UIControlStateNormal];
             UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
             self.navigationItem.rightBarButtonItem= rightItem;
             [rightButton addTarget:self action:@selector(collectbtn:)forControlEvents:UIControlEventTouchUpInside];
             isCollect=!isCollect;
             
         }
         //         else
         //         {
         //             [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"收藏商品失败，%@",dict[@"msg"]]];
         //         }
         
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"请求失败:%@",error);
         [SVProgressHUD showErrorWithStatus:@"网络不通，请检查网络！"];
         
     }];
}

//取消收藏商品
- (void)deleteCollectArticle
{
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/deleteCollect";
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *dict = @{@"appkey":APPKEY,
                           @"backtype":BACKTYPE,
                           @"xid":XID,
                           @"user_id":USER_ID,
                           @"user_type":USER_TYPE,
                           @"collect_id":self.orderNum,
                           @"collect_type":@"1",
                           
                           };
    //    NSLog(@"%@",dict);
    
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
         NSLog(@"请求失败:%@",error);
         [SVProgressHUD showErrorWithStatus:@"网络不通，请检查网络！"];
         
     }];
}

@end
