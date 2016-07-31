
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

#import "ClassDetailInfoViewController.h"


@interface ClassEditInfoViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;

}

//学校logo
@property (nonatomic) NSMutableArray *iconImageViewArray;
//开课状态
@property (nonatomic) NSMutableArray *stateArray;;
//课程名称
@property (nonatomic) NSMutableArray *courseNameArray;
//学校名称
@property (nonatomic) NSMutableArray *schoolNameArray;
//老师名称
@property (nonatomic) NSMutableArray *teacherNameArray;

//省
@property (nonatomic) NSMutableArray *provinceArray;
//市
@property (nonatomic) NSMutableArray *cityArray;;
//区
@property (nonatomic) NSMutableArray *areaArray;
//学校类型
@property (nonatomic) NSMutableArray *schoolTypeArray;
//年级
@property (nonatomic) NSMutableArray *gradeArray;
//班级
@property (nonatomic) NSMutableArray *classArray;
//审核人员
@property (nonatomic) NSMutableArray *checkArray;



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
    NSDictionary *parameter = @{@"appkey":APPKEY, @"backtype":BACKTYPE, @"xid":XID, @"user_id":USER_ID, @"user_type":USER_TYPE, @"baby_id":babyId};
    
    [WZYHttpTool post:urlStr params:parameter success:^(id responseObj) {
        //
//        NSLog(@"获取数据成功!-------%@", responseObj);
        _iconImageViewArray = [[NSMutableArray alloc] init];
        _stateArray = [[NSMutableArray alloc] init];
        _courseNameArray = [[NSMutableArray alloc] init];
        _teacherNameArray = [[NSMutableArray alloc] init];
        _schoolNameArray = [[NSMutableArray alloc] init];
        
        _provinceArray = [[NSMutableArray alloc] init];
        _cityArray = [[NSMutableArray alloc] init];
        _areaArray = [[NSMutableArray alloc] init];
        _schoolTypeArray = [[NSMutableArray alloc] init];
        _gradeArray = [[NSMutableArray alloc] init];
        _classArray = [[NSMutableArray alloc] init];
        _checkArray = [[NSMutableArray alloc] init];
        
    
        if ([[NSString stringWithFormat:@"%@", responseObj[@"code"]] isEqualToString:@"1"]) {
            //
            /*
             {
             id = 28,
             baby_id = 1,
             course_id = 5,
             examine_tname = 楚梦近,
             school_id = 8,
             school_name = 水晶鞋,
             examine_id = 2,
             sch_type = 4,  //学校类型,请传数字代号:幼儿园/小学/中学/培训机构 1/2/3/4
             school_logo = app_upload/text/school_logo/8.jpg,
             province = 上海市,
             term_end_tm = 1472197548,  开始时间
             city = 上海市,
             teacher = 高大京,
             district = 浦东新区,
             term_start_tm = 1460864748,  结束时间
             grade = 少儿现代舞蹈班,
             class = 201604,
             condit = 1     //审核状态  0:未审核  1:审核通过
             }
             */
            if ([responseObj[@"data"] count] == 0 ) {
                
                // 1、无数据的时候
                UIImage *myImage = [UIImage imageNamed:@"人物"];
                CGFloat myImageWidth = myImage.size.width;
                CGFloat myImageHeight = myImage.size.height;
                
                UIImageView *myImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kWidth / 2 - myImageWidth / 2, kHeight / 2 - myImageWidth / 2, myImageWidth, myImageHeight)];
                myImageView.image = myImage;
                [self.view addSubview:myImageView];
                
            }else{
                
                for (NSDictionary *dic in responseObj[@"data"]) {
                    
                    //如果是 培训机构
                    if ([[NSString stringWithFormat:@"%@",dic[@"sch_type"]] isEqualToString:@"4"]) {
                        //课程名称 grade 抽象设计
                        
                        NSString *courseNameStr = [NSString stringWithFormat:@"%@  %@",dic[@"grade"], dic[@"class"]];
                        
                        [_courseNameArray addObject:courseNameStr];
                       
                        //年级
                        [_gradeArray addObject:dic[@"grade"]];
                        //班级
                        [_classArray addObject:dic[@"class"]];


                    }else{
                        //课程名称 几年级 几班
                        
                        NSString *courseNameStr = [NSString stringWithFormat:@"%@年级  %@班",dic[@"grade"], dic[@"class"]];
                        
                        [_courseNameArray addObject:courseNameStr];
                        
                        //年级
                        NSString *gradeString = [NSString stringWithFormat:@"%@年级", [WZYTool changeStringFromFigure:dic[@"grade"]]];
                        
                        [_gradeArray addObject:gradeString];
                        //班级
                        NSString *classString = [NSString stringWithFormat:@"%@班", [WZYTool changeStringFromFigure:dic[@"class"]]];
                        
                        [_classArray addObject:classString];

                        
                        
                    }
                    
                    //学校 logo
                    NSString *iconStr = [NSString stringWithFormat:@"%@%@", picURL, dic[@"school_logo"]];
                    
                    [self.iconImageViewArray addObject:iconStr];
                    
                    //学校名称
                    [self.schoolNameArray addObject:dic[@"school_name"]];
                    //老师名称
                    [self.teacherNameArray addObject:dic[@"teacher"]];
                    
                    //开课状态
                    [_stateArray addObject:dic[@"condit"]];
                    
                    //省
                    [_provinceArray addObject:dic[@"province"]];
                    //市
                    [_cityArray addObject:dic[@"city"]];
                    //区
                    [_areaArray addObject:dic[@"district"]];
                    //学校类型
                    [_schoolTypeArray addObject:dic[@"sch_type"]];
                    //审核人员
                    [_checkArray addObject:dic[@"examine_tname"]];
                    
                    
                }
                
                [_tableView reloadData];
                
            }

            
            
        }else{
        
        
        }
        
    } failure:^(NSError *error) {
        //
        NSLog(@"获取数据失败!-----%@", error);
    }];
    

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

    return _schoolNameArray.count;
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
    
    [cell.picIamgeV sd_setImageWithURL:[NSURL URLWithString:_iconImageViewArray[indexPath.row]] placeholderImage:[UIImage imageNamed:@"书籍126x128"]];
    
    //班级
    cell.dataLabel.text = _schoolNameArray[indexPath.row];
    //学校名称
    cell.titleLabel.text = _courseNameArray[indexPath.row];
    //老师 名称 授课老师:
    cell.teachLabel.text =[NSString stringWithFormat:@"授课老师: %@", _teacherNameArray[indexPath.row]];

    //0:未审核  1:审核通过
    NSString *stateStr = _stateArray[indexPath.row];
    if ([stateStr isEqualToString:@"0"]) {
    
       cell.stateImag.image =[UIImage imageNamed:@"daishenghe"];
        
    }else if ([stateStr isEqualToString:@"1"]){
        
       cell.stateImag.image =[UIImage imageNamed:@"yishenghe"];
    
    }

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    ClassDetailInfoViewController *ClassDetailInfoVC = [[ClassDetailInfoViewController alloc] init];
    
    ClassDetailInfoVC.provinceStr = _provinceArray[indexPath.row];
    ClassDetailInfoVC.cityStr = _cityArray[indexPath.row];
    ClassDetailInfoVC.areaStr = _areaArray[indexPath.row];
    ClassDetailInfoVC.schoolTypeStr = _schoolTypeArray[indexPath.row];
    ClassDetailInfoVC.schoolNameStr = _schoolNameArray[indexPath.row];
    ClassDetailInfoVC.gradeStr = _gradeArray[indexPath.row];
    ClassDetailInfoVC.classStr = _classArray[indexPath.row];
    ClassDetailInfoVC.checkStr = _checkArray[indexPath.row];
    
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
