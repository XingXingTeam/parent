//
//  AccountManagerViewController.m
//  XingXingEdu
//
//  Created by keenteam on 16/5/25.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//
#define KPATA @"AccountManagerCell"
#import "AccountManagerViewController.h"
#import "KTMoneyViewController.h"
#import "AccountManagerCell.h"
#import "AddAccountViewController.h"
#import "HHControl.h"
//#import "FlowerToMoneyViewController.h"
@interface AccountManagerViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *titleArray;
    NSMutableArray *imageArray;
    NSMutableArray *detailArray;
    

}
@end

@implementation AccountManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"账号管理";
    // Do any additional setup after loading the view.
    [self createTableView];
    [self createRightBar];
}
- (void)createRightBar{
  
    UIButton *rightBtn =[HHControl createButtonWithFrame:CGRectMake(0, 0, 25, 25) backGruondImageName:@"添加icon44x44@2x" Target:self Action:@selector(add) Title:nil];
    UIBarButtonItem *rightBar =[[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem =rightBar;

}
- (void)add{
//提现
    AddAccountViewController *addAccountVC =[[AddAccountViewController alloc]init];
    [self.navigationController pushViewController:addAccountVC animated:NO];
    
}
- (void)createTableView{

    _tableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight) style:UITableViewStyleGrouped];
    _tableView.dataSource =self;
    _tableView.delegate =self;
    [self.view addSubview:_tableView];
   
    titleArray =[[NSMutableArray alloc]init];
    imageArray =[[NSMutableArray alloc]init];
    detailArray =[[NSMutableArray alloc]init];
    NSArray *titleArr =[[NSArray alloc]initWithObjects:@"实习生(*千林)",@"莉(*莉)",@"京(*京)", nil];
    NSArray *imageArr =[[NSArray alloc]initWithObjects:@"占位图94x94@2x(1)",@"占位图94x94@2x(1)",@"占位图94x94@2x(1)", nil];
    NSArray *detailArr =[[NSArray alloc]initWithObjects:@"137***8655",@"135***9292",@"ale***@hotmail.com", nil];
    [titleArray addObjectsFromArray:titleArr];
    [imageArray addObjectsFromArray:imageArr];
    [detailArray addObjectsFromArray:detailArr];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return titleArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0000001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AccountManagerCell *cell=(AccountManagerCell*)[tableView dequeueReusableCellWithIdentifier:KPATA];
    if (!cell) {
        NSArray *nib =[[NSBundle mainBundle]loadNibNamed:@"AccountManagerCell" owner:[AccountManagerCell class] options:nil];
        cell =(AccountManagerCell*)[nib objectAtIndex:0];
    }
    cell.imagV.image =[UIImage imageNamed:imageArray[indexPath.row]];
    cell.titleLbl.text =titleArray[indexPath.row];
    cell.detailLbl.text =detailArray[indexPath.row];
    cell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    
            KTMoneyViewController *ktMoneyVC =[[KTMoneyViewController alloc]init];
            ktMoneyVC.accountStr =detailArray[indexPath.row];
            ktMoneyVC.moneyStr =self.moneyStr;
            [self.navigationController pushViewController:ktMoneyVC animated:YES];

    
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
