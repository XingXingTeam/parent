//
//  primarySchoolViewController.m
//  XingXingEdu
//
//  Created by super on 16/3/1.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "primarySchoolViewController.h"
#import "kindergartenTableViewCell.h"
#import "WebViewController.h"
@interface primarySchoolViewController ()<UITableViewDataSource,UITableViewDelegate>

{
    NSArray * primaryImageArray;
    NSArray * primaryLabelArray;
    NSArray * primaryLabeliArray;
}
@property (strong, nonatomic) IBOutlet UITableView *primarySchoolTabelView;

@end

@implementation primarySchoolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    primaryImageArray = [[NSMutableArray alloc]init];
    primaryLabelArray  = [[NSMutableArray alloc]init];
    primaryLabeliArray = [[NSMutableArray alloc]init];
    // self.edgesForExtendedLayout = UIRectEdgeNone;
    self.primarySchoolTabelView.delegate = self;
    self.primarySchoolTabelView.dataSource = self;
   primaryImageArray = @[@"add1",@"add1",@"add1",@"add1",@"add1",@"add1",@"add1",@"add1",@"add1"];
    
    primaryLabelArray = @[@"疯狂的小学",@"小学须知",@"小学的迷失",@"疯狂的小学",@"小学须知",@"小学的迷失",@"疯狂的小学",@"小学须知",@"小学的迷失"];
    primaryLabeliArray = @[@"2015-5-3 16：23",@"2015-5-3 16：23",@"2015-5-3 16：23",@"2015-5-3 16：23",@"2015-5-3 16：23",@"2015-5-3 16：23",@"2015-5-3 16：23",@"2015-5-3 16：23",@"2015-5-3 16：23"];
    
    UINib *nib = [UINib nibWithNibName:@"kindergartenTableViewCell" bundle:nil];
    [self.primarySchoolTabelView registerNib:nib forCellReuseIdentifier:@"cell"];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    
    return primaryImageArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    kindergartenTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(cell==nil){
        cell=[[kindergartenTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
    }
    
    
    cell.kindergartenImageVIew.layer.cornerRadius= cell.kindergartenImageVIew.bounds.size.width/2;
    cell.kindergartenImageVIew.layer.masksToBounds=YES;
    cell.kindergartenImageVIew.image = [UIImage imageNamed:primaryImageArray[indexPath.row]];
    cell.KindergartenLabeli = primaryLabelArray[indexPath.row];
    cell.KindergartenLabelab = primaryLabeliArray [indexPath.row];
    
   
    
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
