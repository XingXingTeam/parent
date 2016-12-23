//
//  SchoolRecipesViewController.m
//  XingXingEdu
//
//  Created by keenteam on 16/1/18.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//
#define KT @"yyyy年MM月dd日 HH:MM:ss"
#define KPDATA @"SchoolRecipeCell"
#import "SchoolRecipesViewController.h"
#import "SchoolRecipeInfoViewController.h"
#import "SchoolRecipeCell.h"
#import "HHControl.h"
#import "LandingpageViewController.h"


@interface SchoolRecipesViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_myTableView;
    
    NSMutableArray *_dataSourceArray;
    
    //历史 食谱
    NSMutableArray *historyRecipeArray;
    //现在和未来 食谱
    NSMutableArray *nowAndFutureArray;
    //所有 食谱
    NSMutableArray *totalArray;
    
    //日期 年-月-日 星期几
    NSMutableArray *dateArray;
    //某一天 食谱 id  cookbook_id
    NSMutableArray *cookbook_idArray;
    //早餐
    NSMutableArray *breakfastDataSource;
    //午餐
    NSMutableArray *lunchDataSource;
    //晚餐
    NSMutableArray *dinnerDataSource;
    
    //食物 图片
    NSMutableArray *mealPicArray;
    NSMutableArray *mealPicDataSource;
    
    //头像
    NSMutableArray *iconImageViewArray;
    NSMutableArray *iconImageViewDataSource;
    //标题 早 午 晚
    NSArray *titleArray;
    //饭菜 组成
    NSMutableArray *contentArray;
    NSMutableArray *contentDataSource;
    
    //删除 食谱 的 section
    NSInteger deleteSection;
    //记录 最初 历史 食谱 个数
    NSInteger historyCount;
    NSString *parameterXid;
    NSString *parameterUser_Id;
    
}

@end

@implementation SchoolRecipesViewController
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden =NO;
    self.navigationController.navigationBar.barTintColor =UIColorFromRGB(0, 170, 42);
    [self.navigationController.navigationBar setTintColor:UIColorFromRGB(255, 255, 255)];
    
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }
    [self fetchNetData];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"食谱";
    self.view.backgroundColor = UIColorFromRGB(34, 56, 67);

    [self createTableView];
}
- (void)fetchNetData{
    
    NSString *urlStr = @"http://www.xingxingedu.cn/Parent/school_cookbook";
    
    NSString *schoolStr = [DEFAULTS objectForKey:@"SCHOOL_ID"];
    
    NSDictionary *dict = @{@"appkey":APPKEY,
                           @"backtype":BACKTYPE,
                           @"xid":parameterXid,
                           @"user_id":parameterUser_Id,
                           @"user_type":USER_TYPE,
                           @"school_id":schoolStr,
                           };
    
    [WZYHttpTool post:urlStr params:dict success:^(id responseObj) {
        
        dateArray = [[NSMutableArray alloc] init];
        cookbook_idArray = [[NSMutableArray alloc] init];
        historyRecipeArray = [[NSMutableArray alloc] init];
        nowAndFutureArray = [[NSMutableArray alloc] init];
        totalArray = [[NSMutableArray alloc] init];
        breakfastDataSource = [[NSMutableArray alloc] init];
        lunchDataSource =  [[NSMutableArray alloc] init];
        dinnerDataSource = [[NSMutableArray alloc] init];
        
        mealPicDataSource = [[NSMutableArray alloc] init];
        iconImageViewDataSource = [[NSMutableArray alloc] init];
        contentDataSource = [[NSMutableArray alloc] init];
        
        NSLog(@"hhhh %@", responseObj);
        
        if([[NSString stringWithFormat:@"%@",responseObj[@"code"]]isEqualToString:@"1"] )
        {
            NSDictionary *dict = responseObj[@"data"];
            //历史 食谱
            historyRecipeArray = dict[@"history_food"];
            
            //现在和未来 食谱
            nowAndFutureArray = dict[@"totay_food"];
            
            //总共 食谱
            [totalArray addObjectsFromArray:historyRecipeArray];
            [totalArray addObjectsFromArray:nowAndFutureArray];
            
            for (NSDictionary *dic in totalArray) {
                //日期
                NSString *dateString = [WZYTool dateStringFromNumberTimer:dic[@"date_tm"]];
                [dateArray addObject:dateString];
                
                //食谱 id
                [cookbook_idArray addObject:dic[@"cookbook_id"]];
                
                mealPicArray = [[NSMutableArray alloc] init];
                iconImageViewArray = [[NSMutableArray alloc] init];
                contentArray = [[NSMutableArray alloc] init];
                
                if ([dic[@"breakfast"][@"pic_arr"] count] != 0) {
                    [mealPicArray addObject:dic[@"breakfast"][@"pic_arr"]];
                    [iconImageViewArray addObject:dic[@"breakfast"][@"pic_arr"][0][@"pic"]];
                }else{
                    NSArray *emptyArray = [[NSArray alloc] init];
                    [mealPicArray addObject:emptyArray];
                    [iconImageViewArray addObject:@""];
                }
                
                if ([dic[@"lunch"][@"pic_arr"] count] != 0) {
                    [mealPicArray addObject:dic[@"lunch"][@"pic_arr"]];
                    [iconImageViewArray addObject:dic[@"lunch"][@"pic_arr"][0][@"pic"]];
                }else{
                    NSArray *emptyArray = [[NSArray alloc] init];
                    [mealPicArray addObject:emptyArray];
                    [iconImageViewArray addObject:@""];
                }
                
                
                if ([dic[@"dinner"][@"pic_arr"] count] != 0) {
                    [mealPicArray addObject:dic[@"dinner"][@"pic_arr"]];
                    [iconImageViewArray addObject:dic[@"dinner"][@"pic_arr"][0][@"pic"]];
                }else{
                    NSArray *emptyArray = [[NSArray alloc] init];
                    [mealPicArray addObject:emptyArray];
                    [iconImageViewArray addObject:@""];
                }
                
                [mealPicDataSource addObject:mealPicArray];
                [iconImageViewDataSource addObject:iconImageViewArray];
                
                [contentArray addObject:dic[@"breakfast"][@"title"]];
                [contentArray addObject:dic[@"lunch"][@"title"]];
                [contentArray addObject:dic[@"dinner"][@"title"]];
                [contentDataSource addObject:contentArray];
                
            }
            
            
        }else{
            
        }
        [self customContent];
    } failure:^(NSError *error) {
        
        NSLog(@"%@", error);
        
    }];
    
}

// 有数据 和 无数据 进行判断
- (void)customContent{
    
    if (totalArray.count == 0) {
        
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        // 1、无数据的时候
        UIImage *myImage = [UIImage imageNamed:@"all_placeholder"];
        CGFloat myImageWidth = myImage.size.width;
        CGFloat myImageHeight = myImage.size.height;
        
        UIImageView *myImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kWidth / 2 - myImageWidth / 2, (kHeight - 64 - 49) / 2 - myImageHeight / 2, myImageWidth, myImageHeight)];
        myImageView.image = myImage;
        [self.view addSubview:myImageView];
        
    }else{
        //2、有数据的时候
        //        NSLog(@"%ld", historyRecipeArray.count);
        //滚动到 时间 为今天 的食谱 cell
        [_myTableView setContentOffset:CGPointMake(0.0, historyRecipeArray.count  *(80 * 3 + 30) ) animated:NO];
        
    }
    
    [_myTableView reloadData];
}


- (void)createTableView{
    _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight) style:UITableViewStyleGrouped];
    _myTableView.dataSource =self;
    _myTableView.delegate =self;
    [self.view addSubview:_myTableView];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
//    NSLog(@"%@", totalArray);
    return totalArray.count;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SchoolRecipeCell *cell =(SchoolRecipeCell*)[tableView dequeueReusableCellWithIdentifier:KPDATA];
    if (!cell) {
        NSArray *nib =[[NSBundle mainBundle]loadNibNamed:KPDATA owner:[SchoolRecipeCell class] options:nil];
        cell = (SchoolRecipeCell*)[nib objectAtIndex:0];
        
    }
    
    if ([iconImageViewDataSource[indexPath.section] count] != 0) {
        
//    NSLog(@"gg --  oo%@", iconImageViewDataSource[indexPath.section]);
        NSString *iconStr = [NSString stringWithFormat:@"%@%@", picURL, iconImageViewDataSource[indexPath.section][indexPath.row]];
        
                NSLog(@"===  %@", iconStr);
        
        [cell.imageV sd_setImageWithURL:[NSURL URLWithString:iconStr] placeholderImage:[UIImage imageNamed:@"home_recipe_placehoder_icon"]];
    }else{
        
        cell.imageV.image = [UIImage imageNamed:@"home_recipe_placehoder_icon"];
    }
    
    cell.imageV.contentMode = UIViewContentModeScaleAspectFill;
    cell.imageV.clipsToBounds = YES;
    cell.titleLbl.text = titleArray[indexPath.row];
    cell.detailLbl.text = contentDataSource[indexPath.section][indexPath.row];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;

    
}
- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if ([totalArray[section] count] != 0) {
    return dateArray[section];
    }else {
    return  @"";
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([XXEUserInfo user].login) {
        SchoolRecipeInfoViewController *schoolRecInfoVC = [[SchoolRecipeInfoViewController alloc]init];
        if ([mealPicDataSource[indexPath.section] count] != 0) {
            schoolRecInfoVC.mealPicDataSource = mealPicDataSource[indexPath.section][indexPath.row];
        }
        schoolRecInfoVC.i =indexPath.row;
        schoolRecInfoVC.detailStr = contentDataSource[indexPath.section][indexPath.row];
        [self.navigationController pushViewController:schoolRecInfoVC animated:YES];
        
    }else{
        [SVProgressHUD showInfoWithStatus:@"请用账号登录后查看"];
         }
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 25;
    }
    return 15;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
