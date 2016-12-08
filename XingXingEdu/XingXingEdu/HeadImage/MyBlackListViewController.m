//
//  MyBlackListViewController.m
//  XingXingEdu
//
//  Created by keenteam on 16/4/13.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//
#define kPata @"MyBlackListCell"
#import "MyBlackListViewController.h"
#import "MyBlackListCell.h"
#import "HomePeopleInfoViewController.h"
#import "HHControl.h"
#import "MBProgressHUD.h"
#import "MJRefresh.h"
@interface MyBlackListViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *dataArray;
    NSArray *dataArr;
    MBProgressHUD *HUD;
    UIAlertView *_alert;
    NSMutableArray *head_imgMArr;
    NSMutableArray *head_img_typeMArr;
    NSMutableArray *nickNameMArr;
    NSMutableArray *sexMArr;
    NSMutableArray *xidKTMArr;
    NSString *dataKTStr;
    int j;
    NSString *parameterXid;
    NSString *parameterUser_Id;

}
@end

@implementation MyBlackListViewController
- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController.navigationBar setBarTintColor:UIColorFromRGB(0, 170, 42)];
    [self.navigationController.navigationBar setTintColor:UIColorFromRGB(255, 255, 255)];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName ,nil]];
    [_tableView reloadData];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [_tableView.header beginRefreshing];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }
    
    dataArray =[[NSMutableArray alloc]init];
    head_imgMArr =[[NSMutableArray alloc]init];
    head_img_typeMArr =[[NSMutableArray alloc]init];
    nickNameMArr =[[NSMutableArray alloc]init];
    sexMArr =[[NSMutableArray alloc]init];
    xidKTMArr =[[NSMutableArray alloc]init];
    j=0;
    self.title =@"我的黑名单";
    [self initData];

    [self createTableView];
    _tableView.header =[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    [self createRightBar];
}
- (void)loadNewData{
    [self initData];
    [_tableView.header endRefreshing];
}
- (void)endRefresh{
    [_tableView.header endRefreshing];

}
- (void)initData{
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/black_user_list";
    
    NSDictionary *dict = @{@"appkey":APPKEY,
                           @"backtype":BACKTYPE,
                           @"xid":parameterXid,
                           @"user_id":parameterUser_Id,
                           @"user_type":USER_TYPE,
                           };

     [WZYHttpTool post:urlStr params:dict success:^(id responseObj) {
         NSDictionary *dict =responseObj;
         if([[NSString stringWithFormat:@"%@",dict[@"code"]]isEqualToString:@"1"] )
         {
                 dataArr =dict[@"data"];
      // NSLog(@"------------------------dataArr----%@",dataArr);
       
                 for (int i=0; i<dataArr.count; i++) {
                     
                     [head_imgMArr addObject:[dataArr[i] objectForKey:@"head_img"]];
                     [head_img_typeMArr addObject:[dataArr[i] objectForKey:@"head_img_type"]];
                     [nickNameMArr addObject:[dataArr[i] objectForKey:@"nickname"]];
                     [sexMArr addObject:[dataArr[i] objectForKey:@"sex"]];
                     [xidKTMArr addObject:[dataArr[i] objectForKey:@"xid"]];
                 }
         }
         [_tableView reloadData];
     } failure:^(NSError *error) {
         
     }];

}
- (void)createRightBar{

    UIButton *rightBtn =[HHControl createButtonWithFrame:CGRectMake(251, 0, 26, 26) backGruondImageName:@"移除icon44x44@2x" Target:self Action:@selector(right) Title:nil];
    UIBarButtonItem *rightBar =[[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem =rightBar;

}
- (void)right{
    if (j==0) {
       
        [SVProgressHUD showErrorWithStatus:@"请选择要移除的人"];
    }
    else{
        
        if (dataArray.count==0) {
             [SVProgressHUD showErrorWithStatus:@"请选择要移除的人"];
        }
        else{
 //移除黑名单
         //   NSLog(@"&&&&&&&&&&&&&&&&&======%@",dataArray);
         
                
               dataKTStr= [dataArray componentsJoinedByString:@","];
               
            
         
         //   NSLog(@"!!!!!!!****dataKTStr***********%@",dataKTStr);
            NSString *urlStr = @"http://www.xingxingedu.cn/Global/cancle_black_user";
            
            NSDictionary *dict = @{@"appkey":APPKEY,
                                   @"backtype":BACKTYPE,
                                   @"xid":parameterXid,
                                   @"user_id":parameterUser_Id,
                                   @"user_type":USER_TYPE,
                                   @"other_xid":dataKTStr,
                                   };
            
            [WZYHttpTool post:urlStr params:dict success:^(id responseObj) {
                NSDictionary *dict =responseObj;
              //  NSLog(@"!!!!!!!!!!!!!!!!!!%@",dict);
                // NSLog(@"!!!!!!!!!!!!!!!!!!%@",dict[@"msg"]);
                if([[NSString stringWithFormat:@"%@",dict[@"code"]]isEqualToString:@"1"] )
                {
                    HUD =[[MBProgressHUD alloc]initWithView:self.view];
                    [self.view addSubview:HUD];
                    HUD.mode =MBProgressHUDModeText;
                    HUD.dimBackground =YES;
                    _alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"移除成功!" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
                    [_alert show];
                    
                    [HUD showAnimated:YES whileExecutingBlock:^{
                        sleep(1);
                    } completionBlock:^{
                        [HUD removeFromSuperview];
                        HUD =nil;
                        [_alert dismissWithClickedButtonIndex:0 animated:NO];
                        [self.navigationController popViewControllerAnimated:YES];
                    }];

                }
                [_tableView reloadData];
            } failure:^(NSError *error) {
                
            }];
        }
   }
}
- (void)createTableView{

    _tableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight) style:UITableViewStyleGrouped];
    _tableView.dataSource =self;
    _tableView.delegate =self;
    [self.view addSubview:_tableView];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataArr.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyBlackListCell *cell =(MyBlackListCell*)[tableView dequeueReusableCellWithIdentifier:kPata];
    
    if (!cell) {
        NSArray *nib =[[NSBundle mainBundle]loadNibNamed:kPata owner:self options:nil];
        cell =(MyBlackListCell*)[nib objectAtIndex:0];
    }
    
    cell.iconImagV.layer.cornerRadius =30;
    cell.iconImagV.layer.masksToBounds =YES;

   if ([head_img_typeMArr[indexPath.row] integerValue]==0) {
        [cell.iconImagV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",picURL,head_imgMArr[indexPath.row]]] placeholderImage:[UIImage imageNamed:@"占位图94x94@2x(1)"]];
    }
    else if ([head_img_typeMArr[indexPath.row] integerValue]==1){
     [cell.iconImagV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",head_imgMArr[indexPath.row]]] placeholderImage:[UIImage imageNamed:@"占位图94x94@2x(1)"]];
    }
   
    cell.nameLabel.text =[NSString stringWithFormat:@"%@",nickNameMArr[indexPath.row]];
    cell.ageLabel.text =[NSString stringWithFormat:@"%@",sexMArr[indexPath.row]];
    
    cell.selectBtn.tag =indexPath.row +100;
    [cell.selectBtn addTarget:self action:@selector(selectBt:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}
- (void)selectBt:(UIButton *)btn{
  
    if (btn.selected) {
        [btn setBackgroundImage:[UIImage imageNamed:@"未勾选34x34"] forState:UIControlStateNormal];
        btn.selected =NO;
        j--;
         [dataArray removeObject:[xidKTMArr objectAtIndex:(btn.tag -100)]];
       
         // NSLog(@"btn---取消---tag----%ld",btn.tag -100);
    }
    else{
        [btn setBackgroundImage:[UIImage imageNamed:@"已勾选34x34"] forState:UIControlStateNormal];
        btn.selected =YES;
        j++;
        [dataArray addObject:[xidKTMArr objectAtIndex:(btn.tag -100)]];
         // NSLog(@"btn---添加---tag----%ld",btn.tag -100);
        
    }
   // NSLog(@"~~~~~~~~~~~~~~~~~dataArr~~~~~~~%@",dataArray);
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0000001;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

//    HomePeopleInfoViewController *homePeopleVC =[[HomePeopleInfoViewController alloc]init];
//    [self.navigationController pushViewController:homePeopleVC animated:YES];


}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
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
