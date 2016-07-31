//
//  CommentInfoViewController.m
//  XingXingStore
//
//  Created by codeDing on 16/2/16.
//  Copyright © 2016年 codeDing. All rights reserved.
//

#import "CommentInfoViewController.h"
#import "CommentHistoryTableViewController.h"
#import "RedFlowerViewController.h"

@interface CommentInfoViewController (){
    NSInteger  imgCount;
    BOOL isCollect;

}

//@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

- (IBAction)historyBtn:(id)sender;
- (IBAction)deleteBtn:(id)sender;

- (IBAction)seePhotoBtn:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *commentHistoryBtn;


@end

@implementation CommentInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
     self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    self.view.backgroundColor = UIColorFromRGB(229, 232, 233);
    
    if(self.isHistory==YES){
        self.commentHistoryBtn.hidden=YES;
    }
    
    [[self navigationItem] setTitle:@"点评详情"];
  

    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.teacherNameLabel.text= [NSString stringWithFormat:@"点评老师: %@",_tnameStr];
    self.requestContentTextView.text= _ask_conStr;
    self.replyContentTextView.text= _com_conStr;
    
    [self setRightCollectionButton];
    
    imgCount=2;
//    [self scroll];
}


- (IBAction)seePhotoBtn:(id)sender {
//    NSLog(@"--%@",_com_picStr);
    NSMutableArray *imgArray=[NSMutableArray array];
    if ([_com_picStr isEqualToString:@""]) {
        NSLog(@"没有图片");
        
            _PicView.hidden = YES;
            [SVProgressHUD showErrorWithStatus:@"该点评没有图片"];
    }else{
        NSArray *imgtmpArr = [_com_picStr componentsSeparatedByString:@","];
        
        for (NSString * urlStr in imgtmpArr) {
//            NSString * picStr=[picURL stringByAppendingString:urlStr];
            [imgArray addObject:urlStr];
        }
        
        RedFlowerViewController *redFlowerVC =[[RedFlowerViewController alloc]init];
        redFlowerVC.s =(int)imgArray.count;
        redFlowerVC.imageArr =imgArray;
        redFlowerVC.isUrlImage=YES;
        
//        NSLog(@"%@", imgArray);
        
        redFlowerVC.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:redFlowerVC animated:YES];
    }

}


- (void)setRightCollectionButton{

    UIButton*rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,22,22)];
//    [rightButton setImage:[UIImage imageNamed:@"commentInfo10.png"]forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(collectbtn:)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem= rightItem;
    
        //[collect_condit] => 1			//1:是收藏过这个商品  2:未收藏过
    UIImage *saveImage;
    
    if ([_collect_conditStr integerValue] == 1) {
        isCollect = YES;
        saveImage = [UIImage imageNamed:@"收藏(H)icon44x44"];
        
    }else if([_collect_conditStr integerValue] == 2){
        isCollect = NO;
        saveImage = [UIImage imageNamed:@"收藏icon44x44"];
    }
    [rightButton setBackgroundImage:saveImage forState:UIControlStateNormal];
    
}

-(void)collectbtn:(UIButton *)btn{
    
    if (isCollect==NO) {
        [self collectComment];
        
    }
    else  if (isCollect==YES) {
        
        [self deleteCollectcollectComment];
    }
    
}


//收藏点评
- (void)collectComment
{
    /*
     【收藏】通用于各种收藏
     
     接口:
     http://www.xingxingedu.cn/Global/collect
     
     传参:
     collect_id	//收藏id (如果是收藏用户,这里是xid)
     collect_type	//收藏品种类型	1:商品  2:点评  3:用户  4:课程  5:学校  6:花朵
     */
    
    //路径
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/collect";
    
    //请求参数  无
    
    NSDictionary *params = @{@"appkey":APPKEY, @"backtype":BACKTYPE, @"xid":XID, @"user_id":USER_ID, @"user_type":USER_TYPE, @"collect_id":_commentIdStr, @"collect_type":@"2",};
    [WZYHttpTool post:urlStr params:params success:^(id responseObj) {
        //
        NSDictionary *dict = responseObj;
        
        if([[NSString stringWithFormat:@"%@",dict[@"code"]]isEqualToString:@"1"] ){
                         [SVProgressHUD showSuccessWithStatus:@"收藏点评成功"];
                         UIButton*rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,22,22)];
                         [rightButton setBackgroundImage:[UIImage imageNamed:@"commentInfo10.png"] forState:UIControlStateNormal];
                         UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
                         self.navigationItem.rightBarButtonItem= rightItem;
                         [rightButton addTarget:self action:@selector(collectbtn:)forControlEvents:UIControlEventTouchUpInside];
                         isCollect=!isCollect;
            
            
                     }
                     else
                     {
                         [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"收藏点评失败，%@",dict[@"msg"]]];
                     }
    } failure:^(NSError *error) {
        //
                 NSLog(@"请求失败:%@",error);
                 [SVProgressHUD showErrorWithStatus:@"网络不通，请检查网络！"];
    }];
    
    
}

//取消收藏点评
- (void)deleteCollectcollectComment
{
   
    /*
     【删除/取消收藏】通用于各种收藏
     
     接口:
     http://www.xingxingedu.cn/Global/deleteCollect
     
     传参:
     collect_id	//收藏id (如果是收藏用户,这里是xid)
     collect_type	//收藏品种类型	1:商品  2:点评  3:用户  4:课程  5:学校  6:花朵 7:图片
     */
    
    //路径
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/deleteCollect";
    
    //请求参数  无
    
    NSDictionary *params = @{@"appkey":APPKEY, @"backtype":BACKTYPE, @"xid":XID, @"user_id":USER_ID, @"user_type":USER_TYPE, @"collect_id":_commentIdStr, @"collect_type":@"2",};
    [WZYHttpTool post:urlStr params:params success:^(id responseObj) {
        //
        
        NSDictionary *dict = responseObj;
        
        if([[NSString stringWithFormat:@"%@",dict[@"code"]]isEqualToString:@"1"] ){
                [SVProgressHUD showSuccessWithStatus:@"取消收藏成功"];
            
                 UIButton*rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,22,22)];
                  [rightButton setBackgroundImage:[UIImage imageNamed:@"commentInfo9.png"] forState:UIControlStateNormal];
                  UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
                         self.navigationItem.rightBarButtonItem= rightItem;
                 [rightButton addTarget:self action:@selector(collectbtn:)forControlEvents:UIControlEventTouchUpInside];
                         isCollect=!isCollect;
            
            
                     }else{
                        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"取消收藏商品失败，%@",dict[@"msg"]]];
                     }
    } failure:^(NSError *error) {
        //
                 NSLog(@"请求失败:%@",error);
                 [SVProgressHUD showErrorWithStatus:@"网络不通，请检查网络！"];
    }];
    

}



- (IBAction)historyBtn:(id)sender {
    CommentHistoryTableViewController * vc=[[CommentHistoryTableViewController alloc]init];
    vc.teacherId = _tuser_idStr;
    [self.navigationController pushViewController: vc animated:YES];
}

- (IBAction)deleteBtn:(id)sender {
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
    
    NSDictionary *dict = @{@"appkey":@"U3k8Dgj7e934bh5Y",
                           @"backtype":@"json",
                           @"xid":@"18884982",
                           @"user_id":@"1",
                           @"user_type":@"1",
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
