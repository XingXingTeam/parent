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
#import "RedFlowerViewController.h"

@interface ClassHomeInfoMationViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *dataArr;
    NSMutableArray *picMArr;
    
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
    
    NSArray *headArr;
    NSArray *titleArr;
    NSMutableArray *contentArray;
    
    NSInteger picRow;
    
    NSMutableArray *picDataSource;
    
}
@end

@implementation ClassHomeInfoMationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.title =@"作业详情";
    self.view.backgroundColor = UIColorFromRGB(196, 213, 255);
    
    dataArr =[[NSMutableArray alloc]init];
    headArr =@[@"release40x44",@"作业主题40x40",@"作业内容40x40",@"releaseTime40x40",@"上交时间40x40"];
    titleArr =@[@"发布人:",@"作业主题:",@"作业内容:",@"发布时间:",@"交作业时间:"];
    
    [dataArr addObject:headArr];
    [dataArr addObject:titleArr];
    
    [self initData];
    [self createTableView];
    
}
- (void)initData{
    //加载网络数据
    NSString *urlStr = @"http://www.xingxingedu.cn/Parent/class_homework_detail";
    
    NSString *parameterXid;
    NSString *parameterUser_Id;
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }
    
    NSDictionary *dict = @{@"appkey":APPKEY,
                           @"backtype":BACKTYPE,
                           @"xid":parameterXid,
                           @"user_id":parameterUser_Id,
                           @"user_type":USER_TYPE,
                           @"homework_id":self.idStr,
                           };
    
    [WZYHttpTool post:urlStr params:dict success:^(id responseObj) {
        
        if([[NSString stringWithFormat:@"%@",responseObj[@"code"]]isEqualToString:@"1"] )
        {
            picDataSource = [[NSMutableArray alloc] init];
            picMArr = [[NSMutableArray alloc] init];
            
            NSDictionary *dict =responseObj[@"data"];
            
            conStr = dict[@"con"];
            
            date_end_tmStr = [WZYTool dateStringFromNumberTimer:dict[@"date_end_tm"]];
            date_tmStr = [WZYTool dateStringFromNumberTimer:dict[@"date_tm"]];
            teach_courseStr = dict[@"teach_course"];
            titleStr = dict[@"title"];
            tnameStr = dict[@"tname"];
            picMArr = dict[@"pic_group"];
            
            contentArray = [[NSMutableArray alloc] initWithObjects:tnameStr, titleStr, conStr, date_tmStr, date_end_tmStr, nil];
            
            [picDataSource addObject:picMArr];
        }
        //        NSLog(@" 图片 %@", picMArr);
        /*
         [
         app_upload/text/homework/1.jpg,
         app_upload/text/homework/2.jpg,
         app_upload/text/homework/3.jpg,
         app_upload/text/homework/4.jpg,
         app_upload/text/homework/5.jpg
         ]
         */
        
        [dataArr addObject:contentArray];
        
        
        [_tableView reloadData];
        
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
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
        return 40 + picRow * 80;
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
    
    cell.headImagV.image =[UIImage imageNamed:dataArr[0][indexPath.row]];
    cell.titleLbl.text =dataArr[1][indexPath.row];
    if (dataArr.count == 3) {
        cell.detailLbl.text =dataArr[2][indexPath.row];
        
    }
    
    if (indexPath.row == 3) {
        
        //result= num1>num2?num1:num2;
        
        if (picMArr.count % 4 == 0) {
            picRow = picMArr.count / 4;
        }else{
            
            picRow = picMArr.count / 4 + 1;
        }
        //创建 十二宫格  三行、四列
        //              int totalLine = 4;
        //              int buttonCount = 12;
        int margin = 5;
        CGFloat picWidth = (kWidth - 5 * margin) / 4;
        CGFloat picHeight = picWidth;
        
        for (int i = 0; i < picMArr.count; i++) {
            
            //行
            int buttonRow = i / 4;
            
            //列
            int buttonLine = i % 4;
            
            CGFloat buttonX = (picWidth + margin) * buttonLine;
            CGFloat buttonY = 40 + (picHeight + margin) * buttonRow;
            
            UIImageView *pictureImageView = [[UIImageView alloc] initWithFrame:CGRectMake(buttonX, buttonY, picWidth, picHeight)];
            
            [pictureImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", picURL, picMArr[i]]]];
            pictureImageView.tag = 20 + i;
            pictureImageView.userInteractionEnabled = YES;
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickPicture:)];
            [pictureImageView addGestureRecognizer:tap];
            
            [cell.contentView addSubview:pictureImageView];
            
        }
        
    }
    
    
    return cell;
}

- (void)onClickPicture:(UITapGestureRecognizer *)tap{
    
    RedFlowerViewController *redFlowerVC =[[RedFlowerViewController alloc]init];
    NSMutableArray *imageArr = picMArr;
    redFlowerVC.index = tap.view.tag - 20;
    redFlowerVC.imageArr = imageArr;
    //举报 来源 7:作业图片
    redFlowerVC.origin_pageStr = @"7";
    redFlowerVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:redFlowerVC animated:YES];
    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==2) {
        ClassHomeWorkContentViewController *classHomeWorkContentVC =[[ClassHomeWorkContentViewController alloc]init];
        classHomeWorkContentVC.contentStr =dataArr[2][indexPath.row];
        [self.navigationController pushViewController:classHomeWorkContentVC animated:YES];
        
    }
}




@end
