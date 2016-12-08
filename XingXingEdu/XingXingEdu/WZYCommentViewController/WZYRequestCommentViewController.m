



//
//  WZYRequestCommentViewController.m
//  XingXingEdu
//
//  Created by Mac on 16/7/3.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "WZYRequestCommentViewController.h"

#import "WZYRequestCommentTableViewCell.h"

#import "WZYRequestCommentModel.h"
#import "Friend.h"
#import "FriendGroup.h"


@interface WZYRequestCommentViewController ()<UITableViewDataSource, UITableViewDelegate>
{

    UIButton *arrowButton;
    NSString *parameterXid;
    NSString *parameterUser_Id;

}


@property (nonatomic, strong) UITableView *myTableView;
//请求点评 老师 数组
@property (nonatomic, strong) NSMutableArray *teacherArray;
//请求点评 管理人员 数组
@property (nonatomic, strong) NSMutableArray *managerArray;
//总 数据源
@property (nonatomic, strong) NSMutableArray *dataSourceArray;

//请求点评 老师 数组
@property (nonatomic, strong) NSMutableArray *teacherModelArray;
//请求点评 管理人员 数组
@property (nonatomic, strong) NSMutableArray *managerModelArray;
//总 数据源
@property (nonatomic, strong) NSMutableArray *dataModelArray;

//组 头视图 按钮
//@property (nonatomic, strong) UIButton *headButton;

//组头 标题  老师  管理员

//用来存放是否展开的BOOL值
@property (nonatomic, strong) NSMutableArray *showArray;

@property (nonatomic , strong) NSMutableArray *selectedTeacherInfoArr;


@end

@implementation WZYRequestCommentViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }

    
    [self fetchNetData];
    
    [self createTableView];
}

- (void)fetchNetData{
    /*
     【老师点评--单个孩子的班级教师通讯录(只有老师)】
     接口:
     http://www.xingxingedu.cn/Parent/class_teacher_msg_book
     传参:
     school_id 	//学校id
     class_id 	//班级id
     */
    
    //    //路径
    NSString *urlStr = @"http://www.xingxingedu.cn/Parent/class_teacher_msg_book";
    //
    
   NSString *class_idStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"CLASS_ID"];
   NSString *schoolIdStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"SCHOOL_ID"];
    
//    NSLog(@"aaaa////class_idStr----%@; schoolIdStr------%@", class_idStr, schoolIdStr);
    
    NSDictionary *params = @{@"appkey":APPKEY, @"backtype":BACKTYPE, @"xid":parameterXid, @"user_id":parameterUser_Id, @"user_type":USER_TYPE, @"school_id":schoolIdStr ,@"class_id":class_idStr };
    
    [WZYHttpTool post:urlStr params:params success:^(id responseObj) {
        
        _teacherArray = [[NSMutableArray alloc] init];
        _managerArray = [[NSMutableArray alloc] init];
        _dataSourceArray = [[NSMutableArray alloc] init];
        _teacherModelArray = [[NSMutableArray alloc] init];
        _managerModelArray = [[NSMutableArray alloc] init];
        _dataModelArray = [[NSMutableArray alloc] init];
        _showArray = [[NSMutableArray alloc] init];
//        NSLog(@"请求 点评 --  rrrrr%@", responseObj);

        NSDictionary *dic = responseObj[@"data"];
        
        NSString *codeStr = [NSString stringWithFormat:@"%@", responseObj[@"code"]];
        
        if ([codeStr isEqualToString:@"1"]) {
            _teacherArray = dic[@"teacher"];
            _managerArray = dic[@"manager"];

            
            if (_teacherArray.count != 0) {
                for (NSDictionary *teacherDic in _teacherArray) {
                    
                    WZYRequestCommentModel *model = [WZYRequestCommentModel modelWithDictionary:teacherDic];
                    
//                    NSLog(@"%@", model);
                    
                    [_teacherModelArray addObject:model];
                }
            }
            
            if (_managerArray.count != 0) {
                for (NSDictionary *managerModel in _managerArray) {
                    WZYRequestCommentModel *model = [WZYRequestCommentModel modelWithDictionary:managerModel];
                    [_managerModelArray addObject:model];
                }
            }
            
           
            NSLog(@"%@", _teacherModelArray);
            
            [_dataModelArray addObject:_teacherModelArray];
            [_dataModelArray addObject:_managerModelArray];
            //初始化 数据源的时候 ，添加 YES，默认是展开状态
            [_showArray addObject:@YES];
            [_showArray addObject:@YES];
            
        }else{
            
            [SVProgressHUD showErrorWithStatus:@"获取信息失败!"];
        
        }
        
//        NSLog(@"%@", _dataModelArray);
        
        [_myTableView reloadData];
        
    } failure:^(NSError *error) {
        //
        NSLog(@"%@", error);
        [SVProgressHUD showInfoWithStatus:@"获取数据失败!"];
    }];

}


- (void)createTableView{

    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight) style:UITableViewStyleGrouped];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    
    [self.view addSubview:_myTableView];
}

#pragma mark - 
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

//    NSLog(@"%@", _dataModelArray);
//    
//    return _dataModelArray.count;
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if ([_showArray[section] boolValue] == 1) {
        return [_dataModelArray[section] count];
    }else{
        return 0;
    }

}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *identifier = @"cell";
    WZYRequestCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"WZYRequestCommentTableViewCell" owner:self options:nil] lastObject];
    }

    WZYRequestCommentModel *model;
    if (indexPath.section == 0) {
        model = _teacherModelArray[indexPath.row];

    }else if (indexPath.section == 1){
        model = _managerModelArray[indexPath.row];
    
    }
    [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.iconStr] placeholderImage:[UIImage imageNamed:@"人物头像172x172"]];
    
    cell.nameLabel.text = model.nameStr;
    cell.jobLabel.text = model.jobStr;
    
    return cell;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//
//    return 80;
//}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
    
    view.userInteractionEnabled = YES;
    
    view.tag = 100 + section;
    
    UITapGestureRecognizer *viewPress = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewPressClick:)];
    [view addGestureRecognizer:viewPress];
    
    arrowButton = [[UIButton alloc]initWithFrame:CGRectMake(10, (44-24)/2, 17.5, 20)];
    NSNumber *flagN = self.showArray[section];
    
    if ([flagN boolValue]) {
        [arrowButton setBackgroundImage:[UIImage imageNamed:@"ico_list"] forState:UIControlStateNormal];
        CGAffineTransform currentTransform =arrowButton.transform;
        CGAffineTransform newTransform =CGAffineTransformRotate(currentTransform, M_PI/2);
        arrowButton.transform =newTransform;
        
    }else
    {
        [arrowButton setBackgroundImage:[UIImage imageNamed:@"ico_list"] forState:UIControlStateNormal ];
        
    }
    arrowButton.tag = 300+section;

    [view addSubview:arrowButton];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(40, 5, 200, 30)];

        if (section == 0) {
            label.text = @"老师";
        }else if (section == 1){
            label.text = @"管理人员";
        }
    
    label.textColor = [UIColor lightGrayColor];
    label.font = [UIFont boldSystemFontOfSize:20];
    [view addSubview:label];
    
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80;
}

- (void)viewPressClick:(UITapGestureRecognizer *)press{
    
    //    NSLog(@" 头视图  tag  %ld", press.view.tag - 100);
    
    if ([self.showArray[press.view.tag - 100] boolValue]) {
        [self.showArray replaceObjectAtIndex:(press.view.tag - 100) withObject:[NSNumber  numberWithBool:NO]];
        
    }else{
        [self.showArray replaceObjectAtIndex:(press.view.tag - 100) withObject:[NSNumber numberWithBool:YES]];
    }
    [self.myTableView reloadData ];
    
    
}


//返回每个分组的表头视图的高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0000001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WZYRequestCommentModel *model;
    if (indexPath.section == 0) {
        //
        model = _teacherModelArray[indexPath.row];
    
    }else if(indexPath.section == 1){

        model = _managerModelArray[indexPath.row];
    }

    
    if ([_didSelectTeacherIdArray containsObject:model.tidStr]) {
        [SVProgressHUD showInfoWithStatus:@"该老师已选中,请重新选择赠送对象!"];
    }else{
        //选中老师的 头像、名称、id、课程 放进数组
        _selectedTeacherInfoArr = [[NSMutableArray alloc] initWithObjects:model.iconStr, model.nameStr, model.tidStr, model.jobStr, nil];
        
        
        //    NSLog(@"%@", _selectedTeacherInfoArr);
        
        self.ReturnArrayBlock(_selectedTeacherInfoArr);
        
        [self.navigationController popViewControllerAnimated:YES];

    }
    
}


- (void)returnArray:(ReturnArrayBlock)block{

    self.ReturnArrayBlock = block;

}

@end
