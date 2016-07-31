//
//  RCAddFriendViewController.m
//  RongCloudChat
//
//  Created by codeDing on 16/3/4.
//  Copyright © 2016年 codeDing. All rights reserved.
//

#import "RCAddFriendViewController.h"
#import "PhoneAddressBookViewController.h"
#import "FriendApplicationTableViewCell.h"
#import"ClassTelephoneViewController.h"
#import "RCAddFriendInfoViewController.h"
#import "LookNearUserTableViewController.h"
#import "HomeViewController.h"

#import "WZYSearchPeopleInfoViewController.h"


@interface RCAddFriendViewController ()<UITableViewDelegate,UITableViewDataSource>{
    
    NSMutableArray * dataArray;
    NSMutableArray *idArray;
    
    NSMutableArray *searchArray;
  
}

@property (nonatomic, strong) UISearchController *searchController;

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
//- (IBAction)PhoneAddressBookBtn:(id)sender;
//- (IBAction)LookNearUserBtn:(id)sender;

@end

@implementation RCAddFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.view.backgroundColor = UIColorFromRGB(229, 232, 233);
    self.view.backgroundColor = [UIColor whiteColor];
    
    searchArray = [[NSMutableArray alloc] init];
    
    
    [self fetchNetData];
    
    [self settingButtons];

    
    // Do any additional setup after loading the view from its nib.
//    array=[NSMutableArray arrayWithObjects:@[@"张一",@"张一请求添加你为好友",@"DefaultHeader.png"],
//           @[@"张二",@"张二请求添加你为好友",@"DefaultHeader.png"],@[@"张三",@"张三请求添加你为好友",@"DefaultHeader.png"],@[@"张三",@"张三请求添加你为好友",@"DefaultHeader.png"], nil];
    self.myTableView.dataSource=self;
    self.myTableView.delegate=self;
    UINib *nib = [UINib nibWithNibName:@"FriendApplicationTableViewCell" bundle:nil];
    [self.myTableView registerNib:nib forCellReuseIdentifier:@"cell"];
    
}


- (void)settingButtons{
    //搜索
    [_searchButton setTitle:@"猩ID/手机号" forState:UIControlStateNormal];

    UIImage *img = [UIImage imageNamed:@ "secarhicon" ];
    img = [img imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];//原图片显示，不失真，不会变成系统默认蓝色
    [_searchButton setImage:img forState:UIControlStateNormal];
    //UIEdgeInsets insets = {top, left, bottom, right};
    [_searchButton setImageEdgeInsets:UIEdgeInsetsMake(0.0, -20.0,0.0, 0.0)];//图片距离右边框距离减少图片的宽度，其它不边
    
    _searchButton.backgroundColor = [UIColor whiteColor];
    _searchButton.layer.cornerRadius = 8;
    _searchButton.layer.masksToBounds = YES;
    [_searchButton addTarget:self action:@selector(searchButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    
//从班级 通讯录 导入
    _fromClassBtn.backgroundColor = UIColorFromRGB(229, 232, 233);
//    _fromClassBtn.backgroundColor = [UIColor whiteColor];
    [_fromClassBtn setTitleColor:UIColorFromRGB(0, 170, 42) forState:UIControlStateNormal];
    [_fromClassBtn addTarget:self action:@selector(fromClassBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    //从 手机 通讯录 导入
    _PhoneAddressBookBtn.backgroundColor = UIColorFromRGB(229, 232, 233);
//    _PhoneAddressBookBtn.backgroundColor = [UIColor whiteColor];
    [_PhoneAddressBookBtn setTitleColor:UIColorFromRGB(0, 170, 42) forState:UIControlStateNormal];
    [_PhoneAddressBookBtn addTarget:self action:@selector(phoneAddressBookBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    //查看附近的人
    _LookNearUserBtn.backgroundColor = UIColorFromRGB(229, 232, 233);
//    _LookNearUserBtn.backgroundColor = [UIColor whiteColor];
    [_LookNearUserBtn setTitleColor:UIColorFromRGB(0, 170, 42) forState:UIControlStateNormal];
    [_LookNearUserBtn addTarget:self action:@selector(lookNearUserBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)searchButtonClick{

    WZYSearchPeopleInfoViewController *WZYSearchPeopleInfoVC = [[WZYSearchPeopleInfoViewController alloc] init];
    [WZYSearchPeopleInfoVC returnArray:^(NSMutableArray *mArr) {
       
        NSLog(@"---   搜索 返回 结果  %@", mArr);
    }];
    
    [self.navigationController pushViewController:WZYSearchPeopleInfoVC animated:NO];
}


- (void)fromClassBtnClick{

        ClassTelephoneViewController *vc=[[ClassTelephoneViewController alloc]init];
        vc.isRCIM=YES;
         [self.navigationController pushViewController:vc animated:YES];
}


- (void)phoneAddressBookBtnClick{

    //    [self.navigationController pushViewController:[PhoneAddressBookViewController alloc] animated:YES];
    
        [self.navigationController pushViewController:[HomeViewController alloc] animated:YES];
}

- (void)lookNearUserBtnClick{

    [self.navigationController pushViewController:[LookNearUserTableViewController alloc] animated:YES];

}


- (void)fetchNetData{

/*
 【聊天--请求好友列表】
 
 接口:
 http://www.xingxingedu.cn/Global/friend_request_list
 
 传参:
 */
    
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/friend_request_list";
    
    //请求参数  无
    NSString *Xid;
    NSString *userId;
    /*
     kkkk dict:{
     msg = Success!登录成功!,
     data = {
     account = 15026511452,
     user_head_img = http://www.xingxingedu.cn/Public/app_upload/head_img/2016/07/04/20160704141256_6865.png,
     nickname = 大熊猫2,
     user_type = 1,
     user_id = 2,
     token = lJELO79GiykHxvqdSxvKcJQEwCVP7+PYbY08BpzgYl48DKZh/HyFQH3WEkDs8QQy/DibEI+T5ZwHAuk3NAfi1Hij3+TGVQ+r,
     xid = 18886064,
     login_times = 2
     },
     code = 1
     }
     
     */
    
    if ([DEFAULTS objectForKey:@"RCUserId"] == nil) {
     Xid = @"18886064";
     userId = @"2";
        
    }else{
        
        Xid = [DEFAULTS objectForKey:@"RCUserId"];
        userId = [DEFAULTS objectForKey:@"UserId"];
    }
    

    
    NSDictionary *params = @{@"appkey":APPKEY, @"backtype":BACKTYPE, @"xid":Xid, @"user_id":userId, @"user_type":@"1"};
    
    [WZYHttpTool post:urlStr params:params success:^(id responseObj) {
        
        dataArray = [[NSMutableArray alloc] init];
        idArray = [[NSMutableArray alloc] init];
        
//        NSLog(@"yyyyttt%@", responseObj);
        /*
         {
         requester_xid = 18886386,
         id = 4,
         notes = 我是王老师,
         nickname = 含笑半步颠,
         head_img_type = 0,
         head_img = app_upload/text/parent/p6.jpg,
         date_tm = 1461884982,
         receiver_xid = 18884982
         }
         */
        
        NSArray *dataSource = responseObj[@"data"];
        
        NSString *codeStr = [NSString stringWithFormat:@"%@", responseObj[@"code"]];
        
        if ([codeStr isEqualToString:@"1"]) {
            
            for (NSDictionary *dic in dataSource) {
                
                //                0 :表示 自己 头像 ，需要添加 前缀
                //                1 :表示 第三方 头像 ，不需要 添加 前缀
                //判断是否是第三方头像
                NSString * head_img;
                if([[NSString stringWithFormat:@"%@",dic[@"head_img_type"]]isEqualToString:@"0"]){
                    head_img=[picURL stringByAppendingString:dic[@"head_img"]];
                }else{
                    head_img=dic[@"head_img"];
                }
                
                NSArray *itemArray = [[NSArray alloc] init];
                //@[@"张一",@"张一请求添加你为好友",@"DefaultHeader.png"]
                itemArray = @[dic[@"nickname"], dic[@"notes"],head_img];
                
                [dataArray addObject:itemArray];
                
                [idArray addObject:[NSString stringWithFormat:@"%@", dic[@"id"]]];
            
            }
            
        }else{
            
            
            
        }
        
//        NSLog(@"idArray+++++++====%@", idArray);
//        NSLog(@"bbbbbb%@", dataArray);
        
        [_myTableView reloadData];
        
    } failure:^(NSError *error) {
        //
        
    }];


}




#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return dataArray.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FriendApplicationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(cell==nil){
        cell=[[FriendApplicationTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    NSArray * tmp=dataArray[indexPath.row];
    
    //昵称
    cell.nameLabel.text=tmp[0];
    //内容
    cell.remarkLabel.text=tmp[1];
    
    //头像
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:tmp[2]] placeholderImage:[UIImage imageNamed:@"人物头像172x172"]];
//    cell.imgView.image=[UIImage imageNamed:tmp[2]];
    
    cell.imgView.layer.cornerRadius = 30;
    cell.imgView.layer.masksToBounds = YES;
    
    cell.agreeBtn.tag = indexPath.row + 10;
    
    [cell.agreeBtn setTitle:@"同意" forState:UIControlStateNormal];
     [cell.agreeBtn setTintColor:UIColorFromRGB(0, 170, 42)];
    [cell.agreeBtn addTarget:self action:@selector(collectPressed:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.navigationController pushViewController:[RCAddFriendInfoViewController alloc] animated:YES];
}
-(void)collectPressed:(UIButton *)btn{
    /*
     
     接口:
     http://www.xingxingedu.cn/Global/agree_friend_request
     
     传参:
     request_id	//请求id
     */
    
    NSString *Xid;
    NSString *userId;
    
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/agree_friend_request";
    
    //请求参数  无
    
    if ([DEFAULTS objectForKey:@"RCUserId"] == nil) {
        Xid = @"18886064";
        userId = @"2";
        
    }else{
        
        Xid = [DEFAULTS objectForKey:@"RCUserId"];
        userId = [DEFAULTS objectForKey:@"UserId"];
    }
    
    NSString *idStr = idArray[btn.tag - 10];
    
//    NSLog(@"点击 同意%@", idStr);
    
    NSDictionary *params = @{@"appkey":APPKEY, @"backtype":BACKTYPE, @"xid":Xid, @"user_id":userId, @"user_type":@"1", @"request_id":idStr};
    [WZYHttpTool post:urlStr params:params success:^(id responseObj) {
        //
//        NSLog(@"%@", responseObj);
        if([[NSString stringWithFormat:@"%@",responseObj[@"code"]]isEqualToString:@"1"] ){
        
            
        
        }else{
        
        
        }
        
        [self fetchNetData];
        [_myTableView reloadData];
        
    } failure:^(NSError *error) {
        //
        NSLog(@"%@", error);
    }];

    
}



//滑动删除
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete)
         {
       [dataArray removeObjectAtIndex:indexPath.row];
           
        [self.myTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }
}



- (IBAction)searchButton:(UIButton *)sender {
}
@end
