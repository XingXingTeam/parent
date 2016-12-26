//
//  ClassTelephoneViewController.m
//  XingXingEdu
//
//  Created by keenteam on 16/1/18.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//
#import "ClassTelephoneViewController.h"
#define KPATA @"KTelephoneCell"
#import "macrodefine.h"
//#import "ClassTelephoneCell.h"
#import "TeleViewController.h"
#import "HomeInfoViewController.h"
#import "TeleTeachInfoViewController.h"
#import "WZYBabyCenterViewController.h"
#import "KTClassTelephoneBabyViewController.h"
#import "Friend.h"
#import "FriendGroup.h"
#import "HeadView.h"
#import "SVProgressHUD.h"
#import "UtilityFunc.h"
#import "KTelephoneCell.h"
#import "LandingpageViewController.h"


char* const buttonKey = "buttonKey";
@interface ClassTelephoneViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,HeadViewDelegate>
{
    UITableView *_telTabView;
    NSMutableArray *_telArray;
    NSArray *sections;
    NSArray *_friendsData;
    //ceshi
    UITableView *_tableView;
    NSArray *tempArray;
    //age  head  tname
    NSMutableArray *ageMArr;
    NSMutableArray *KTAgeMArr;
    NSMutableArray *head_imgMArr;
    NSMutableArray *tnameMArr;
    //teacher
    NSMutableArray *KTHead_imgMArr;
    NSMutableArray *KTTnameMArr;
    NSMutableArray *KTTeach_courseMArr;
    NSMutableArray *headTitleArr;
    NSMutableArray *frindsDataMArr;
    NSMutableArray *friends;
    NSMutableArray *managers;
    NSMutableArray *teachers;
    NSArray *sectionArray;
    NSArray *rowArray;
    NSDictionary *_showDic;//用来判断分组展开与收缩的
    NSMutableArray *keyMArr;
    NSMutableArray *parent_listMArr;
    NSMutableArray *KTparent_listMArr;
    NSMutableArray *idMArr;
    NSMutableArray *KTIDMArr;
    
    UIButton *arrowButton;
    
    NSString *search_wordsStr;
    
    //老师 xid
    NSMutableArray *teacherXidArray;
    //管理人员 Xid
    NSMutableArray *managerXidArray;
    
    NSString *parameterXid;
    NSString *parameterUser_Id;
}
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *flagArray;
@property(nonatomic,strong)UISearchBar *searchBar;
@property(nonatomic,strong)UISearchController *searchDC;
@property (nonatomic, strong) NSMutableArray *contactArraytemp; //从数据库读取的contacts数据
@property (nonatomic, strong) NSMutableArray *allArray;  // 包含空数据的contactsArray
@property (nonatomic, strong) NSMutableArray *indexTitles;

@property (nonatomic, assign) BOOL flagShow;
@property (nonatomic, strong) UIImageView *placeholderImageView;


@end

@implementation ClassTelephoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    _flagShow = NO;
    
    self.title =@"班级通讯录";
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }

    KTAgeMArr =[[NSMutableArray alloc]init];
    KTHead_imgMArr =[[NSMutableArray alloc]init];
    KTTnameMArr =[[NSMutableArray alloc]init];
    headTitleArr =[[NSMutableArray alloc]init];
    KTparent_listMArr =[[NSMutableArray alloc]init];
    KTIDMArr =[[NSMutableArray alloc]init];
    
    teacherXidArray =  [[NSMutableArray alloc] init];
    managerXidArray = [[NSMutableArray alloc] init];
    
    
    _showDic =[[NSDictionary alloc]initWithObjectsAndKeys:@"班级宝贝",@"baby_info",@"班级老师",@"teacher",@"管理员",@"manager",nil];
    
    self.flagArray = [[NSMutableArray alloc]init];
    for (int j=0; j<3; j++) {
        NSNumber *flagN = [NSNumber numberWithBool:YES];
        [self.flagArray addObject:flagN];
    }
    [self loadMoreData];
    [self createRightBar];
    [self createTableView];
}
//创建tableView
-(void)createTableView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
}

#pragma mark UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return KTAgeMArr.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
        if ([self.flagArray[section] boolValue] == YES) {
            return [KTAgeMArr[section] count];
        }else{
            return 0;
        }

}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    KTelephoneCell *cell =(KTelephoneCell*)[tableView dequeueReusableCellWithIdentifier:KPATA];
    
    if (cell == nil) {
        NSArray *nib =[[NSBundle mainBundle]loadNibNamed:KPATA owner:[KTelephoneCell class] options:nil];
        cell =(KTelephoneCell*)[nib objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
    }
    
    if ([KTHead_imgMArr[indexPath.section][indexPath.row] hasPrefix:@"http:"]) {
        [cell.headImgV sd_setImageWithURL:[NSURL URLWithString:KTHead_imgMArr[indexPath.section][indexPath.row]] placeholderImage:[UIImage imageNamed:@"人物头像占位图136x136@2x"]];
    }
    else{
        [cell.headImgV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",picURL,KTHead_imgMArr[indexPath.section][indexPath.row]]] placeholderImage:[UIImage imageNamed:@"人物头像占位图136x136@2x"]];
    }
    
    cell.headImgV.layer.cornerRadius = cell.headImgV.size.width / 2;
    cell.headImgV.layer.masksToBounds = YES;
    cell.headImgV.userInteractionEnabled =YES;
    
    if (indexPath.section ==0) {
        UITapGestureRecognizer *iconTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(iconTap:)];
        cell.headImgV.tag =100+indexPath.row;
        [cell.headImgV addGestureRecognizer:iconTap];
        
        cell.titleLbl.text = KTTnameMArr[indexPath.section][indexPath.row];
        cell.detailLbl.textColor =UIColorFromRGB(166, 166, 166);
        
        cell.detailLbl.text = [NSString stringWithFormat:@"%@岁",KTAgeMArr[indexPath.section][indexPath.row]];
    }
    else{
        cell.lookFLBl.hidden =YES;
        cell.titleLbl.text = KTTnameMArr[indexPath.section][indexPath.row];
        cell.detailLbl.textColor =UIColorFromRGB(166, 166, 166);
        
        cell.detailLbl.text = KTAgeMArr[indexPath.section][indexPath.row];
    }
    
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    view.backgroundColor = [UIColor whiteColor];
    view.userInteractionEnabled = YES;
    
    view.tag = 100 + section;
    
    UITapGestureRecognizer *viewPress = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewPressClick:)];
    [view addGestureRecognizer:viewPress];
    
    arrowButton = [[UIButton alloc]initWithFrame:CGRectMake(10, (40-12)/2, 12, 12)];
    NSNumber *flagN = self.flagArray[section];
    
    if ([flagN boolValue]) {
        [arrowButton setBackgroundImage:[UIImage imageNamed:@"narrow_icon"] forState:UIControlStateNormal];
        CGAffineTransform currentTransform =arrowButton.transform;
        CGAffineTransform newTransform =CGAffineTransformRotate(currentTransform, M_PI/2);
        arrowButton.transform =newTransform;
        
    }else
    {
        [arrowButton setBackgroundImage:[UIImage imageNamed:@"narrow_icon"] forState:UIControlStateNormal ];
        
    }
    arrowButton.tag = 300+section;
    //    [arrowButton addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:arrowButton];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(30, 5, 200 * kWidth / 375, 30)];
    label.text = [NSString stringWithFormat:@"%@",headTitleArr[section]];
    label.textColor = [UIColor lightGrayColor];
    label.font = [UIFont boldSystemFontOfSize:16 * kWidth / 375];
    [view addSubview:label];
    
    //线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 39, kWidth, 1)];
    lineView.backgroundColor = UIColorFromRGB(229, 232, 233);
    [view addSubview:lineView];
    
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80;
}

- (void)viewPressClick:(UITapGestureRecognizer *)press{
    
    //    NSLog(@" 头视图  tag  %ld", press.view.tag - 100);
    
    if ([self.flagArray[press.view.tag - 100] boolValue]) {
        [self.flagArray replaceObjectAtIndex:(press.view.tag - 100) withObject:[NSNumber  numberWithBool:NO]];
        
    }else{
        [self.flagArray replaceObjectAtIndex:(press.view.tag - 100) withObject:[NSNumber numberWithBool:YES]];
    }
    [self.tableView reloadData ];
    
    
}
//返回每个分组的表头视图的高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0000001;
}

- (void)createRightBar{
    UIBarButtonItem *searchBar = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"NavBarIconSearch_blue@2x"] style:UIBarButtonItemStylePlain target:self action:@selector(searchB:)];
    self.navigationItem.rightBarButtonItem =searchBar;
}
- (void)searchB:(UIBarButtonItem*)btn{
    
//    _flagShow = !_flagShow;
    
    if ([XXEUserInfo user].login){
        _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0,20, kWidth, 44)];
        UIImage *backgroundImg = [UtilityFunc createImageWithColor:UIColorFromHex(0xf0eaf3) size:_searchBar.frame.size];
        [_searchBar setBackgroundImage:backgroundImg];
        _searchBar.placeholder =@"输入你想要查询的联系人";
        _searchBar.tintColor = [UIColor blackColor];
        _searchBar.delegate =self;
        _searchDC = [[UISearchController alloc]initWithSearchResultsController:self];
        [self.navigationItem.titleView sizeToFit];
        [self.navigationController.view addSubview:_searchBar];
        _searchBar.showsCancelButton =YES;
    }else{
    [SVProgressHUD showInfoWithStatus:@"请用账号登录后查看"];
    }

}

- (void)loadMoreData{
    
    [KTAgeMArr removeAllObjects];
    [KTHead_imgMArr removeAllObjects];
    [KTTnameMArr removeAllObjects];
    [headTitleArr removeAllObjects];
    [KTparent_listMArr removeAllObjects];
    [KTIDMArr removeAllObjects];
    /*
     【班级通讯录】
     接口:
     http://www.xingxingedu.cn/Parent/class_contact_book
     传参:
     school_id	//学校id
     class_id
     search_words	//搜索关键词
     */

    NSString *urlStr = @"http://www.xingxingedu.cn/Global/class_contact_book";
    NSString *schoolIdStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"SCHOOL_ID"];
    NSString *class_idStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"CLASS_ID"];
    
    if (search_wordsStr == nil) {
        search_wordsStr = @"";
    }else{
        [_flagArray removeAllObjects];
        for (int j=0; j<3; j++) {
            NSNumber *flagN = [NSNumber numberWithBool:YES];
            [_flagArray addObject:flagN];
        }
    }
    
    NSDictionary *dictKT = @{@"appkey":APPKEY,
                             @"backtype":BACKTYPE,
                             @"xid":parameterXid,
                             @"user_id":parameterUser_Id,
                             @"user_type":USER_TYPE,
                             @"school_id":schoolIdStr,
                             @"class_id":class_idStr,
                             @"search_words":search_wordsStr
                             };
    
    [WZYHttpTool post:urlStr params:dictKT success:^(id responseObj) {
        NSDictionary * dict =responseObj;

        if([[NSString stringWithFormat:@"%@",dict[@"code"]]isEqualToString:@"1"])
        {
            
//            NSLog(@"data===========================%@",dict[@"data"]);
            for (NSString *key in dict[@"data"]) {
                [headTitleArr addObject:[_showDic objectForKey:[NSString stringWithFormat:@"%@",key]]];
                
                ageMArr=[[NSMutableArray alloc]init];
                head_imgMArr =[[NSMutableArray alloc]init];
                tnameMArr =[[NSMutableArray alloc]init];
                parent_listMArr =[[NSMutableArray alloc]init];
                idMArr =[[NSMutableArray alloc]init];
                if ([key isEqualToString:@"baby_info"]) {
                    
                    //宝贝
                    NSArray *babyInfoArray = [NSArray arrayWithArray:dict[@"data"][@"baby_info"]];
                    
                    for (int i=0; i<[babyInfoArray count]; i++) {
                        [ageMArr addObject:babyInfoArray[i][@"age"]];
                        [head_imgMArr addObject:[babyInfoArray[i] objectForKey:@"head_img"]];
                        [tnameMArr addObject:[babyInfoArray[i] objectForKey:@"tname"]];
                        [parent_listMArr addObject:[babyInfoArray[i] objectForKey:@"parent_list"]];
                        [idMArr addObject:[babyInfoArray[i] objectForKey:@"id"]];
                        
                        
                    }
                    
                    [KTAgeMArr addObject:ageMArr];
                    [KTHead_imgMArr addObject:head_imgMArr];
                    [KTTnameMArr addObject:tnameMArr];
                    [KTparent_listMArr addObject:parent_listMArr];
                    [KTIDMArr addObject:idMArr];
                    
                }
                else if ([key isEqualToString:@"manager"]){
                    
                    //管理人员
                    
                    NSArray *managerArray = [NSArray arrayWithArray:dict[@"data"][@"manager"]];
                    
                    for (int i=0; i<[managerArray count]; i++) {
                        [ageMArr addObject:[managerArray[i] objectForKey:@"teach_course"]];
                        [head_imgMArr addObject:[managerArray[i] objectForKey:@"head_img"]];
                        [tnameMArr addObject:[managerArray[i] objectForKey:@"tname"]];
                        [parent_listMArr addObject:[managerArray[i] objectForKey:@"id"]];
                        
                        [managerXidArray addObject:[managerArray[i] objectForKey:@"xid"]];
                        
                    }
                    [KTAgeMArr addObject:ageMArr];
                    [KTHead_imgMArr addObject:head_imgMArr];
                    [KTTnameMArr addObject:tnameMArr];
                    [KTparent_listMArr addObject:parent_listMArr];
                    
                }
                else if ([key isEqualToString:@"teacher"]) {
                    
                    //老师
                    
                    NSArray *teacherArray = [NSArray arrayWithArray:dict[@"data"][@"teacher"]];
                    
                    for (int i=0; i<[teacherArray count]; i++) {
                        [ageMArr addObject:[teacherArray[i] objectForKey:@"teach_course"]];
                        [head_imgMArr addObject:[teacherArray[i] objectForKey:@"head_img"]];
                        [tnameMArr addObject:[teacherArray[i] objectForKey:@"tname"]];
                        [parent_listMArr addObject:[teacherArray[i] objectForKey:@"id"]];
                        
                        [teacherXidArray addObject:[teacherArray[i] objectForKey:@"xid"]];
                        
                    }
                    [KTAgeMArr addObject:ageMArr];
                    [KTHead_imgMArr addObject:head_imgMArr];
                    [KTTnameMArr addObject:tnameMArr];
                    [KTparent_listMArr addObject:parent_listMArr];
                    
                }
                
            }
            
        }
        
        [self customContentView];
//        NSLog(@"hhhh   --  %@", KTTnameMArr);
    } failure:^(NSError *error) {
        
    }];
    
}


// 有数据 和 无数据 进行判断
- (void)customContentView{
    
    if (KTTnameMArr.count == 0) {
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        // 1、无数据的时候
        [self createPlaceholderView];
        
    }else{
        
    }
    
    [_tableView reloadData];
}


//没有 数据 时,创建 占位图
- (void)createPlaceholderView{
    
    // 1、无数据的时候
    UIImage *myImage = [UIImage imageNamed:@"人物"];
    CGFloat myImageWidth = myImage.size.width;
    CGFloat myImageHeight = myImage.size.height;
    
    _placeholderImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kWidth / 2 - myImageWidth / 2, (kHeight - 64 - 49) / 2 - myImageHeight / 2, myImageWidth, myImageHeight)];
    _placeholderImageView.image = myImage;
    [self.view addSubview:_placeholderImageView];
}



- (void)iconTap:(UITapGestureRecognizer*)tap{
   // NSLog(@">>>>>>>>>>>>>>tapViewTag>>>>>>>>>>>>>>>>>>>>>%ld",tap.view.tag);
   if ([XXEUserInfo user].login){
    KTClassTelephoneBabyViewController *telephoneBabyVC =[[KTClassTelephoneBabyViewController alloc]init];
    telephoneBabyVC.idKT =KTIDMArr[0][tap.view.tag-100];
    [self.navigationController pushViewController:telephoneBabyVC animated:NO];
}else{
    [SVProgressHUD showInfoWithStatus:@"请用账号登录后查看"];
 }
    
}


- (void)ReturnTextBlock:(ReturnTextBlock)block{
    self.textblock =block;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([XXEUserInfo user].login){
        if (self.isFlowerView==YES||self.isComment==YES) {
            self.textblock(@"李伟");
            [self.navigationController popViewControllerAnimated:YES];
        }else if (indexPath.section==0){
            HomeInfoViewController *infoVC = [[HomeInfoViewController alloc]init];
            infoVC.isRCIM = self.isRCIM;
            //传递家庭数组
            infoVC.familyMArr =KTparent_listMArr[indexPath.section][indexPath.row];
            // NSLog(@">>>>>>>>>>>>>>familyMArr>>>>>>>>>>>>>>>>>>>>>>>%@",infoVC.familyMArr);
            
            [self.navigationController pushViewController:infoVC animated:YES];
        }else if (indexPath.section==1){
            //老师
            if(self.isRCIM==YES){
                //从聊天界面 过来 添加 好友
                //被选中 老师 的xid
                NSString *teacherXid = teacherXidArray[indexPath.row];
                [self addFriendRequestNotice:teacherXid];
            }else{
                //进入老师详情
                TeleTeachInfoViewController *teleTeachVC =[[TeleTeachInfoViewController alloc]init];
                teleTeachVC.teacherId =KTparent_listMArr[indexPath.section][indexPath.row];
                teleTeachVC.teacherXid = teacherXidArray[indexPath.row];
                //            NSLog(@" ggggg   %@", teacherXidArray[indexPath.row]);
                [self.navigationController pushViewController:teleTeachVC animated:NO];
            }
        }else if (indexPath.section==2){
            //管理人员
            if(self.isRCIM==YES){
                //从聊天界面 过来 添加 好友
                //被选中 管理员 的xid
                NSString *managerXid = managerXidArray[indexPath.row];
                [self addFriendRequestNotice:managerXid];
            }else{
                TeleTeachInfoViewController *teleTeachVC =[[TeleTeachInfoViewController alloc]init];
                teleTeachVC.teacherId =KTparent_listMArr[indexPath.section][indexPath.row];
                teleTeachVC.managerXid = managerXidArray[indexPath.row];
                //            NSLog(@"%@", managerXidArray[indexPath.row]);
                [self.navigationController pushViewController:teleTeachVC animated:NO];
            }
            
        }

    }else{
        [SVProgressHUD showInfoWithStatus:@"请用账号登录后查看"];
    }
}

- (void)addFriendRequestNotice:(NSString *)otherXid{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"添加好友" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        //
        textField.placeholder = @"申请备注";
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //
        [self requestAddFriend:otherXid];
    }];
    [alert addAction:cancel];
    [alert addAction:ok];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}


- (void)requestAddFriend:(NSString *)otherXidStr{
    
    //路径
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/action_friend_request";
    NSDictionary *params = @{@"appkey":APPKEY, @"backtype":BACKTYPE, @"xid":parameterXid, @"user_id":parameterUser_Id, @"user_type":USER_TYPE, @"other_xid":otherXidStr};
    
    //    NSLog(@"%@", params);
    
    [WZYHttpTool post:urlStr params:params success:^(id responseObj) {
        //        NSLog(@"搜索 人  返回值%@", responseObj);
        
        NSString *str = [NSString stringWithFormat:@"%@", responseObj[@"code"]];
        
        if ([str isEqualToString:@"1"]) {
            
            [SVProgressHUD showInfoWithStatus:@"请求成功,等待对方同意!"];
            
        }else if ([str isEqualToString:@"4"]) {
            [SVProgressHUD showInfoWithStatus:@"不能请求自己!"];
            
        }else if ([str isEqualToString:@"5"]){
            
            [SVProgressHUD showInfoWithStatus:@"已经是好友了(不能对好友发起请求)!"];
            
        }else if ([str isEqualToString:@"6"]){
            
            [SVProgressHUD showInfoWithStatus:@"对方在我的黑名单中,无法发起请求!"];
            
        }else if ([str isEqualToString:@"7"]){
            
            [SVProgressHUD showInfoWithStatus:@"您已经在对方黑名单中,无法发起请求!"];
            
        }else if ([str isEqualToString:@"8"]){
            
            [SVProgressHUD showInfoWithStatus:@"不能重复对同一个人发起请求!"];
            
        }else if ([str isEqualToString:@"9"]){
            
            [SVProgressHUD showInfoWithStatus:@"对方已同意,可以直接聊天了!"];
            
        }
        
    } failure:^(NSError *error) {
        //
        NSLog(@"%@", error);
    }];}



-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    //搜尋結束後，恢復原狀
    return YES;
}
#pragma mark - search bar delegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    _searchBar.showsCancelButton = YES;
    
    return YES;
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    search_wordsStr = _searchBar.text;
    
    [self loadMoreData];
    
    [searchBar resignFirstResponder];
    
    [searchBar removeFromSuperview];

}


- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    
    searchBar.showsCancelButton = NO;
    [searchBar resignFirstResponder];
    [searchBar removeFromSuperview];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_searchBar endEditing:YES];
}
- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden =NO;
    self.navigationController.navigationBar.barTintColor =UIColorFromRGB(0, 170, 42);
}
- (void)viewWillDisappear:(BOOL)animated{
    
    _searchBar.text=nil;
    _searchBar.showsCancelButton = NO;
    [_searchBar resignFirstResponder];
}


@end
