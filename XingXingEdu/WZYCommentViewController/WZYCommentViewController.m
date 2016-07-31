


//
//  WZYCommentViewController.m
//  XingXingEdu
//
//  Created by Mac on 16/6/2.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

//#import "WZYCommentViewController.h"
//
//@interface WZYCommentViewController ()
//
//@end
//
//@implementation WZYCommentViewController
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    // Do any additional setup after loading the view.
//}

#import "WZYCommentViewController.h"
#define KPATA @"KTelephoneCell"
#define kPData     @"ClassTelephoneCell"
#import "macrodefine.h"
//#import "ClassTelephoneCell.h"
#import "TeleViewController.h"
#import "HomeInfoViewController.h"
#import "TeleTeachInfoViewController.h"
//ceshi
#import "Friend.h"
#import "FriendGroup.h"
#import "HeadView.h"
#import "SVProgressHUD.h"
#import "UtilityFunc.h"
#import "KTelephoneCell.h"


@interface WZYCommentViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,HeadViewDelegate>
{
    UITableView *_telTabView;
    NSMutableArray *_telArray;
    NSArray *sections;
    NSArray *_friendsData;
    //ceshi
    UITableView *_tableView;
    NSArray *tempArray;
}
@property(nonatomic,strong)UISearchBar *searchBar;
@property(nonatomic,strong)UISearchController *searchDC;
@property (nonatomic, strong) NSMutableArray *contactArraytemp; //从数据库读取的contacts数据
@property (nonatomic, strong) NSMutableArray *allArray;  // 包含空数据的contactsArray  // 核心数据
@property (nonatomic, strong) NSMutableArray *indexTitles;
//请求点评 老师 数组
@property (nonatomic, strong) NSMutableArray *teacherArray;
//请求点评 管理人员 数组
@property (nonatomic, strong) NSMutableArray *managerArray;

/*
 tname = 姜兰兰,
 teach_course = 英语,
 tid = 15,
 head_img = app_upload/text/teacher/15.jpg,
 head_img_type = 0
 */
@property (nonatomic, strong) NSMutableArray *tnameArray;
@property (nonatomic, strong) NSMutableArray *teach_courseArray;
@property (nonatomic, strong) NSMutableArray *tidArray;
@property (nonatomic, strong) NSMutableArray *head_imgArray;
@property (nonatomic, strong) NSMutableArray *head_img_typeArray;


@end

@implementation WZYCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.title =@"班级通讯录";
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColorFromRGB(229, 232, 233);
    
    [self.navigationController.navigationBar setTintColor:UIColorFromRGB(255, 255, 255)];
    [self createTableView];
    [self loadData];
    [self createRightBar];
    
}
- (void)createRightBar{
    UIBarButtonItem *searchBar = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"NavBarIconSearch_blue@2x"] style:UIBarButtonItemStylePlain target:self action:@selector(searchB:)];
    self.navigationItem.rightBarButtonItem =searchBar;
}
- (void)searchB:(UIBarButtonItem*)btn{
    
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
    
}

#pragma mark 加载数据//KTteacher
- (void)loadData
{
    
/*
    【老师点评--单个孩子的班级教师通讯录(只有老师)】
    
    接口:
http://www.xingxingedu.cn/Parent/class_teacher_msg_book
    
    传参:
    school_id 	//学校id
    grade		//年级
    class		//班级
 
    */
    
//    //路径
    NSString *urlStr = @"http://www.xingxingedu.cn/Parent/class_teacher_msg_book";
//
//    //请求参数
//从首页 获取
    NSString *schoolID = [[NSUserDefaults standardUserDefaults] objectForKey:@"SCHOOL_ID"];
     NSString *gradeStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"GRADE"];
     NSString *classStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"CLASS"];
    
//    NSLog(@"aaaa///////////schoolID----%@; gradeStr------%@; classStr------%@", schoolID, gradeStr, classStr);
    
    NSDictionary *params = @{@"appkey":APPKEY, @"backtype":BACKTYPE, @"xid":XID, @"user_id":USER_ID, @"user_type":USER_TYPE, @"school_id":schoolID  , @"grade": gradeStr , @"class": classStr };

    [WZYHttpTool post:urlStr params:params success:^(id responseObj) {
        //
        _teacherArray = [[NSMutableArray alloc] init];
        _managerArray = [[NSMutableArray alloc] init];
        
        _tnameArray = [[NSMutableArray alloc] init];
        _teach_courseArray = [[NSMutableArray alloc] init];
        _tidArray = [[NSMutableArray alloc] init];
        _head_imgArray = [[NSMutableArray alloc] init];
        _head_img_typeArray = [[NSMutableArray alloc] init];
        
//        NSLog(@"请求老师点评++++++++=======----------%@", responseObj);
        
        NSDictionary *dic = responseObj[@"data"];
        
        NSString *codeStr = [NSString stringWithFormat:@"%@", responseObj[@"code"]];
        
        if ([codeStr isEqualToString:@"1"]) {
            _teacherArray = dic[@"teacher"];
            
            _managerArray = dic[@"manage"];
            
            /*
             {
             tname = 姜兰兰,
             teach_course = 英语,
             tid = 15,
             head_img = app_upload/text/teacher/15.jpg,
             head_img_type = 0
             }
             */
            for (NSDictionary *dicItem in _teacherArray) {
                NSString *tnameStr = dicItem[@"tname"];
                [_tnameArray addObject:tnameStr];

                NSString *teach_courseStr = dicItem[@"teach_course"];
                [_teach_courseArray addObject:teach_courseStr];
                
                NSString *tidStr = dicItem[@"tid"];
                [_tidArray addObject:tidStr];
                
                                //                0 :表示 自己 头像 ，需要添加 前缀
                                //                1 :表示 第三方 头像 ，不需要 添加 前缀
                                //判断是否是第三方头像
               NSString * head_img;
               if([[NSString stringWithFormat:@"%@",dic[@"head_img_type"]]isEqualToString:@"0"]){
                head_img=[picURL stringByAppendingString:dic[@"head_img"]];
                }else{
                head_img=dic[@"head_img"];
                }
                [_head_imgArray addObject:head_img];
    
            }
            
        }else{
        
        
        }
        
    } failure:^(NSError *error) {
        //
        NSLog(@"%@", error);
    }];
    
//    [WZYHttpTool post:urlStr params:params success:^(id responseObj) {
//        
//        iconImageViewArray = [[NSMutableArray alloc] init];
//        nameArray = [[NSMutableArray alloc] init];
//        contentArray = [[NSMutableArray alloc] init];
//        timeArray = [[NSMutableArray alloc] init];
//        idArray = [[NSMutableArray alloc] init];
//        //
//        //                        NSLog(@"（（（（（（（（（（%@", responseObj);
//        /*
//         (
//         {
//         "baby_id" = 1;
//         con = "\U5f88\U597d";
//         "date_tm" = 1464931533;
//         "head_img" = "app_upload/text/teacher/1.jpg";
//         "head_img_type" = 0;
//         id = 3;
//         "teacher_tname" = "\U6881\U7ea2\U6c34";
//         tid = 1;
//         },
//         
//         */
//        NSArray *dataSource = responseObj[@"data"];
//        
//        NSString *codeStr = [NSString stringWithFormat:@"%@", responseObj[@"code"]];
//        
//        if ([codeStr isEqualToString:@"1"]) {
//            
//            for (NSDictionary *dic in dataSource) {
//                
//                //                0 :表示 自己 头像 ，需要添加 前缀
//                //                1 :表示 第三方 头像 ，不需要 添加 前缀
//                //判断是否是第三方头像
//                NSString * head_img;
//                if([[NSString stringWithFormat:@"%@",dic[@"head_img_type"]]isEqualToString:@"0"]){
//                    head_img=[picURL stringByAppendingString:dic[@"head_img"]];
//                }else{
//                    head_img=dic[@"head_img"];
//                }
//**********************************************************************
    
    

        NSURL *url = [[NSBundle mainBundle] URLForResource:@"KTteacher.plist" withExtension:nil];
        tempArray = [NSArray arrayWithContentsOfURL:url];
    
    NSMutableArray *fgArray = [NSMutableArray array];
    for (NSDictionary *dict in tempArray) {
        FriendGroup *friendGroup = [FriendGroup friendGroupWithDict:dict];
        [fgArray addObject:friendGroup];
    }
    
    _friendsData = fgArray;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//    return _friendsData.count;
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    FriendGroup *friendGroup = _friendsData[section];
    NSInteger count = friendGroup.isOpened ? friendGroup.friends.count : 0;
    return count;
    
//    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KTelephoneCell *cell =(KTelephoneCell*)[tableView dequeueReusableCellWithIdentifier:KPATA];
    
    if (cell == nil) {
        NSArray *nib =[[NSBundle mainBundle]loadNibNamed:KPATA owner:[KTelephoneCell class] options:nil];
        cell =(KTelephoneCell*)[nib objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    FriendGroup *friendGroup = _friendsData[indexPath.section];
    Friend *friend = friendGroup.friends[indexPath.row];
    cell.lookFLBl.hidden = YES;
    cell.headImgV.image = [UIImage imageNamed:friend.icon];
    cell.titleLbl.textColor = friend.isVip ? [UIColor   orangeColor] : [UIColor blackColor];
    cell.titleLbl.text = friend.name;
    cell.detailLbl.textColor =UIColorFromRGB(166, 166, 166);
    cell.detailLbl.text = friend.intro;
    return cell;
    
//    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    HeadView *headView = [HeadView headViewWithTableView:tableView];
    
    headView.delegate = self;
    headView.friendGroup = _friendsData[section];
    
    return headView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//   UITableViewCell *cell = (UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath.row];

    FriendGroup *friendGroup = _friendsData[indexPath.section];
    Friend *friend = friendGroup.friends[indexPath.row];
    self.returnCommentIconBlock(friend.icon);
    self.returnCommentNameBlock(friend.name);
    
    if (self.isFlowerView==YES||self.isComment==YES) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if(self.isRCIM==YES){
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"添加好友" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
        [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            
            //        textField.backgroundColor = [UIColor orangeColor];
            textField.placeholder=@"申请备注";
        }];
        UIAlertAction *cancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *ok=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [SVProgressHUD showSuccessWithStatus:@"添加成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }];
        [alert addAction:ok];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else  if (indexPath.section==1) {
        HomeInfoViewController *infoVC = [[HomeInfoViewController alloc]init];
        
        [self.navigationController pushViewController:infoVC animated:YES];
        
        
    }
    else if (indexPath.section ==2){
        //            TeleViewController *teleVC = [[TeleViewController alloc] init];
        //            teleVC.name = friend.name;
        //            teleVC.telephone = friend.intro;
        //            teleVC.imagStr =friend.icon;
        //            teleVC.index =0;
        //            [self.navigationController pushViewController:teleVC animated:YES];
        TeleTeachInfoViewController *teleTeachVC =[[TeleTeachInfoViewController alloc]init];
        [self.navigationController pushViewController:teleTeachVC animated:YES];
        
        
    }
    else{
        //            TeleViewController *teleVC = [[TeleViewController alloc] init];
        //            teleVC.name = friend.name;
        //            teleVC.telephone = friend.intro;
        //            teleVC.imagStr =friend.icon;
        //            teleVC.index =0;
        //            [self.navigationController pushViewController:teleVC animated:YES];
        
        
        
        TeleTeachInfoViewController *teleTeachVC =[[TeleTeachInfoViewController alloc]init];
        [self.navigationController pushViewController:teleTeachVC animated:YES];
        
        
    }
    
}

- (void)clickHeadView
{
    [_tableView reloadData];
}

- (void) createTableView{
    //self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -44, kWidth,kHeight+44) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_telTabView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"telCell"];
    [self.view addSubview: _tableView];
}

- (void)returnText:(ReturnCommentNameBlock)block{
    self.returnCommentNameBlock =block;
}

- (void)returnIcon:(ReturnCommentIconBlock)block{
    self.returnCommentIconBlock = block;
}

//测试
// searchbar 点击上浮，完毕复原
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
    // self.navigationController.navigationBar.barTintColor =UIColorFromRGB(248, 248, 248);
    _searchBar.text=nil;
    _searchBar.showsCancelButton = NO;
    [_searchBar resignFirstResponder];
}

@end
