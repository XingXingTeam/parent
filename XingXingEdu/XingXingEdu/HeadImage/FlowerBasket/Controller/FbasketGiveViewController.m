//
//  FbasketGiveViewController.m
//  XingXingEdu
//
//  Created by keenteam on 16/6/6.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "FbasketGiveViewController.h"



#define KPATA @"FbasketCell"
#define kPData     @"ClassTelephoneCell"
#import "macrodefine.h"
//#import "ClassTelephoneCell.h"
#import "TeleViewController.h"
#import "HomeInfoViewController.h"
#import "TeleTeachInfoViewController.h"
#import "WZYBabyCenterViewController.h"
//ceshi
#import "Friend.h"
#import "FriendGroup.h"
#import "HeadView.h"
#import "SVProgressHUD.h"
#import "UtilityFunc.h"
#import "FbasketCell.h"
@interface FbasketGiveViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,HeadViewDelegate>
{
    UITableView *_telTabView;
    NSMutableArray *_telArray;
    NSArray *sections;
    NSArray *_friendsData;
    //ceshi
    UITableView *_tableView;
    NSArray *tempArray;
    NSMutableArray *KTAgeMArr;
    NSMutableArray *KTHead_imgMArr;
    NSMutableArray *KTTnameMArr;
    NSMutableArray *KTparent_listMArr;
    
    NSMutableArray *headTitleArr;
    NSMutableArray *KTIDMArr;
    NSDictionary *_showDic;
    
    NSMutableArray * ageMArr;
    NSMutableArray * head_imgMArr;
    NSMutableArray * parent_listMArr;
    NSMutableArray * tnameMArr;
    NSMutableArray * idMArr;
    NSString *parameterXid;
    NSString *parameterUser_Id;
    
    
}
@property(nonatomic,strong)UISearchBar *searchBar;
@property(nonatomic,strong)UISearchController *searchDC;
@property (nonatomic, strong) NSMutableArray *contactArraytemp; //从数据库读取的contacts数据
@property (nonatomic, strong) NSMutableArray *allArray;  // 包含空数据的contactsArray  // 核心数据
@property (nonatomic, strong) NSMutableArray *indexTitles;
@end

@implementation FbasketGiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }
    self.title =@"班级通讯录";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = UIColorFromRGB(229, 232, 233);
    KTAgeMArr =[[NSMutableArray alloc]init];
    KTHead_imgMArr =[[NSMutableArray alloc]init];
    KTTnameMArr =[[NSMutableArray alloc]init];
    headTitleArr =[[NSMutableArray alloc]init];
    KTparent_listMArr =[[NSMutableArray alloc]init];
    KTIDMArr =[[NSMutableArray alloc]init];
    _showDic =[[NSDictionary alloc]initWithObjectsAndKeys:@"班级老师",@"teacher",@"管理员",@"manager",nil];
    
    [self.navigationController.navigationBar setTintColor:UIColorFromRGB(255, 255, 255)];
    [self loadNetData];
    [self createTableView];
    
}

#pragma mark ======== 【猩猩商城--花篮转增下的通讯录(针对某个班级的)】====
- (void)loadNetData{
/*
 接口类型:1
 接口:
 http://www.xingxingedu.cn/Global/fbasket_give_teacher
 传参:
	school_id	//学校id
	class_id	//班级id
 */
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/fbasket_give_teacher";
    
    NSString *schoolID = [DEFAULTS objectForKey:@"SCHOOL_ID"];
    NSString *classID = [DEFAULTS objectForKey:@"CLASS_ID"];
    
    NSDictionary *dictKT = @{@"appkey":APPKEY,
                             @"backtype":BACKTYPE,
                             @"xid":parameterXid,
                             @"user_id":parameterUser_Id,
                             @"user_type":USER_TYPE,
                             @"school_id":schoolID,
                             @"class_id":classID,
                             };
    
  [WZYHttpTool post:urlStr params:dictKT success:^(id responseObj) {
      NSDictionary * dict =responseObj;
      
      if([[NSString stringWithFormat:@"%@",dict[@"code"]]isEqualToString:@"1"])
     {
         
         NSLog(@"data=============%@",dict[@"data"]);
         
         
             ageMArr=[[NSMutableArray alloc]init];
             head_imgMArr =[[NSMutableArray alloc]init];
             tnameMArr =[[NSMutableArray alloc]init];
             parent_listMArr =[[NSMutableArray alloc]init];
             idMArr =[[NSMutableArray alloc]init];

             
                 for (int i=0; i<[dict[@"data"][@"teacher"] count]; i++) {
                     [ageMArr addObject:[dict[@"data"][@"teacher"][i] objectForKey:@"teach_course"]];
                     [head_imgMArr addObject:[dict[@"data"][@"teacher"][i] objectForKey:@"head_img"]];
                     [tnameMArr addObject:[dict[@"data"][@"teacher"][i] objectForKey:@"tname"]];
                     [parent_listMArr addObject:[dict[@"data"][@"teacher"][i] objectForKey:@"id"]];
                 }
                 [KTAgeMArr addObject:ageMArr];
                 [KTHead_imgMArr addObject:head_imgMArr];
                 [KTTnameMArr addObject:tnameMArr];
                 [KTparent_listMArr addObject:parent_listMArr];
         
         
     }
      
      [_tableView reloadData];
    
  } failure:^(NSError *error) {
      
  }];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return KTAgeMArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ageMArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FbasketCell *cell =(FbasketCell*)[tableView dequeueReusableCellWithIdentifier:KPATA];
    
    if (cell == nil) {
        NSArray *nib =[[NSBundle mainBundle]loadNibNamed:KPATA owner:[FbasketCell class] options:nil];
        cell =(FbasketCell*)[nib objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    
    if ([KTHead_imgMArr[indexPath.section][indexPath.row] hasPrefix:@"http:"]) {
        [cell.headImgV sd_setImageWithURL:[NSURL URLWithString:KTHead_imgMArr[indexPath.section][indexPath.row]] placeholderImage:[UIImage imageNamed:@"人物头像占位图136x136@2x"]];
    }
    else{
        [cell.headImgV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",picURL,KTHead_imgMArr[indexPath.section][indexPath.row]]] placeholderImage:[UIImage imageNamed:@"人物头像占位图136x136@2x"]];
    }

    cell.titleLbl.text = KTTnameMArr[indexPath.section][indexPath.row];
    cell.detailLbl.textColor =UIColorFromRGB(166, 166, 166);
    cell.detailLbl.text = KTAgeMArr[indexPath.section][indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
- ( NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;{
    
    return[NSString stringWithFormat:@"班级老师"];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}
- (void)ReturnTextBlock:(ReturnTextBlock)block{
    self.textblock =block;
}
- (void)ReturnIDBlock:(ReturnIDBlock)block{
    self.idblock =block;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (self.isFlowerView==YES||self.isComment==YES) {
        self.textblock(KTTnameMArr[indexPath.section][indexPath.row]);
        self.idblock(KTparent_listMArr[indexPath.section][indexPath.row]);
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if(self.isRCIM==YES){
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"添加好友" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
        [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            
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
        
        TeleTeachInfoViewController *teleTeachVC =[[TeleTeachInfoViewController alloc]init];
        [self.navigationController pushViewController:teleTeachVC animated:YES];
        
    }
    else{
        
        TeleTeachInfoViewController *teleTeachVC =[[TeleTeachInfoViewController alloc]init];
        [self.navigationController pushViewController:teleTeachVC animated:YES];
        
    }
    
}

- (void)clickHeadView
{
    [_tableView reloadData];
}

- (void) createTableView{

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth,kHeight - 30) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_telTabView registerClass:[UITableViewCell class] forCellReuseIdentifier:KPATA];
    [self.view addSubview: _tableView];
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

    _searchBar.text=nil;
    _searchBar.showsCancelButton = NO;
    [_searchBar resignFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
