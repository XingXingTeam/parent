//
//  noticeViewController.m
//  Homepage
//
//  Created by super on 16/2/3.
//  Copyright © 2016年 Edu. All rights reserved.
//
#define KT @"yyyy年MM月dd日 HH:MM:ss"
#import "noticeViewController.h"
#import "schoolTableViewCell.h"
#import "NoticeInfomationViewController.h"
#import "NoticeSettingInfomationViewController.h"
@interface noticeViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *schoolDataArr;
    NSMutableArray *officialDataArr;
    
    NSMutableArray * idMArr;
    NSMutableArray * typeMArr;
    NSMutableArray * school_idMArr;
    NSMutableArray * gradeMArr;
    NSMutableArray * classMArr;
    NSMutableArray * date_tmMArr;
    NSMutableArray * titleMArr;
    NSMutableArray * conMArr;
    NSMutableArray * tidMArr;
    NSMutableArray * examine_tidMArr;
    NSMutableArray * school_logoMArr;
    NSMutableArray * tnameMArr;
    NSMutableArray * school_nameMArr;
    NSDateFormatter *fomatter;
    NSString *confromTimespStr;
    NSMutableArray * iconImgMArr;
    NSMutableArray * schoolNameMArr;
    NSMutableArray * detailNameMArr;
    NSMutableArray * timeMArr;
     //系统
    NSMutableArray * KTidMArr;
    NSMutableArray * KTtypeMArr;
    NSMutableArray * KTdate_tmMArr;
    NSMutableArray * KTtitleMArr;
    NSMutableArray * KTschool_logoMArr;
    NSMutableArray * KTschool_nameMArr;
    NSMutableArray * KTconMArr;
    
    NSInteger x;
    UISegmentedControl *segementedControl;
    NSInteger a;
    
    int schoolFootRefresh;
    int officialFootRefresh;
    
}

@property (strong, nonatomic) IBOutlet UITableView *releaseTabelView;
@property (strong ,nonatomic)NSMutableArray * dataArray;
@end

@implementation noticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    fomatter =[[NSDateFormatter alloc]init];
    [fomatter setDateStyle:NSDateFormatterMediumStyle];
    [fomatter setTimeStyle:NSDateFormatterShortStyle];
    [fomatter setDateFormat:KT];

    a = 0;
    
    [self createLeftButton];
    [self createSegement];
    [self  loadMoreData:1];
    
}


- (void)createSegement{
    
    schoolDataArr = [NSMutableArray array];
    officialDataArr = [NSMutableArray array];
    //校园
    idMArr =[[NSMutableArray alloc]init];
    typeMArr =[[NSMutableArray alloc]init];
    school_idMArr =[[NSMutableArray alloc]init];
    gradeMArr =[[NSMutableArray alloc]init];
    classMArr =[[NSMutableArray alloc]init];
    date_tmMArr =[[NSMutableArray alloc]init];
    titleMArr =[[NSMutableArray alloc]init];
    conMArr =[[NSMutableArray alloc]init];
    tidMArr =[[NSMutableArray alloc]init];
    examine_tidMArr =[[NSMutableArray alloc]init];
    school_logoMArr =[[NSMutableArray alloc]init];
    tnameMArr =[[NSMutableArray alloc]init];
    school_nameMArr =[[NSMutableArray alloc]init];
    
    //系统
    KTidMArr =[[NSMutableArray alloc]init];
    KTtypeMArr =[[NSMutableArray alloc]init];
    KTdate_tmMArr =[[NSMutableArray alloc]init];
    KTtitleMArr =[[NSMutableArray alloc]init];
    KTschool_logoMArr =[[NSMutableArray alloc]init];
    KTschool_nameMArr =[[NSMutableArray alloc]init];
    KTconMArr =[[NSMutableArray alloc]init];
    
    
    iconImgMArr =[[NSMutableArray alloc]init];
    schoolNameMArr =[[NSMutableArray alloc]init];
    detailNameMArr =[[NSMutableArray alloc]init];
    timeMArr =[[NSMutableArray alloc]init];
    
    schoolFootRefresh = 1;
    officialFootRefresh = 1;
    
    
    segementedControl =[[UISegmentedControl alloc]initWithFrame:CGRectMake(80, 5, 100, 30)];
    [segementedControl insertSegmentWithTitle:@"校园通知" atIndex:0 animated:NO];
    [segementedControl insertSegmentWithTitle:@"系统消息" atIndex:1 animated:NO];
    self.navigationItem.titleView = segementedControl;
    segementedControl.tintColor =[UIColor whiteColor];
    segementedControl.selectedSegmentIndex =0;
    [segementedControl addTarget:self action:@selector(controlPressed:) forControlEvents:UIControlEventValueChanged];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.releaseTabelView.delegate = self;
    self.releaseTabelView.dataSource = self;
    self.releaseTabelView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(MJloadMoreData)];
    UINib *nib = [UINib nibWithNibName:@"schoolTableViewCell" bundle:nil];
    [self.releaseTabelView registerNib:nib forCellReuseIdentifier:@"cell"];
    
}

-(void)MJloadMoreData{
    a = segementedControl.selectedSegmentIndex;
    if(a == 0){
        schoolFootRefresh ++;
        [self loadMoreData:schoolFootRefresh];
    }
    else if(a == 1){
        
        officialFootRefresh++;
        [self loadSetData:officialFootRefresh];
    }
    [self.releaseTabelView.footer endRefreshing];
}


-(void)createLeftButton{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(- 10, 0, 44, 20);
    
    [backBtn setImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(doBack:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
}
-(void)doBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)loadMoreData:(NSInteger)page{

    //加载网络数据
  NSString * urlStr = @"http://www.xingxingedu.cn/Parent/school_notice";
  NSDictionary * pragm = @{ @"appkey":APPKEY,
                           @"backtype":BACKTYPE,
                           @"xid":XID,
                           @"user_id":USER_ID,
                           @"user_type":USER_TYPE,
                           @"school_id":@"1",
                           @"grade":@"1",
                           @"class":@"1",
                           @"page":[NSString stringWithFormat:@"%ld",(long)page],
                           };

  [WZYHttpTool post:urlStr params:pragm success:^(id responseObj) {
       NSDictionary *dict =responseObj;
      
//      NSLog(@"===========school_notice===========%@",dict);
    if([[NSString stringWithFormat:@"%@",dict[@"code"]]isEqualToString:@"1"] )
    {
           schoolDataArr = dict[@"data"];
        
        if (schoolDataArr.count > 0) {
            for (int i=0; i<schoolDataArr.count; i++) {
                [idMArr addObject:[schoolDataArr[i] objectForKey:@"id"]];
                [typeMArr addObject:[schoolDataArr[i] objectForKey:@"type"]];
                [school_idMArr  addObject:[schoolDataArr[i] objectForKey:@"school_id"]];
                [gradeMArr  addObject:[schoolDataArr[i] objectForKey:@"grade"]];
                [classMArr addObject:[schoolDataArr[i] objectForKey:@"class"]];
                [date_tmMArr addObject:[schoolDataArr[i] objectForKey:@"date_tm"]];
                [titleMArr addObject:[schoolDataArr[i] objectForKey:@"title"]];
                [conMArr addObject:[schoolDataArr[i] objectForKey:@"con"]];
                [tidMArr addObject:[schoolDataArr[i] objectForKey:@"tid"]];
                [examine_tidMArr addObject:[schoolDataArr[i] objectForKey:@"examine_tid"]];
                [school_logoMArr addObject:[schoolDataArr[i] objectForKey:@"school_logo"]];
                [tnameMArr addObject:[schoolDataArr[i] objectForKey:@"tname"]];
                [school_nameMArr addObject:[schoolDataArr[i] objectForKey:@"school_name"]];
            }

        }else{
         [SVProgressHUD showInfoWithStatus:@"没有更多数据了..."];
        }
        
    }
      [self initUI];
    [self.releaseTabelView reloadData];
    
      } failure:^(NSError *error) {
    
         NSLog(@"%@", error);
    
     }];

}
- (void)initUI{

    iconImgMArr = school_logoMArr;
    schoolNameMArr = school_nameMArr;
    detailNameMArr = titleMArr;
    timeMArr = date_tmMArr;

}
- (void)loadSetData:(NSInteger)page{
// con   date_tm  id  title  type
    
    //加载网络数据
    NSString * urlStr = @"http://www.xingxingedu.cn/Global/official_notice";
    NSDictionary * pragm = @{ @"appkey":APPKEY,
                              @"backtype":BACKTYPE,
                              @"xid":XID,
                              @"user_id":USER_ID,
                              @"user_type":USER_TYPE,
                              @"app_type":@"1",
                              @"page":[NSString stringWithFormat:@"%ld",(long)page],
                              };
    
    [WZYHttpTool post:urlStr params:pragm success:^(id responseObj) {
        NSDictionary *dict =responseObj;
        
//         NSLog(@"===========official_notice===========%@",dict);
        if([[NSString stringWithFormat:@"%@",dict[@"code"]]isEqualToString:@"1"] )
        {
           officialDataArr =dict[@"data"];
            if (officialDataArr > 0) {
                for (int i=0; i<officialDataArr.count; i++) {
                    
                    [KTidMArr addObject:[officialDataArr[i] objectForKey:@"id"]];
                    [KTtypeMArr addObject:[officialDataArr[i] objectForKey:@"type"]];
                    [KTdate_tmMArr addObject:[officialDataArr[i] objectForKey:@"date_tm"]];
                    [KTtitleMArr addObject:[officialDataArr[i] objectForKey:@"title"]];
                    [KTconMArr addObject:[officialDataArr[i] objectForKey:@"con"]];
                    [KTschool_logoMArr addObject:[officialDataArr[i] objectForKey:@"school_logo"]];
                    [KTschool_nameMArr addObject:[officialDataArr[i] objectForKey:@"school_name"]];
                }
                
            }else{
                [SVProgressHUD showInfoWithStatus:@"没有更多数据了..."];
            }

        }
        [self initSetUI];
        [self.releaseTabelView reloadData];
        
    } failure:^(NSError *error) {
        
      [SVProgressHUD showErrorWithStatus:@"网络不通，请检查网络"];
        
    }];
    
}
- (void)initSetUI{
    iconImgMArr = KTschool_logoMArr;
    schoolNameMArr = KTschool_nameMArr;
    detailNameMArr = KTtitleMArr;
    timeMArr = KTdate_tmMArr;
}



- (void)controlPressed:(UISegmentedControl*)segment{
    NSInteger selectedIndex =[segment selectedSegmentIndex];
    if (selectedIndex ==0) {
        a = 0;
        [self loadMoreData:1];
        [self.releaseTabelView reloadData];
    }
    else{
        a = 1;
        [self loadSetData:1];
       [self.releaseTabelView reloadData];
    }
  
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0000001;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (a ==0) {
        return idMArr.count;
    }
    else if (a ==1) {
        
        return KTidMArr.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    schoolTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(cell==nil){
        cell=[[schoolTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
    }if (a == 0) {
        cell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
        cell.image.layer.cornerRadius =cell.image.bounds.size.width/2;
        cell.image.layer.masksToBounds =YES;
        [cell.image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",picURL,school_logoMArr[indexPath.row]]] placeholderImage:[UIImage imageNamed:@"picterPlace"]];
        cell.schoolname.text = school_nameMArr[indexPath.row];
        cell.liYouLabel.text = titleMArr[indexPath.row];
        
        x =[NSString stringWithFormat:@"%@",date_tmMArr[indexPath.row]].integerValue;
        NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:x];
        confromTimespStr = [fomatter stringFromDate:confromTimesp];
        cell.firstwellLabel.text = [NSString stringWithFormat:@"%@",confromTimespStr];

    }else if (a == 1){
        
        cell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
        cell.image.layer.cornerRadius =cell.image.bounds.size.width/2;
        cell.image.layer.masksToBounds =YES;
        [cell.image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",picURL,KTschool_logoMArr[indexPath.row]]] placeholderImage:[UIImage imageNamed:@"picterPlace"]];
        
        cell.schoolname.text =KTschool_nameMArr[indexPath.row];
        cell.liYouLabel.text =KTtitleMArr[indexPath.row];
        
        x =[NSString stringWithFormat:@"%@",KTdate_tmMArr[indexPath.row]].integerValue;
        NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:x];
        confromTimespStr = [fomatter stringFromDate:confromTimesp];
        cell.firstwellLabel.text = [NSString stringWithFormat:@"%@",confromTimespStr];
    }
    
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 100;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (a) {
        case 0:
        {
            NoticeInfomationViewController *noticeInfoVC =[[NoticeInfomationViewController alloc]init];
            noticeInfoVC.nameStr  =schoolNameMArr[indexPath.row];
            noticeInfoVC.locationStr =typeMArr[indexPath.row];
            x =[NSString stringWithFormat:@"%@",timeMArr[indexPath.row]].integerValue;
            NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:x];
            confromTimespStr = [fomatter stringFromDate:confromTimesp];
            noticeInfoVC.dateStr =[NSString stringWithFormat:@"%@",confromTimespStr];
            noticeInfoVC.conStr =conMArr[indexPath.row];
           [self.navigationController pushViewController:noticeInfoVC animated:YES];
        }
            break;
        case 1:
        {
           NoticeSettingInfomationViewController *noticeInfoVC =[[NoticeSettingInfomationViewController alloc]init];
            noticeInfoVC.nameStr =KTschool_nameMArr[indexPath.row];
            x =[NSString stringWithFormat:@"%@",KTdate_tmMArr[indexPath.row]].integerValue;
            NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:x];
            confromTimespStr = [fomatter stringFromDate:confromTimesp];
            noticeInfoVC.dateStr =[NSString stringWithFormat:@"%@",confromTimespStr];
            noticeInfoVC.conStr =KTconMArr[indexPath.row];
           [self.navigationController pushViewController:noticeInfoVC animated:YES];
        }
            break;
        default:
            break;
    }
}

@end
