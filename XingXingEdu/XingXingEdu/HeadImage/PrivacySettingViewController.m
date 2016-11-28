//
//  PrivacySettingViewController.m
//  XingXingEdu
//
//  Created by keenteam on 16/3/22.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "PrivacySettingViewController.h"
//#import "WhoViewController.h"
#import "PrivacySettingCell.h"
@interface PrivacySettingViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *dataArr;
    NSMutableArray *nameArr;
    NSString *urlStr;
    NSDictionary *dictKT;
    NSDictionary *KTDict;
    NSString *show_phone;
    NSString *show_tname;
    NSString *search_phone;
    NSString *search_xid;
    NSString *search_nearby;
    NSString *add_friend_set;
    NSString *parameterXid;
    NSString *parameterUser_Id;
    

    
}
@end

@implementation PrivacySettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }

    dataArr = [[NSMutableArray alloc]init];
    nameArr = [[NSMutableArray alloc]init];
    // Do any additional setup after loading the view.
    self.title =@"隐私设置";
   dictKT =[[NSDictionary alloc]initWithObjectsAndKeys:@"班级联系人",@"1",@"好友",@"2",@"所有人",@"3",@"仅自己",@"4",nil];
    KTDict =[[NSDictionary alloc]initWithObjectsAndKeys:@"1",@"班级联系人",@"2",@"好友",@"3",@"所有人",@"4",@"仅自己",nil];
    self.view.backgroundColor = UIColorFromRGB(255,163, 195);
   
    [self createTableView];
     [self loadMoreData];
}

- (void)loadMoreData{

    urlStr = @"http://www.xingxingedu.cn/Global/secret_default";
    NSDictionary *pragm = @{   @"appkey":APPKEY,
                               @"backtype":BACKTYPE,
                               @"xid":parameterXid,
                               @"user_id":parameterUser_Id,
                               @"user_type":USER_TYPE,
                               };
    [WZYHttpTool post:urlStr params:pragm success:^(id responseObj) {
        NSDictionary *dict =responseObj;
        
        if([[NSString stringWithFormat:@"%@",dict[@"code"]]isEqualToString:@"1"] )
        {
            
           // NSLog(@">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>%@",dict[@"data"]);
            show_phone =[dictKT objectForKey:[NSString stringWithFormat:@"%@",[dict[@"data"] objectForKey:@"show_phone"]]];
            show_tname =[dictKT objectForKey:[NSString stringWithFormat:@"%@",[dict[@"data"] objectForKey:@"show_tname"]]];
            search_phone =[dict[@"data"] objectForKey:@"search_phone"];
            search_xid =[dict[@"data"] objectForKey:@"search_xid"];
            search_nearby =[dict[@"data"] objectForKey:@"search_nearby"];
            add_friend_set =[dict[@"data"] objectForKey:@"add_friend_set"];
            
        }
        [self initUI];
        [_tableView reloadData];

    } failure:^(NSError *error) {
        
    }];


}
- (void)initUI{

    NSArray *array = [NSArray arrayWithObjects:show_tname,show_phone,search_nearby,search_xid,search_phone,add_friend_set, nil];
    [nameArr addObjectsFromArray:array];

}
- (void)createTableView{

    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight) style:UITableViewStyleGrouped];
    _tableView.dataSource =self;
    _tableView.delegate =self;
    [self.view addSubview:_tableView];
   
    NSArray *arr =[NSArray arrayWithObjects:@"实名对谁可见:",@"手机号对谁可见:",@"允许被附近的人查看:",@"通过猩猩ID搜索到我:",@"通过手机号搜索到我:",@"直接通过加好友请求:", nil];
    [dataArr addObjectsFromArray:arr];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPat{
    if (indexPat.row ==0) {
        return 50;
        
    }
    else{
        return 50;
        
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
  
        return 0.00000000001;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static  NSString *cellID=@"cellID";
    PrivacySettingCell *cell =(PrivacySettingCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        NSArray *nib =[[NSBundle mainBundle]loadNibNamed:@"PrivacySettingCell" owner:[PrivacySettingCell class] options:nil];
        cell =(PrivacySettingCell*)[nib objectAtIndex:0];
    }
    
    if (indexPath.row ==0) {
        cell.switchBtn.hidden =YES;
        cell.titleLabel.text =dataArr[indexPath.row];
        if (nameArr.count!=0) {
              cell.nameLabel.text =nameArr[indexPath.row];
              cell.nameLabel.tag =100+indexPath.row;
        }
        cell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
    }
    else if (indexPath.row ==1){
        cell.switchBtn.hidden =YES;
        cell.titleLabel.text =dataArr[indexPath.row];
      
        if (nameArr.count!=0) {
            cell.nameLabel.text =nameArr[indexPath.row];
            cell.nameLabel.tag =100+indexPath.row;
        }
        cell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
    }
    else {
        cell.titleLabel.text = dataArr[indexPath.row];
        if (nameArr.count!=0) {
         cell.switchBtn.tag =100+indexPath.row;
          [cell.switchBtn setOn:[nameArr[indexPath.row] integerValue] ==0 ? YES:NO];
        }
        
        cell.nameLabel.hidden =YES;
    }
    return cell;
  
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSelector:@selector(delect) withObject:nil afterDelay:0.5f];
    if (indexPath.row ==1) {
        //手机号对谁可见
//        WhoViewController *whoVC =[[WhoViewController alloc]init];
//        [whoVC returnText:^(NSString *showText) {
//            if (showText) {
//                //[whoBtn setTitle:showText forState:UIControlStateNormal];
//                [nameArr insertObject:showText atIndex:1];
//                [tableView reloadData];
//            }
//            
//        }];
//        [self.navigationController pushViewController:whoVC animated:YES];
    }
    else if (indexPath.row==0){
        //实名对谁可见
//        WhoViewController *whoVC =[[WhoViewController alloc]init];
//        [whoVC returnText:^(NSString *showText) {
//            if (showText) {
//                // [nameArr setTitle:showText forState:UIControlStateNormal];
//                [nameArr insertObject:showText atIndex:0];
//                [tableView reloadData];
//            }
//            
//        }];
//        [self.navigationController pushViewController:whoVC animated:YES];
    }

}
- (void)viewWillDisappear:(BOOL)animated{
    UILabel *lab =(UILabel*)[self.view viewWithTag:100];
    UILabel *label =(UILabel*)[self.view viewWithTag:101];
   // NSLog(@">>>>>>>>>>>>>>>>%@<<<<<<<<<<<<<<<<<<<<<<%@",lab.text,label.text);
   NSString *reallyName =[KTDict objectForKey:[NSString stringWithFormat:@"%@",lab.text]];
   NSString *phoneName =[KTDict objectForKey:[NSString stringWithFormat:@"%@",label.text]];
   // NSLog(@">>>>>>>>>>>>>>>>%@<<<<<<<<<<<<<<<<<<<<<<%@",reallyName,phoneName);
      UISwitch *sw =(UISwitch*)[self.view viewWithTag:102];
      UISwitch *swi =(UISwitch*)[self.view viewWithTag:103];
      UISwitch *swic =(UISwitch*)[self.view viewWithTag:104];
      UISwitch *swich =(UISwitch*)[self.view viewWithTag:105];
    NSString* st =[NSString stringWithFormat:@"%@", sw.isOn == YES ? @"2":@"1"];
     NSString* str =[NSString stringWithFormat:@"%@", swi.isOn == YES ? @"2":@"1"];
     NSString* stri =[NSString stringWithFormat:@"%@", swic.isOn == YES ? @"2":@"1"];
     NSString* strin =[NSString stringWithFormat:@"%@", swich.isOn == YES ? @"2":@"1"];
    
    //  NSLog(@">>>>>>>%@>>>>>%@>>>>%@<<<<<<<%@",st,str,stri,strin);
    
    urlStr = @"http://www.xingxingedu.cn/Global/secret_set";
    NSDictionary *pragm = @{   @"appkey":APPKEY,
                               @"backtype":BACKTYPE,
                               @"xid":parameterXid,
                               @"user_id":parameterUser_Id,
                               @"user_type":USER_TYPE,
                               @"show_phone":phoneName,
                               @"show_tname":reallyName,
                               @"search_phone":stri,
                               @"search_xid":str,
                               @"search_nearby":st,
                               @"add_friend_set":strin
                               };
    [WZYHttpTool post:urlStr params:pragm success:^(id responseObj) {
        NSDictionary *dict =responseObj;
//        NSLog(@"=========info====%@",dict);
        if([[NSString stringWithFormat:@"%@",dict[@"code"]]isEqualToString:@"1"] )
        {
          [SVProgressHUD showInfoWithStatus:@"设置成功!"];
            
        }else{
            [SVProgressHUD showInfoWithStatus:@"设置失败!"];
        }
        
    } failure:^(NSError *error) {
        [SVProgressHUD showInfoWithStatus:@"获取数据失败!"];
    }];

}
- (void)delect{
    [_tableView  deselectRowAtIndexPath:[_tableView indexPathForSelectedRow] animated:YES];

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
