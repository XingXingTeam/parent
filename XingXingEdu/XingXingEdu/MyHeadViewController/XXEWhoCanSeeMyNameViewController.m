

//
//  XXEWhoCanSeeMyNameViewController.m
//  teacher
//
//  Created by Mac on 16/9/12.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEWhoCanSeeMyNameViewController.h"
#import "WhoSeeCell.h"


@interface XXEWhoCanSeeMyNameViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *titleArray;
    NSString *titleText;
}


@end

@implementation XXEWhoCanSeeMyNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"系统设置";
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.view.backgroundColor =UIColorFromRGB(229 , 232, 233);

    titleArray =[[NSMutableArray alloc]initWithObjects:@"班级联系人",@"好友",@"所有人",@"仅自己", nil];
    
    [self createTable];
}


- (void)createTable{
    
    _tableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight - 64) style:UITableViewStyleGrouped];
    _tableView.dataSource =self;
    _tableView.delegate =self;
    [self.view addSubview:_tableView];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.00000001;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return titleArray.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"cell";
    WhoSeeCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"WhoSeeCell" owner:self options:nil]lastObject];
    }
    
    cell.textLbl.text =titleArray[indexPath.row];
    cell.btn.tag =indexPath.row +100;
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    titleText =titleArray[indexPath.row];
    UIButton *btn =(UIButton *)[self.view viewWithTag:indexPath.row+100];
    [btn setBackgroundImage:[UIImage imageNamed:@"report_selected_icon"] forState:UIControlStateNormal];
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



@end
