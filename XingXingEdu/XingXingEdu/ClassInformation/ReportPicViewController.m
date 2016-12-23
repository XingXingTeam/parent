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
    NSMutableArray *idArray;
    NSMutableArray *seletedIdArray;
    UIAlertView *_alert;
    MBProgressHUD *HUD;
    NSMutableString * report_name_idStr;
    
    NSString *parameterXid;
    NSString *parameterUser_Id;

    
}


@end

@implementation ReportPicViewController

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setToolbarHidden:YES];
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
    
    seletedIdArray = [[NSMutableArray alloc] init];
   
    self.title =@"举报";
    
    self.view.backgroundColor = UIColorFromRGB(116,205, 169);
   
    [self fetchNetData];
    
    [self createTableView];
    [self createRightBar];
    
}

- (void)fetchNetData{
/*
 【举报列表(两端通用)】
 接口:
 http://www.xingxingedu.cn/Global/report_list
 */
    //路径
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/report_list";
    
    NSDictionary *params = @{@"appkey":APPKEY, @"backtype":BACKTYPE, @"xid":parameterXid, @"user_id":parameterUser_Id, @"user_type":USER_TYPE};
    
    [WZYHttpTool post:urlStr params:params success:^(id responseObj) {
        //
        idArray = [[NSMutableArray alloc] init];
        dataArray = [[NSMutableArray alloc] init];
        
//        NSLog(@"%@", responseObj);
        NSString *codeStr = [NSString stringWithFormat:@"%@", responseObj[@"code"]];
        
        if ([codeStr isEqualToString:@"1"]) {
        
          for (NSDictionary *dic in responseObj[@"data"]) {
            [idArray addObject:dic[@"id"]];
            [dataArray addObject:dic[@"name"]];
          }
            
        }else{
        
        
        }
        
        [_tableView reloadData];
        
    } failure:^(NSError *error) {
        //
        NSLog(@"%@", error);
    }];

}


- (void)createTableView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight) style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    _tableView.dataSource =self;
    _tableView.delegate =self;

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
- (void)selectBt:(UIButton *)btn  {
    
    NSString *idString = idArray[btn.tag - 100];
    
            if (btn.selected) {
                
                //由已勾选 变为 未勾选
                [btn setBackgroundImage:[UIImage imageNamed:@"未勾选34x34"] forState:UIControlStateNormal];
                btn.selected =NO;

                [seletedIdArray removeObject:idString];

            }
            else{
                //由未勾选 变为 已勾选
                [btn setBackgroundImage:[UIImage imageNamed:@"已勾选34x34"] forState:UIControlStateNormal];
               btn.selected =YES;
                
                [seletedIdArray addObject:idString];
                
            }
    
}




- (void)ktUp:(UIButton*)barItem{
    
    if (seletedIdArray.count == 0) {
        
        
    }else{
       
        [self submit];
    }
}


- (void)submit{
    /*
     【举报提交(两端通用)】
     接口:
     http://www.xingxingedu.cn/Global/report_sub
     传参:
     other_xid	//被举报人xid (举报用户时才有此参数)
     report_name_id	//举报内容id , 多个逗号隔开
     report_type	//举报类型 1:举报用户  2:举报图片
     url		//被举报的链接(report_type非等于1时才有此参数),如果是图片,不带http头部的,例如:app_upload/........
     origin_page	//举报内容来源(report_type非等于1时才有此参数),传参是数字:
     1:小红花赠言中的图片
     2:圈子图片
     3:猩课堂发布的课程图片
     4:学校相册图片
     5:班级相册
     6:老师点评
     7:作业图片
     */
    
    //路径
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/report_sub";
    //请求参数
    //获取学校id数组
    //    NSLog(@"已选 id  %@", seletedIdArray);
    NSMutableString *tidStr = [NSMutableString string];
    
    for (int j = 0; j < seletedIdArray.count; j ++) {
        NSString *str = seletedIdArray[j];
        
        if (j != seletedIdArray.count - 1) {
            [tidStr appendFormat:@"%@,", str];
        }else{
            [tidStr appendFormat:@"%@", str];
        }
    }
    
    report_name_idStr = tidStr;

    NSDictionary *params;
    
    if (_other_xidStr == nil) {
        //被举报的是图片
    params = @{@"appkey":APPKEY, @"backtype":BACKTYPE, @"xid":parameterXid, @"user_id":parameterUser_Id, @"user_type":USER_TYPE, @"report_name_id":report_name_idStr, @"report_type":@"2", @"url":_picUrlStr, @"origin_page":_origin_pageStr};
    }else{
    //被举报的是人
    params = @{@"appkey":APPKEY, @"backtype":BACKTYPE, @"xid":parameterXid, @"user_id":parameterUser_Id, @"user_type":USER_TYPE, @"report_name_id":report_name_idStr, @"report_type":@"1", @"other_xid":_other_xidStr};
    }
//        NSLog(@"传参  --  %@", params);
    
    HUD =[[MBProgressHUD alloc]initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.mode =MBProgressHUDModeText;
    HUD.dimBackground =YES;
    
    [WZYHttpTool post:urlStr params:params success:^(id responseObj) {
        //
//        NSLog(@"jb %@", responseObj);
        
        NSString *codeStr = [NSString stringWithFormat:@"%@", responseObj[@"code"]];
        
        if ([codeStr isEqualToString:@"1"]) {

            _alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"感谢您的举报,我们会在第一时间进行审核,谢谢您的支持!" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [_alert show];
            
            [HUD showAnimated:YES whileExecutingBlock:^{
                sleep(1.5);
            } completionBlock:^{
                [HUD removeFromSuperview];
                HUD =nil;
                [_alert dismissWithClickedButtonIndex:0 animated:NO];
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }else{
            
        }
        
    } failure:^(NSError *error) {
        //
        NSLog(@"%@", error);

        _alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"提交失败,请重新提交!" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [_alert show];
        
        [HUD showAnimated:YES whileExecutingBlock:^{
            sleep(1.5);
        } completionBlock:^{
            [HUD removeFromSuperview];
            HUD =nil;
            [_alert dismissWithClickedButtonIndex:0 animated:NO];

        }];
        
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

@end
