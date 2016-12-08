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
//    UIImageView *imgV;
//    UILabel *lbl;
    //pic
    NSMutableArray *picArray;
    //pic id
    NSMutableArray *picIdArray;
    //图标
    NSString *iconStr;
    //早 中 晚 餐
    NSString *titleStr;
    
}


@end

@implementation SchoolRecipeInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setTintColor:UIColorFromRGB(255, 255, 255)];
    self.title = @"食谱详情";
    self.view.backgroundColor = UIColorFromRGB(235, 235, 235);

    picArray = [[NSMutableArray alloc] init];
    picIdArray = [[NSMutableArray alloc] init];
    
    [self createData];
    [self createTableView];
}

- (void)createData{
    
    if (_mealPicDataSource.count != 0) {
        for (NSDictionary *dic in _mealPicDataSource) {
            [picArray addObject:dic[@"pic"]];
            [picIdArray addObject:dic[@"id"]];
        }
        
    }
    
    switch (self.i) {
        case 0:
        {
            iconStr = @"早餐38x34";
            titleStr =@"早餐";
        }
            break;
        case 1:
        {
            iconStr = @"午餐38x34";
            titleStr =@"午餐";
        }
            break;
        case 2:
        {
            iconStr = @"晚餐38x34";
            titleStr =@"晚餐";
        }
            break;
            
        default:
            break;
    }
    
}


- (void)createTableView{
    _tableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight) style:UITableViewStyleGrouped];
    _tableView.dataSource =self;
    _tableView.delegate =self;
    [self.view addSubview:_tableView];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 220;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return picArray.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    KTRecipeCell *cell =(KTRecipeCell*)[tableView dequeueReusableCellWithIdentifier:KPATA];
    if (!cell) {
        NSArray *nib =[[NSBundle mainBundle]loadNibNamed:KPATA owner:[KTRecipeCell class] options:nil];
        cell =(KTRecipeCell*)[nib objectAtIndex:0];
    }
    
    //placeholder
    [cell.bgImagV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",picURL,picArray[indexPath.row]]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 60)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 15, 20, 20)];
    iconImageView.image = [UIImage imageNamed:iconStr];
    [headerView addSubview:iconImageView];
    
    UILabel *titleLabel1 = [HHControl createLabelWithFrame:CGRectMake(35, 15, 40, 20) Font:14 Text:titleStr];
    titleLabel1.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:titleLabel1];
    
    UITextView *contentTextView = [[UITextView alloc] initWithFrame:CGRectMake(80, 10, 250, 40)];
    contentTextView.text = _detailStr;
    contentTextView.editable = NO;
    [headerView addSubview:contentTextView];
    
    return headerView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
