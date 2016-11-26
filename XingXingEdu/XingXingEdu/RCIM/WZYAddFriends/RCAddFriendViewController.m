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
    NSString *parameterXid;
    NSString *parameterUser_Id;
}

@property (nonatomic, strong) UISearchController *searchController;

@property (weak, nonatomic) IBOutlet UITableView *myTableView;


@end

@implementation RCAddFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    searchArray = [[NSMutableArray alloc] init];

    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }
    
    [self fetchNetData];
    
    [self settingButtons];

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
    [_fromClassBtn setTitleColor:UIColorFromRGB(0, 170, 42) forState:UIControlStateNormal];
    [_fromClassBtn addTarget:self action:@selector(fromClassBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    //从 手机 通讯录 导入
    _PhoneAddressBookBtn.backgroundColor = UIColorFromRGB(229, 232, 233);
    [_PhoneAddressBookBtn setTitleColor:UIColorFromRGB(0, 170, 42) forState:UIControlStateNormal];
    [_PhoneAddressBookBtn addTarget:self action:@selector(phoneAddressBookBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    //查看附近的人
    _LookNearUserBtn.backgroundColor = UIColorFromRGB(229, 232, 233);
    [_LookNearUserBtn setTitleColor:UIColorFromRGB(0, 170, 42) forState:UIControlStateNormal];
    [_LookNearUserBtn addTarget:self action:@selector(lookNearUserBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)searchButtonClick{

    WZYSearchPeopleInfoViewController *WZYSearchPeopleInfoVC = [[WZYSearchPeopleInfoViewController alloc] init];
    [WZYSearchPeopleInfoVC returnArray:^(NSMutableArray *mArr) {
       
//        NSLog(@"---   搜索 返回 结果  %@", mArr);
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

    NSDictionary *params = @{@"appkey":APPKEY, @"backtype":BACKTYPE, @"xid":parameterXid, @"user_id":parameterUser_Id, @"user_type":USER_TYPE};
    
    [WZYHttpTool post:urlStr params:params success:^(id responseObj) {
        
        dataArray = [[NSMutableArray alloc] init];
        idArray = [[NSMutableArray alloc] init];
        
//        NSLog(@"yyyyttt%@", responseObj);

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
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/agree_friend_request";
    
    NSString *idStr = idArray[btn.tag - 10];
    
    NSDictionary *params = @{@"appkey":APPKEY, @"backtype":BACKTYPE, @"xid":parameterXid, @"user_id":parameterUser_Id, @"user_type":USER_TYPE, @"request_id":idStr};
    [WZYHttpTool post:urlStr params:params success:^(id responseObj) {
//        NSLog(@"%@", responseObj);
        if([[NSString stringWithFormat:@"%@",responseObj[@"code"]]isEqualToString:@"1"] ){
            [SVProgressHUD showInfoWithStatus:@"添加好友成功!"];
        }else{
            [SVProgressHUD showInfoWithStatus:@"添加好友失败!"];
        
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

@end
