//
//  SchoolRecipeInfoViewController.m
//  XingXingEdu
//
//  Created by keenteam on 16/5/9.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//
#define KPATA @"KTRecipeCell"
#import "SchoolRecipeInfoViewController.h"
#import "HHControl.h"
#import "KTRecipeCell.h"
@interface SchoolRecipeInfoViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *dataArray;
    UIImageView *imgV;
    UILabel *lbl;

}
@property (weak, nonatomic) IBOutlet UIImageView *titleImagV;
@property (weak, nonatomic) IBOutlet UILabel *detailLbl;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UIImageView *mainImgV;

@end

@implementation SchoolRecipeInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setTintColor:UIColorFromRGB(255, 255, 255)];
    self.title = @"食谱详情";
    self.view.backgroundColor = UIColorFromRGB(235, 235, 235);
    dataArray =[[NSMutableArray alloc]init];
    // Do any additional setup after loading the view.
    [self createImageView];
    [self createData];
    
   
    
}
- (void)createImageView{
    _tableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight) style:UITableViewStyleGrouped];
    _tableView.dataSource =self;
    _tableView.delegate =self;
    [self.view addSubview:_tableView];
    //dataArray tab图片数据
    
    [dataArray addObjectsFromArray:self.imageArr];
    
    
    UIView *tabHeadView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 60)];
    tabHeadView.backgroundColor =UIColorFromRGB(255, 255, 255);
    //firstPIC
    imgV =[[UIImageView alloc]initWithFrame:CGRectMake(20, tabHeadView.centerY - 25 / 2, 25, 25)];
    
    [tabHeadView addSubview:imgV];
    lbl =[HHControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(imgV.frame) + 10, tabHeadView.centerY - 30 / 2, 60, 30) Font:16 Text:@""];
    [tabHeadView addSubview:lbl];
    
    UILabel *Klbl =[HHControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(lbl.frame) + 10, 5, kWidth - 150, 50) Font:14 Text:self.detailStr];
    Klbl.numberOfLines = 0;

    [tabHeadView addSubview:Klbl];
    
    _tableView.tableHeaderView =tabHeadView;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 220;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataArray.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    KTRecipeCell *cell =(KTRecipeCell*)[tableView dequeueReusableCellWithIdentifier:KPATA];
    if (!cell) {
        NSArray *nib =[[NSBundle mainBundle]loadNibNamed:KPATA owner:[KTRecipeCell class] options:nil];
        cell =(KTRecipeCell*)[nib objectAtIndex:0];
    }
    
    [cell.bgImagV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",picURL,dataArray[indexPath.row]]] placeholderImage:[UIImage imageNamed:@"picterPlace"]];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{




}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0000001;
}
- (void)createData{
    switch (self.i) {
        case 0:
        {
             imgV.image  =[UIImage imageNamed:@"早餐38x34"];
            lbl.text =@"早餐";
        }
            break;
        case 1:
        {
             imgV.image =[UIImage imageNamed:@"午餐38x34"];
             lbl.text =@"午餐";
        }
            break;
        case 2:
        {
              imgV.image  =[UIImage imageNamed:@"晚餐38x34"];
              lbl.text =@"晚餐";
        }
            break;
            
        default:
            break;
    }

    
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
