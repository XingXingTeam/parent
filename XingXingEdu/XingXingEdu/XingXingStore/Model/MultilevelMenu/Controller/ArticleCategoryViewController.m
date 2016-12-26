//
//  ArticleInfoViewController.h
//  XingXingStore
//
//  Created by codeDing on 16/3/21.
//  Copyright © 2016年 codeDing. All rights reserved.
//

#import "ArticleCategoryViewController.h"
#import "XXEXingStoreCategoryModel.h"
#import "XXEXingStoreGoodInfoModel.h"
#import "MultilevelMenu.h"
#import "HHControl.h"
//商品 详情
#import "XXEStoreGoodDetailInfoViewController.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface ArticleCategoryViewController ()<UISearchBarDelegate>{

    UISearchBar* m_searchBar;
    
    NSString *parameterXid;
    NSString *parameterUser_Id;
    
    NSMutableArray *categoryModelArray;
    NSMutableArray *goodModelArray;
    
}

@property (nonatomic, copy) NSString *rowStr;

@end

@implementation ArticleCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.tabBarController.navigationItem.title=@"分类";
    
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }
    categoryModelArray = [[NSMutableArray alloc] init];
    goodModelArray = [[NSMutableArray alloc] init];
    
    [self pickUpCategoryMsg];
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

//agma mark 请求分类
- (void)pickUpCategoryMsg
{
    //初始化数据
    if (categoryModelArray.count != 0) {
        [categoryModelArray removeAllObjects];
    }
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/coin_goods_class";
    NSDictionary *dict = @{@"appkey":APPKEY,
                           @"backtype":BACKTYPE,
                           @"xid":parameterXid,
                           @"user_id":parameterUser_Id,
                           @"user_type":USER_TYPE,
                           };
    
    [WZYHttpTool post:urlStr params:dict success:^(id responseObj) {
        //        NSLog(@"%@", responseObj);
        if ([responseObj[@"code"]  integerValue] == 1) {
            NSArray *array = [[NSArray alloc] init];
            array  = [XXEXingStoreCategoryModel parseResondsData:responseObj[@"data"]];
            
            //            NSLog(@"ff %@", array);
            [categoryModelArray addObjectsFromArray:array];
        }
        //        NSLog(@" kk %@", categoryModelArray);
        //接受通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectIndex:) name:@"selectIndex" object:nil];
        
        XXEXingStoreCategoryModel *model = categoryModelArray[0];
        [self pickUpCategoryDetailed:model.category_id search:@""];
    } failure:^(NSError *error) {
        //
        
    }];
}

//通知相应事件
-(void)selectIndex:(NSNotification *)text{
    
    [m_searchBar resignFirstResponder];
    
    NSString *teacherName =[NSString stringWithFormat:@"%@", text.userInfo[@"selectIndex"]];
    
    XXEXingStoreCategoryModel *model = categoryModelArray[[teacherName integerValue]];
    [self pickUpCategoryDetailed:model.category_id search:@""];
    _rowStr = teacherName;
    MultilevelMenu *menu = [[MultilevelMenu alloc] init];
    [menu.rightCollection reloadData];
}
#pragma mark 请求物品种类
- (void)pickUpCategoryDetailed:(NSString *)class search:(NSString *)searchWords{
    if (goodModelArray.count != 0) {
        [goodModelArray removeAllObjects];
    }
    
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/coin_goods";
    NSDictionary *dict = @{@"appkey":APPKEY,
                           @"backtype":BACKTYPE,
                           @"xid":parameterXid,
                           @"user_id":parameterUser_Id,
                           @"user_type":USER_TYPE,
                           @"class":class,
                           @"search_words":searchWords,
                           };
    
    [WZYHttpTool post:urlStr params:dict success:^(id responseObj) {
        //        NSLog(@"vvvv %@", responseObj);
        if ([responseObj[@"code"]  integerValue] == 1) {
            
            NSArray *array = [[NSArray alloc] init];
            array  = [XXEXingStoreGoodInfoModel parseResondsData:responseObj[@"data"]];
            [goodModelArray addObjectsFromArray:array];
            
        }
        
        [self createArticle];
        
    } failure:^(NSError *error) {
        //
        [SVProgressHUD showErrorWithStatus:@"网络不通,请检查网络!"];
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
    
    //分类类目====================================================
    NSMutableArray * lis=[NSMutableArray arrayWithCapacity:0];
    NSInteger countMax= categoryModelArray.count;
    for (int i=0; i<countMax; i++) {
        rightMeun * meun=[[rightMeun alloc] init];
        XXEXingStoreCategoryModel *model = categoryModelArray[i];
        meun.meunName = model.category_name;
        NSMutableArray * sub=[NSMutableArray arrayWithCapacity:0];
        for ( int j=0; j <1; j++) {
            rightMeun * meun1=[[rightMeun alloc] init];
            
            XXEXingStoreCategoryModel *model1 = categoryModelArray[j];
            meun1.meunName = model1.category_name;
            [sub addObject:meun1];
            
            NSMutableArray *zList=[NSMutableArray arrayWithCapacity:0];
            for ( int z=0; z <goodModelArray.count; z++) {
                rightMeun * meun2=[[rightMeun alloc] init];
                XXEXingStoreGoodInfoModel *model2 = goodModelArray [z];
                
                meun2.meunName = model2.title;
                meun2.urlName = [NSString stringWithFormat:@"%@%@", picURL, model2.goods_pic];
                meun2.price = model2.price;
                meun2.sale_num = model2.sale_num;
                meun2.ID = model2.good_id;
                
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
        
        XXEStoreGoodDetailInfoViewController*vc=  [[XXEStoreGoodDetailInfoViewController alloc]init];
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
