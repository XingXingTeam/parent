//
//  SubjectInfoViewController.m
//  XingXingEdu
//    ___  _____   ______  __ _   _________
//   / _ \/ __/ | / / __ \/ /| | / / __/ _ \
//  / , _/ _/ | |/ / /_/ / /_| |/ / _// , _/
// /_/|_/___/ |___/\____/____/___/___/_/|_|
//
//  Created by keenteam on 16/1/28.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//
#define kPData     @"ClassSubjectCell"
#import "SubjectInfoViewController.h"
#import "RBCustomDatePickerView.h"
#import "ClassSubjectCell.h"
#import "SubEditViewController.h"
#import "AddSubViewController.h"
#import "KTSubjectInfoViewController.h"
#import "ClassTimeTableModel.h"
#import "AddNewSubjeactIfonViewController.h"
@interface SubjectInfoViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *dataArray;
    NSMutableArray *classRoomArr;
    NSMutableArray *teacherMArr;
    NSMutableArray *remarkMArr;
    NSMutableArray *typeMArr;
    
    UIAlertView    *_alert;
//    NSString *urlStr;
    /**
     *  数组存储
     */
    NSMutableArray *idMArr;
    NSMutableArray *week_dateMArr;
    NSMutableArray *lesson_start_tmMArr;
    NSMutableArray *course_end_tmMArr;
    NSMutableArray *course_nameMArr;
    NSMutableArray *teacher_nameMArr;
    NSMutableArray *classroomMArr;
    NSMutableArray *notesMArr;
    NSMutableArray *wdMArr;
    NSMutableArray *_listArr;
    NSMutableArray *_dataType3Arr;
    ClassTimeTableModel *timeModel;
    NSMutableArray *modelMArr;
    
    NSString *babyId;
    
    NSString *parameterXid;
    NSString *parameterUser_Id;
}
@end

@implementation SubjectInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.backgroundColor = UIColorFromRGB(0, 170, 42);
    self.navigationController.navigationBarHidden = NO;
    
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }
    babyId =[DEFAULTS objectForKey:@"BABYID"];
    self.title = @"课程表";
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColorFromRGB(245,245, 245);
    
    idMArr =[[NSMutableArray alloc]init];
    week_dateMArr =[[NSMutableArray alloc]init];
    
    course_nameMArr =[[NSMutableArray alloc]init];
    teacher_nameMArr =[[NSMutableArray alloc]init];
    classroomMArr =[[NSMutableArray alloc]init];
    notesMArr =[[NSMutableArray alloc]init];
    typeMArr =[[NSMutableArray alloc]init];
    wdMArr =[[NSMutableArray alloc]init];
    modelMArr =[[NSMutableArray alloc]init];
    
    [self loadNetData];
    
    [self createRightBar];
    
    
}

- (void)createRightBar{
    
    UIButton *addBtn =[HHControl createButtonWithFrame:CGRectMake(251, 0, 26, 26) backGruondImageName:@"添加按钮icon" Target:self Action:@selector(addBtn:) Title:nil];
    UIBarButtonItem *rightBar =[[UIBarButtonItem alloc]initWithCustomView:addBtn];
    self.navigationItem.rightBarButtonItem =rightBar;
    
}
- (void)addBtn:(UIButton*)item{
    
    AddNewSubjeactIfonViewController *subjectVC =[[AddNewSubjeactIfonViewController alloc]init];
//    subjectVC.weekDataStr = self.weekStr;
    [self.navigationController pushViewController:subjectVC animated:NO];
    
}
- (void)loadNetData{
    
    dataArray = [[NSMutableArray alloc]init];
    classRoomArr = [[NSMutableArray alloc]init];
    teacherMArr = [[NSMutableArray alloc]init];
    remarkMArr = [[NSMutableArray alloc]init];
    
    lesson_start_tmMArr =[[NSMutableArray alloc]init];
    course_end_tmMArr =[[NSMutableArray alloc]init];
    _dataType3Arr = [NSMutableArray array];
    
    if (![self.detailMArr isEqual:@"..."]) {
        NSError *error;
        NSData *jsonData =[NSJSONSerialization dataWithJSONObject:self.detailMArr  options:kNilOptions error:&error];
        NSString *jsonString =[[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        
//        NSLog(@"==========jsonString==============%@",jsonString);
        if (self.detailMArr.count > 0) {
            
            NSString *urlStr =@"http://www.xingxingedu.cn/Parent/schedule_detail";
            
            NSDictionary *pragram =@{
                                     @"appkey":APPKEY,
                                     @"backtype":BACKTYPE,
                                     @"xid":parameterXid,
                                     @"user_id":parameterUser_Id,
                                     @"user_type":USER_TYPE,
                                     @"baby_id":babyId,
                                     @"week_date":self.weekStr,
                                     @"parame_data":jsonString,
                                     };
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
                
                manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];//设置相应内容类型
                [manager POST:urlStr parameters:pragram success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    NSDictionary *dict =responseObject;
                    
                    
//    NSLog(@"========>%@",dict);
                    
                    
                    if ([[NSString stringWithFormat:@"%@",dict[@"code"]] isEqualToString:@"1"]) {
                        _listArr = dict[@"data"];
                        
                        for (int i=0; i<_listArr.count; i++) {
                            
                            NSString *subjectName = [_listArr[i] objectForKey:@"course_name"];
                            NSString *classroomNanme = [_listArr[i] objectForKey:@"classroom"];
                            NSString *teacherName = [_listArr[i] objectForKey:@"teacher_name"];
                            NSString *lesstionStart = [_listArr[i] objectForKey:@"lesson_start_tm"];
                            NSString *lesstionEnd = [_listArr[i] objectForKey:@"lesson_end_tm"];
                            NSString *typeStr = [_listArr[i] objectForKey:@"type"];
                            NSString *notesStr = [_listArr[i] objectForKey:@"notes"];
                            NSString *idStr = [_listArr[i] objectForKey:@"id"];
                            NSString *wdStr = [_listArr[i] objectForKey:@"wd"];
                            
                            
                            NSMutableArray *dataArr = [[NSMutableArray alloc] initWithObjects:subjectName,classroomNanme,teacherName,lesstionStart,lesstionEnd,typeStr,notesStr,idStr,wdStr, nil];
                            
                            [_dataType3Arr addObject:dataArr];
                            
                        }
                    }
                    
                    [self createTableView];
                    [_tableView reloadData];
                    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    NSLog(@"error");
                }];
                
            });
        }
    }
}


- (void)createTableView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight) style:UITableViewStyleGrouped];
    _tableView.dataSource =self;
    _tableView.delegate =self;
    [self.view addSubview:_tableView];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _listArr.count;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.00001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ClassSubjectCell *cell = (ClassSubjectCell*) [tableView dequeueReusableCellWithIdentifier:kPData];
    if(cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:kPData owner:[ClassSubjectCell class] options:nil];
        cell = (ClassSubjectCell *)[nib objectAtIndex:0];
        cell.contentView.backgroundColor = [UIColor clearColor];
        
    }
    
    //    if ([self.className rangeOfString:@"&"].location !=NSNotFound ) {
    //
    //        cell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
    //    }
    //    else{
    
    NSArray * tmp = _dataType3Arr[indexPath.row];
    
    cell.classSubjectName.text =[NSString stringWithFormat:@"课程名:%@",tmp[0]];
    cell.classRoomName.text = [NSString stringWithFormat:@"教室:%@",tmp[1]];
    cell.goTimeHour.text = [NSString stringWithFormat:@"上课时间:%@",tmp[3]];
    cell.stopTimeHour.text = [NSString stringWithFormat:@"下课时间:%@",tmp[4]];
    cell.teacherName.text = [NSString stringWithFormat:@"老师:%@",tmp[2]];
    cell.remarkName.text = [NSString stringWithFormat:@"备注:%@",tmp[6]];
    
    cell.backgroundColor = UIColorFromRGB(255,255, 255);
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    //    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([[NSString stringWithFormat:@"%@",_dataType3Arr[indexPath.row][5]] isEqualToString:@"3"]) {
        
        KTSubjectInfoViewController *subjectVC =[[KTSubjectInfoViewController alloc]init];
        subjectVC.dataArr = _dataType3Arr[indexPath.row];
        subjectVC.weekDataStr = self.weekStr;
        subjectVC.hidden = YES;
        [self.navigationController pushViewController:subjectVC animated:YES];
        
    } else{
        KTSubjectInfoViewController *subjectVC =[[KTSubjectInfoViewController alloc]init];
        subjectVC.dataArr = _dataType3Arr[indexPath.row];
        subjectVC.weekDataStr = self.weekStr;
        subjectVC.hidden = NO;
        [self.navigationController pushViewController:subjectVC animated:YES];
        return;
    }
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewCellEditingStyleDelete;
    
}
- (NSString*)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle ==UITableViewCellEditingStyleDelete) {
        
        NSString *urlStr = @"http://www.xingxingedu.cn/Parent/schedule_parent_delete";
        AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
        
        NSDictionary *dict = @{@"appkey":APPKEY,
                               @"backtype":BACKTYPE,
                               @"xid":parameterXid,
                               @"user_id":parameterUser_Id,
                               @"user_type":USER_TYPE,
                               @"baby_id":babyId,
                               @"schedule_id":_dataType3Arr[indexPath.row][7],
                               
                               };
        // 服务器返回的数据格式
        mgr.responseSerializer = [AFHTTPResponseSerializer serializer]; // 二进制数据
        [mgr POST:urlStr parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject){
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            //            NSLog(@"===========>%@",dict);
            if([[NSString stringWithFormat:@"%@",dict[@"code"]] isEqualToString:@"1"] ){
                
                _alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"确定要删除该课程吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                
                [_alert show];
                
                [self.navigationController popViewControllerAnimated:YES];
                
                
            }else{
                
                [SVProgressHUD showErrorWithStatus:@"删除失败，请检查网络是否通畅"];
                
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"网络不通，请检查网络！"];
        }];
        
        
        
    }
    
}
//网络请求
-(void)deleteSubjectNetWorking{
}

- (void)returnText:(ReturnTextBlock)block{
    self.returnTextBlock =block;
}
- (void)viewWillDisappear:(BOOL)animated{
    
    UITextField *classTextFiled =(UITextField *)[self.view viewWithTag:10000];
    if (self.returnTextBlock !=nil) {
        self.returnTextBlock(classTextFiled.text);
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
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
