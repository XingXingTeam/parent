//
//  CommentRequestViewController.m
//  XingXingStore
//
//  Created by codeDing on 16/2/17.
//  Copyright © 2016年 codeDing. All rights reserved.
//

#import "CommentRequestViewController.h"
#import "CommentRequestTableViewCell.h"
#import "DynamicScrollView.h"
#import "SVProgressHUD.h"
#import "WZYCommentViewController.h"
#import "ClassTelephoneViewController.h"

#import "WZYRequestCommentViewController.h"


@interface CommentRequestViewController ()<UITextViewDelegate>{
    UITableView * myTableView;
    NSMutableArray * commentArray;
    
    NSMutableArray *images;//老师头像
    NSArray *nameArray;//老师名字
     NSMutableArray *didSelectTeacherNameArray;//选中老师 名称  数组
    NSMutableArray *didSelectTeacherIdArray;//选中老师 tid  数组
    NSMutableArray *didSelectTeacherCourseArray;//选中老师 课程  数组
    
    
    //选中 老师 id 拼接后的字符串
    NSString *teacherIdStr;
    //选中 老师 课程 拼接后的字符串
    NSString *teacherCourseStr;
    
    DynamicScrollView *dynamicScrollView;
    NSString *parameterXid;
    NSString *parameterUser_Id;
}

//选中 老师 信息
@property (nonatomic, strong) NSMutableArray *selectedTeacherInfoArr;

@end


@implementation CommentRequestViewController


- (instancetype)init
{
    self = [super init];
    if (self) {

        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }
    didSelectTeacherNameArray = [[NSMutableArray alloc] init];
    didSelectTeacherIdArray = [[NSMutableArray alloc] init];
    didSelectTeacherCourseArray = [[NSMutableArray alloc] init];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;

    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    
   self.navigationItem.title=@"点评详情";

    images = [NSMutableArray array];
    
    self.requestText.layer.borderColor = UIColorFromRGB(229, 222, 223).CGColor;
    self.requestText.layer.borderWidth =0.8;//该属性显示外边框
    self.requestText.layer.cornerRadius = 1.0;//通过该值来设置textView边角的弧度
    self.requestText.layer.masksToBounds = YES;
    self.requestText.delegate=self;
    
    //选取老师控件
    dynamicScrollView = [[DynamicScrollView alloc] initWithFrame:CGRectMake(80,10,WinWidth-80,62) withImages:nil];
    [self.view addSubview:dynamicScrollView];
    
    
    //监听通知
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(removeSuccess:) name:@"TeacherNameRemoveSuccess" object:nil];
    
}



- (IBAction)addButton:(id)sender {
    
    if (didSelectTeacherNameArray.count == 4) {
        [SVProgressHUD showInfoWithStatus:@"一次最多可请求4位老师点评"];
    }else{
        WZYRequestCommentViewController *WZYRequestCommentVC = [[WZYRequestCommentViewController alloc] init];
        
        WZYRequestCommentVC.didSelectTeacherIdArray = didSelectTeacherIdArray;
        
        //返回 数组 头像、名称、id、课程
        [WZYRequestCommentVC returnArray:^(NSMutableArray *selectedTeacherInfoArray) {
            _selectedTeacherInfoArr = [NSMutableArray arrayWithArray:selectedTeacherInfoArray];
            
            //老师 头像
            [dynamicScrollView addImageView:selectedTeacherInfoArray[0]];
            
            //老师 名字
            [didSelectTeacherNameArray addObject:selectedTeacherInfoArray[1]];
            NSMutableString *labelStr=[NSMutableString string];
            for (NSString * str in didSelectTeacherNameArray ) {
                [labelStr appendString:str];
                [labelStr appendString:@"  "];
            }
            self.nameLabel.text=labelStr;
            
            //老师 id
            [didSelectTeacherIdArray addObject:selectedTeacherInfoArray[2]];
            
            NSMutableString *tidStr = [NSMutableString string];
            
            for (int j = 0; j < didSelectTeacherIdArray.count; j ++) {
                NSString *str = didSelectTeacherIdArray[j];
                
                if (j != didSelectTeacherIdArray.count - 1) {
                    [tidStr appendFormat:@"%@,", str];
                }else{
                    [tidStr appendFormat:@"%@", str];
                }
            }
            
            teacherIdStr = tidStr;
            
        }];
        
        [self.navigationController pushViewController:WZYRequestCommentVC animated:YES];
    
    }
    
}

- (IBAction)sendBtn:(id)sender {
     if ([self.nameLabel.text isEqualToString:@""]){
        [SVProgressHUD showErrorWithStatus:@"请选择老师"];
     }else if([self.requestText.text isEqualToString:@""]){
         [SVProgressHUD showErrorWithStatus:@"请填写请求内容"];
     }
     else if(self.requestText.text.length>200){
         [SVProgressHUD showErrorWithStatus:@"请求内容不能超过200字"];
     }
    
    else{

        [self ask_teacher_comment];

    }
}

- (void)removeSuccess:(NSNotification *)notification
{
    NSString *indexStr=[[notification userInfo] valueForKey:@"index"];
    NSInteger index=[indexStr integerValue];
    [didSelectTeacherNameArray removeObjectAtIndex:index];
    NSMutableString *labelStr=[NSMutableString string];
    for (NSString * str in didSelectTeacherNameArray ) {
        [labelStr appendString:str];
        [labelStr appendString:@"  "];
    }
    self.nameLabel.text=labelStr;
    
    //老师 id
    [didSelectTeacherIdArray removeObjectAtIndex:index];
    NSMutableString *tidStr = [NSMutableString string];
    
    for (int j = 0; j < didSelectTeacherIdArray.count; j ++) {
        NSString *str = didSelectTeacherIdArray[j];
        
        if (j != didSelectTeacherIdArray.count - 1) {
            [tidStr appendFormat:@"%@,", str];
        }else{
            [tidStr appendFormat:@"%@", str];
        }
    }
    
    teacherIdStr = tidStr;
    
}


- (void)textViewDidChange:(UITextView *)textView{

//    self.textcountLabel.text=[NSString stringWithFormat:@"%lu/200",(unsigned long)textView.text.length];
    if (textView == _requestText) {
        
        if (_requestText.text.length <= 200) {
            self.textcountLabel.text=[NSString stringWithFormat:@"%lu/200",(unsigned long)textView.text.length];
        }else{
            [SVProgressHUD showInfoWithStatus:@"最多可输入200个字符"];
            _requestText.text = [_requestText.text substringToIndex:200];
        }
    }
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
   [self.view endEditing:YES];
}

//发送点评请求

- (void)ask_teacher_comment{

/*
 【请求老师点评确认发送】
 接口:
 http://www.xingxingedu.cn/Parent/ask_teacher_comment
 传参:
 	baby_id		//孩子id, 测试用值3
    class_id
    school_id
	tid 		//教师id (多个用逗号隔开)
	ask_con		//请求内容
 */
    //路径
    NSString *urlStr = @"http://www.xingxingedu.cn/Parent/ask_teacher_comment";
    
    //请求参数  无

    NSString *babyIdStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"BABYID"];
    NSString *class_idStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"CLASS_ID"];
    NSString *schoolIdStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"SCHOOL_ID"];

    NSDictionary *params = @{@"appkey":APPKEY, @"backtype":BACKTYPE, @"xid":parameterXid, @"user_id":parameterUser_Id, @"user_type":USER_TYPE, @"tid": teacherIdStr, @"class_id": class_idStr, @"school_id": schoolIdStr, @"baby_id": babyIdStr, @"ask_con": self.requestText.text};
    
//    NSLog(@"传参  -- %@", params);
    
    [WZYHttpTool post:urlStr params:params success:^(id responseObj) {

//        NSLog(@"%@", responseObj);
        
        NSString *codeStr = [NSString stringWithFormat:@"%@", responseObj[@"code"]];
        if ([codeStr isEqualToString:@"1"]) {
            
            [SVProgressHUD showInfoWithStatus:@"请求点评成功!"];
            sleep(1);
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
        
         [SVProgressHUD showInfoWithStatus:@"请求点评失败!"];
            
        }
        
    } failure:^(NSError *error) {
        //
        NSLog(@"%@", error);
    }];
}

@end
