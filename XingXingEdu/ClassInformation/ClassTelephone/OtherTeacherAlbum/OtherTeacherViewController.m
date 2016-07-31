//
//  OtherTeacherViewController.m
//  XingXingEdu
//    ___  _____   ______  __ _   _________
//   / _ \/ __/ | / / __ \/ /| | / / __/ _ \
//  / , _/ _/ | |/ / /_/ / /_| |/ / _// , _/
// /_/|_/___/ |___/\____/____/___/___/_/|_|
//
//  Created by keenteam on 16/3/15.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//
#define KT @"yyyy年MM月dd日 HH:MM:ss"
#define kPData     @"UpLoadPicCell"
#import "OtherTeacherViewController.h"
#import "OtherTeacherInfoViewController.h"
#import "UpLoadPicCell.h"
#import "WZYAlbumDateISectionViewController.h"


@interface OtherTeacherViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSDateFormatter *fomatter;
    NSMutableArray *albumIDMArr;
    NSString *confromTimespStr;
    NSMutableArray *albmPicMArr;
    NSMutableArray *albmNameMArr;
    NSMutableArray *dateTmMArr;
    NSMutableArray *picNumMArr;
    NSInteger x;
}
@end

@implementation OtherTeacherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    fomatter =[[NSDateFormatter alloc]init];
    [fomatter setDateStyle:NSDateFormatterMediumStyle];
    [fomatter setTimeStyle:NSDateFormatterShortStyle];
    [fomatter setDateFormat:KT];
    self.title =[NSString stringWithFormat:@"%@的相册",self.KTitle];
    self.view.backgroundColor = UIColorFromRGB(196, 213, 255);
    albumIDMArr =[[NSMutableArray alloc]init];
    albmPicMArr =[[NSMutableArray alloc]init];
    dateTmMArr =[[NSMutableArray alloc]init];
    picNumMArr =[[NSMutableArray alloc]init];
    albmNameMArr =[[NSMutableArray alloc]init];
    [self createTableView];
    [self initData];
    // Do any additional setup after loading the view.
}
- (void)initData{
   
    NSString *urlStr = @"http://www.xingxingedu.cn/Parent/class_teacher_album";
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    NSString *class_idStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"CLASS_ID"];
    NSString *schoolIdStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"SCHOOL_ID"];
    
    //    NSLog(@"aaaa///////////class_idStr----%@; schoolIdStr------%@", class_idStr, schoolIdStr);
    
    NSDictionary *dict = @{@"appkey":APPKEY,
                           @"backtype":BACKTYPE,
                           @"xid":XID,
                           @"user_id":USER_ID,
                           @"user_type":USER_TYPE,
                           @"school_id":schoolIdStr,                        @"class_id":class_idStr,
                           @"teacher_id":[NSString stringWithFormat:@"%@",self.teacherID],
                           };

    
    // 服务器返回的数据格式
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer]; // 二进制数据
    [mgr POST:urlStr parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         
         if([[NSString stringWithFormat:@"%@",dict[@"code"]]isEqualToString:@"1"] )
         {
             NSArray *dataArr =dict[@"data"];
             for (int i=0 ; i<dataArr.count; i++) {
                 [albumIDMArr addObject:[dataArr[i] objectForKey:@"album_id"]];
                 [albmNameMArr addObject:[dataArr[i] objectForKey:@"album_name"]];
                 [albmPicMArr addObject:[dataArr[i] objectForKey:@"album_pic"]];
                 [dateTmMArr addObject:[dataArr[i] objectForKey:@"date_tm"]];
                 [picNumMArr addObject:[dataArr[i] objectForKey:@"pic_num"]];
             }
        
         }
         [_tableView reloadData];
         //@"网络不通，请检查网络！"
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@",error]];
         
     }];
    


}
- (void)createTableView{
    _tableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight) style:UITableViewStyleGrouped];
    _tableView.dataSource =self;
    _tableView.delegate   =self;
    [self.view addSubview:_tableView];
  
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    if (albmPicMArr.count>2) {
//        return 2;
//    }
    return albmPicMArr.count;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.00001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    UpLoadPicCell *cell = (UpLoadPicCell*) [tableView dequeueReusableCellWithIdentifier:kPData];
    if(cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:kPData owner:[UpLoadPicCell class] options:nil];
        cell = (UpLoadPicCell *)[nib objectAtIndex:0];
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
    

    [cell.imageV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",picURL,albmPicMArr[indexPath.row]]] placeholderImage: [UIImage imageNamed:@"占位图94x94@2x(1)"]];
    
    cell.albumLabel.text =albmNameMArr[indexPath.row];
    cell.numLabel.text =[NSString stringWithFormat:@"共%@张",picNumMArr[indexPath.row]];
    x =[NSString stringWithFormat:@"%@",dateTmMArr[indexPath.row]].integerValue;
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:x];
    confromTimespStr = [fomatter stringFromDate:confromTimesp];
    cell.timeLbl.text = [NSString stringWithFormat:@"%@",confromTimespStr];//@"共3张";
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WZYAlbumDateISectionViewController *WZYAlbumDateISectionVC = [[WZYAlbumDateISectionViewController alloc] init];
    WZYAlbumDateISectionVC.albumID = albumIDMArr[indexPath.row];
    [self.navigationController pushViewController:WZYAlbumDateISectionVC animated:YES];
}

@end
