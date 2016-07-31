//
//  ClassHomeInfoMationViewController.m
//  XingXingEdu
//    ___  _____   ______  __ _   _________
//   / _ \/ __/ | / / __ \/ /| | / / __/ _ \
//  / , _/ _/ | |/ / /_/ / /_| |/ / _// , _/
// /_/|_/___/ |___/\____/____/___/___/_/|_|
//
//  Created by keenteam on 16/5/10.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//
#define KT @"yyyy年MM月dd日 HH:MM:ss"
#define KDATA @"HomeWorkCell"
#import "ClassHomeInfoMationViewController.h"
#import "ClassHomeWorkContentViewController.h"
#import "HHControl.h"
#import "HomeWorkCell.h"
@interface ClassHomeInfoMationViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *dataArr;
    NSMutableArray *picMArr;
    NSArray *headArr;
    NSDateFormatter *fomatter;
    NSString *confromTimespStr;
    NSString *confromTimeStr;
    NSString *conStr;
    NSString *date_end_tmStr;
    NSString *date_tmStr ;
    NSString *teach_courseStr;
    NSString *titleStr;
    NSString *tnameStr;
    NSInteger x;
    NSInteger y;
    
}
@end

@implementation ClassHomeInfoMationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    picMArr =[[NSMutableArray alloc]init];
    // Do any additional setup after loading the view from its nib.
    self.title =@"作业详情";
    self.view.backgroundColor = UIColorFromRGB(196, 213, 255);
    fomatter =[[NSDateFormatter alloc]init];
    [fomatter setDateStyle:NSDateFormatterMediumStyle];
    [fomatter setTimeStyle:NSDateFormatterShortStyle];
    [fomatter setDateFormat:KT];
    [self initData];
    [self createTableView];
   
}
- (void)initData{
    //加载网络数据
    NSString *urlStr = @"http://www.xingxingedu.cn/Parent/class_homework_detail";
    NSDictionary *dict = @{@"appkey":APPKEY,
                           @"backtype":BACKTYPE,
                           @"xid":XID,
                           @"user_id":USER_ID,
                           @"user_type":USER_TYPE,
                           @"homework_id":self.idStr,
                           };
    
    [WZYHttpTool post:urlStr params:dict success:^(id responseObj) {
        NSDictionary *dict =responseObj;
        
        if([[NSString stringWithFormat:@"%@",dict[@"code"]]isEqualToString:@"1"] )
        {
           // NSLog(@"data ========%@",dict[@"data"]);
            conStr =[dict[@"data"] objectForKey:@"con"];
            date_end_tmStr =[dict[@"data"] objectForKey:@"date_end_tm"];
            date_tmStr =[dict[@"data"] objectForKey:@"date_tm"];
            teach_courseStr =[dict[@"data"] objectForKey:@"teach_course"];
            titleStr =[dict[@"data"] objectForKey:@"title"];
            tnameStr =[dict[@"data"] objectForKey:@"tname"];
         NSArray *arr =[dict[@"data"] objectForKey:@"pic_group"];
            if (arr.count!=0) {
                for (int j=0; j<arr.count; j++) {
                    [picMArr addObject:arr[j]];
                }
            }
        }
        [self initUI];
        [_tableView reloadData];
    
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}
- (void)initUI{

    dataArr =[[NSMutableArray alloc]init];
    headArr =@[@"release40x44",@"作业主题40x40",@"作业内容40x40",@"",@"releaseTime40x40",@"上交时间40x40"];
    NSArray *titleArr =@[@"发布人:",@"作业主题:",@"作业内容:",@"",@"发布时间:",@"交作业时间:"];
    x =[NSString stringWithFormat:@"%@",date_tmStr].integerValue;
    y =[NSString stringWithFormat:@"%@",date_end_tmStr].integerValue;
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:x];
     NSDate *confromTime = [NSDate dateWithTimeIntervalSince1970:y];
    confromTimespStr = [fomatter stringFromDate:confromTimesp];
    confromTimeStr = [fomatter stringFromDate:confromTime];
    
    
    NSArray *nameArr =@[[NSString stringWithFormat:@"%@",tnameStr],[NSString stringWithFormat:@"%@",titleStr],[NSString stringWithFormat:@"%@",conStr],@"",[NSString stringWithFormat:@"%@",confromTimespStr],[NSString stringWithFormat:@"%@",confromTimeStr]];
    [dataArr addObject:headArr];
    [dataArr addObject:titleArr];
    [dataArr addObject:nameArr];

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
    return headArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.00001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row==3) {
        return 200;
    }
    else{
        return 40;
    }

}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeWorkCell *cell =(HomeWorkCell*)[tableView dequeueReusableCellWithIdentifier:KDATA];
    if (!cell) {
        NSArray *nib =[[NSBundle mainBundle]loadNibNamed:KDATA owner:[HomeWorkCell class] options:nil];
        cell =(HomeWorkCell*)[nib objectAtIndex:0];
    }
    if (indexPath.row==2) {
        cell.bgImageV.hidden =YES;
        cell.headImagV.hidden =NO;
        cell.titleLbl.hidden =NO;
        cell.detailLbl.hidden =NO;
        cell.headImagV.image =[UIImage imageNamed:dataArr[0][indexPath.row]];
        cell.titleLbl.text =dataArr[1][indexPath.row];
        cell.detailLbl.text =dataArr[2][indexPath.row];
        cell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
    }
   else if (indexPath.row==3) {
        cell.headImagV.hidden =YES;
        cell.titleLbl.hidden =YES;
        cell.detailLbl.hidden =YES;
        cell.bgImageV.hidden =NO;
        if (picMArr.count !=0) {
            [cell.bgImageV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",picURL,picMArr[0]]] placeholderImage:[UIImage imageNamed:@"picterPlace"]];
        }
        else{
        
            [cell.bgImageV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",picURL,@"app_upload/text/homework/4.jpg"]] placeholderImage:[UIImage imageNamed:@"picterPlace"]];;
        }
        
      
    }
    else{
        cell.bgImageV.hidden =YES;
        cell.headImagV.hidden =NO;
        cell.titleLbl.hidden =NO;
        cell.detailLbl.hidden =NO;
        cell.headImagV.image =[UIImage imageNamed:dataArr[0][indexPath.row]];
        cell.titleLbl.text =dataArr[1][indexPath.row];
        cell.detailLbl.text =dataArr[2][indexPath.row];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==2) {
        ClassHomeWorkContentViewController *classHomeWorkContentVC =[[ClassHomeWorkContentViewController alloc]init];
        classHomeWorkContentVC.contentStr =dataArr[2][indexPath.row];
        [self.navigationController pushViewController:classHomeWorkContentVC animated:YES];
        
    }
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
