//
//  MessageListDetailController.m
//  XingXingEdu
//
//  Created by mac on 16/6/7.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "MessageListDetailController.h"
#import "DFImageUnitView.h"
#import "YDCommentInputView.h"
#import "MessageListDetailViewCell.h"
#import "DFLineCommentItem.h"
#import "WZYTool.h"
#define Kmarg 10.0f
#define KLabelH 25.0f
#define Padding 2

/**
 *  消息类型
 */
typedef NS_OPTIONS(NSInteger, Comments){
    /**
     *  评论消息
     */
    CommentsMessage = 0,
    /**
     *  回复消息
     */
    ReplyCommentsMessage
};


@interface MessageListDetailController ()<YDCommentInputViewDelegate,UITableViewDelegate,UITableViewDataSource>{
    UIScrollView *_bgScrollView;
    UIView *_detailView;
    UIImageView *_headImage;//头像
    UILabel *_nameLabel;//名字
    UITextView *_detailSayView;//内容
    UIImageView *_picView;//照片
    UILabel *_timeLabel;//时间戳
    UIImageView *_detailImage;//详情评论
    
    NSString *_commentHead_img;
    NSMutableArray *_baseInfo;
    
    NSMutableArray *_commentListArr;
    NSMutableArray *_to_who_nicknameArr;
    NSMutableArray *_talk_idArr;
    NSMutableArray *_nicknameArr;
    NSMutableArray *_conArr;
    NSMutableArray *_to_who_xidArr;
    NSMutableArray *_com_typeArr;
    NSMutableArray *_xidArr;
    NSMutableArray *_idArr;
    
    
    
}
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelReplyComments;
@property (strong, nonatomic) YDCommentInputView *commentInputView;

@property (strong, nonatomic)  NSString *name;/*用户*/
@property (assign, nonatomic) int message;/*消息类型*/

@end

@implementation MessageListDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets=YES;
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.view.backgroundColor=[UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    
   self.title = @"消息详情";
    
    [self createDetailMessageNetRequest];
    
}

-(void) initTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(_detailView.frame), kWidth - 60, _commentListArr.count * 70) style:UITableViewStylePlain];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled = NO;
    _tableView.separatorInset = UIEdgeInsetsZero;
    [_bgScrollView addSubview:_tableView];
}

//键盘
- (YDCommentInputView *)commentInputView
{
    if (!_commentInputView) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"YDCommentInputView" owner:self options:nil];
        _commentInputView = [nib objectAtIndex:0];
        _commentInputView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, _commentInputView.frame.size.height);
        _commentInputView.delegate = self;
    }
    return _commentInputView;
}


-(void)createDetailMessage {
    //背景
    _bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kWidth,kHeight *2 )];
    _bgScrollView.backgroundColor = [UIColor whiteColor];
    _bgScrollView.pagingEnabled = NO;
    _bgScrollView.showsHorizontalScrollIndicator = YES;
    _bgScrollView.showsVerticalScrollIndicator  = YES;
    _bgScrollView.alwaysBounceVertical = YES;
    
    [self.view addSubview:_bgScrollView];
//
    //详情背景
    _detailView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 150)];
    _detailView.backgroundColor = [UIColor whiteColor];
    [_bgScrollView addSubview:_detailView];
    
    //头像
    _headImage = [[UIImageView alloc] initWithFrame:CGRectMake(Kmarg , Kmarg , 40, 40)];
    [_headImage sd_setImageWithURL:[NSURL URLWithString:_baseInfo[8]] placeholderImage:[UIImage imageNamed:@"头像194x194.png"]];
    [_detailView addSubview:_headImage];
    
    //名字
    _nameLabel = [HHControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(_headImage.frame) + Kmarg, Kmarg, kWidth - 20, KLabelH) Font:16 Text:_baseInfo[9]];
     _nameLabel.textColor = UIColorFromRGB(74, 160, 239);
    [_detailView addSubview:_nameLabel];
    
    //内容
    _detailSayView = [[UITextView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_headImage.frame) + Kmarg, CGRectGetMaxY(_nameLabel.frame) + Kmarg, kWidth - 80, 120)];
    _detailSayView.text = _baseInfo[7];
    _detailSayView.font = [UIFont systemFontOfSize:12];
    _detailSayView.userInteractionEnabled = NO;
    [_detailSayView flashScrollIndicators];   // 闪动滚动条
    //自动适应行高
    static CGFloat maxHeight = 130.0f;
    CGRect frame = _detailSayView.frame;
    CGSize constraintSize = CGSizeMake(frame.size.width, MAXFLOAT);
    CGSize size = [_detailSayView sizeThatFits:constraintSize];
    if (size.height >= maxHeight){
        size.height = maxHeight;
        _detailSayView.scrollEnabled = YES;   // 允许滚动
    }
    else{
        _detailSayView.scrollEnabled = NO;    // 不允许滚动，当textview的大小足以容纳它的text的时候，需要设置scrollEnabed为NO，否则会出现光标乱滚动的情况
    }
    _detailSayView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, size.height);
    [_detailView addSubview:_detailSayView];
    
    //图片 待完善
//    for (int i = 0; i < 9; i ++) {
    
        _picView = [[UIImageView alloc] initWithFrame:CGRectMake( CGRectGetMaxX(_headImage.frame) + Kmarg, CGRectGetMaxY(_detailSayView.frame), kWidth - 100, 120)];
        [_picView sd_setImageWithURL:[NSURL URLWithString:_baseInfo[3]] placeholderImage:nil];
        [_detailView addSubview:_picView];
        
//    }

    //时间戳
    NSString *timeStr = [WZYTool dateStringFromNumberTimer:_baseInfo[6]];
    _timeLabel = [HHControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(_headImage.frame) + Kmarg,CGRectGetMaxY(_detailSayView.frame) + Kmarg, 120, KLabelH) Font:14 Text:timeStr];
    _timeLabel.textColor = UIColorFromRGB(74, 160, 239);
    [_detailView addSubview:_timeLabel];
    
    //评论
    _detailImage = [[UIImageView alloc] initWithFrame:CGRectMake(kWidth - Kmarg*6 , CGRectGetMaxY(_detailSayView.frame) + Kmarg, 40, 30)];
    _detailImage.image = [UIImage imageNamed:@"AlbumOperateMoreHL@2x.png"];
    _detailImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onComment)];
    [_detailImage addGestureRecognizer:tap];
    [_detailView addSubview:_detailImage];
    
    //重写详情背景的frame
    CGFloat detailMaxH =  CGRectGetMaxY(_timeLabel.frame) + 10;
    _detailView.frame = CGRectMake(0, 0, kWidth, detailMaxH);
    
}
-(void)createDetailMessageNetRequest{
    
    _baseInfo = [NSMutableArray array];
    _commentListArr = [NSMutableArray array];
    _to_who_nicknameArr = [NSMutableArray array];
    _talk_idArr = [NSMutableArray array];
    _nicknameArr = [NSMutableArray array];
    _conArr = [NSMutableArray array];
    _to_who_xidArr = [NSMutableArray array];
    _com_typeArr = [NSMutableArray array];
    _xidArr = [NSMutableArray array];
    _idArr = [NSMutableArray array];
    
//    NSLog(@"==============_talkId_talkId_talkId================%@",_talkId);
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/one_shuoshuo";
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    NSDictionary *dict = @{@"appkey":APPKEY,
                           @"backtype":BACKTYPE,
                           @"xid":XID,
                           @"user_id":USER_ID,
                           @"user_type":USER_TYPE,
                           @"talk_id":_talkId,
                           };
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer]; // 二进制数据
    [mgr POST:urlStr parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
//         NSLog(@"===============createNewMessageNetRequest=====================%@",dict);
         
         if([[NSString stringWithFormat:@"%@",dict[@"code"]] isEqualToString:@"1"] ){
             
             NSString *commentPosition = [NSString stringWithFormat:@"%@",dict[@"data"][@"position"]];
             NSString *commentId =[NSString stringWithFormat:@"%@",dict[@"data"][@"id"]];
             NSString *commentFile_type = [NSString stringWithFormat:@"%@",dict[@"data"][@"file_type"]];
             NSString *commentPic_url =[NSString stringWithFormat:@"%@",dict[@"data"][@"pic_url"]];
             NSString *commentXid =[NSString stringWithFormat:@"%@",dict[@"data"][@"xid"]];
             NSString *commentDate_tm = [NSString stringWithFormat:@"%@",dict[@"data"][@"date_tm"]];
             NSString *commentWords =[NSString stringWithFormat:@"%@",dict[@"data"][@"words"]];
             
             
             if ([dict[@"data"][@"head_img_type"] isEqualToString:@"1"]) {
                 _commentHead_img =[NSString stringWithFormat:@"%@",dict[@"data"][@"head_img"]];
             }else{
                 _commentHead_img =[NSString stringWithFormat:@"%@%@",picURL,dict[@"data"][@"head_img"]];
             }
             
             NSString *commentNickname =[NSString stringWithFormat:@"%@",dict[@"data"][@"nickname"]];
             
             _baseInfo = [[NSMutableArray alloc] initWithObjects:commentPosition,commentId,commentFile_type,commentPic_url,commentXid,commentXid,commentDate_tm,commentWords,_commentHead_img,commentNickname, nil];
             
             _commentListArr = dict[@"data"][@"comment_group"];
             if (_commentListArr.count > 0) {
                 for (int i=0; i<_commentListArr.count; i++) {
                     
                     [_talk_idArr addObject:[_commentListArr[i] objectForKey:@"talk_id"]];
                     [_nicknameArr addObject:[_commentListArr[i] objectForKey:@"nickname"]];
                     [_conArr addObject:[_commentListArr[i] objectForKey:@"con"]];
                     [_com_typeArr addObject:[_commentListArr[i] objectForKey:@"com_type"]];
                     [_xidArr addObject:[_commentListArr[i] objectForKey:@"xid"]];
                     [_idArr addObject:[_commentListArr[i] objectForKey:@"id"]];
                     [_to_who_xidArr addObject:[_commentListArr[i] objectForKey:@"to_who_xid"]];
                     [_to_who_nicknameArr  addObject:[_commentListArr[i] objectForKey:@"to_who_nickname"]];
                 }
             }
             [self createDetailMessage];
             
             [self initTableView];
             
             CGFloat bgScrollMaxH =  CGRectGetMaxY(_tableView.frame) + 800;
             _bgScrollView.contentSize = CGSizeMake(0, bgScrollMaxH);
         }
         [_tableView reloadData];
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"请求失败:%@",error);
         [SVProgressHUD showErrorWithStatus:@"网络不通，请检查网络！"];
         
     }];
}


#pragma mark - TableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _commentListArr.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageListDetailViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"messageListDetailViewCell"];
    if(cell==nil){
        cell=[[MessageListDetailViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"messageListDetailViewCell"];
    }
    UIImageView *commentView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 22, 22)];
    commentView.image = [UIImage imageNamed:@"AlbumOperateMore"];
    [cell.contentView addSubview:commentView];
    
    NSArray  *to_who_nicknameArr = _to_who_nicknameArr;
    //    NSArray  *talk_idArr = _talk_idArr;
    NSArray  *nicknameArr = _nicknameArr;
    NSArray  *conArr = _conArr;
    //    NSArray  *to_who_xidArr = _to_who_xidArr;
    NSArray  *com_typeArr = _com_typeArr;
    //    NSArray  *xidArr = _xidArr;
    //    NSArray  *idArr = _idArr;
    
    
    cell.contentView.backgroundColor = UIColorFromRGB(229, 232, 233);
    if ([com_typeArr[indexPath.row] isEqualToString:@"1"]) {
        
        UILabel *nickName = [HHControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(commentView.frame) + Kmarg, 5, 280, 25) Font:14 Text:[NSString stringWithFormat:@"%@:",nicknameArr[indexPath.row]]];
        nickName.tag = 10000;
         [cell.contentView addSubview:nickName];
        
        UITextView *conTextView = [[UITextView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(commentView.frame) + Kmarg, CGRectGetMaxY(nickName.frame), 280, 40)];
        conTextView.text = conArr[indexPath.row];
         conTextView.backgroundColor = [UIColor clearColor];
        conTextView.userInteractionEnabled = NO;
        conTextView.scrollEnabled = NO;
        conTextView.font = [UIFont systemFontOfSize:12];
        //自动适应行高
        static CGFloat maxHeight = 130.0f;
        CGRect frame = conTextView.frame;
        CGSize constraintSize = CGSizeMake(frame.size.width, MAXFLOAT);
        CGSize size = [conTextView sizeThatFits:constraintSize];
        if (size.height >= maxHeight){
            size.height = maxHeight;
            conTextView.scrollEnabled = YES;   // 允许滚动
        }else{
            conTextView.scrollEnabled = NO;    // 不允许滚动，当textview的大小足以容纳它的text的时候，需要设置scrollEnabed为NO，否则会出现光标乱滚动的情况
        }
        conTextView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, size.height);
        [cell.contentView addSubview:conTextView];
        
    }else{
        UILabel *nickName = [HHControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(commentView.frame) + Kmarg, 5, 280, 25) Font:14 Text:[NSString stringWithFormat:@"%@回复%@:", nicknameArr[indexPath.row],to_who_nicknameArr[indexPath.row]]];
        [cell.contentView addSubview:nickName];
        
        UITextView *conTextView = [[UITextView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(commentView.frame) + Kmarg, CGRectGetMaxY(nickName.frame), 280, 40)];
        
        conTextView.text = conArr[indexPath.row];
        conTextView.backgroundColor = [UIColor clearColor];
        conTextView.userInteractionEnabled = NO;
        conTextView.scrollEnabled = NO;
        conTextView.font = [UIFont systemFontOfSize:12];
        //自动适应行高
        static CGFloat maxHeight = 130.0f;
        CGRect frame = conTextView.frame;
        CGSize constraintSize = CGSizeMake(frame.size.width, MAXFLOAT);
        CGSize size = [conTextView sizeThatFits:constraintSize];
        if (size.height >= maxHeight){
            size.height = maxHeight;
            conTextView.scrollEnabled = YES;   // 允许滚动
        }else{
            conTextView.scrollEnabled = NO;    // 不允许滚动，当textview的大小足以容纳它的text的时候，需要设置scrollEnabed为NO，否则会出现光标乱滚动的情况
        }
        conTextView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, size.height);
        [cell.contentView addSubview:conTextView];
    }
    
    
    
    return cell;
}

#pragma mark - TabelViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UILabel *replyUserNick = [_tableView viewWithTag:10000];
    //回复评论
    self.message = ReplyCommentsMessage;
    self.commentInputView.commentInputTextField.placeholder = [NSString stringWithFormat:@"回复%@",replyUserNick.text];
    [self.commentInputView showInputView];
    
}

//(long)评论
-(void)onComment{
    self.message = CommentsMessage;
    [self.commentInputView showInputView];
}


#pragma mark - YDCommentInputViewDelegate
- (void)commentInputView:(YDCommentInputView *)anInputView onSendText:(NSString *)aText
{
    if (self.message == CommentsMessage) {
        NSString *urlStr = @"http://www.xingxingedu.cn/Global/my_circle_comment";
        AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
        
        NSDictionary *dict = @{@"appkey":APPKEY,
                               @"backtype":BACKTYPE,
                               @"xid":XID,
                               @"user_id":USER_ID,
                               @"user_type":USER_TYPE,
                               @"com_type":@"1",
                               @"talk_id":_talkId,
                               @"con":aText,
                               };
        // 服务器返回的数据格式
        mgr.responseSerializer = [AFHTTPResponseSerializer serializer]; // 二进制数据
        [mgr POST:urlStr parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             
             
             NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
//               NSLog(@"======commentInputTextViewcommentInputTextView=============%@",dict);
             if([[NSString stringWithFormat:@"%@",dict[@"code"]] isEqualToString:@"1"] ){
                 NSDictionary *dictK =dict[@"data"];
                 NSString *commentXid = [NSString stringWithFormat:@"%@",dictK[@"xid"]];
                 NSString *commentNickName =[NSString stringWithFormat:@"%@",dictK[@"nickname"]];
                 
                 DFLineCommentItem *commentItem = [[DFLineCommentItem alloc] init];
                 commentItem.commentId = [commentXid integerValue];
                 commentItem.userId = [commentXid integerValue];
                 commentItem.userNick = commentNickName;
                 commentItem.text = aText;
             }
             
             [SVProgressHUD showSuccessWithStatus:@"评论成功"];
             
             [self createDetailMessageNetRequest];
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"请求失败:%@",error);
             [SVProgressHUD showErrorWithStatus:@"网络不通，请检查网络！"];
             
         }];
        
    } else {
        
        NSString *urlStr = @"http://www.xingxingedu.cn/Global/my_circle_comment";
        AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
        
        NSDictionary *dict = @{@"appkey":APPKEY,
                               @"backtype":BACKTYPE,
                               @"xid":XID,
                               @"user_id":USER_ID,
                               @"user_type":USER_TYPE,
                               @"com_type":@"2",
                               @"talk_id":_talkId,
                               @"con":aText,
                               @"to_who_xid":@"12345",
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
                 NSString *commentTo_who_xid = [NSString stringWithFormat:@"%@",dictK[@"to_who_xid"]];
                 NSString *commentTo_who_nickname =[NSString stringWithFormat:@"%@",dictK[@"to_who_nickname"]];
                 
                 DFLineCommentItem *commentItem = [[DFLineCommentItem alloc] init];
                 commentItem.commentId = [commentXid integerValue];
                 commentItem.userId = [commentXid integerValue];
                 commentItem.userNick = commentNickName;
                 commentItem.text = aText;
                 commentItem.replyUserId = [commentTo_who_xid integerValue];
                 commentItem.replyUserNick = commentTo_who_nickname;
    
             }
             [SVProgressHUD showSuccessWithStatus:@"回复成功"];
             
             [self createDetailMessageNetRequest];
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"请求失败:%@",error);
             [SVProgressHUD showErrorWithStatus:@"网络不通，请检查网络！"];
             
         }];

    }
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
