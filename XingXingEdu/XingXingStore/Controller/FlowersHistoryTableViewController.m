//
//  FlowersHistoryTableViewController.m
//  XingXingStore
//
//  Created by codeDing on 16/1/22.
//  Copyright © 2016年 codeDing. All rights reserved.
//
#define KT @"yyyy年MM月dd日 HH:MM:ss"
#import "FlowersHistoryTableViewController.h"
#import "FlowersHistoryTableViewCell.h"

@interface FlowersHistoryTableViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    
    UITableView *_tableView;
    NSInteger x;
    NSMutableArray *conMArr;
    NSMutableArray *date_tmMArr;
    NSMutableArray *head_imgMArr;
    NSMutableArray *idMArr;
    NSMutableArray *numMArr;
    NSMutableArray *tnameMArr;
    NSDateFormatter *fomatter;
    NSString *confromTimespStr;
    NSInteger j;




}
@property(nonatomic ,strong)NSArray * allArray;

@end

@implementation FlowersHistoryTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    conMArr =[[NSMutableArray alloc]init];
    date_tmMArr =[[NSMutableArray alloc]init];
    head_imgMArr =[[NSMutableArray alloc]init];
    idMArr =[[NSMutableArray alloc]init];
    numMArr =[[NSMutableArray alloc]init];
    tnameMArr =[[NSMutableArray alloc]init];
    fomatter =[[NSDateFormatter alloc]init];
    [fomatter setDateStyle:NSDateFormatterMediumStyle];
    [fomatter setTimeStyle:NSDateFormatterShortStyle];
    [fomatter setDateFormat:KT];
    [[self navigationItem] setTitle:@"历史记录"];
    [self initData];
    
    UINib *nib = [UINib nibWithNibName:@"FlowersHistoryTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"cell"];
    
}
- (void)initData{
    
    //teacher
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/fbasket_record";
    NSDictionary *dict = @{@"appkey":APPKEY,
                           @"backtype":BACKTYPE,
                           @"xid":XID,
                           @"user_id":USER_ID,
                           @"user_type":USER_TYPE,
                           };
    
    [WZYHttpTool post:urlStr params:dict success:^(id responseObj) {
        NSDictionary *dict =responseObj;
        
//        NSLog(@"dict:%@",dict);
//        NSLog(@"dictmsg:%@",dict[@"msg"]);
        
        if([[NSString stringWithFormat:@"%@",dict[@"code"]]isEqualToString:@"1"] )
        {
            x =[dict[@"data"] count];
            for (int i=0; i<[dict[@"data"] count]; i++) {
                
                [conMArr addObject:[dict[@"data"][i] objectForKey:@"con"]];
                [date_tmMArr addObject:[dict[@"data"][i] objectForKey:@"date_tm"]];
                [head_imgMArr addObject:[dict[@"data"][i] objectForKey:@"head_img"]];
                [idMArr addObject:[dict[@"data"][i] objectForKey:@"id"]];
                [numMArr addObject:[dict[@"data"][i] objectForKey:@"num"]];
                [tnameMArr addObject:[dict[@"data"][i] objectForKey:@"tname"]];
            }
            
            
            [self.tableView reloadData];
        }
        
    } failure:^(NSError *error) {
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
     return x;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FlowersHistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(cell==nil){
        cell=[[FlowersHistoryTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
   
    cell.iconImage.layer.cornerRadius =cell.iconImage.bounds.size.width/2;
    cell.iconImage.layer.masksToBounds =YES;
    
    [cell.iconImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",picURL,head_imgMArr[indexPath.row]]] placeholderImage:[UIImage imageNamed:@"LOGO172x172@2x"]];

    cell.useLabel.text =tnameMArr[indexPath.row];
    cell.priceLabel.text =[NSString stringWithFormat:@"-%@",numMArr[indexPath.row]];
    cell.wordsLabel.text =[NSString stringWithFormat:@"赠言: %@",conMArr[indexPath.row]];
    j =[NSString stringWithFormat:@"%@",date_tmMArr[indexPath.row]].integerValue;
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:j];
    confromTimespStr = [fomatter stringFromDate:confromTimesp];
    cell.timeLabel.text =[NSString stringWithFormat:@"%@",confromTimespStr];

    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 97;
}



@end
