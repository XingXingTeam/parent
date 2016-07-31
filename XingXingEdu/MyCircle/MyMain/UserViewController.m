//
//  UserTimelineViewController.m
//  DFTimelineView
//
//  Created by keenteam on 16/2/1.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//
#define MYCIRLE  @"http://www.xingxingedu.cn/Global/select_mycircle"
#import "UserViewController.h"
#import "UserInformationViewController.h"
@implementation UserViewController
{
    
    NSMutableArray *_user_info;
    NSMutableArray *_listArr;
    NSMutableArray *_xidArr;
    NSMutableArray *_pic_urlArr;
    NSMutableArray *_date_tmArr;
    NSMutableArray *_positionArr;
    NSMutableArray *_file_typeArr;
    NSMutableArray *_wordsArr;
    NSMutableArray *_video_urlArr;
    NSMutableArray *_good_userArr;
    NSMutableArray *_goodArr;
    NSMutableArray *_idArr;
    NSMutableArray *_comment_group;
    
    NSInteger   _pageNumber;
    
}
-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title =@"我的";
    _pageNumber = 1;
    
    [self downLoadData:1 isLoadMore:NO];
    
}
- (void)downLoadData:(NSInteger)page isLoadMore:(BOOL)isLoadMore{
    
    _user_info = [NSMutableArray array];
    _listArr = [NSMutableArray array];
    _date_tmArr = [NSMutableArray array];
    _pic_urlArr = [NSMutableArray array];
    _positionArr = [NSMutableArray array];
    _wordsArr = [NSMutableArray array];
    _video_urlArr = [NSMutableArray array];
    _good_userArr = [NSMutableArray array];
    _goodArr = [NSMutableArray array];
    _idArr = [NSMutableArray array];
    _comment_group = [NSMutableArray array];
    _file_typeArr = [NSMutableArray array];
    _wordsArr  = [NSMutableArray array];
    
    if (![_xidStr isEqualToString:XID]) {
        //  网络请求
        NSString *urlStr = MYCIRLE;
        AFHTTPRequestOperationManager *mgr =[AFHTTPRequestOperationManager manager];
        NSDictionary *dict = @{@"appkey":APPKEY,
                               @"backtype":BACKTYPE,
                               @"xid":XID,
                               @"user_id":USER_ID,
                               @"user_type":USER_TYPE,
                               @"other_xid":_xidStr,
                               @"page":[NSString stringWithFormat:@"%ld",page],
                               };
        
        // 服务器返回的数据格式
        mgr.responseSerializer = [AFHTTPResponseSerializer serializer]; // 二进制数据
        [mgr POST:urlStr parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
             //            NSLog(@"===========别人家的=====================%@========",dict);
             if([[NSString stringWithFormat:@"%@",dict[@"code"]] isEqualToString:@"1"] ){
                 //头视图信息
                 //头像
                 if ([dict[@"data"][@"user_info"][@"head_img_type"] isEqualToString:@"1"]) {
                     NSString *head_img =[NSString stringWithFormat:@"%@",dict[@"data"][@"user_info"][@"head_img"]];
                     //昵称
                     NSString *nickname =dict[@"data"][@"user_info"][@"nickname"];
                     _user_info = [[NSMutableArray alloc] initWithObjects:head_img,nickname, nil];
                 }else{
                     NSString *head_img =[NSString stringWithFormat:@"%@%@",picURL,dict[@"data"][@"user_info"][@"head_img"]];
                     //昵称
                     NSString *nickname =dict[@"data"][@"user_info"][@"nickname"];
                     _user_info = [[NSMutableArray alloc] initWithObjects:head_img,nickname, nil];
                 }
                 
                 //朋友圈信息
                 _listArr = dict[@"data"][@"ss"];
                 
                 if (_listArr.count > 0) {
                     for (int i=0; i< _listArr.count; i++) {
                         //Xid
                         [_xidArr  addObject:[_listArr[i] objectForKey:@"xid"]];
                         //图片
                         [_pic_urlArr addObject: [NSString stringWithFormat:@"%@",[_listArr[i] objectForKey:@"pic_url"]]];
                         //时间
                         [_date_tmArr addObject:[_listArr[i] objectForKey:@"date_tm"]];
                         //位置
                         [ _positionArr addObject:[_listArr[i] objectForKey:@"position"]];
                         //文件类型 1:图片 2:类型
                         [_file_typeArr addObject:[_listArr[i] objectForKey:@"file_type"]];
                         //写接口时测试
                         [_wordsArr addObject:[_listArr[i] objectForKey:@"words"]];
                         //小视频
                         [_video_urlArr addObject:[_listArr[i] objectForKey:@"video_url"]];
                         //ID
                         [_idArr addObject:[_listArr[i] objectForKey:@"id"]];
                         //点赞
                         [_good_userArr addObject:[_listArr[i] objectForKey:@"good_user"]];
                         [_goodArr addObject:[_listArr[i] objectForKey:@"good"]];
                         //评论
                         [_comment_group addObject:[_listArr[i] objectForKey:@"comment_group"]];
                     }
                 }
             }else{
                 [SVProgressHUD showErrorWithStatus:@"没有更多数据啦"];
                 [self endLoadMore];
             }
             [self setHeader];
             
             [self initData];
             
         } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
             NSLog(@"%@", error);
             [SVProgressHUD showErrorWithStatus:@"网络不通，请检查网络！"];
         }];
    }
    else
    {
        //  网络请求
        NSString *urlStr = MYCIRLE;
        AFHTTPRequestOperationManager *mgr =[AFHTTPRequestOperationManager manager];
        NSDictionary *dict = @{@"appkey":APPKEY,
                               @"backtype":BACKTYPE,
                               @"xid":XID,
                               @"user_id":USER_ID,
                               @"user_type":USER_TYPE,
                               @"page":[NSString stringWithFormat:@"%ld",page],
                               };
        
        // 服务器返回的数据格式
        mgr.responseSerializer = [AFHTTPResponseSerializer serializer]; // 二进制数据
        [mgr POST:urlStr parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
             //            NSLog(@"===========自己家的=====================%@========",dict);
             //头视图信息
             if ([dict[@"data"][@"user_info"][@"head_img_type"] isEqualToString:@"1"]) {
                 NSString *head_img =[NSString stringWithFormat:@"%@",dict[@"data"][@"user_info"][@"head_img"]];
                 //昵称
                 NSString *nickname =dict[@"data"][@"user_info"][@"nickname"];
                 _user_info = [[NSMutableArray alloc] initWithObjects:head_img,nickname, nil];
             }else{
                 NSString *head_img =[NSString stringWithFormat:@"%@%@",picURL,dict[@"data"][@"user_info"][@"head_img"]];
                 //昵称
                 NSString *nickname =dict[@"data"][@"user_info"][@"nickname"];
                 _user_info = [[NSMutableArray alloc] initWithObjects:head_img,nickname, nil];
             }
             //朋友圈信息  添加数据 待完善
             _listArr = dict[@"data"][@"ss"];
             //              NSLog(@"===========自己家的=====================%@========",_listArr);
             if (_listArr.count > 0) {
                 for (int i=0; i< _listArr.count; i++) {
                     //Xid
                     [_xidArr  addObject:[_listArr[i] objectForKey:@"xid"]];
                     //图片
                     [_pic_urlArr addObject: [NSString stringWithFormat:@"%@",[_listArr[i] objectForKey:@"pic_url"]]];
                     //时间
                     [_date_tmArr addObject:[_listArr[i] objectForKey:@"date_tm"]];
                     //位置
                     [ _positionArr addObject:[_listArr[i] objectForKey:@"position"]];
                     //文件类型 1:图片 2:类型
                     [_file_typeArr addObject:[_listArr[i] objectForKey:@"file_type"]];
                     //写接口时测试
                     [_wordsArr addObject:[_listArr[i] objectForKey:@"words"]];
                     //小视频
                     [_video_urlArr addObject:[_listArr[i] objectForKey:@"video_url"]];
                     //ID
                     [_idArr addObject:[_listArr[i] objectForKey:@"id"]];
                     //点赞
                     [_good_userArr addObject:[_listArr[i] objectForKey:@"good_user"]];
                     [_goodArr addObject:[_listArr[i] objectForKey:@"good"]];
                     //评论
                     [_comment_group addObject:[_listArr[i] objectForKey:@"comment_group"]];
                 }
                 
             }else{
                 [SVProgressHUD showErrorWithStatus:@"没有更多数据啦"];
                 [self endLoadMore];
             }
             [self setHeader];
             
             [self initData];
             
             //发送到服务器请求头部信息
         } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
             NSLog(@"%@", error);
             [SVProgressHUD showErrorWithStatus:@"网络不通，请检查网络！"];
         }];
    }
}

//头试图
-(void) setHeader{
    //大头像背景
    [self setCover:_user_info[0]];
    //签名
    [self setUserSign:@""];
    //头像
    [self setUserAvatar:_user_info[0]];
    //昵称
    [self setUserNick:_user_info[1]];
}

-(void) initData
{
    for (int i=0; i<_listArr.count; i++) {
        
        DFTextImageUserLineItem *item = [[DFTextImageUserLineItem alloc]init];
        item.itemId =[_idArr[i] integerValue];
        item.ts =[_date_tmArr[i] integerValue]*1000;
        if (![_pic_urlArr[i] isEqualToString:@""]) {
            NSMutableArray *Images = [NSMutableArray array];
            for (int j=0; j<[_pic_urlArr[i] componentsSeparatedByString:@","].count; j++) {
                
                [Images addObject:[NSString stringWithFormat:@"%@%@",picURL,[_pic_urlArr[i] componentsSeparatedByString:@","][j]]];
            }
            item.cover =Images[0];
            item.text =_wordsArr[i];
            item.photoCount = Images.count;
            item.imageMrr =Images;
            [self addItem:item];
        }else{
            item.text =_wordsArr[i];
            [self addItem:item];
        }
    }
    [self endLoadMore];
    
}

-(void)loadMore
{
    _pageNumber ++;
    [self downLoadData:_pageNumber isLoadMore:YES];
    
}
-(void) refresh{
    [self endRefresh];
}



-(void)onClickItem:(DFTextImageUserLineItem *)item{
    
    UserInformationViewController *userInfoVC =[[UserInformationViewController alloc]init];
    userInfoVC.ts =item.ts;
    userInfoVC.itemId = [NSString stringWithFormat:@"%lld",item.itemId];
    userInfoVC.conText = item.text;
    userInfoVC.imagesArr = item.imageMrr;
    userInfoVC.goodArr = _good_userArr;
    userInfoVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:userInfoVC animated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
