//
//  ViewController.m
//  DFTimelineView
//
//  Created by keenteam on 16/2/1.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//
#define tempUrl  @"http://file-cdn.datafans.net/temp/12.jpg_%dx%d.jpeg"
#define avaUrl  @"http://file-cdn.datafans.net/avatar/1.jpeg_%dx%d.jpeg"
#import "MessageListViewController.h"
#import "ViewController.h"
#import "UserViewController.h"

@interface ViewController ()
{
    NSMutableArray *_listArr;
    //    NSMutableArray *_user_info;
    
    NSMutableArray *_date_tmArr;
    NSMutableArray *_head_imgArr;
    NSMutableArray *_nickNameArr;
    NSMutableArray *_pic_urlArr;
    NSMutableArray *_positionArr;
    NSMutableArray *_wordsArr;
    NSMutableArray *_video_urlArr;
    NSMutableArray *_good_userArr;
    NSMutableArray *_goodArr;
    NSMutableArray *_idArr;
    NSMutableArray *_comment_group;
    NSMutableArray *_xidArr;
    NSString *_talk_id;
    //点赞Xid
    NSString *_goodXid;
    //点赞昵称
    NSString *_goodNickName;
    //翻页
    NSInteger  _pageNumber;
    NSString *_head_img;
    //昵称
    NSString *_nickname;
    
    UIView *_bgView;
    
}

@end

@implementation ViewController


- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarItem.badgeValue = nil;
    self.navigationController.navigationBarHidden =NO;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self downLoadData:1 isLoadMore:NO];
    _pageNumber = 1;
}

-(void)refresh{
    //下来刷新
   
//    [self downLoadData:1 isLoadMore:YES];
//    [self.tableView reloadData];
    [self endRefresh];
}

-(void)createNewMessageView{
    //接数据后 判断是否有值   进行隐藏  后者出现
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(120, 200, 120, 30)];
    _bgView.layer.cornerRadius = 8;
    _bgView.userInteractionEnabled = YES;
    _bgView.layer.masksToBounds = YES;
    //点击手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(setBadgeValueNum)];
    [_bgView addGestureRecognizer:tap];
    _bgView.layer.borderWidth = 1;
    _bgView.layer.borderColor = [[UIColor colorWithRed:0.52 green:0.09 blue:0.07 alpha:1] CGColor];
    _bgView.backgroundColor = UIColorFromRGB(229, 233, 232);
    [self.view addSubview:_bgView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 3, 25, 25)];
    imageView.image =[UIImage imageNamed:@"头像194x194.png"];
    [_bgView addSubview:imageView];
    //新消息
    UIButton *messageBtn =[HHControl createButtonWithFrame:CGRectMake(CGRectGetMaxY(imageView.frame) + 5, 3, 100, 25) backGruondImageName:nil Target:self Action:@selector(setBadgeValueNum) Title:@"你有新消息了"];
    messageBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_bgView addSubview:messageBtn];
    
}
- (void)setBadgeValueNum{
    MessageListViewController *messageListVC = [[MessageListViewController alloc] init];
    [self.navigationController pushViewController:messageListVC animated:YES];
    
}

- (void)downLoadData:(NSInteger)page isLoadMore:(BOOL)isLoadMore{
    
    //    _user_info = [NSMutableArray array];
    _listArr = [NSMutableArray array];
    _date_tmArr = [NSMutableArray array];
    _head_imgArr = [NSMutableArray array];
    _nickNameArr = [NSMutableArray array];
    _pic_urlArr = [NSMutableArray array];
    _positionArr = [NSMutableArray array];
    _wordsArr = [NSMutableArray array];
    _video_urlArr = [NSMutableArray array];
    _good_userArr = [NSMutableArray array];
    _goodArr = [NSMutableArray array];
    _idArr = [NSMutableArray array];
    _comment_group = [NSMutableArray array];
    _xidArr = [NSMutableArray array];
    //  网络请求
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/my_friend_circle";
    
    AFHTTPRequestOperationManager *mgr =[AFHTTPRequestOperationManager manager];
    NSDictionary *dict = @{@"appkey":APPKEY,
                           @"backtype":BACKTYPE,
                           @"xid":XID,
                           @"user_id":USER_ID,
                           @"user_type":USER_TYPE,
                           @"page":[NSString stringWithFormat:@"%ld",(long)page],
                           };
    
    // 服务器返回的数据格式
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer]; // 二进制数据
    [mgr POST:urlStr parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         NSLog(@"%@",dict);
         
         if([[NSString stringWithFormat:@"%@",dict[@"code"]] isEqualToString:@"1"] ){
             //头视图信息
             //头像
             if ([dict[@"data"][@"user_info"][@"head_img_type"] isEqualToString:@"1"]) {
                 //头像
                 _head_img =[NSString stringWithFormat:@"%@",dict[@"data"][@"user_info"][@"head_img"]];
                 //昵称
                 _nickname = dict[@"data"][@"user_info"][@"nickname"];

                 
             }else{
                 //头像
                 _head_img =[NSString stringWithFormat:@"%@%@",picURL,dict[@"data"][@"user_info"][@"head_img"]];
                 //昵称
                 _nickname =dict[@"data"][@"user_info"][@"nickname"];

             }
             
             //判断是否有新消息
             NSString *circle_noread = [NSString stringWithFormat:@"%@",dict[@"data"][@"user_info"][@"circle_noread"]];
             
             if ([circle_noread isEqualToString:@"1"]) {
                 
                  [self createNewMessageView];
            
             }else{
                 
                 [_bgView removeFromSuperview];
             }
             
             //朋友圈信息 添加数据 待完善
             _listArr = dict[@"data"][@"list"];
             
             
             
             if (_listArr.count > 0) {
                 for (int i=0; i<_listArr.count; i++) {
                     //时间
                     [_date_tmArr  addObject:[_listArr[i] objectForKey:@"date_tm"]];
                     
                     //Xid
                     [_xidArr addObject:[_listArr[i] objectForKey:@"xid"]];
                     //头像
                     [_head_imgArr addObject: [NSString stringWithFormat:@"%@%@",picURL,[_listArr[i] objectForKey:@"head_img"]]];
                     //昵称
                     [_nickNameArr addObject:[_listArr[i] objectForKey:@"nickname"]];
                     //图片
                     [_pic_urlArr addObject:[_listArr[i] objectForKey:@"pic_url"]];
                     //位置
                     [_positionArr addObject:[_listArr[i] objectForKey:@"position"]];
                     //内容
                     [_wordsArr addObject:[_listArr[i] objectForKey:@"words"]];
                     //视频
                     [_video_urlArr addObject:[_listArr[i] objectForKey:@"video_url"]];
                     //id
                     [_idArr addObject:[_listArr[i] objectForKey:@"id"]];
                     //点赞人
                     [_good_userArr addObject:[_listArr[i] objectForKey:@"good_user"]];
                     //点赞
                     [_goodArr addObject:[_listArr[i] objectForKey:@"good"]];
                     //评论信息
                     [_comment_group addObject:[_listArr[i] objectForKey:@"comment_group"]];

                     NSLog(@"_comment_group评论的信息 :%@",_comment_group);
                 }
             }
         }else{
             [SVProgressHUD showErrorWithStatus:@"没有更多数据啦"];
             [self endLoadMore];
         }
         //头视图赋值
         [self setHeader];
         //朋友圈状态赋值
         [self initMoreData];
         
         //发送到服务器请求头部信息
     } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
         
         [SVProgressHUD showErrorWithStatus:@"网络不通，请检查网络！"];
         
     }];
    
}


-(void)loadMore{
    _pageNumber ++;
    [self downLoadData:_pageNumber isLoadMore:YES];
}


//评论的消息
-(void)onCommentCreate:(long long)commentId text:(NSString *)text itemId:(long long) itemId{
    
    if (![[NSString stringWithFormat:@"%lld",commentId] isEqualToString:@"0"]) {
        
        NSString *urlStr = @"http://www.xingxingedu.cn/Global/my_circle_comment";
        AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
        
        NSDictionary *dict = @{@"appkey":APPKEY,
                               @"backtype":BACKTYPE,
                               @"xid":XID,
                               @"user_id":USER_ID,
                               @"user_type":USER_TYPE,
                               @"com_type":@"2",
                               @"talk_id":[NSString stringWithFormat:@"%lld",itemId],
                               @"con":text,
                               @"to_who_xid":[NSString stringWithFormat:@"%lld",commentId],
                               };
        
        // 服务器返回的数据格式
        mgr.responseSerializer = [AFHTTPResponseSerializer serializer]; // 二进制数据
        [mgr POST:urlStr parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
//             NSLog(@"======commentInputTextViewcommentInputTextView=============%@",dict);
          
             if([[NSString stringWithFormat:@"%@",dict[@"code"]] isEqualToString:@"1"] ){
                 
                 NSDictionary *dictK =dict[@"data"];
                 
                 NSString *commentCommentId =[NSString stringWithFormat:@"%@",dictK[@"id"]];
                 NSString *commentXid = [NSString stringWithFormat:@"%@",dictK[@"xid"]];
                 NSString *commentNickName =[NSString stringWithFormat:@"%@",dictK[@"nickname"]];
                 NSString *commentTo_who_xid = [NSString stringWithFormat:@"%@",dictK[@"to_who_xid"]];
                 NSString *commentTo_who_nickname =[NSString stringWithFormat:@"%@",dictK[@"to_who_nickname"]];

                 
                 DFLineCommentItem *commentItem = [[DFLineCommentItem alloc] init];
                 commentItem.commentId = [commentCommentId integerValue];
                 commentItem.userId = [commentXid integerValue];
                 commentItem.userNick = commentNickName;
                 commentItem.text = text;
                 commentItem.replyUserId = [commentTo_who_xid integerValue];
                 commentItem.replyUserNick = commentTo_who_nickname;
                 [self addCommentItem:commentItem itemId:itemId replyCommentId:commentId];
             }
             [SVProgressHUD showSuccessWithStatus:@"回复成功"];
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"请求失败:%@",error);
             [SVProgressHUD showErrorWithStatus:@"网络不通，请检查网络！"];
             
         }];
        
    }else{
        
        NSString *urlStr = @"http://www.xingxingedu.cn/Global/my_circle_comment";
        AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
        
        NSDictionary *dict = @{@"appkey":APPKEY,
                               @"backtype":BACKTYPE,
                               @"xid":XID,
                               @"user_id":USER_ID,
                               @"user_type":USER_TYPE,
                               @"com_type":@"1",
                               @"talk_id":[NSString stringWithFormat:@"%lld",itemId],
                               @"con":text,
                               };
        
        // 服务器返回的数据格式
        mgr.responseSerializer = [AFHTTPResponseSerializer serializer]; // 二进制数据
        [mgr POST:urlStr parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
             
//             NSLog(@"==========DFLineCommentItemDFLineCommentItem=============>%@",dict);
             if([[NSString stringWithFormat:@"%@",dict[@"code"]] isEqualToString:@"1"] ){
                 
                 NSDictionary *dictK =dict[@"data"];
                 NSString *commentXid = [NSString stringWithFormat:@"%@",dictK[@"xid"]];
                 NSString *commentNickName =[NSString stringWithFormat:@"%@",dictK[@"nickname"]];
                 NSString *commentCommentId =[NSString stringWithFormat:@"%@",dictK[@"id"]];
                 
                 DFLineCommentItem *commentItem = [[DFLineCommentItem alloc] init];
                 commentItem.commentId = [commentCommentId integerValue];
                 commentItem.userId = [commentXid integerValue];
                 commentItem.userNick = commentNickName;
                 commentItem.text = text;
                 [self addCommentItem:commentItem itemId:itemId replyCommentId:commentId];
             }
             
             [SVProgressHUD showSuccessWithStatus:@"评论成功"];
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"请求失败:%@",error);
             [SVProgressHUD showErrorWithStatus:@"网络不通，请检查网络！"];
             
         }];
        
    }
    
}

//点赞
-(void)onLike:(long long)itemId{
    
    //点赞网络请求
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/my_circle_good";
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *dict = @{@"appkey":APPKEY,
                           @"backtype":BACKTYPE,
                           @"xid":XID,
                           @"user_id":USER_ID,
                           @"user_type":USER_TYPE,
                           @"talk_id":[NSString stringWithFormat:@"%lld",itemId],
                           };
    // 服务器返回的数据格式
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer]; // 二进制数据
    [mgr POST:urlStr parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         
         if([[NSString stringWithFormat:@"%@",dict[@"code"]] isEqualToString:@"1"] ){
             
             NSDictionary *dictK =dict[@"data"];
             
             _goodXid = [NSString stringWithFormat:@"%@",dictK[@"xid"]];
             _goodNickName =[NSString stringWithFormat:@"%@",dictK[@"nickname"]];
             //点赞model赋值
             DFLineLikeItem *likeItem = [[DFLineLikeItem alloc] init];
             likeItem.userId = [_goodXid integerValue];
             likeItem.userNick = _goodNickName;
             
             [self addLikeItem:likeItem itemId:itemId isSelet:NO];
             
             [SVProgressHUD showSuccessWithStatus:@"点赞成功"];
             
         }else{
             
             NSDictionary *dictK =dict[@"data"];
             _goodXid = [NSString stringWithFormat:@"%@",dictK[@"xid"]];
             _goodNickName =[NSString stringWithFormat:@"%@",dictK[@"nickname"]];
             //点赞model赋值
             DFLineLikeItem *likeItem = [[DFLineLikeItem alloc] init];
             likeItem.userId = [_goodXid integerValue];
             likeItem.userNick = _goodNickName;
             [self addLikeItem:likeItem itemId:itemId isSelet:YES];
             
             [SVProgressHUD showSuccessWithStatus:@"取消点赞"];
         }
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"请求失败:%@",error);
         [SVProgressHUD showErrorWithStatus:@"网络不通，请检查网络！"];
     }];
}

//点击左边头像 或者 点击评论和赞的用户昵称
-(void)onClickUser:(NSUInteger)userId{
    
    UserViewController *controller = [[UserViewController alloc] init];
    
    controller.xidStr = [NSString stringWithFormat:@"%ld",(unsigned long)userId];
    
    [self.navigationController pushViewController:controller animated:YES];
}

//点击头视图上的小头像 传自己的xid
-(void)onClickHeaderUserAvatar{
    [self onClickUser:[XID integerValue]];
}

//头试图
-(void) setHeader{
    //大头像背景
    [self setCover:_head_img];
    //签名
    [self setUserSign:@""];
    //头像
    [self setUserAvatar:_head_img];
    //昵称
    [self setUserNick:_nickname];
}

//加载更多   //加载网络数据
- (void)initMoreData{
    
    //小视频加载=========小视频有值
    for (int i=0; i<_listArr.count; i++) {
        if (![_video_urlArr[i] isEqualToString:@""]) {
            
            DFVideoLineItem *videoItem = [[DFVideoLineItem alloc] init];
            videoItem.itemId = [_idArr[i] integerValue]; //随便设置一个 待服务器生成
            videoItem.userId = [_xidArr[i] integerValue];
            videoItem.ts =[_date_tmArr[i] integerValue] *1000;
            videoItem.userAvatar = _head_imgArr[i];
            videoItem.userNick = _nickNameArr[i];
            videoItem.text = _wordsArr[i]; //这里需要present一个界面 用户填入文字后再发送 场景和发图片一样
            videoItem.location = _positionArr[i];
            
            //            videoItem.localVideoPath = videoPath;
            //            videoItem.videoUrl = [NSString stringWithFormat:@"%@%@",picURL,_video_urlArr[i]]; //网络路径
            //            videoItem.thumbUrl = [NSString stringWithFormat:@"%@%@",picURL,_video_urlArr[i]];
            videoItem.thumbImage =[UIImage imageNamed:@"placeHodle"];
            //screenShot; //如果thumbImage存在 优先使用thumbImag
            
            //加载定位位置
            videoItem.location = _positionArr[i];
            //加载发布时间
            videoItem.ts =[_date_tmArr[i] integerValue] *1000;
            
            //加载点赞  如果点赞有值
            //            if ( ![_goodArr[i] isEqualToString:@""]) {
            if ( [_good_userArr[i]  count] > 0 ) {
                for (int g = 0; g < [_good_userArr[i] count]; g++) {
                    DFLineLikeItem *likeItem1_1 = [[DFLineLikeItem alloc] init];
                    likeItem1_1.userId = [[_good_userArr[i][g] objectForKey:@"xid"] integerValue];
                    likeItem1_1.userNick = [_good_userArr[i][g] objectForKey:@"nickname"];
                    [videoItem.likes addObject:likeItem1_1];
                }
            }
            //  加载评论  如果评论有值
            if ( [_comment_group[i]  count] > 0 ) {
                
                for (int g=0; g<[_comment_group[i] count]; g++) {
                    
                    if ([[_comment_group[i][g] objectForKey:@"com_type"] isEqualToString:@"1"]) {
                        DFLineCommentItem *commentItem1_1 = [[DFLineCommentItem alloc] init];
                        commentItem1_1.commentId = [[_comment_group[i][g] objectForKey:@"id"] integerValue];
                        commentItem1_1.userId = [[_comment_group[i][g] objectForKey:@"xid"] integerValue];
                        commentItem1_1.userNick = [_comment_group[i][g] objectForKey:@"nickname"];
                        commentItem1_1.text = [_comment_group[i][g] objectForKey:@"con"];
                        [videoItem.comments addObject:commentItem1_1];
                    }
                    else if ([[_comment_group[i][g] objectForKey:@"com_type"] isEqualToString:@"2"]) {
                        
                        DFLineCommentItem *commentItem1_2 = [[DFLineCommentItem alloc] init];
                        commentItem1_2.commentId = [[_comment_group[i][g] objectForKey:@"id"] integerValue];
                        commentItem1_2.userId = [[_comment_group[i][g] objectForKey:@"xid"] integerValue];
                        commentItem1_2.userNick = [_comment_group[i][g] objectForKey:@"nickname"];
                        commentItem1_2.text = [_comment_group[i][g] objectForKey:@"con"];
                        commentItem1_2.replyUserId = [[_comment_group[i][g] objectForKey:@"to_who_xid"] integerValue];
                        commentItem1_2.replyUserNick = [_comment_group[i][g] objectForKey:@"to_who_nickname"];
                        [videoItem.comments addObject:commentItem1_2];
                    }
                }
            }
            [self addItemTop:videoItem];
            
            
        }else{
            //图文加载
            DFTextImageLineItem *textImage = [[DFTextImageLineItem alloc] init];
            textImage.itemId = [_idArr[i] integerValue];
            textImage.userId = [_xidArr[i] integerValue];
            textImage.userAvatar = _head_imgArr[i];
            textImage.userNick = _nickNameArr[i];
            textImage.title = @"";
            textImage.text = _wordsArr[i];
            
            //如果图文加载 图片有值
            
            if (![_pic_urlArr[i] isEqualToString:@""]) {
                NSMutableArray *srcImages = [NSMutableArray array];
                NSMutableArray *thumbImages = [NSMutableArray array];
                for (int  j= 0; j<[_pic_urlArr[i] componentsSeparatedByString:@","].count; j++) {
                    [srcImages addObject:[NSString stringWithFormat:@"%@%@",picURL,[_pic_urlArr[i] componentsSeparatedByString:@","][j]]];
                    [thumbImages addObject:[NSString stringWithFormat:@"%@%@",picURL,[_pic_urlArr[i] componentsSeparatedByString:@","][j]]];
                    
                }
                textImage.width = kWidth;
                textImage.height = 360;
                textImage.srcImages = srcImages;
                textImage.thumbImages = thumbImages;
            }
            
            //加载定位位置
            textImage.location = _positionArr[i];
            
            //加载发布时间
            textImage.ts =[_date_tmArr[i] integerValue] *1000;
            
            //加载图文的点赞
            //            if ( ![_goodArr[i] isEqualToString:@""]) {
            if ( [_good_userArr[i]  count] > 0 ) {
                for (int g=0; g<[_good_userArr[i] count]; g++) {
                    
                    DFLineLikeItem *likeItem1_1 = [[DFLineLikeItem alloc] init];
                    likeItem1_1.userId = [[_good_userArr[i][g] objectForKey:@"xid"] integerValue];
                    likeItem1_1.userNick = [_good_userArr[i][g] objectForKey:@"nickname"];
                    [textImage.likes addObject:likeItem1_1];
                }
            }
            //  加载评论  如果评论有值
            if ( [_comment_group[i]  count] > 0 ) {
                for (int g=0; g<[_comment_group[i] count]; g++) {
                    if ([[_comment_group[i][g] objectForKey:@"com_type"] isEqualToString:@"1"]) {
                        DFLineCommentItem *commentItem1_1 = [[DFLineCommentItem alloc] init];
                        commentItem1_1.commentId = [[_comment_group[i][g] objectForKey:@"id"] integerValue];
                        commentItem1_1.userId = [[_comment_group[i][g] objectForKey:@"xid"] integerValue];
                        commentItem1_1.userNick = [_comment_group[i][g] objectForKey:@"nickname"];
                        commentItem1_1.text = [_comment_group[i][g] objectForKey:@"con"];
                        [textImage.comments addObject:commentItem1_1];
                    }
                    else if ([[_comment_group[i][g] objectForKey:@"com_type"] isEqualToString:@"2"]) {
                        
                        DFLineCommentItem *commentItem1_2 = [[DFLineCommentItem alloc] init];
                        commentItem1_2.commentId = [[_comment_group[i][g] objectForKey:@"id"] integerValue];
                        commentItem1_2.userId = [[_comment_group[i][g] objectForKey:@"xid"] integerValue];
                        commentItem1_2.userNick = [_comment_group[i][g] objectForKey:@"nickname"];
                        commentItem1_2.text = [_comment_group[i][g] objectForKey:@"con"];
                        commentItem1_2.replyUserId = [[_comment_group[i][g] objectForKey:@"to_who_xid"] integerValue];
                        commentItem1_2.replyUserNick = [_comment_group[i][g] objectForKey:@"to_who_nickname"];
                        [textImage.comments addObject:commentItem1_2];
                    }
                }
            }
            [self addItem:textImage];
        }
        
    }
    [self endLoadMore];
}

//选择照片后得到数据
-(void)onSendTextImage:(NSString *)text images:(NSArray *)images
{
    
    NSMutableArray *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"USER_INFO"];
    
    DFTextImageLineItem *textImageItem = [[DFTextImageLineItem alloc] init];
    textImageItem.itemId = [userInfo[0] intValue]; //随便设置一个 待服务器生成
    textImageItem.userId = [XID integerValue];
    textImageItem.userAvatar = _head_img;
    textImageItem.userNick = _nickname;
    textImageItem.title = @"发表了";
    textImageItem.text = text;
    textImageItem.ts = [[NSDate date] timeIntervalSince1970]*1000;
    NSMutableArray *srcImages = [NSMutableArray array];
    textImageItem.srcImages = srcImages; //大图 可以是本地路径 也可以是网络地址 会自动判断
    NSMutableArray *thumbImages = [NSMutableArray array];
    textImageItem.thumbImages = thumbImages; //小图 可以是本地路径 也可以是网络地址 会自动判断
    for (id img in images) {
        [srcImages addObject:img];
        [thumbImages addObject:img];
    }
    textImageItem.location = userInfo[1];
    [self addItemTop:textImageItem];
    //接着上传图片 和 请求服务器接口
    //请求完成之后 刷新整个界面
    
}


//发送视频 目前没有实现填写文字
-(void)onSendVideo:(NSString *)text videoPath:(NSString *)videoPath screenShot:(UIImage *)screenShot{
    DFVideoLineItem *videoItem = [[DFVideoLineItem alloc] init];
    videoItem.itemId = 10000000; //随便设置一个 待服务器生成
    videoItem.userId = [XID integerValue];
    videoItem.userAvatar = _head_img;
    videoItem.userNick = _nickname;
    videoItem.title = @"发表了";
    videoItem.text = text; //这里需要present一个界面 用户填入文字后再发送 场景和发图片一样
    videoItem.location = @"上海市浦东巨峰路";
    videoItem.localVideoPath = videoPath;
    //    videoItem.videoUrl = @"http://data.vod.itc.cn/?prod=app&new=/194/216/JBUeCIHV4s394vYk3nbgt2.mp4"; //网络路径
    //    videoItem.thumbUrl = @"http://data.vod.itc.cn/?prod=app&new=/194/216/JBUeCIHV4s394vYk3nbgt2.mp4";
    videoItem.thumbImage = screenShot; //如果thumbImage存在 优先使用thumbImage
    
    [self addItemTop:videoItem];
    //接着上传图片 和 请求服务器接口
    //请求完成之后 刷新整个界面
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
