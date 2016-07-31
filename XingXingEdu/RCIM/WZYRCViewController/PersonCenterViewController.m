//
//  PersonCenterViewController.m
//  RCIM
//
//  Created by codeDing on 16/3/26.
//  Copyright © 2016年 codeDing. All rights reserved.
//

#import "PersonCenterViewController.h"
#import "WMConversationViewController.h"
#import "AppDelegate.h"
#import "UIImageView+WebCache.h"
#import "HHControl.h"
#import "RCAddFriendViewController.h"
#import "SVProgressHUD.h"
#import "UserViewController.h"
#import  "ViewController.h"
#import "ReportPicViewController.h"

#define WinWidth [UIScreen mainScreen].bounds.size.width
#define WinHeight [UIScreen mainScreen].bounds.size.height
#define W(x) WinWidth*(x)/375.0
#define H(y) WinHeight*(y)/667.0
@interface PersonCenterViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSMutableArray *dataSource;
    UIView *headerView;
    UIImageView *headerIV;
    UIButton *chatBtn;
    UIButton *addBtn;
}
@property (weak, nonatomic) IBOutlet UITableView *table;
- (IBAction)blacklistBtn:(id)sender;

- (IBAction)reportBtn:(id)sender;

- (IBAction)seeFriendSterBtn:(id)sender;
- (IBAction)deleteBtn:(id)sender;
- (IBAction)chatToOneBtn:(id)sender;


@end

@implementation PersonCenterViewController

-(void)logoutAction:(UIBarButtonItem *)sender{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        [[RCIMClient sharedRCIMClient] disconnect:YES];
    }];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _table.scrollEnabled = NO;
    
    if (self.showUserInfo==nil) {
        self.showUserInfo = [RCIM sharedRCIM].currentUserInfo;
    }
    dataSource = [[NSMutableArray alloc]init];
    [dataSource addObject:[NSString stringWithFormat:@"姓名:%@",self.showUserInfo.name]];
    //
    [dataSource addObject:[NSString stringWithFormat:@"猩ID:%@",self.showUserInfo.userId]];
//    [dataSource addObject:[NSString stringWithFormat:@"性别:%@",self.showUserInfo.sex]];
    self.view.backgroundColor = UIColorFromRGB(229, 232, 233);
    [self initTableAndHeader];
    
}
-(void)initTableAndHeader{
    
//    chatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    chatBtn.frame = CGRectMake(0, 0, self.view.frame.size.width, 44);
//    [chatBtn setTitle:@"私聊" forState:UIControlStateNormal];
//    [chatBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//    [chatBtn addTarget:self action:@selector(chatRightNow:) forControlEvents:UIControlEventTouchUpInside];
//    chatBtn.backgroundColor = [UIColor lightGrayColor];
    
    
    headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
    headerView.backgroundColor = [UIColor whiteColor];
//    headerIV = [[UIImageView alloc]initWithFrame:headerView.bounds];
    headerIV = [[UIImageView alloc]initWithFrame:CGRectMake((WinWidth-100)/2, 5, 100, 100)];
    headerIV.layer.cornerRadius= headerIV.bounds.size.width/2;
    headerIV.layer.masksToBounds=YES;
    [headerIV sd_setImageWithURL:[NSURL URLWithString:self.showUserInfo.portraitUri] placeholderImage:[UIImage imageNamed:@"DefaultHeader"]];
    [headerView addSubview:headerIV];
    
    self.table.estimatedRowHeight = 1000;
    self.table.rowHeight = UITableViewAutomaticDimension;
    self.table.backgroundColor = [UIColor whiteColor];
//    self.table.tableFooterView = chatBtn;
    self.table.tableHeaderView = headerView;

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    [headerIV sd_setImageWithURL:[NSURL URLWithString:self.showUserInfo.portraitUri] placeholderImage:[UIImage imageNamed:@"DefaultHeader"]];
    return dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
//    UIView *viewline=[[UIView alloc]initWithFrame:CGRectMake(8, 42, WinWidth-16, 1)];
//    viewline.backgroundColor=[UIColor lightGrayColor];
//    viewline.alpha=0.4;
//    [cell addSubview:viewline];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.text = dataSource[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (void)chatRightNow:(UIButton *)sender {
    
    if (self.showUserInfo) {
        WMConversationViewController *_conversationVC = [[WMConversationViewController alloc]init];
        _conversationVC.conversationType = ConversationType_PRIVATE;
        
        _conversationVC.targetId = self.showUserInfo.userId;
        _conversationVC.title = [NSString stringWithFormat:@"%@",self.showUserInfo.name];
        [self.navigationController pushViewController:_conversationVC animated:YES];
    }else{
        WMConversationViewController *_conversationVC = [[WMConversationViewController alloc]init];
        _conversationVC.conversationType = ConversationType_PRIVATE;
        _conversationVC.targetId = [RCIM sharedRCIM].currentUserInfo.userId;
        _conversationVC.title = [NSString stringWithFormat:@"%@",[RCIM sharedRCIM].currentUserInfo.name];
        [self.navigationController pushViewController:_conversationVC animated:YES];
    }
    
}
#pragma mark - UIScrollViewDelegate
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    CGFloat yOffset = self.table.contentOffset.y;
//    //向上偏移量变正  向下偏移量变负
//    CGFloat confuse = headerView.frame.size.height;
//    if (yOffset < 0) {
//        CGFloat factor = ABS(yOffset)+confuse;
//        CGRect f = CGRectMake(-([[UIScreen mainScreen] bounds].size.width*factor/(confuse)-[[UIScreen mainScreen] bounds].size.width)/2,-ABS(yOffset), [[UIScreen mainScreen] bounds].size.width*factor/(confuse), factor);
//        headerIV.frame = f;
//    }else {
//        CGRect f = headerView.frame;
//        f.origin.y = 0;
//        headerView.frame = f;
//        headerIV.frame = CGRectMake(0, f.origin.y, [[UIScreen mainScreen] bounds].size.width, (confuse));
//    }
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)exitBtn{
    //    [self.navigationController pushViewController:[LoginViewController alloc] animated:YES];
}

-(void)addFriendBtn{
    [self.navigationController pushViewController:[RCAddFriendViewController alloc] animated:YES];
}
- (IBAction)blacklistBtn:(id)sender {
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"确定将好友加入黑名单？" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
    
    UIAlertAction *cancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *ok=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [SVProgressHUD showSuccessWithStatus:@"加入黑名单成功"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    }];
    [alert addAction:ok];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)reportBtn:(id)sender {
//    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"举报好友" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
//    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
//        
//        //        textField.backgroundColor = [UIColor orangeColor];
//        textField.placeholder=@"举报";
//    }];
//    UIAlertAction *cancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
//    UIAlertAction *ok=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [SVProgressHUD showSuccessWithStatus:@"举报成功"];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self.navigationController popViewControllerAnimated:YES];
//        });
//    }];
//    [alert addAction:ok];
//    [alert addAction:cancel];
//    [self presentViewController:alert animated:YES completion:nil];
    ReportPicViewController * vc=[[ReportPicViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)seeFriendSterBtn:(id)sender {
    ViewController *viewVC = [[ViewController alloc]init];
    [self.navigationController pushViewController:viewVC animated:YES
     ];
    
}

- (IBAction)deleteBtn:(id)sender {
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"确定删除好友？" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
    
    UIAlertAction *cancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *ok=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [SVProgressHUD showSuccessWithStatus:@"删除好友成功"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    }];
    [alert addAction:ok];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)chatToOneBtn:(id)sender {
    
    if (self.showUserInfo) {
        WMConversationViewController *_conversationVC = [[WMConversationViewController alloc]init];
        _conversationVC.conversationType = ConversationType_PRIVATE;
        
        _conversationVC.targetId = self.showUserInfo.userId;
        _conversationVC.title = [NSString stringWithFormat:@"%@",self.showUserInfo.name];
        [self.navigationController pushViewController:_conversationVC animated:YES];
    }else{
        WMConversationViewController *_conversationVC = [[WMConversationViewController alloc]init];
        _conversationVC.conversationType = ConversationType_PRIVATE;
        _conversationVC.targetId = [RCIM sharedRCIM].currentUserInfo.userId;
        _conversationVC.title = [NSString stringWithFormat:@"%@",[RCIM sharedRCIM].currentUserInfo.name];
        [self.navigationController pushViewController:_conversationVC animated:YES];
    }
    

}
@end
