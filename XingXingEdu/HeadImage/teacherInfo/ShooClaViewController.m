//
//  ShooClaViewController.m
//  XingXingEdu
//
//  Created by keenteam on 16/3/17.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "ShooClaViewController.h"
#import "ClassTeacherTableViewCell.h"
#import "JSDropDownMenu.h"
#import "ClassSubjectTableViewCell.h"
#import "ClassRoomSubjectInfoViewController.h"
#define kPData @"ClassSubjectTableViewCell"

@interface ShooClaViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UISegmentedControl *segMent;
    NSInteger  segMentIndex;
    UITableView * myTableView;
    NSArray * teacherArray;
    NSArray * schoolArray;
    NSArray * tmp;
    
}
@end

@implementation ShooClaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =UIColorFromRGB(241, 242, 241);
    // Do any additional setup after loading the view.
    
    [self creatFieldset];
}



-(void)creatFieldset{
    
    //tableView
    myTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, WinWidth, WinHeight-300) style:UITableViewStylePlain];
    myTableView.delegate=self;
    myTableView.dataSource=self;
    myTableView.backgroundColor = UIColorFromRGB(229, 232, 233);
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:myTableView];
    
}


#pragma mark  tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.subjectArray.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ClassSubjectTableViewCell *cell = (ClassSubjectTableViewCell*) [tableView dequeueReusableCellWithIdentifier:kPData];
    if(cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:kPData owner:[ClassSubjectTableViewCell class] options:nil];
        cell = (ClassSubjectTableViewCell *)[nib objectAtIndex:0];
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
    
    tmp = self.subjectArray[indexPath.row];
    cell.iconImg.layer.cornerRadius= cell.iconImg.bounds.size.width/2;
    cell.iconImg.layer.masksToBounds=YES;
    [cell.iconImg sd_setImageWithURL:[NSURL URLWithString:tmp[0]] placeholderImage:[UIImage imageNamed:@"sdimg1.png"]];
    
    cell.nameLabel.text=tmp[1];
    
    NSString *teacherName;
    for (NSString * name in tmp[2]) {
        teacherName=name;
    }
    cell.teacherLabel.text = [NSString stringWithFormat:@"授课老师:%@",teacherName];
    cell.peopleNumLabel.text = tmp[3];
    cell.beginDateLabel.text= [NSString stringWithFormat:@"还剩 %@ 人",tmp[4]];
    //新的对旧的  旧的对现价....
    cell.priceNewLabel.text= [NSString stringWithFormat:@"原价: %@   限时抢购价: %@",tmp[5],tmp[6]];
    cell.distanceLabel.hidden = YES;
    
    if([[NSString stringWithFormat:@"%@",tmp[7]]isEqualToString:@"1"]){
        
        [cell.moneyXing  setBackgroundImage:[UIImage imageNamed:@"猩币icon28x30.png"] forState:UIControlStateNormal];
        
    }else{
        cell.moneyXing.hidden=YES;
    }
    
    if([[NSString stringWithFormat:@"%@",tmp[8]]isEqualToString:@"1"]){
        [cell.moveBack  setBackgroundImage:[UIImage imageNamed:@"退icon28x30.png"] forState:UIControlStateNormal];
    }else{
        cell.moveBack.hidden=YES;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ClassRoomSubjectInfoViewController *classRoomVC =[[ClassRoomSubjectInfoViewController alloc]init];
    classRoomVC.courseId = _subjectArray[indexPath.row][9];
    [self.navigationController pushViewController:classRoomVC animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 110;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)collectPressed:(UIButton *)btn{
    if ([btn.currentTitle isEqualToString:@"收藏"]) {
        [btn setTitle:@"已收藏" forState:UIControlStateNormal];
    }
    else  if ([btn.currentTitle isEqualToString:@"已收藏"]) {
        [btn setTitle:@"收藏" forState:UIControlStateNormal];
    }
    
}

@end
