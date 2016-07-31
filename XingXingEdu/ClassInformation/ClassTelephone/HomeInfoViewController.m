//
//  HomeInfoViewController.m
//  XingXingEdu
//    ___  _____   ______  __ _   _________
//   / _ \/ __/ | / / __ \/ /| | / / __/ _ \
//  / , _/ _/ | |/ / /_/ / /_| |/ / _// , _/
// /_/|_/___/ |___/\____/____/___/___/_/|_|
//
//  Created by keenteam on 16/1/25.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "HomeInfoViewController.h"
#import "HomePeopleInfoViewController.h"
#import "OtherPeopleViewController.h"

@interface HomeInfoViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *telArray;
    UITableView *_tableView;
}

@end

@implementation HomeInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"家庭成员 ";
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColorFromRGB(255, 255, 255);
    [self createTableView];
    
}
- (void)createTableView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight) style:UITableViewStyleGrouped];
    _tableView.dataSource =self;
    _tableView.delegate =self;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"telCell"];
    [self.view addSubview:_tableView];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.isRCIM==YES){
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
    }else{
        OtherPeopleViewController *OtherPeopleVC = [[OtherPeopleViewController alloc] init];
        //        [[NSUserDefaults standardUserDefaults]setObject:baby_id1 forKey:@"BABYID"];
        NSString *babyId = [[NSUserDefaults standardUserDefaults] objectForKey:@"BABYID"];
        OtherPeopleVC.babyIdStr = babyId;
        OtherPeopleVC.familyIdStr = _familyMArr[indexPath.row][@"id"];
        OtherPeopleVC.familyXidStr = _familyMArr[indexPath.row][@"xid"];
        
        [self.navigationController pushViewController:OtherPeopleVC animated:YES];
        
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.familyMArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0000001;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"telCell";
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }
    cell.imageView.layer.cornerRadius = 30;
    cell.imageView.clipsToBounds = YES;
    
    cell.textLabel.text =[NSString stringWithFormat:@"%@-%@",[self.familyMArr[indexPath.row] objectForKey:@"relation_name"],[self.familyMArr[indexPath.row] objectForKey:@"tname"]];
    cell.detailTextLabel.textColor =UIColorFromRGB(168, 254, 84);
    cell.detailTextLabel.text = [NSString stringWithFormat:@"等级%@",[self.familyMArr[indexPath.row] objectForKey:@"lv"]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
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

