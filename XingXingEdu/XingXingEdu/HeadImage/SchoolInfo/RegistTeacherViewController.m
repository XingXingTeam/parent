//
//  RegistTeacherViewController.m
//  XingXingEdu
//
//  Created by keenteam on 16/3/21.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//
#define kPData @"ClassTeacherTableViewCell"
#import "RegistTeacherViewController.h"
#import "ClassTeacherTableViewCell.h"
#import "JSDropDownMenu.h"
#import "ClassSubjectTableViewCell.h"
#import "ClassSchoolTableViewCell.h"
#import "ClassRoomSearchViewController.h"
#import "TeleTeachInfoViewController.h"
@interface RegistTeacherViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UISegmentedControl *segMent;
    NSInteger  segMentIndex;
    UITableView * myTableView;
    NSArray * teacherArray;
    NSArray * subjectArray;
    NSArray * schoolArray;
    
    
    
    NSMutableArray *_data1;
    NSMutableArray *_data2;
    NSMutableArray *_data3;
    NSInteger _currentData1Index;
    NSInteger _currentData2Index;
    NSInteger _currentData3Index;
    NSInteger _currentData1SelectedIndex;
    
}

@end

@implementation RegistTeacherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"注册教师";
   
    self.view.backgroundColor = UIColorFromRGB(116,205, 169);
    // Do any additional setup after loading the view.
    [self loadingData];
    [self creatFieldset];
    
    
}
//加载数据
-(void)loadingData{
  
    teacherArray=@[@[@"张老师",@"4.8分",@"教龄:10年",@"授课范围:语文，写作",@"1.2KM",@"XXicon1.jpg",@"年龄:35岁",@"attestationImg1.jpg"],
                   @[@"张老师",@"4.8分",@"教龄:10年",@"授课范围:语文，写作",@"1.2KM",@"XXicon1.jpg",@"年龄:35岁",@"attestationImg1.jpg"],
                   @[@"张老师",@"4.8分",@"教龄:10年",@"授课范围:语文，写作",@"1.2KM",@"XXicon1.jpg",@"年龄:35岁",@"attestationImg1.jpg"],
                   @[@"张老师",@"4.8分",@"教龄:10年",@"授课范围:语文，写作",@"1.2KM",@"XXicon1.jpg",@"年龄:35岁",@"attestationImg1.jpg"],
                   @[@"张老师",@"4.8分",@"教龄:10年",@"授课范围:语文，写作",@"1.2KM",@"XXicon1.jpg",@"年龄:35岁",@"attestationImg1.jpg"],
                   @[@"张老师",@"4.8分",@"教龄:10年",@"授课范围:语文，写作",@"1.2KM",@"XXicon1.jpg",@"年龄:35岁",@"attestationImg1.jpg"],
                   ];
    
}

-(void)creatFieldset
{
 //tableView
    myTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, WinWidth, WinHeight) style:UITableViewStylePlain];
    myTableView.delegate=self;
    myTableView.dataSource=self;
    [self.view addSubview:myTableView];

}

#pragma mark  tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
        return teacherArray.count;
 
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ClassTeacherTableViewCell *cell = (ClassTeacherTableViewCell*) [tableView dequeueReusableCellWithIdentifier:kPData];
    if(cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:kPData owner:[ClassTeacherTableViewCell class] options:nil];
        cell = (ClassTeacherTableViewCell *)[nib objectAtIndex:0];
        
    }
        NSArray * tmp=teacherArray[indexPath.row];
        cell.NameLabel.text=tmp[0];
        cell.gradeLabel.text=tmp[1];
        cell.infoLabel.text=tmp[2];
        cell.courseLabel.text=tmp[3];
        cell.distanceLabel.text=@"";
        cell.iconImg.image=[UIImage imageNamed:tmp[5]];
        cell.agelabel.text=tmp[6];
        cell.attestationImg.image=[UIImage imageNamed:tmp[7]];
        
        [cell.collect setTitle:@"收藏" forState:UIControlStateNormal];
        
        [cell.collect addTarget:self action:@selector(collectPressed:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
 
 [self.navigationController pushViewController:[TeleTeachInfoViewController alloc] animated:YES];

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
