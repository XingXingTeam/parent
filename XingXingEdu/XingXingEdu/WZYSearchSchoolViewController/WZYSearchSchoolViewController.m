



//
//  WZYSearchSchoolViewController.m
//  XingXingEdu
//
//  Created by Mac on 16/7/7.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "WZYSearchSchoolViewController.h"

@interface WZYSearchSchoolViewController ()<UISearchControllerDelegate, UISearchResultsUpdating, UITableViewDataSource, UITableViewDelegate>

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
//学校 名称
@property (nonatomic, strong) NSMutableArray *searchResultArray;
//省
@property (nonatomic, strong) NSMutableArray *provinceArray;
//市
@property (nonatomic, strong) NSMutableArray *cityArray;
//区
@property (nonatomic, strong) NSMutableArray *areaArray;
//类型
@property (nonatomic, strong) NSMutableArray *schoolTypeArray;
//学校 id
@property (nonatomic, strong) NSMutableArray *schoolIdArray;


@end

@implementation WZYSearchSchoolViewController

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
    _searchResultArray = [[NSMutableArray alloc] init];
    _provinceArray = [[NSMutableArray alloc] init];
    _cityArray = [[NSMutableArray alloc] init];
    _areaArray = [[NSMutableArray alloc] init];
    _schoolTypeArray = [[NSMutableArray alloc] init];
    _schoolIdArray = [[NSMutableArray alloc] init];
    /*
     【通过学校类型地区获取学校】
     接口:
     http://www.xingxingedu.cn/Global/get_school_info
     传参:
     school_type 	//学校类型,请传数字代号:幼儿园/小学/中学/培训机构 1/2/3/4
     province  	//省
     city		//城市
     district	//区
     search_words	//搜索关键词(搜索的时候上面4个传参不需要,传上面4个时,搜索词不需要)
     */
    //路径
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/get_school_info";
    
    //请求参数  无
    NSString *parameterXid;
    NSString *parameterUser_Id;
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }

    NSDictionary *params = @{@"appkey":APPKEY, @"backtype":BACKTYPE, @"xid":parameterXid, @"user_id":parameterUser_Id, @"user_type":USER_TYPE, @"search_words":_searchController.searchBar.text};
    
    [WZYHttpTool post:urlStr params:params success:^(id responseObj) {
        //
        NSLog(@"搜索 学校 返回值%@", responseObj);
        
        NSString *str = [NSString stringWithFormat:@"%@", responseObj[@"code"]];
        
        if ([str isEqualToString:@"1"]) {
            
            NSArray *dataSource = responseObj[@"data"];
            
            for (NSDictionary *dic in dataSource) {
//                [_searchResultArray addObject:dic[@"id"]];
                //学校 名称
                [_searchResultArray addObject:dic[@"name"]];
                //省
                [_provinceArray addObject:dic[@"province"]];
                //市
                [_cityArray addObject:dic[@"city"]];
                //区
                [_areaArray addObject:dic[@"district"]];
                //类型
                [_schoolTypeArray addObject:dic[@"type"]];
                //学校 id
                [_schoolIdArray addObject:dic[@"id"]];
            }
            
        }else {
            
            
        }
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

        return _searchResultArray.count;

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    cell.textLabel.text = _searchResultArray[indexPath.row];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 0.000001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    NSString *schoolNameStr = cell.textLabel.text;
    
    NSString *provinceStr = _provinceArray[indexPath.row];
    
    NSString *cityStr = _cityArray[indexPath.row];
    NSString *areaStr = _areaArray[indexPath.row];
    NSString *schoolTypeStr = _schoolTypeArray[indexPath.row];
    NSString *schoolID = _schoolIdArray[indexPath.row];
    //省/市/区/学校类型/学校名称/学校ID/formWZYSearchSchool
    NSMutableArray *newArray = [[NSMutableArray alloc] initWithObjects: provinceStr, cityStr, areaStr, schoolTypeStr,  schoolNameStr, schoolID, @"formWZYSearchSchool", nil];
    
    self.returnArrayBlock(newArray);

    
//    NSLog(@"222222%ld", newArray.count);
//    self.returnCommentNameBlock(cell.textLabel.text);
 
    [self.navigationController popViewControllerAnimated:YES];
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
