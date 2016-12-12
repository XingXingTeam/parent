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
#import "XXEClassAddressTeacherInfoModel.h"
#import "XXEClassAddressManagerInfoModel.h"



@interface FbasketGiveViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,HeadViewDelegate>
{

    UITableView *_tableView;
    
    //数据源
    NSMutableArray *dataSourceArray;
    NSArray *title_nameArray;
    UIButton *arrowButton;

    NSString *parameterXid;
    NSString *parameterUser_Id;
    
    
}
@property (nonatomic,strong) NSMutableArray *flagArray;
@property(nonatomic,strong)UISearchBar *searchBar;
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
    dataSourceArray = [[NSMutableArray alloc] init];
    self.flagArray = [[NSMutableArray alloc]init];
    for (int j=0; j<2; j++) {
        NSNumber *flagN = [NSNumber numberWithBool:YES];
        [self.flagArray addObject:flagN];
    }
    title_nameArray = [[NSArray alloc] initWithObjects:@"班级老师", @"管理员", nil];
    self.title =@"班级通讯录";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = UIColorFromRGB(229, 232, 233);

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
      
      if([[NSString stringWithFormat:@"%@",responseObj[@"code"]]isEqualToString:@"1"])
     {
         NSDictionary *dict = responseObj[@"data"];
         NSArray *teacherModelArray = [[NSArray alloc] init];
         teacherModelArray = [XXEClassAddressTeacherInfoModel parseResondsData:dict[@"teacher"]];
         NSArray *managerModelArray = [[NSArray alloc] init];
         managerModelArray  = [XXEClassAddressManagerInfoModel parseResondsData:dict[@"manager"]];
         
         [dataSourceArray addObject:teacherModelArray];
         [dataSourceArray addObject:managerModelArray];
     }
      
      [_tableView reloadData];
    
  } failure:^(NSError *error) {
      [SVProgressHUD showErrorWithStatus:@"获取数据失败!"];
  }];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return dataSourceArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    if ([self.flagArray[section] boolValue] == YES) {
        return [dataSourceArray[section] count];
    }else{
        return 0;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    FbasketCell *cell =(FbasketCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell =[[[NSBundle mainBundle]loadNibNamed:@"FbasketCell" owner:[FbasketCell class] options:nil] lastObject];
    }
    
    /*
     0 :表示 自己 头像 ，需要添加 前缀
     1 :表示 第三方 头像 ，不需要 添加 前缀
     //判断是否是第三方头像
     */
    if (indexPath.section == 0) {
        XXEClassAddressTeacherInfoModel *model = dataSourceArray[indexPath.section][indexPath.row];
        NSString *haeadImage;
        if ([model.head_img_type integerValue] == 0) {
            haeadImage = [NSString stringWithFormat:@"%@%@", picURL, model.head_img];
        }else{
            haeadImage = [NSString stringWithFormat:@"%@", model.head_img];
        }
        [cell.headImgV sd_setImageWithURL:[NSURL URLWithString:haeadImage] placeholderImage:[UIImage imageNamed:@"人物头像占位图136x136"]];
        cell.titleLbl.text = model.tname;
        cell.detailLbl.text = model.teach_course;
        cell.detailLbl.textColor = [UIColor lightGrayColor];
        
    }else if (indexPath.section == 1) {
        XXEClassAddressManagerInfoModel *model = dataSourceArray[indexPath.section][indexPath.row];
        NSString *haeadImage;
        if ([model.head_img_type integerValue] == 0) {
            haeadImage = [NSString stringWithFormat:@"%@%@", picURL, model.head_img];
        }else{
            haeadImage = [NSString stringWithFormat:@"%@", model.head_img];
        }
        [cell.headImgV sd_setImageWithURL:[NSURL URLWithString:haeadImage] placeholderImage:[UIImage imageNamed:@"人物头像占位图136x136"]];
        cell.titleLbl.text = model.tname;
        cell.detailLbl.text = model.teach_course;
        cell.detailLbl.textColor = [UIColor lightGrayColor];
        
    }
    cell.headImgV.layer.masksToBounds = YES;
    cell.headImgV.layer.cornerRadius = cell.headImgV.frame.size.width / 2;
    
    return cell;
}


///
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
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(40, 5, 200 * kScreenRatioWidth, 30)];
    label.text = [NSString stringWithFormat:@"%@",title_nameArray[section]];
    label.textColor = [UIColor blackColor];
    label.font = [UIFont boldSystemFontOfSize:16 * kScreenRatioWidth];
    [view addSubview:label];
    
    //线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 39, KScreenWidth, 1)];
    lineView.backgroundColor = UIColorFromRGB(229, 232, 233);
    [view addSubview:lineView];
    
    return view;
}

- (void)viewPressClick:(UITapGestureRecognizer *)press{
    
    //    NSLog(@" 头视图  tag  %ld", press.view.tag - 100);
    
    if ([self.flagArray[press.view.tag - 100] boolValue]) {
        [self.flagArray replaceObjectAtIndex:(press.view.tag - 100) withObject:[NSNumber  numberWithBool:NO]];
        
    }else{
        [self.flagArray replaceObjectAtIndex:(press.view.tag - 100) withObject:[NSNumber numberWithBool:YES]];
    }
    [_tableView reloadData ];
    
    
}


//返回每个分组的表头视图的高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0000001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
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
        if (indexPath.section == 0) {
            XXEClassAddressTeacherInfoModel *model = dataSourceArray[indexPath.section][indexPath.row];
            self.textblock(model.tname);
            self.idblock(model.teacher_id);
        }else if (indexPath.section == 1){
            XXEClassAddressManagerInfoModel *model = dataSourceArray[indexPath.section][indexPath.row];
            self.textblock(model.tname);
            self.idblock(model.manager_id);
        }
    
        [self.navigationController popViewControllerAnimated:YES];
    }else if(self.isRCIM==YES){
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
    }else  if (indexPath.section==1) {
        HomeInfoViewController *infoVC = [[HomeInfoViewController alloc]init];
        
        [self.navigationController pushViewController:infoVC animated:YES];
        
        
    }else if (indexPath.section ==2){
        
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


@end
