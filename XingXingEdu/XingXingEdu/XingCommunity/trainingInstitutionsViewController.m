//
//  trainingInstitutionsViewController.m
//  XingXingEdu
//
//  Created by super on 16/3/1.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "trainingInstitutionsViewController.h"
#import "kindergartenTableViewCell.h"
#import "WebViewController.h"
@interface trainingInstitutionsViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray * trainingInstitutionImageArray;
    NSArray * trainingInstitutionLabelArray;
    NSArray * trainingInstitutionLabeliArray;
}
@property (strong, nonatomic) IBOutlet UITableView *trainingInstitutions;

@end

@implementation trainingInstitutionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    trainingInstitutionImageArray = [[NSMutableArray alloc]init];
    trainingInstitutionLabelArray  = [[NSMutableArray alloc]init];
    trainingInstitutionLabeliArray = [[NSMutableArray alloc]init];
    // self.edgesForExtendedLayout = UIRectEdgeNone;
    self.trainingInstitutions.delegate = self;
    self.trainingInstitutions.dataSource = self;
    trainingInstitutionImageArray = @[@"add1",@"add1",@"add1",@"add1",@"add1",@"add1",@"add1",@"add1",@"add1"];
    
    trainingInstitutionLabelArray = @[@"培训班注意事项",@"幼儿园须知",@"幼儿园的迷失",@"培训班注意事项",@"幼儿园须知",@"幼儿园的迷失",@"培训班注意事项",@"幼儿园须知",@"幼儿园的迷失"];
    trainingInstitutionLabeliArray = @[@"2014-2-3 12：23",@"2014-2-3 12：23",@"2014-2-3 12：23",@"2014-2-3 12：23",@"2014-2-3 12：23",@"2014-2-3 12：23",@"2014-2-3 12：23",@"2014-2-3 12：23",@"2014-2-3 12：23"];
    
    UINib *nib = [UINib nibWithNibName:@"kindergartenTableViewCell" bundle:nil];
    [self.trainingInstitutions registerNib:nib forCellReuseIdentifier:@"cell"];
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
    
    return trainingInstitutionImageArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    kindergartenTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(cell==nil){
        cell=[[kindergartenTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
    }
    
    cell.kindergartenImageVIew.layer.cornerRadius= cell.kindergartenImageVIew.bounds.size.width/2;
    cell.kindergartenImageVIew.layer.masksToBounds=YES;
    cell.kindergartenImageVIew.image = [UIImage imageNamed:trainingInstitutionImageArray[indexPath.row]];
    cell.KindergartenLabeli = trainingInstitutionLabelArray[indexPath.row];
    cell.KindergartenLabelab = trainingInstitutionLabeliArray [indexPath.row];
       
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

@end
