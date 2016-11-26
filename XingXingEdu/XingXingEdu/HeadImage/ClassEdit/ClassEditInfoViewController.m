
//
//  ClassEditInfoViewController.m
//  XingXingEdu
//
//  Created by keenteam on 16/3/23.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//
#define kPData @"ClassEditInfoCell"
#import "ClassEditInfoViewController.h"
#import "ClassEditInfoCell.h"
#import "ClassEditViewController.h"
#import "ClassInfomationViewController.h"
#import "HHControl.h"
#import "ClassEditInfoModel.h"
#import "ClassDetailInfoViewController.h"


@interface ClassEditInfoViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    
    NSMutableArray *_dataSourceArray;
    
    UIImageView *placeholderImageView;
    
    NSString *parameterXid;
    NSString *parameterUser_Id;


}

////学校logo
//@property (nonatomic) NSMutableArray *iconImageViewArray;
////开课状态
//@property (nonatomic) NSMutableArray *stateArray;;
////课程名称
//@property (nonatomic) NSMutableArray *courseNameArray;
////学校名称
//@property (nonatomic) NSMutableArray *schoolNameArray;
////老师名称
//@property (nonatomic) NSMutableArray *teacherNameArray;
//
////省
//@property (nonatomic) NSMutableArray *provinceArray;
////市
//@property (nonatomic) NSMutableArray *cityArray;;
////区
//@property (nonatomic) NSMutableArray *areaArray;
////学校类型
//@property (nonatomic) NSMutableArray *schoolTypeArray;
////年级
//@property (nonatomic) NSMutableArray *gradeAndClassArray;
////班级
////@property (nonatomic) NSMutableArray *classArray;
////审核人员
//@property (nonatomic) NSMutableArray *checkArray;



//课程状态
@property (nonatomic) UIImageView *courseState;
//课程名称
@property (nonatomic) NSString *courseName;
//老师名称
@property (nonatomic) NSString *teacherName;
//学校名称
@property (nonatomic) NSString *schoolName;


@end

@implementation ClassEditInfoViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"编辑班级";
    self.view.backgroundColor = UIColorFromRGB(255,163, 195);
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }
    _dataSourceArray = [[NSMutableArray alloc] init];
    
    
    // Do any additional setup after loading the view.
    [self.navigationController.navigationBar setTintColor:UIColorFromRGB(255, 255, 255)];
    
    
    [self fetchNetData];
    
    
    [self createTableView];
}

- (void)fetchNetData{

/*
 
 【编辑班级列表】
 
 接口:
 http://www.xingxingedu.cn/Parent/edit_class_list
 
 传参:
	baby_id		//孩子id
 */

    NSString *urlStr = @"http://www.xingxingedu.cn/Parent/edit_class_list";
    
    //[[NSUserDefaults standardUserDefaults]setObject:baby_id1 forKey:@"BABYID"];
    NSString *babyId = [[NSUserDefaults standardUserDefaults] objectForKey:@"BABYID"];
    
    //传参
    NSDictionary *parameter = @{@"appkey":APPKEY, @"backtype":BACKTYPE, @"xid":parameterXid, @"user_id":parameterUser_Id, @"user_type":USER_TYPE, @"baby_id":babyId};
    
    [WZYHttpTool post:urlStr params:parameter success:^(id responseObj) {
        //
//        NSLog(@"获取数据成功!-------%@", responseObj);

        if ([[NSString stringWithFormat:@"%@", responseObj[@"code"]] isEqualToString:@"1"]) {
            
            NSArray *modelArray = [[NSArray alloc] init];
            modelArray = [ClassEditInfoModel parseResondsData:responseObj[@"data"]];
            
            [_dataSourceArray addObjectsFromArray:modelArray];
        }
        [self customContent];
        
    } failure:^(NSError *error) {
        //
        NSLog(@"获取数据失败!-----%@", error);
    }];
    

}

// 有数据 和 无数据 进行判断
- (void)customContent{
    // 如果 有占位图 先 移除
    [self removePlaceholderImageView];
    
    if (_dataSourceArray.count == 0) {
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        // 1、无数据的时候
        [self createPlaceholderView];
        
    }else{
        //2、有数据的时候
        
    }
    
    [_tableView reloadData];
    
}


//没有 数据 时,创建 占位图
- (void)createPlaceholderView{
    // 1、无数据的时候
    UIImage *myImage = [UIImage imageNamed:@"all_placeholder"];
    CGFloat myImageWidth = myImage.size.width;
    CGFloat myImageHeight = myImage.size.height;
    
    placeholderImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kWidth / 2 - myImageWidth / 2, (kHeight - 64 - 49) / 2 - myImageHeight / 2, myImageWidth, myImageHeight)];
    placeholderImageView.image = myImage;
    [self.view addSubview:placeholderImageView];
}

//去除 占位图
- (void)removePlaceholderImageView{
    if (placeholderImageView != nil) {
        [placeholderImageView removeFromSuperview];
    }
}


- (void)createTableView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight) style:UITableViewStyleGrouped];
    _tableView.dataSource =self;
    _tableView.delegate =self;
    [self.view addSubview:_tableView];
    
    UIButton *btn =[HHControl createButtonWithFrame:CGRectMake(0, 251, 25, 25) backGruondImageName:@"addicon" Target:self Action:@selector(onClickBtn) Title:nil];
    UIBarButtonItem *addBar =[[UIBarButtonItem  alloc]initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem =addBar;
}
- (void)onClickBtn{
    
    ClassEditViewController *classEditVC =[[ClassEditViewController alloc]init];
    
    [self.navigationController pushViewController:classEditVC animated:YES];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return _dataSourceArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ClassEditInfoCell *cell = (ClassEditInfoCell*) [tableView dequeueReusableCellWithIdentifier:kPData];
    if(cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:kPData owner:[ClassEditInfoCell class] options:nil];
        cell = (ClassEditInfoCell *)[nib objectAtIndex:0];
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
    
    ClassEditInfoModel *model = _dataSourceArray[indexPath.row];
    
    [cell.picIamgeV sd_setImageWithURL:[NSURL URLWithString:model.school_logo] placeholderImage:[UIImage imageNamed:@"书籍126x128"]];
    
    //班级
    cell.dataLabel.text = model.class_name;
    //学校名称
    cell.titleLabel.text = model.school_name;
    //老师 名称 授课老师:
    
    cell.teachLabel.text =[NSString stringWithFormat:@"授课老师: %@", model.teacher];

    //0:未审核  1:审核通过
    NSString *stateStr = model.condit;
    if ([stateStr isEqualToString:@"0"]) {
    
       cell.stateImag.image =[UIImage imageNamed:@"daishenghe"];
        
    }else if ([stateStr isEqualToString:@"1"]){
        
       cell.stateImag.image =[UIImage imageNamed:@"yishenghe"];
    
    }

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    ClassDetailInfoViewController *ClassDetailInfoVC = [[ClassDetailInfoViewController alloc] init];
    
    ClassEditInfoModel *model = _dataSourceArray[indexPath.row];
    ClassDetailInfoVC.model = model;
    
    [self.navigationController pushViewController:ClassDetailInfoVC animated:YES];


}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.00000001;

}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        NSUInteger row = [indexPath row];
//        [self.list removeObjectAtIndex:row];
// [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]withRowAnimation:UITableViewRowAnimationAutomatic];
    }


}

@end
