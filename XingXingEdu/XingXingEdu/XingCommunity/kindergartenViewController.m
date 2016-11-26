//
//  kindergartenViewController.m
//  XingXingEdu
//
//  Created by super on 16/2/25.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "kindergartenViewController.h"
#import "kindergartenTableViewCell.h"
#import "WebViewController.h"
@interface kindergartenViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *kindImageArray;
    NSArray *kindLabelArray;
    NSArray *kindLabeliArray;
}
@property (strong, nonatomic) IBOutlet UITableView *kindergarten;

@end

@implementation kindergartenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
   
    kindImageArray = [[NSMutableArray alloc]init];
   kindLabelArray  = [[NSMutableArray alloc]init];
    kindLabeliArray = [[NSMutableArray alloc]init];
   // self.edgesForExtendedLayout = UIRectEdgeNone;
    self.kindergarten.delegate = self;
    self.kindergarten.dataSource = self;
    kindImageArray = @[@"add1",@"add1",@"add1",@"add1",@"add1",@"add1",@"add1",@"add1",@"add1"];
    
    kindLabelArray = @[@"疯狂的宝贝",@"幼儿园须知",@"幼儿园的迷失",@"疯狂的宝贝",@"幼儿园须知",@"幼儿园的迷失",@"疯狂的宝贝",@"幼儿园须知",@"幼儿园的迷失"];
    kindLabeliArray = @[@"2014-2-3 12：23",@"2014-2-3 12：23",@"2014-2-3 12：23",@"2014-2-3 12：23",@"2014-2-3 12：23",@"2014-2-3 12：23",@"2014-2-3 12：23",@"2014-2-3 12：23",@"2014-2-3 12：23"];
    
    UINib *nib = [UINib nibWithNibName:@"kindergartenTableViewCell" bundle:nil];
    [self.kindergarten registerNib:nib forCellReuseIdentifier:@"cell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    
    return kindImageArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    kindergartenTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(cell==nil){
        cell=[[kindergartenTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
    }
    
    cell.kindergartenImageVIew.layer.cornerRadius= cell.kindergartenImageVIew.bounds.size.width/2;
    cell.kindergartenImageVIew.layer.masksToBounds=YES;
    cell.kindergartenImageVIew.image = [UIImage imageNamed:kindImageArray[indexPath.row]];
    cell.KindergartenLabeli = kindLabelArray[indexPath.row];
    cell.KindergartenLabelab = kindLabeliArray [indexPath.row];
        
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 93;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
 
    WebViewController * webVC = [[WebViewController alloc]init];
    webVC.url=@"http://www.xingxingedu.cn";
    [self.navigationController pushViewController:webVC animated:YES];
    
    //
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
