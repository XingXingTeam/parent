//
//  ArticleInfoViewController.h
//  XingXingStore
//
//  Created by codeDing on 16/3/21.
//  Copyright © 2016年 codeDing. All rights reserved.
//

#import "ArticleCategoryViewController.h"
#import "MultilevelMenu.h"
#import "HHControl.h"
#import "ArticleInfoViewController.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface ArticleCategoryViewController ()<UISearchBarDelegate>{
    NSMutableArray *_categoryArr;//类别
    NSMutableArray *_titleArr;//物品名称
    NSMutableArray *_priceArr;//销售价格
    NSMutableArray *_sale_numArr;//销售数量
    NSMutableArray *_goods_picArr;//物品图片
    NSMutableArray *_idArr;//物品ID
    NSMutableArray *_exchange_coinArr;
    UISearchBar* m_searchBar;
    
    
}

//@property (nonatomic, strong) MultilevelMenu *menu;
@property (nonatomic, copy) NSString *rowStr;

@end

@implementation ArticleCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.tabBarController.navigationItem.title=@"分类";
    
    [self pickUpCategoryMsg];
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

//agma mark 请求分类
- (void)pickUpCategoryMsg
{
    //初始化数据
    _categoryArr = [NSMutableArray array];
    
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/coin_goods_class";
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *dict = @{@"appkey":@"U3k8Dgj7e934bh5Y",
                           @"backtype":@"json",
                           @"xid":@"18884982",
                           @"user_id":@"1",
                           @"user_type":@"1",
                           };
    
    // 服务器返回的数据格式
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer]; // 二进制数据
    [mgr POST:urlStr parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         
         //          NSLog(@"~~~%@",dict);
         if([[NSString stringWithFormat:@"%@",dict[@"code"]]isEqualToString:@"1"] ){
             NSMutableArray *dataArr = dict[@"data"];
             _categoryArr = dataArr;
             //接受通知
               [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectIndex:) name:@"selectIndex" object:nil];
             
               [self pickUpCategoryDetailed:@"玩具" search:@""];
         }
         else{
             [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"获取信息失败，%@",dict[@"msg"]]];
         }
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         [SVProgressHUD showErrorWithStatus:@"网络不通，请检查网络！"];
     }];
}

//通知相应事件
-(void)selectIndex:(NSNotification *)text{
    
    [m_searchBar resignFirstResponder];
    
    NSString *teacherName =[NSString stringWithFormat:@"%@", text.userInfo[@"selectIndex"]];

    if ([teacherName isEqualToString:@"0"]) {
        [self pickUpCategoryDetailed:@"玩具" search:@""];
    }if ([teacherName isEqualToString:@"1"]){
        [self pickUpCategoryDetailed:@"生活用品" search:@""];
    }if ([teacherName isEqualToString:@"2"]){
        [self pickUpCategoryDetailed:@"话费" search:@""];
    }if ([teacherName isEqualToString:@"3"]){
        [self pickUpCategoryDetailed:@"花篮" search:@""];
    }
    _rowStr = teacherName;
    MultilevelMenu *menu = [[MultilevelMenu alloc] init];
    [menu.rightCollection reloadData];
}
#pragma mark 请求物品种类
- (void)pickUpCategoryDetailed:(NSString *)class search:(NSString *)searchWords{
    
    _titleArr  = [NSMutableArray array];
    _goods_picArr = [NSMutableArray array];
    _sale_numArr = [NSMutableArray array];
    _priceArr = [NSMutableArray array];
    _idArr = [NSMutableArray array];
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/coin_goods";
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *dict = @{@"appkey":@"U3k8Dgj7e934bh5Y",
                           @"backtype":@"json",
                           @"xid":@"18884982",
                           @"user_id":@"1",
                           @"user_type":@"1",
                           @"class":class,
                           @"search_words":searchWords,
                           };
    
    // 服务器返回的数据格式
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer]; // 二进制数据
    [mgr POST:urlStr parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         
//                  NSLog(@"~~~%@",dict);
         if([[NSString stringWithFormat:@"%@",dict[@"code"]]isEqualToString:@"1"] ){
             
             for (NSDictionary *dic in dict[@"data"]) {
                NSString * exchange_coin=dic[@"exchange_coin"];
                 NSString * goods_pic=dic[@"goods_pic"];
                 NSString * sale_num=dic[@"sale_num"];
                 
                 NSString * title=dic[@"title"];
                 NSString * storeid = dic[@"id"];
                 
                 [_titleArr addObject:title];
                 [_goods_picArr addObject:goods_pic];
                 [_sale_numArr addObject:sale_num];
                 [_priceArr addObject:exchange_coin];
                 [_idArr addObject:storeid];

             }
             [self createArticle];
         }
         else{
             [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"查询物品失败或没有此物品"]];
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         [SVProgressHUD showErrorWithStatus:@"网络不通，请检查网络！"];
     }];
}


//搭建分类界面
-(void) createArticle {
    UIView *view1=[HHControl createViewWithFrame:CGRectMake(0, 49, WinWidth, 1)];
    view1.backgroundColor=UIColorFromRGB(193, 193, 193);
    view1.userInteractionEnabled = YES;
    [self.view addSubview:view1];
    UIImageView *bg=[HHControl createImageViewWithFrame:CGRectMake(0, 0, WinWidth, 48) ImageName:@"lightgraybg.png"];
    bg.userInteractionEnabled = YES;
    [self.view addSubview:bg];
    
    //搜索框
    m_searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(8, 9, WinWidth-16, 30)];
    m_searchBar.barStyle = UIBarStyleDefault;
    m_searchBar.placeholder =@"寻找喜欢的商品";
    m_searchBar.delegate = self;
    m_searchBar.userInteractionEnabled = YES;
    [m_searchBar setShowsCancelButton:YES];
    m_searchBar.returnKeyType = UIReturnKeyDone;
   [[[[ m_searchBar.subviews objectAtIndex : 0 ] subviews ] objectAtIndex : 0 ] removeFromSuperview ];
    [ m_searchBar setBackgroundColor :[ UIColor clearColor]];
    [self.view addSubview:m_searchBar];
    
//分类类目
    NSMutableArray * lis=[NSMutableArray arrayWithCapacity:0];
    NSInteger countMax= _categoryArr.count;
    for (int i=0; i<countMax; i++) {
        rightMeun * meun=[[rightMeun alloc] init];
        meun.meunName = _categoryArr[i];
        NSMutableArray * sub=[NSMutableArray arrayWithCapacity:0];
        for ( int j=0; j <1; j++) {
            rightMeun * meun1=[[rightMeun alloc] init];
            meun1.meunName = _categoryArr[j];
            [sub addObject:meun1];
        
            NSMutableArray *zList=[NSMutableArray arrayWithCapacity:0];
            for ( int z=0; z <_titleArr.count; z++) {
                rightMeun * meun2=[[rightMeun alloc] init];
                meun2.meunName = _titleArr[z];
                meun2.urlName = [NSString stringWithFormat:@"http://www.xingxingedu.cn/Public/%@",_goods_picArr[z]];
                meun2.price = _priceArr[z];
                meun2.sale_num = _sale_numArr[z];
                meun2.ID = _idArr[z];
                
                [zList addObject:meun2];
            }
            meun1.nextArray=zList;
        }
        meun.nextArray = sub;
        [lis addObject:meun];
;
    }
    /**
     *  适配 ios 7 和ios 8 的 坐标系问题
     */
    self.automaticallyAdjustsScrollViewInsets = YES;
    
    /**
     默认是 选中第一行
     */

    MultilevelMenu * view=[[MultilevelMenu alloc] initWithFrame:CGRectMake(0, 50, kScreenWidth, kScreenHeight-50) WithData:lis withSelectIndex:^(NSInteger left, NSInteger right,rightMeun* info) {
        
        ArticleInfoViewController*vc=  [[ArticleInfoViewController alloc]init];
        vc.orderNum = info.ID;
        [self.navigationController pushViewController:vc animated:YES];
    }];
    view.leftSelectColor=UIColorFromRGB(133, 199, 1);
    view.leftUnSelectBgColor=[UIColor whiteColor];
    view.leftBgColor=[UIColor whiteColor];
    view.needToScorllerIndex = [_rowStr intValue];
    view.isRecordLastScroll = YES;
    [self.view addSubview:view];
    
}
#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self pickUpCategoryDetailed:@"" search:searchBar.text];
    
    [m_searchBar resignFirstResponder];
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [m_searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [m_searchBar resignFirstResponder];
}
-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
