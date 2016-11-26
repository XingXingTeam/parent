//
//  XXEWhoCanLookController.m
//  teacher
//
//  Created by codeDing on 16/9/19.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEWhoCanLookController.h"
#import "WhoSeeCell.h"

static NSString *const IdentifierCell = @"WhoSeeCell";
@interface XXEWhoCanLookController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *dataArray;
    NSMutableArray *titleArray;
    NSString *titleText;
}

@end

@implementation XXEWhoCanLookController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.backgroundColor = XXEBackgroundColor;
    
}
/** 这两个方法都可以,改变当前控制器的电池条颜色 */
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"谁可以看";
    [self createTableView];
}
- (void)createTableView{
    dataArray =[[NSMutableArray alloc]initWithObjects:@"所有人可见",@"好友可见",@"仅自己可见",@"班级通讯录可见",nil];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) style:UITableViewStyleGrouped];
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
    WhoSeeCell *cell =(WhoSeeCell*)[tableView dequeueReusableCellWithIdentifier:IdentifierCell];
    
    if (!cell) {
        NSArray *nib =[[NSBundle mainBundle]loadNibNamed:IdentifierCell owner:[WhoSeeCell class] options:nil];
        cell =(WhoSeeCell*)[nib objectAtIndex:0];
    }
    cell.textLbl.text =dataArray[indexPath.row];
    cell.btn.tag =indexPath.row +100;
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    titleText =dataArray[indexPath.row];
    UIButton *btn =(UIButton *)[self.view viewWithTag:indexPath.row+100];
    [btn setBackgroundImage:[UIImage imageNamed:@"已选择icon28x28"] forState:UIControlStateNormal];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
    
    
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
