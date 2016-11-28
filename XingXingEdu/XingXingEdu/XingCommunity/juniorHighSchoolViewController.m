//
//  juniorHighSchoolViewController.m
//  XingXingEdu
//
//  Created by super on 16/3/1.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "juniorHighSchoolViewController.h"
#import "kindergartenTableViewCell.h"
#import "WebViewController.h"
@interface juniorHighSchoolViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    NSArray * juniorHightImageArray;
    NSArray * juniorHigthLabelArray;
    NSArray * juniorHigthLabeliArray;
}

@property (strong, nonatomic) IBOutlet UITableView *juniorHighSchool;

@end

@implementation juniorHighSchoolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    juniorHightImageArray = [[NSMutableArray alloc]init];
   juniorHigthLabelArray  = [[NSMutableArray alloc]init];
    juniorHigthLabeliArray = [[NSMutableArray alloc]init];
    // self.edgesForExtendedLayout = UIRectEdgeNone;
    self.juniorHighSchool.delegate = self;
    self.juniorHighSchool.dataSource = self;
    juniorHightImageArray = @[@"add1",@"add1",@"add1",@"add1",@"add1",@"add1",@"add1",@"add1",@"add1"];
    
    juniorHigthLabelArray = @[@"难忘的初中",@"初中生须知",@"初中生的烦恼",@"难忘的初中",@"初中生须知",@"初中生的烦恼",@"难忘的初中",@"初中生须知",@"初中生的烦恼"];
    juniorHigthLabeliArray = @[@"2015-2-3 12：23",@"2013-2-3 12：23",@"2015-2-3 12：23",@"2015-2-3 12：23",@"2013-2-3 12：23",@"2015-2-3 12：23",@"2015-2-3 12：23",@"2013-2-3 12：23",@"2015-2-3 12：23"];
    
    UINib *nib = [UINib nibWithNibName:@"kindergartenTableViewCell" bundle:nil];
    [self.juniorHighSchool registerNib:nib forCellReuseIdentifier:@"cell"];
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
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    
    return juniorHightImageArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    kindergartenTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(cell==nil){
        cell=[[kindergartenTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
    }
    
    cell.kindergartenImageVIew.layer.cornerRadius= cell.kindergartenImageVIew.bounds.size.width/2;
    cell.kindergartenImageVIew.layer.masksToBounds=YES;
    cell.kindergartenImageVIew.image = [UIImage imageNamed:juniorHightImageArray[indexPath.row]];
    cell.KindergartenLabeli = juniorHigthLabelArray[indexPath.row];
    cell.KindergartenLabelab = juniorHigthLabeliArray [indexPath.row];
    
    
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
}@end
