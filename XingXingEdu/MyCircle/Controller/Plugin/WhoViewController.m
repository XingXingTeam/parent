//
//  WhoViewController.m
//  XingXingEdu
//
//  Created by keenteam on 16/3/16.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//
#define KPATA @"WhoSeeCell"
#import "WhoViewController.h"
#import "WhoSeeCell.h"
@interface WhoViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *dataArray;
    NSMutableArray *titleArray;
    NSString *titleText;

}
@end

@implementation WhoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"谁可以看";
    self.view.backgroundColor= [UIColor colorWithRed:229/255.0f green:232/255.0f blue:234/255.0f alpha:1];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.barTintColor =UIColorFromRGB(0, 170, 42);
    
    // Do any additional setup after loading the view.
    [self createTableView];
}

- (void)createTableView{
    dataArray =[[NSMutableArray alloc]initWithObjects:@"班级联系人",@"好友",@"所有人",@"仅自己",nil];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight) style:UITableViewStyleGrouped];
    _tableView.dataSource =self;
    _tableView.delegate =self;
    [self.view addSubview:_tableView];
 
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0000001;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WhoSeeCell *cell =(WhoSeeCell*)[tableView dequeueReusableCellWithIdentifier:KPATA];
    
    if (!cell) {
        NSArray *nib =[[NSBundle mainBundle]loadNibNamed:KPATA owner:[WhoSeeCell class] options:nil];
        cell =(WhoSeeCell*)[nib objectAtIndex:0];
    }
    cell.textLbl.text =dataArray[indexPath.row];
    cell.btn.tag =indexPath.row +100;
    return cell;

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    titleText =dataArray[indexPath.row];
    UIButton *btn =(UIButton *)[self.view viewWithTag:indexPath.row+100];
    [btn setBackgroundImage:[UIImage imageNamed:@"已勾选34x34"] forState:UIControlStateNormal];
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIButton *btn =(UIButton *)[self.view viewWithTag:indexPath.row+100];
    [btn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];

}
- (void)returnText:(ReturnTextBlock)block{
    self.returnTextBlock =block;
}
- (void)viewWillDisappear:(BOOL)animated{
    self.returnTextBlock(titleText);
    
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
