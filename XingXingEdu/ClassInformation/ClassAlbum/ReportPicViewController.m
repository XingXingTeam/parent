//
//  ReportPicViewController.m
//  XingXingEdu
//    ___  _____   ______  __ _   _________
//   / _ \/ __/ | / / __ \/ /| | / / __/ _ \
//  / , _/ _/ | |/ / /_/ / /_| |/ / _// , _/
// /_/|_/___/ |___/\____/____/___/___/_/|_|
//
//  Created by keenteam on 16/2/1.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//
#define KPATA @"ReportCell"
#import "ReportCell.h"
#import "ReportPicViewController.h"
#import "MBProgressHUD.h"
@interface ReportPicViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *dataArray;
    UIAlertView *_alert;
    MBProgressHUD *HUD;
}
@end

@implementation ReportPicViewController
- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setToolbarHidden:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title =@"举报";
    self.view.backgroundColor = UIColorFromRGB(116,205, 169);
   
    [self createTableView];
     [self createRightBar];
    
}
- (void)createTableView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight) style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    _tableView.dataSource =self;
    _tableView.delegate =self;
    dataArray = [[NSMutableArray alloc]init];
    NSArray *arr = [NSArray arrayWithObjects:@"色情低俗",@"政治敏感",@"违法",@"广告骚扰",@"病毒木马",@"诱导分享",@"侵权投诉",@"售假举报",@"其他", nil];
    [dataArray addObjectsFromArray:arr];

}
- (void)createRightBar{
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(- 10, 0, 44, 20);
    
    [rightBtn setTitle:@"提交"  forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(ktUp:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = backItem;

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return dataArray.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ReportCell *cell =(ReportCell *)[tableView dequeueReusableCellWithIdentifier:KPATA];
    
    if (!cell) {
        NSArray *nib =[[NSBundle mainBundle]loadNibNamed:KPATA owner:[ReportCell class] options:nil];
        cell =(ReportCell *)[nib objectAtIndex:0];
    }
    cell.titleLbl.text = dataArray[indexPath.row];
    cell.selectBtn.tag =indexPath.row +100;
    [cell.selectBtn addTarget:self action:@selector(selectBt:) forControlEvents:UIControlEventTouchUpInside];
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    return cell;
}
- (void)selectBt:(UIButton *)btn{
    switch (btn.tag) {
        case 100:
        {
            if (btn.selected) {
                [btn setBackgroundImage:[UIImage imageNamed:@"未勾选34x34"] forState:UIControlStateNormal];
                btn.selected =NO;
            }
            else{
                [btn setBackgroundImage:[UIImage imageNamed:@"已勾选34x34"] forState:UIControlStateNormal];
               btn.selected =YES;
                
            }
            
        
        }
            break;
        case 101:
        {
            
            if (btn.selected) {
                [btn setBackgroundImage:[UIImage imageNamed:@"未勾选34x34"] forState:UIControlStateNormal];
                btn.selected =NO;
            }
            else{
                [btn setBackgroundImage:[UIImage imageNamed:@"已勾选34x34"] forState:UIControlStateNormal];
                btn.selected =YES;
                
            }
        }
            break;
        case 102:
        {
            if (btn.selected) {
                [btn setBackgroundImage:[UIImage imageNamed:@"未勾选34x34"] forState:UIControlStateNormal];
                btn.selected =NO;
            }
            else{
                [btn setBackgroundImage:[UIImage imageNamed:@"已勾选34x34"] forState:UIControlStateNormal];
                btn.selected =YES;
                
            }
            
        }
            break;
        case 103:
        {
            if (btn.selected) {
                [btn setBackgroundImage:[UIImage imageNamed:@"未勾选34x34"] forState:UIControlStateNormal];
                btn.selected =NO;
            }
            else{
                [btn setBackgroundImage:[UIImage imageNamed:@"已勾选34x34"] forState:UIControlStateNormal];
                btn.selected =YES;
                
            }
            
        }
            break;
        case 104:
        {
            if (btn.selected) {
                [btn setBackgroundImage:[UIImage imageNamed:@"未勾选34x34"] forState:UIControlStateNormal];
                btn.selected =NO;
            }
            else{
                [btn setBackgroundImage:[UIImage imageNamed:@"已勾选34x34"] forState:UIControlStateNormal];
                btn.selected =YES;
                
            }
            
        }
            break;
        case 105:
        {
            if (btn.selected) {
                [btn setBackgroundImage:[UIImage imageNamed:@"未勾选34x34"] forState:UIControlStateNormal];
                btn.selected =NO;
            }
            else{
                [btn setBackgroundImage:[UIImage imageNamed:@"已勾选34x34"] forState:UIControlStateNormal];
                btn.selected =YES;
                
            }
            
        }
            break;
        case 106:
        {
            if (btn.selected) {
                [btn setBackgroundImage:[UIImage imageNamed:@"未勾选34x34"] forState:UIControlStateNormal];
                btn.selected =NO;
            }
            else{
                [btn setBackgroundImage:[UIImage imageNamed:@"已勾选34x34"] forState:UIControlStateNormal];
                btn.selected =YES;
                
            }
            
        }
            break;
        case 107:
        {
            
            if (btn.selected) {
                [btn setBackgroundImage:[UIImage imageNamed:@"未勾选34x34"] forState:UIControlStateNormal];
                btn.selected =NO;
            }
            else{
                [btn setBackgroundImage:[UIImage imageNamed:@"已勾选34x34"] forState:UIControlStateNormal];
                btn.selected =YES;
                
            }
        }
            break;
        case 108:
        {
            if (btn.selected) {
                [btn setBackgroundImage:[UIImage imageNamed:@"未勾选34x34"] forState:UIControlStateNormal];
                btn.selected =NO;
            }
            else{
                [btn setBackgroundImage:[UIImage imageNamed:@"已勾选34x34"] forState:UIControlStateNormal];
                btn.selected =YES;
                
            }
            
        }
            break;
        default:
            break;
    }
}
- (void)ktUp:(UIButton*)barItem{
    
    HUD =[[MBProgressHUD alloc]initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.mode =MBProgressHUDModeText;
    HUD.dimBackground =YES;
    _alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"感谢您的举报,我们会在第一时间进行审核,谢谢您的支持!" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [_alert show];

    [HUD showAnimated:YES whileExecutingBlock:^{
        sleep(3);
    } completionBlock:^{
        [HUD removeFromSuperview];
        HUD =nil;
        [_alert dismissWithClickedButtonIndex:0 animated:NO];
          [self.navigationController popViewControllerAnimated:YES];
    }];
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSelector:@selector(select) withObject:nil afterDelay:0.5f];
//    NSLog(@"%ld",indexPath.row);
}
- (void)select{
    [_tableView deselectRowAtIndexPath:[_tableView indexPathForSelectedRow] animated:YES];

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 40;
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
