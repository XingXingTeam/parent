




//
//  XXECommentRequestInfoViewController.m
//  XingXingEdu
//
//  Created by Mac on 16/7/29.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "XXECommentRequestInfoViewController.h"
#import "CommentHistoryTableViewController.h"

@interface XXECommentRequestInfoViewController (){
    NSInteger  imgCount;
    BOOL isCollect;
    NSString *parameterXid;
    NSString *parameterUser_Id;
    
}

@end

@implementation XXECommentRequestInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    self.view.backgroundColor = UIColorFromRGB(229, 232, 233);
    
//    if(self.isHistory==YES){
//        self.commentHistoryBtn.hidden=YES;
//    }
    
    [[self navigationItem] setTitle:@"点评详情"];
    

    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.nameLabel.text= [NSString stringWithFormat:@"点评老师: %@",_tnameStr];
    self.requestContentTextView.text= _ask_conStr;
//    self.replyContentTextView.text= _com_conStr;

}

- (IBAction)commentHistoryButton:(id)sender {
    
    CommentHistoryTableViewController * vc=[[CommentHistoryTableViewController alloc]init];
    
    vc.teacherId = _tuser_idStr;
    [self.navigationController pushViewController: vc animated:YES];

    
}

- (IBAction)deleteButton:(id)sender {
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"删除点评不可恢复，确定删除？" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *cancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *ok=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self deleteComment];
        
        
    }];
    [alert addAction:ok];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];

    
}

//删除点评
- (void)deleteComment
{
    NSString *urlStr = @"http://www.xingxingedu.cn/Parent/delete_teacher_com";
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *dict = @{@"appkey":APPKEY,
                           @"backtype":BACKTYPE,
                           @"xid":parameterXid,
                           @"user_id":parameterUser_Id,
                           @"user_type":USER_TYPE,
                           @"com_id":_commentIdStr,
                           
                           };
    //        NSLog(@"%@",dict);
    
    // 服务器返回的数据格式
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer]; // 二进制数据
    [mgr POST:urlStr parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         //                  NSLog(@"%@",dict);
         //        NSLog(@"%@",dict[@"code"]);
         
         if([[NSString stringWithFormat:@"%@",dict[@"code"]]isEqualToString:@"1"] )
         {
             [SVProgressHUD showSuccessWithStatus:@"删除点评成功"];
             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                 [self.navigationController popViewControllerAnimated:YES];
             });
             
             
         }
         else
         {
             [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"删除点评失败，%@",dict[@"msg"]]];
         }
         
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"请求失败:%@",error);
         [SVProgressHUD showErrorWithStatus:@"网络不通，请检查网络！"];
         
     }];
}


@end
