//
//  SchoolRecipesViewController.m
//  XingXingEdu
//
//  Created by keenteam on 16/1/18.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//
#define KT @"yyyy年MM月dd日 HH:MM:ss"
#define KPDATA @"SchoolRecipeCell"
#import "SchoolRecipesViewController.h"
#import "SchoolRecipeInfoViewController.h"
#import "SchoolRecipeCell.h"
#import "HHControl.h"
@interface SchoolRecipesViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    NSMutableArray *_goodArray;
    NSMutableArray *_sections;
    NSMutableArray *todayHisMArr;
    NSMutableArray *date_tmMArr;
    NSMutableArray *titleMArr;
    NSMutableArray *totalMArr;
    NSMutableArray *nameMArr;
    NSMutableArray *picMArr;
    NSMutableArray *ktMArr;
    NSMutableArray *TotalPicMArr;
    NSMutableArray *TotalktMArr;
    NSDateFormatter *fomatter;
    NSString *confromTimespStr;
    NSInteger x;
}
@end

@implementation SchoolRecipesViewController
- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden =NO;
    self.navigationController.navigationBar.barTintColor =UIColorFromRGB(0, 170, 42);
     [self.navigationController.navigationBar setTintColor:UIColorFromRGB(255, 255, 255)];
}
- (void)viewWillDisappear:(BOOL)animated{
    // self.navigationController.navigationBar.barTintColor =UIColorFromRGB(248, 248, 248);
  
}
- (void)viewDidLoad {
    [super viewDidLoad];
     self.title =@"食谱";
     self.view.backgroundColor = UIColorFromRGB(34, 56, 67);
    // Do any additional setup after loading the view.
    _goodArray = [[NSMutableArray alloc]init];
    _sections  = [[NSMutableArray alloc]init];
    todayHisMArr =[[NSMutableArray alloc]init];
    date_tmMArr =[[NSMutableArray alloc]init];
    TotalPicMArr =[[NSMutableArray alloc]init];
    nameMArr =[[NSMutableArray alloc]init];
    TotalktMArr =[[NSMutableArray alloc]init];
    NSArray *arr =[NSArray arrayWithObjects:@"早餐",@"午餐",@"晚餐", nil];
    [nameMArr addObjectsFromArray:arr];
    totalMArr =[[NSMutableArray alloc]init];
    fomatter =[[NSDateFormatter alloc]init];
    [fomatter setDateStyle:NSDateFormatterMediumStyle];
    [fomatter setTimeStyle:NSDateFormatterShortStyle];
    [fomatter setDateFormat:KT];
    [self createData];
    [self createTableView];
}
- (void)createData{
  
    NSString *urlStr = @"http://www.xingxingedu.cn/Parent/school_cookbook";
    NSDictionary *dict = @{@"appkey":APPKEY,
                           @"backtype":BACKTYPE,
                           @"xid":XID,
                           @"user_id":USER_ID,
                           @"user_type":USER_TYPE,
                           @"school_id":@"1",
                           };
    
    [WZYHttpTool post:urlStr params:dict success:^(id responseObj) {
        NSDictionary *dict =responseObj;
   
    if([[NSString stringWithFormat:@"%@",dict[@"code"]]isEqualToString:@"1"] )
        {
//            NSLog(@"data ========%@",dict[@"data"]);
            for (NSString * s in dict[@"data"]) {
//                NSLog(@"%@",s);
                [todayHisMArr addObject:s];
            }
            NSArray *arr= [dict[@"data"] objectForKey:todayHisMArr[0]];
//            NSLog(@"arr=====%@",arr);
            if (arr.count!=0) {
                for (int j=0; j<arr.count; j++) {
                    
//                    NSLog(@"%@",arr[j]);
//                    NSLog(@"%@",[arr[j] allKeys]);
                
                    NSString *dateString = [WZYTool dateStringFromNumberTimer:arr[j][@"date_tm"]];
                    
                    NSArray *dateArray = [dateString componentsSeparatedByString:@" "];
                    NSString *dateStr = dateArray[0];
                    [date_tmMArr addObject:dateStr];
                    
                    
                    titleMArr =[[NSMutableArray alloc]init];
                    picMArr =[[NSMutableArray alloc]init];
                    ktMArr =[[NSMutableArray alloc]init];

                    [picMArr addObject:[[arr[j] objectForKey:@"breakfast"] objectForKey:@"pic_arr"][0]];
                    [picMArr addObject:[[arr[j] objectForKey:@"lunch"] objectForKey:@"pic_arr"][0]];
                    [picMArr addObject:[[arr[j] objectForKey:@"dinner"] objectForKey:@"pic_arr"][0]];
                    [TotalPicMArr addObject:picMArr];
                    
                    [ktMArr addObject:[[arr[j] objectForKey:@"breakfast"] objectForKey:@"pic_arr"]];
                    [ktMArr addObject:[[arr[j] objectForKey:@"lunch"] objectForKey:@"pic_arr"]];
                    [ktMArr addObject:[[arr[j] objectForKey:@"dinner"] objectForKey:@"pic_arr"]];
                    [TotalktMArr addObject:ktMArr];
                    
                    
                    [titleMArr addObject:[[arr[j] objectForKey:@"breakfast"] objectForKey:@"title"]];
                    [titleMArr addObject:[[arr[j] objectForKey:@"lunch"] objectForKey:@"title"]];
                    [titleMArr addObject:[[arr[j] objectForKey:@"dinner"] objectForKey:@"title"]];
                    [totalMArr addObject:titleMArr];
                    
                }
//                NSLog(@"%@",date_tmMArr);
//                NSLog(@"%@",totalMArr);
                
            }
        }
        [_tableView reloadData];
    } failure:^(NSError *error) {
        
        NSLog(@"%@", error);
        
    }];

}
- (void)createTableView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight) style:UITableViewStyleGrouped];
    _tableView.dataSource =self;
    _tableView.delegate =self;
    [self.view addSubview:_tableView];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return date_tmMArr.count;

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SchoolRecipeCell *cell =(SchoolRecipeCell*)[tableView dequeueReusableCellWithIdentifier:KPDATA];
    if (!cell) {
        NSArray *nib =[[NSBundle mainBundle]loadNibNamed:KPDATA owner:[SchoolRecipeCell class] options:nil];
        cell = (SchoolRecipeCell*)[nib objectAtIndex:0];
        
    }
   
    [cell.imageV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",picURL,TotalPicMArr[indexPath.section][indexPath.row]]] placeholderImage:[UIImage imageNamed:@"picterPlace"]];
    cell.titleLbl.textColor =UIColorFromRGB(0, 170, 42);
    cell.titleLbl.text =  nameMArr[indexPath.row];
    cell.detailLbl.text = totalMArr[indexPath.section][indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;

}
- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    return date_tmMArr[section];

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

        SchoolRecipeInfoViewController *schoolRecInfoVC = [[SchoolRecipeInfoViewController alloc]init];
        schoolRecInfoVC.imageArr =TotalktMArr[indexPath.section][indexPath.row];
        schoolRecInfoVC.i =indexPath.row;
        schoolRecInfoVC.detailStr =totalMArr[indexPath.section][indexPath.row];
        [self.navigationController pushViewController:schoolRecInfoVC animated:YES];
       
  
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 25;
    }
    return 15;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
