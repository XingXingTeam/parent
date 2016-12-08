//
//  CommentInputViewController.m
//  XingXingEdu
//
//  Created by mac on 16/6/27.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "CommentInputViewController.h"
#import "SVProgressHUD.h"
#import "AFNetworking.h"
#define Kmarg 10.0f
@interface CommentInputViewController ()<UITextViewDelegate>

@property (nonatomic, strong) UITextView *contentView;

@end

@implementation CommentInputViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.edgesForExtendedLayout=UIRectEdgeNone;
    self.view.backgroundColor = UIColorFromRGB(229, 232, 233);;
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    self.navigationController.navigationBar.barTintColor =UIColorFromRGB(0, 170, 42);
    
    [self rightItemButton];
    [self createTextView];
    // Do any additional setup after loading the view.
}


-(void)createTextView{
    
    _contentView = [[UITextView alloc] initWithFrame:CGRectMake(Kmarg, Kmarg, kWidth - Kmarg *2, 120)];
    _contentView.text = @"";
    _contentView.textAlignment = NSTextAlignmentLeft;
    _contentView.dataDetectorTypes = UIDataDetectorTypeAll;
    _contentView.scrollEnabled = YES;
    _contentView.editable =YES;
    _contentView.font = [UIFont systemFontOfSize:15];
    _contentView.delegate =self;
    _contentView.textColor = [UIColor blackColor];
    [self.view addSubview:_contentView];
}
-(void)rightItemButton{
    UIButton*rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,40,30)];
    [rightButton setTitle:@"发送" forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(sendMessageBtn)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem= rightItem;
}
-(void)sendMessageBtn{
    if(_contentView.text.length < 1){
        [SVProgressHUD showErrorWithStatus:@"不能为空，请输入文字"];
        return;
    }else{
        
        [self commentInputTextView];
        
     [self.navigationController popViewControllerAnimated:YES];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (range.location >= 300){
        //控制输入文本的长度
        return  NO;
    }if ([text isEqualToString:@"\n"]) {
        //禁止输入换行
        return YES;
    }else{
        return YES;
    }
    
}
-(void)commentInputTextView{
    
    NSString *strngXid;
    NSString *homeUserId;
    if ([XXEUserInfo user].login) {
        strngXid = [XXEUserInfo user].xid;
        homeUserId = [XXEUserInfo user].user_id;
    }else {
        strngXid = XID;
        homeUserId = USER_ID;
    }
    
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/my_circle_comment";
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *dict = @{@"appkey":APPKEY,
                           @"backtype":BACKTYPE,
                           @"xid":strngXid,
                           @"user_id":homeUserId,
                           @"user_type":USER_TYPE,
                           @"com_type":@"1",
                           @"talk_id":_itemId,
                           @"con":_contentView.text,
                           };
    // 服务器返回的数据格式
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer]; // 二进制数据
    [mgr POST:urlStr parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         if([[NSString stringWithFormat:@"%@",dict[@"code"]] isEqualToString:@"1"] ){
             NSDictionary *dictK =dict[@"data"];
             NSString *commentXid = [NSString stringWithFormat:@"%@",dictK[@"xid"]];
             NSString *commentNickName =[NSString stringWithFormat:@"%@",dictK[@"nickname"]];
             
             DFLineCommentItem *commentItem = [[DFLineCommentItem alloc] init];
             commentItem.commentId = [commentXid integerValue];
             commentItem.userId = [commentXid integerValue];
             commentItem.userNick = commentNickName;
             commentItem.text = _contentView.text;
//             [self addCommentItem:commentItem itemId:itemId replyCommentId:commentId];
         }
         
         [SVProgressHUD showSuccessWithStatus:@"评论成功"];
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"请求失败:%@",error);
         [SVProgressHUD showErrorWithStatus:@"网络不通，请检查网络！"];
         
     }];

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_contentView endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
