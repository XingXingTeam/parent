//
//  OtherTeacherInfoViewController.m
//  XingXingEdu
//
//  Created by keenteam on 16/3/15.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//
#define KT @"yyyy年MM月dd日 HH:MM:ss"
#define kPData @"PhotoCell"
#import "OtherTeacherInfoViewController.h"
#import "PhotoCell.h"
#import "UpViewController.h"
#import "MBProgressHUD.h"
#import <ShareSDKUI/ShareSDKUI.h>
#import <ShareSDKExtension/SSEShareHelper.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
#import <ShareSDKUI/SSUIShareActionSheetCustomItem.h>
#import <ShareSDK/ShareSDK+Base.h>
// UM
#import "UMSocial.h"
#import "UMSocialSinaHandler.h"
#import "APOpenAPI.h"
#import "HHControl.h"
#import <ShareSDKExtension/ShareSDK+Extension.h>
#import "ReportPicViewController.h"
#import "CoreUMeng.h"
@interface OtherTeacherInfoViewController ()<UITableViewDataSource,UITableViewDelegate,UMSocialUIDelegate>
{
    NSMutableArray *KTSectionMA;
    UITableView *_tableView;
    NSMutableArray *dataArray;
    NSMutableDictionary *editDict;
    UIBarButtonItem *rightBar;
    UIBarButtonItem *leftBar;
    UIButton       * saveBtn;
    MBProgressHUD *HUD;
    MBProgressHUD *HUDH;
    UIImageView *imageV;
    NSArray *sectionArr;
    NSMutableArray *idMArr;
    NSDateFormatter *fomatter;
    NSString *confromTimespStr;
    NSMutableArray *picMArr;
    NSMutableArray *totalpicMArr;
    NSMutableArray *titleMArr;
    NSMutableArray *imageMArr;
    NSMutableArray *goodNumMArr;
    NSMutableArray *KTMArr;
    
    int  x;
    int  t;
    NSInteger o;
    
}
@end

@implementation OtherTeacherInfoViewController
- (void)viewWillDisappear:(BOOL)animated{

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =self.albumName;
    self.view.backgroundColor = UIColorFromRGB(116,205, 169);
    // Do any additional setup after loading the view.
    idMArr =[[NSMutableArray alloc]init];
    dataArray=[[NSMutableArray alloc]init];
    totalpicMArr =[[NSMutableArray alloc]init];
    titleMArr =[[NSMutableArray alloc]init];
    imageMArr =[[NSMutableArray alloc]init];
    goodNumMArr =[[NSMutableArray alloc]init];
    KTMArr =[[NSMutableArray alloc]init];
    fomatter =[[NSDateFormatter alloc]init];
    [fomatter setDateStyle:NSDateFormatterMediumStyle];
    [fomatter setTimeStyle:NSDateFormatterShortStyle];
    [fomatter setDateFormat:KT];
    [self createTableView];
    [self initData];
}
- (void)initData{
    t=0;
    NSString *urlStr = @"http://www.xingxingedu.cn/Parent/class_album_pic";
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *dict = @{@"appkey":@"U3k8Dgj7e934bh5Y",
                           @"backtype":@"json",
                           @"xid":XID,
                           @"user_id":@"1",
                           @"user_type":@"1",
                           @"school_id":@"1",
                           @"grade":@"1",
                           @"class":@"1",
                           @"album_id":[NSString stringWithFormat:@"%@",self.albumID],
                           };
    
    // 服务器返回的数据格式
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer]; // 二进制数据
    [mgr POST:urlStr parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        // NSLog(@"~~~~~~%@",dict);
         if([[NSString stringWithFormat:@"%@",dict[@"code"]]isEqualToString:@"1"] )
         {
             KTSectionMA =[[NSMutableArray alloc]init];
             
             for (NSString *s in dict[@"data"]) {
                 [dataArray addObject:[NSString stringWithFormat:@"%@",s]];
                 sectionArr =[dict[@"data"] allKeys];
                 NSArray *arr= [dict[@"data"] objectForKey:s];
                 NSLog(@"%@",arr);
                 for (int j=0; j<arr.count; j++) {
                     [goodNumMArr addObject:[arr[j] objectForKey:@"good_num"]];
                     [idMArr addObject:[arr[j]  objectForKey:@"id"]];
                     
                   }
                 
                 if (arr.count%3 ==0) {
                     x =(int)arr.count/3;
                 }
                 else{
                     x =(int)arr.count/3+1;
                 }
                 
                 for (int j=0; j<x; j++) {
                       picMArr=[[NSMutableArray alloc]init];
                     for (int i=0; i<3; i++) {
                         if (t>=arr.count)
                            {
                              [picMArr addObject:[NSString stringWithFormat:@""]];
                            }
                         else {
                         [picMArr addObject:[arr[t++] objectForKey:@"pic"]];
                            }
                     }
                      [totalpicMArr addObject:picMArr];
                   
                 }
                 [KTSectionMA addObject:totalpicMArr];
            
             }
             [KTMArr addObject:KTSectionMA];
           
      }
         [self initTime];
         [_tableView reloadData];
         //@"网络不通，请检查网络！"
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@",error]];
         
     }];


}
- (void)initTime{
    
    for (int  b=0; b<dataArray.count; b++) {
        o =[NSString stringWithFormat:@"%@",dataArray[b]].integerValue;
        NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:o];
        confromTimespStr = [fomatter stringFromDate:confromTimesp];
     [titleMArr addObject:[NSString stringWithFormat:@"%@",confromTimespStr]];
        
    }

}
- (void)createToolbtn{
   imageV= [[UIImageView alloc]initWithFrame:CGRectMake(0, kHeight-49, kWidth, 49)];
    imageV.backgroundColor = UIColorFromRGB(255, 255, 255 );
    [self.view addSubview:imageV];
     imageV.hidden =YES;
    imageV.userInteractionEnabled =YES;
    
    UIButton *shareBtn = [[UIButton alloc]initWithFrame:CGRectMake(kWidth/2-20, 2, 30, 30)];
    [shareBtn setTitle:@"" forState:UIControlStateNormal];
    [shareBtn setImage:[UIImage imageNamed:@"分享icon60x48"] forState:UIControlStateNormal];
    [shareBtn setImage:[UIImage imageNamed:@"分享(H)icon60x48"] forState:UIControlStateHighlighted];
    [shareBtn addTarget:self action:@selector(shareButn:) forControlEvents:UIControlEventTouchUpInside];
    [imageV addSubview:shareBtn];
    
    UILabel *shareLbl =[HHControl createLabelWithFrame:CGRectMake(kWidth/2-15, 30, 20, 18) Font:10 Text:@"分享"];
    [imageV addSubview:shareLbl];
    
    
    
    UIButton *downBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, 2, 30, 30)];
    [downBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [downBtn setTitle:@"" forState:UIControlStateNormal];
    [downBtn setImage:[UIImage imageNamed:@"下载icon48x48"] forState:UIControlStateNormal];
    [downBtn setImage:[UIImage imageNamed:@"下载(H)icon48x48"] forState:UIControlStateHighlighted];
    [downBtn addTarget:self action:@selector(downButn:) forControlEvents:UIControlEventTouchUpInside];
    [imageV addSubview:downBtn];
    
    UILabel *downLbl =[HHControl createLabelWithFrame:CGRectMake(23, 30, 20, 18) Font:10 Text:@"下载"];
    [imageV addSubview:downLbl];
    
    saveBtn = [[UIButton alloc]initWithFrame:CGRectMake(kWidth-45, 2, 30, 30)];
    [saveBtn setTitle:@"" forState:UIControlStateNormal];
    [saveBtn setImage:[UIImage imageNamed:@"点赞icon48x48@2x"] forState:UIControlStateNormal];
    [saveBtn setImage:[UIImage imageNamed:@"点赞（H）icon48x48@2x"] forState:UIControlStateHighlighted];
    [imageV addSubview:saveBtn];
    [saveBtn addTarget:self action:@selector(shareBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *saveLbl =[HHControl createLabelWithFrame:CGRectMake(kWidth-43, 30, 20, 18) Font:10 Text:@"点赞"];
    [imageV addSubview:saveLbl];
    
    
}
- (void)shareBtn:(UIButton*)shareBtn{
    
    HUDH =[[MBProgressHUD alloc]initWithView:self.view];
    [self.view addSubview:HUDH];
    
    if (shareBtn.selected ) {
        shareBtn.selected=NO;
        
        HUDH.dimBackground =YES;
        [shareBtn setFrame:CGRectMake(kWidth-45, 2, 30, 30)];
        [shareBtn setBackgroundImage:[UIImage  imageNamed:@"点赞icon48x48@2x"] forState:UIControlStateNormal];
        
        HUDH.labelText =@"取消点赞";
        
        [HUDH showAnimated:YES whileExecutingBlock:^{
            sleep(1);
        } completionBlock:^{
            [HUDH removeFromSuperview];
            HUDH =nil;
            rightBar.title = @"编辑";
            imageV.hidden =YES;
            [_tableView setEditing:NO];
        }];
    }
    else{
        shareBtn.selected=YES;
        [shareBtn setFrame:CGRectMake(kWidth-45, 2, 30, 30)];
        [shareBtn setBackgroundImage:[UIImage  imageNamed:@"点赞（H）icon48x48@2x"] forState:UIControlStateNormal];
        HUDH.dimBackground =YES;
        HUDH.labelText =@"已点赞";
        
        [HUDH showAnimated:YES whileExecutingBlock:^{
            sleep(1);
        } completionBlock:^{
            [HUDH removeFromSuperview];
            HUDH =nil;
            rightBar.title = @"编辑";
             imageV.hidden =YES;
            [_tableView setEditing:NO];
        }];
    }
    
    

   
}

- (void)shareButn:(UIButton*)btn{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *action1 =[UIAlertAction actionWithTitle:@"分享" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

         [CoreUmengShare show:self text:@"为了孩子的未来,这里有你想要的一切,快点点击下载吧！https://itunes.apple.com/cn/app/jie-dian-qian-zhuan-ye-ban/id1112373854?mt=8&v0=WWW-GCCN-ITSTOP100-FREEAPPS&l=&ign-mpt=uo%3D4" image:[UIImage imageNamed:@"猩猩教室.png"]];
    
    }];
    UIAlertAction *action2 =[UIAlertAction actionWithTitle:@"举报 " style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        ReportPicViewController *reportPicVC = [[ReportPicViewController alloc]init];
        [self.navigationController pushViewController:reportPicVC animated:YES];
        
    }];
    UIAlertAction *action3 =[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:action1];
    [alertController addAction:action2];
    [alertController addAction:action3];
    [self presentViewController:alertController animated:YES completion:nil];

}
- (BOOL)isDirectShareInIconActionSheet{
    return YES;
}
- (void)downButn:(UIButton*)btn{
    HUD =[[MBProgressHUD alloc]initWithView:self.view];
    [self.view addSubview:HUD];
    
    HUD.dimBackground =YES;
    HUD.labelText =@"正在下载中.....";
    [HUD showAnimated:YES whileExecutingBlock:^{
        sleep(3);
    } completionBlock:^{
        [HUD removeFromSuperview];
        HUD =nil;
         rightBar.title = @"编辑";
        imageV.hidden =YES;
        [_tableView setEditing:NO];
    }];
    
}

- (void)createTabBar{

   rightBar =[[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(rightBar:)];
    self.navigationItem.rightBarButtonItem =rightBar;


}
- (void)rightBar:(UIBarButtonItem*)rightBa{
    if ([rightBa.title isEqualToString:@"编辑"]) {
        NSLog(@"编辑");
       rightBar.title = @"确定";
        imageV.hidden =NO;
        [_tableView setEditing:YES animated:YES];
    }
    else {
        rightBar.title = @"编辑";
          imageV.hidden =YES;
     
        [_tableView setEditing:NO animated:YES];
    }

}


- (void)createTableView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight) style:UITableViewStyleGrouped];
    _tableView.dataSource =self;
    _tableView.delegate =self;
    [self.view addSubview:_tableView];
}
#pragma mark -
#pragma mark Table view delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return sectionArr.count;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
    return x;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PhotoCell *cell = (PhotoCell*) [tableView dequeueReusableCellWithIdentifier:kPData];
    if(cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:kPData owner:[PhotoCell class] options:nil];
        cell = (PhotoCell *)[nib objectAtIndex:0];
      
    }
   
    [cell.imageV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",picURL,KTSectionMA[indexPath.section][indexPath.row][0]]] placeholderImage: [UIImage imageNamed:@"picterPlace"]];
    [cell.imagV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",picURL,KTSectionMA[indexPath.section][indexPath.row][1]]] placeholderImage: [UIImage imageNamed:@"picterPlace"]];
      [cell.imaV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",picURL,KTSectionMA[indexPath.section][indexPath.row][2]]] placeholderImage: [UIImage imageNamed:@"picterPlace"]];
    cell.selectionStyle =UITableViewCellSelectionStyleNone;
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([rightBar.title isEqualToString:@"确定"]) {
      
    }
    else
    {
        for (int n=0; n<[KTSectionMA[indexPath.section] count]; n++) {
          
            for (int m=0; m<[KTSectionMA[indexPath.section][n] count]; m++) {
                [imageMArr addObject:KTSectionMA[indexPath.section][n][m]];
            }
            
            
        }
        
    UpViewController *upVC =[[UpViewController alloc]init];
    upVC.i =imageMArr.count;
    upVC.index =indexPath.row;
    upVC.imageA =imageMArr;
    upVC.goodNMArr =goodNumMArr;
    upVC.idMArr =idMArr;
    upVC.albumID =[NSString stringWithFormat:@"%@",self.albumID];
    [self.navigationController pushViewController:upVC animated:YES];
    }
    
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([rightBar.title isEqualToString:@"确定"]) {
    }

}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section ==0) {
        return 25;
    }
    else{
    return 10;
    }
}
- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{

    return titleMArr[section];
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
