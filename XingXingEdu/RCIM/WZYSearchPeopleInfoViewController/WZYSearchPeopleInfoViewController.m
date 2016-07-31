


//
//  WZYSearchPeopleInfoViewController.m
//  XingXingEdu
//
//  Created by Mac on 16/7/14.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "WZYSearchPeopleInfoViewController.h"
#import "WZYSearchPeopleInfoTableViewCell.h"

#import "WZYRCAddFriendDetialInfoViewController.h"

#define CELL @"WZYSearchPeopleInfoTableViewCell"


@interface WZYSearchPeopleInfoViewController ()<UISearchControllerDelegate, UISearchResultsUpdating, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) UITableView *myTableView;
/*
 [id] => 5
 [name] => 上海露露小学
 [type] => 1		//幼儿园/小学/中学/培训机构 1/2/3/4
 [province] => 上海
 [city] => 上海
 [district] => 浦东新区
 */
////学校 名称
@property (nonatomic, strong) NSMutableArray *searchResultArray;
////省
//@property (nonatomic, strong) NSMutableArray *provinceArray;
////市
//@property (nonatomic, strong) NSMutableArray *cityArray;
////区
//@property (nonatomic, strong) NSMutableArray *areaArray;
////类型
//@property (nonatomic, strong) NSMutableArray *schoolTypeArray;

@property (nonatomic, copy) NSString *iconStr;
@property (nonatomic, copy) NSString *nicknameStr;
@property (nonatomic, copy) NSString *sexStr;
@property (nonatomic, copy) NSString *xidStr;


@end

@implementation WZYSearchPeopleInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColorFromRGB(229, 232, 233);
    
    //    [self fetchNetData];
    
    [self createTableView];
    
    [self createSearch];
    
}

#pragma mark - createSearch ----------------------------------
- (void)createSearch{
    
    _searchController = [[UISearchController alloc]initWithSearchResultsController:nil];
    
    _searchController.searchResultsUpdater = self;
    _searchController.delegate = self;
    _searchController.dimsBackgroundDuringPresentation = false;
    
    [_searchController.searchBar sizeToFit];
    _searchController.searchBar.backgroundColor = UIColorFromHex(0xdcdcdc);
    
    _myTableView.tableHeaderView = _searchController.searchBar;
    
}

#pragma mark -
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
//    _searchResultArray = [[NSMutableArray alloc] init];
//    _provinceArray = [[NSMutableArray alloc] init];
//    _cityArray = [[NSMutableArray alloc] init];
//    _areaArray = [[NSMutableArray alloc] init];
//    _schoolTypeArray = [[NSMutableArray alloc] init];
    /*
     【聊天--通过手机或猩猩ID搜索用户】
     
     接口:
     http://www.xingxingedu.cn/Global/search_user
     
     传参:
     search_con	//搜索内容
     */
    //路径
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/search_user";
    
    //请求参数  无
    
    NSDictionary *params = @{@"appkey":APPKEY, @"backtype":BACKTYPE, @"xid":XID, @"user_id":USER_ID, @"user_type":USER_TYPE, @"search_con":_searchController.searchBar.text};
    
    NSLog(@"  搜索 参数 %@", params);
    
    
    [WZYHttpTool post:urlStr params:params success:^(id responseObj) {
        //
        NSLog(@"搜索 人  返回值%@", responseObj);
        /*
         搜索 学校 返回值{
         {
         head_img = app_upload/head_img/2016/07/04/20160704140746_7704.png,
         id = 1,
         sex = 男,
         nickname = 大熊猫,
         head_img_type = 0,
         xid = 18884982
         }
         */
        NSString *str = [NSString stringWithFormat:@"%@", responseObj[@"code"]];
        
        if ([str isEqualToString:@"1"]) {
            
//            NSLog(@"%@", responseObj[@"data"]);
            
            NSDictionary *dic = responseObj[@"data"];
            
//            0 :表示 自己 头像 ，需要添加 前缀
//            1 :表示 第三方 头像 ，不需要 添加 前缀
            //判断是否是第三方头像
            if([[NSString stringWithFormat:@"%@",dic[@"head_img_type"]]isEqualToString:@"0"]){
                _iconStr = [picURL stringByAppendingString:dic[@"head_img"]];
            }else{
                _iconStr = dic[@"head_img"];
            }
            
            _nicknameStr = dic[@"nickname"];
            _sexStr = dic[@"sex"];
            _xidStr = dic[@"xid"];
            
        }else {
            
            
        }
        
//        _searchResultArray = [NSMutableArray arrayWithCapacity:1];
        [_myTableView reloadData];
        
    } failure:^(NSError *error) {
        //
        NSLog(@"%@", error);
    }];
    [_myTableView reloadData];
}



#pragma mark - createTableView ----------------------------------------------
- (void)createTableView{
    
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight) style:UITableViewStyleGrouped];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    
    [self.view addSubview:_myTableView];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
    
//    return _searchResultArray.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WZYSearchPeopleInfoTableViewCell *cell =(WZYSearchPeopleInfoTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CELL];
    if (!cell) {
        NSArray *nib =[[NSBundle mainBundle]loadNibNamed:CELL owner:[WZYSearchPeopleInfoTableViewCell class] options:nil];
        cell =(WZYSearchPeopleInfoTableViewCell*)[nib objectAtIndex:0];
        // cell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.iconImageView.layer.cornerRadius = 25;
    cell.iconImageView.layer.masksToBounds = YES;
    
    [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:_iconStr] placeholderImage:[UIImage imageNamed:@"人物头像172x172"]];
    
    cell.nicknameLabel.text = _nicknameStr;
    
    cell.sexLabel.text = _sexStr;

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 70;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.000001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

//    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    
//    NSString *schoolNameStr = cell.textLabel.text;
//    
//    NSString *provinceStr = _provinceArray[indexPath.row];
//    
//    NSString *cityStr = _cityArray[indexPath.row];
//    NSString *areaStr = _areaArray[indexPath.row];
//    NSString *schoolTypeStr = _schoolTypeArray[indexPath.row];
//    
//    NSMutableArray *newArray = [[NSMutableArray alloc] initWithObjects: provinceStr, cityStr, areaStr, schoolTypeStr,  schoolNameStr, @"formWZYSearchSchool", nil];
//    
//    self.returnArrayBlock(newArray);
//    
//    
//    //    NSLog(@"222222%ld", newArray.count);
//    //    self.returnCommentNameBlock(cell.textLabel.text);
//    
//    [self.navigationController popViewControllerAnimated:YES];
    
//    RCAddFriendInfoViewController *RCAddFriendInfoVC = [[RCAddFriendInfoViewController alloc] init];
//    
//    RCAddFriendInfoVC.iconStr = _iconStr;
//    RCAddFriendInfoVC.nicknameStr = _nicknameStr;
//    
//    [self.navigationController pushViewController:RCAddFriendInfoVC animated:YES];
    
        WZYRCAddFriendDetialInfoViewController *WZYRCAddFriendDetialInfoVC = [[WZYRCAddFriendDetialInfoViewController alloc] init];
    
        WZYRCAddFriendDetialInfoVC.iconStr = _iconStr;
        WZYRCAddFriendDetialInfoVC.nicknameStr = _nicknameStr;
        WZYRCAddFriendDetialInfoVC.xidStr = _xidStr;
    
        [self.navigationController pushViewController:WZYRCAddFriendDetialInfoVC animated:YES];
    
    
    
}

- (void)returnText:(ReturnCommentNameBlock)block{
    
    self.returnCommentNameBlock =block;
}

- (void)returnArray:(ReturnArrayBlock)block{
    
    self.returnArrayBlock = block;
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_searchController.searchBar resignFirstResponder];
    
    [_searchController.searchBar endEditing:YES];
    [self.view endEditing:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.searchController.active) {
        self.searchController.active = NO;
        [self.searchController.searchBar removeFromSuperview];
    }
}

@end
