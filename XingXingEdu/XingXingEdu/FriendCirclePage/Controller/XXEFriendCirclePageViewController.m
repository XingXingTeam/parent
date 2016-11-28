//
//  XXEFriendCirclePageViewController.m
//  teacher
//
//  Created by codeDing on 16/8/2.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEFriendCirclePageViewController.h"
#import "XXEFriendCircleApi.h"
#import "XXECircleUserModel.h"
#import "XXECircleModel.h"
#import "XXECommentModel.h"
#import "XXEGoodUserModel.h"
#import "XXEFriendMyCircleViewController.h"
#import "XXEPublishFriendCircleApi.h"
#import "XXEFriendCirclegoodApi.h"
#import "XXEFriendCircleCommentApi.h"
#import "SVProgressHUD.h"
#import "XXEDeleteCommentApi.h"
#import "XXEWhoCanLookController.h"
#import "XXELocationAddController.h"
#import <AVFoundation/AVFoundation.h>
#import "XingXingEdu-swift.h"
#import "FriendCircleService.h"
#import <JSONModel/JSONModel.h>
#import "ServiceManager.h"
#import "UploadParam.h"

@interface XXEFriendCirclePageViewController ()<DFTimeLineViewControllerDelegate, NSCopying>
{

    NSString *parameterXid;
    NSString *parameterUser_Id;
}

/** 朋友圈的头部视图信息 */
@property (nonatomic, strong)NSMutableArray *headerDatasource;
/** 朋友圈列表的信息 */
@property (nonatomic, strong)NSMutableArray *circleListDatasource;
/** 页数 */
@property (nonatomic, assign)NSInteger page;
/** 说说ID */
@property (nonatomic, copy)NSString *speakId;
/** 用户昵称 */
@property (nonatomic, copy)NSString *userNickName;

/** 回复的内容 */
@property (nonatomic, copy)NSString *toWhoComment;

@property(nonatomic ,assign) BOOL isMaxLoading;

@property (nonatomic, assign) NSInteger maxPage;

//空试图
@property(nonatomic ,strong) UIView *emptyBackView;

@end

@implementation XXEFriendCirclePageViewController

- (NSMutableArray *)headerDatasource
{
    if (!_headerDatasource) {
        _headerDatasource = [NSMutableArray array];
    }
    return _headerDatasource;
}

- (NSMutableArray *)circleListDatasource
{
    if (!_circleListDatasource) {
        _circleListDatasource = [NSMutableArray array];
    }
    return _circleListDatasource;
}
/** 这两个方法都可以,改变当前控制器的电池条颜色 */
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBarTintColor:UIColorFromRGB(0, 170, 42)];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.speakId = @"";
    self.tableView.hidden = YES;
    self.view.backgroundColor = XXEBackgroundColor;
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }
    
    NSLog(@"朋友圈控制器");
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.page = 1;
    //获取朋友圈信息
    [RuningXX.sharedInstance showRuning];
    [self setupFriendCircleMessagePage: _page];
    
    self.delegate = self;
}

//MARK: - 设置空视图
-(void)setEmptyView {
    self.emptyBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    self.emptyBackView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.emptyBackView];
    
    UIImage *loadingFailImg = [UIImage imageNamed:@"jiazaishiban"];
    CGFloat imgWidth = loadingFailImg.size.width;
    CGFloat imgHeight = loadingFailImg.size.height;
    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(KScreenWidth/2 - imgWidth/2, KScreenHeight/2 - imgHeight/2, imgWidth, imgHeight)];
    iv.image = loadingFailImg;
    [self.emptyBackView addSubview:iv];
}

//MARK: - 移除空视图
-(void)removeEmpty {
    [self.emptyBackView removeFromSuperview];
}

#pragma mark - 下拉刷新 与上拉加载更多
- (void)refresh
{
    self.page = 1;
    [self setupFriendCircleMessagePage:self.page];
}

- (void)loadMore
{
    if (self.isMaxLoading) {
        return;
    }
    
    self.page ++;
    [self setupFriendCircleMessagePage:self.page];
}


#pragma mark - 朋友圈网络请求
- (void)setupFriendCircleMessagePage:(NSInteger )page
{
    /*
     【我的圈子--查询我发布的】
     接口类型:1
     接口:
     http://www.xingxingedu.cn/Global/select_mycircle
     传参:
     other_xid	//别人查看某人时,传某人的xid,如果是查看自己发布的,不需要这个参数
     page	//加载第几次(第几页),默认1
     */
//    __weak __typeof(self) weakSelf = self;
    NSString *pageNum = [NSString stringWithFormat:@"%ld",(long)page];
    if ([pageNum isEqualToString:@"1"]) {
        [self.circleListDatasource removeAllObjects];
    }
    
    NSDictionary *parameters = @{
                                 @"page":pageNum,
                                 @"xid":parameterXid,
                                 @"appkey":APPKEY,
                                 @"backtype":BACKTYPE,
                                 @"user_id":parameterUser_Id,
                                 @"user_type":USER_TYPE
                                 };
    __weak __typeof(self)weakSelf = self;
    [[FriendCircleService sharedInstance] friendCircleListRequestWithparameters:parameters succeed:^(id request) {
        
        
        
        NSString *code = [request objectForKey:@"code"];
        
        if (page == 1) {
            self.maxPage = [[[request objectForKey:@"data"] objectForKey:@"max_page"] integerValue];
            if (self.emptyBackView) {
                [self removeEmpty];
            }
            self.tableView.hidden = NO;
        }
        
        if ([code intValue]==1 && [[request objectForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
            [weakSelf detelAllSource];
            NSDictionary *data = [request objectForKey:@"data"];
            NSDictionary *userInfo = [data objectForKey:@"user_info"];
            XXECircleUserModel *Usermodel = [[XXECircleUserModel alloc]initWithDictionary:userInfo error:nil];
            [weakSelf.headerDatasource addObject:Usermodel];
            [weakSelf setHeaderMessage:Usermodel];
            
            //判断是否有信息
            if ([Usermodel.circle_noread isEqualToString:@"1"]) {
                [weakSelf creatNewMessageRemindcircleNoread:Usermodel.circle_noread];
            }
            
            if ([[data objectForKey:@"list"]isKindOfClass:[NSArray class]] ) {
                NSArray *list = [data objectForKey:@"list"];
                for (int i =0; i<list.count; i++) {
                    XXECircleModel *circleModel = [[XXECircleModel alloc]initWithDictionary:list[i] error:nil];
                    [weakSelf.circleListDatasource addObject:circleModel];
                };
                [weakSelf friendCircleMessage];
            }
            
            [weakSelf endRefresh];
            weakSelf.isMaxLoading = NO;
            if (weakSelf.page == self.maxPage) {
                weakSelf.isMaxLoading = YES;
                [weakSelf hudShowText:@"已经是最后一条了" second:2.f];
                [weakSelf endRefresh];
                [weakSelf endLoadMore];
            }
            [weakSelf.tableView reloadData];
        }else {
            weakSelf.isMaxLoading = YES;
            [weakSelf hudShowText:@"获取数据错误" second:2.f];
            [weakSelf endRefresh];
        }
        [RuningXX.sharedInstance dismissWithAnimation];
    } fail:^{
        if (self.page == 1) {
            [self setEmptyView];
        }
        [RuningXX.sharedInstance dismissWithAnimation];
        [weakSelf endRefresh];
        [weakSelf hudShowText:@"网络连接错误" second:2.f];
    }];

}

/** 朋友圈头部信息 */
- (void)setHeaderMessage:(XXECircleUserModel *)model
{
    NSString *cover;
    if ([model.head_img_type isEqualToString:@"0"]){
        cover = [NSString stringWithFormat:@"%@%@",kXXEPicURL,model.head_img];
    }else {
        cover = model.head_img;
    }
    
    self.userNickName = model.nickname;
    [self setCover:cover];
    [self setUserAvatar:cover];
    [self setUserNick:model.nickname];
    [self setUserSign:@""];
}

/** 朋友圈的信息列表 */
- (void)friendCircleMessage
{
    int j=1;
    if (self.circleListDatasource.count != 0) {
        for (int i =0; i<self.circleListDatasource.count; i++) {
            XXECircleModel *circleModel = self.circleListDatasource[i];
            DFTextImageLineItem *textImageItem = [[DFTextImageLineItem alloc] init];
            
            
            textImageItem.itemId = j;
//            NSLog(@"时间轴:%lld",textImageItem.itemId);
            j++;
            [textImageItem configure:circleModel];
            //如果发布的圈子有图片则显示图片
            if (self.page == 1) {
                [self.tableView reloadData];
            }
            
            [self fritnd_circleImageShowTextImageItem:textImageItem CircleModel:circleModel];
        }
    }else{
        NSLog(@"ggg没有数据");
    }
}




#pragma mark - 显示图片
- (void)fritnd_circleImageShowTextImageItem:(DFTextImageLineItem *)textImageItem CircleModel:(XXECircleModel *)circleModel
{
    //处理发布圈子的图片问题
    NSMutableArray *srcSmallImages = [NSMutableArray array];
    NSMutableArray *thumbBigImages = [NSMutableArray array];
    //判断图片的字符串里面有没有逗号
    if ([circleModel.pic_url containsString:@","]) {
        NSArray *array = [circleModel.pic_url componentsSeparatedByString:@","];
        for (NSString *image in array) {
            [srcSmallImages addObject:[NSString stringWithFormat:@"%@%@",kXXEPicURL,image]];
            [thumbBigImages addObject:[NSString stringWithFormat:@"%@%@",kXXEPicURL,image]];
            
        }
        textImageItem.srcImages = srcSmallImages;
        textImageItem.thumbImages = thumbBigImages;
    }else{
        [srcSmallImages addObject:[NSString stringWithFormat:@"%@%@",kXXEPicURL,circleModel.pic_url ]];
        [thumbBigImages addObject:[NSString stringWithFormat:@"%@%@",kXXEPicURL,circleModel.pic_url ]];
        textImageItem.srcImages = srcSmallImages;
        textImageItem.thumbImages = thumbBigImages;
    }
    //发布的评论和点赞
    [self friend_circleShowCommentAndGoodCircleModel:circleModel TextImageItem:textImageItem];
}

#pragma mark - 数据点赞和评论的信息
- (void)friend_circleShowCommentAndGoodCircleModel:(XXECircleModel *)circleModel TextImageItem:(DFTextImageLineItem *)textImageItem
{
    
    //点赞
    if (circleModel.good_user.count == 0) {
    }else{
        for (int j =0; j<circleModel.good_user.count; j++) {
            XXEGoodUserModel *goodModel = circleModel.good_user[j];
            DFTextImageLineItem *likeItem = [[DFTextImageLineItem alloc]init];
            [likeItem configureWithGoodUser:goodModel];
            [textImageItem.likes addObject:likeItem];
        }
    }
    
    // 评论内容
    if (circleModel.comment_group.count != 0) {
        for (int k =0; k<circleModel.comment_group.count; k++) {
            DFLineCommentItem *commentItem = [[DFLineCommentItem alloc]init];
            XXECommentModel *commentModel = circleModel.comment_group[k];
            [commentItem configure:commentModel];
            [textImageItem.comments addObject:commentItem];
        }
    }else{
        NSLog(@"数组为空");
    }
    
    [self addItem:textImageItem];
}


#pragma mark - DFImagesSendViewControllerDelegate 发布圈子的代理
-(void)onSendTextImage:(NSString *)text images:(NSArray *)images Location:(NSString *)location PersonSee:(NSString *)personSee
{
//    NSLog(@"发布的文字%@ 发布的图片%@",text,images);
    if (images.count ==0) {
        
        //往服务器传所有的参数
        [self publishFriendCircleText:text ImageFile:@"" Location:location PersonSee:personSee];
    }else if(images.count == 1) {
        
        NSDictionary *dict = @{@"file_type":@"1",
                               @"page_origin":@"35",
                               @"upload_format":@"1",
                               @"appkey":APPKEY,
                               @"user_type":USER_TYPE,
                               @"backtype":BACKTYPE
                               };
        NSMutableArray<UploadParam *> *uploadParams = [NSMutableArray array];
        UploadParam *uploadParam = [[UploadParam alloc] init];
        NSData *data = UIImageJPEGRepresentation(images[0], 0.5);
        NSString *name = [NSString stringWithFormat:@"1.jpeg"];
        NSString *formKey = [NSString stringWithFormat:@"file"];
        NSString *type = @"image/jpeg";
        [uploadParam configureWithData:data name:formKey filename:name mimetype:type];
        [uploadParams addObject:uploadParam];
        
        [[ServiceManager sharedInstance] uploadWithURLString:XXERegisterUpLoadPicUrl parameters:dict uploadParam:uploadParams success:^(id responseObject) {
            NSString *code = [responseObject objectForKey:@"code"];
            if ([code intValue] == 1) {
                NSString *data = [responseObject objectForKey:@"data"];
                
                //                NSLog(@"图片的网址:%@",data);
                //往服务器传所有的参数
                [self publishFriendCircleText:text ImageFile:data Location:location PersonSee:personSee];
            }
        } failure:^(NSError *error) {
            
        }];
        
    }else{
        NSDictionary *dict = @{@"file_type":@"1",
                           @"page_origin":@"35",
                           @"upload_format":@"2",
                           @"appkey":APPKEY,
                           @"user_type":USER_TYPE,
                           @"backtype":BACKTYPE
                           };
        NSMutableArray<UploadParam *> *uploadParams = [NSMutableArray array];
        for (int i = 0; i< images.count; i++) {
            UploadParam *uploadParam = [[UploadParam alloc] init];
            
            NSData *data = UIImageJPEGRepresentation(images[i], 0.5);
            NSString *name = [NSString stringWithFormat:@"%d.jpeg",i];
            NSString *formKey = [NSString stringWithFormat:@"file%d",i];
            NSString *type = @"image/jpeg";
            [uploadParam configureWithData:data name:formKey filename:name mimetype:type];
            [uploadParams addObject:uploadParam];
        }
    
        [[ServiceManager sharedInstance] uploadWithURLString:XXERegisterUpLoadPicUrl parameters:dict uploadParam:uploadParams success:^(id responseObject) {
            NSString *code = [responseObject objectForKey:@"code"];
            if ([code intValue] == 1) {
                NSArray *data = [responseObject objectForKey:@"data"];
                NSMutableString *str = [NSMutableString string];
                for (int i =0; i< data.count; i++) {
                    NSString *string = data[i];
                    if (i != data.count -1) {
                        [str appendFormat:@"%@,",string];
                    }else {
                        [str appendFormat:@"%@",string];
                    }
                }
                //            NSLog(@"图片的网址:%@",str);
                //往服务器传所有的参数
                [self publishFriendCircleText:text ImageFile:str Location:location PersonSee:personSee];
            }
        } failure:^(NSError *error) {
            
        }];
    }
}

#pragma mark - 网服务器上传发布信息

- (void)publishFriendCircleText:(NSString *)text ImageFile:(NSString *)imageFile Location:(NSString *)location PersonSee:(NSString *)personSee
{
    if ([personSee isEqualToString:@""]) {
        personSee = @"0";
    }else if ([personSee isEqualToString:@"仅自己可见"]){
        personSee = @"1";
    }else if ([personSee isEqualToString:@"好友可见"]){
        personSee = @"2";
    }else if ([personSee isEqualToString:@"班级通讯录可见"]){
        personSee = @"3";
    }else{
        personSee = @"0";
    }
    
    NSDictionary *dict = @{
                           @"xid":parameterXid,
                           @"appkey":APPKEY,
                           @"backtype":BACKTYPE,
                           @"user_id":parameterUser_Id,
                           @"user_type":USER_TYPE,
                           @"position":location,
                           @"file_type":@"1",
                           @"words":text,
                           @"pic_group":imageFile,
                           @"circle_set":personSee,
                           @"video_url":@""
                           };
    
    [[FriendCircleService sharedInstance] friendCirclePublishRequestWithparameters:dict succeed:^(id request) {
        NSString *code = [request objectForKey:@"code"];
        if ([code integerValue]== 1) {
            
            NSDictionary *data = [request objectForKey:@"data"];
            NSString *head_image = [data objectForKey:@"head_img"];
            
            DFTextImageLineItem *textImageItem = [[DFTextImageLineItem alloc]init];
            textImageItem.itemId = 1;
            textImageItem.userId =[parameterXid integerValue];
            NSString *avatarImage = [NSString stringWithFormat:@"%@%@",kXXEPicURL,head_image];
            textImageItem.userAvatar = avatarImage;
            textImageItem.userNick = [data objectForKey:@"nickname"];
            textImageItem.title = @"发表了";
            textImageItem.text = text;
            textImageItem.ts = [[NSDate date] timeIntervalSince1970]*1000;
            //处理发布圈子的图片问题
            NSMutableArray *srcSmallImages = [NSMutableArray array];
            NSMutableArray *thumbBigImages = [NSMutableArray array];
            //判断图片的字符串里面有没有逗号
            if ([imageFile containsString:@","]) {
                NSLog(@"包含");
                NSArray *array = [imageFile componentsSeparatedByString:@","];
                for (NSString *image in array) {
                    [srcSmallImages addObject:[NSString stringWithFormat:@"%@%@",kXXEPicURL,image]];
                    [thumbBigImages addObject:[NSString stringWithFormat:@"%@%@",kXXEPicURL,image]];
                    NSLog(@"小图片%@ 大图片%@",srcSmallImages,thumbBigImages);
                    
                }
                textImageItem.srcImages = srcSmallImages;
                textImageItem.thumbImages = thumbBigImages;

            }else{
                NSLog(@"不包含");
                [srcSmallImages addObject:[NSString stringWithFormat:@"%@%@",kXXEPicURL,imageFile ]];
                [srcSmallImages addObject:@"哈哈.png"];
                [thumbBigImages addObject:[NSString stringWithFormat:@"%@%@",kXXEPicURL,imageFile ]];
                [thumbBigImages addObject:@"哈哈.png"];
                textImageItem.srcImages = srcSmallImages;
                textImageItem.thumbImages = thumbBigImages;

            }
            textImageItem.location = location;
            [self addItemTop:textImageItem];
            [self hudShowText:@"发布成功" second:1.f];
            //获取朋友圈信息
            [self setupFriendCircleMessagePage:1];
        }else{
            [SVProgressHUD showErrorWithStatus:@"获取数据失败"];
            [self endRefresh];
            [self endLoadMore];
        }
    } fail:^{
        [SVProgressHUD showErrorWithStatus:@"获取数据失败"];
        [self endRefresh];
        [self endLoadMore];
    }];

}

#pragma mark - 评论和点赞
-(void)onCommentCreate:(long long)commentId text:(NSString *)text itemId:(long long) itemId talkId:(NSString *)talkId
{
    NSString *otherXid;

    NSInteger myXId = [parameterXid integerValue];
    
    long indexId = itemId-1;
//    NSLog(@"新的:%ld",indexId);
    if (self.circleListDatasource.count ==0) {
        [self hudShowText:@"没有数据" second:1.f];
    }else{
        XXECircleModel *circleModel = self.circleListDatasource[indexId];
        self.speakId = circleModel.talkId;
        otherXid = circleModel.xid;
    }
    self.toWhoComment = text;
    if (commentId > 0) {
        //回复
        DFLineCommentItem *commentItem = [[DFLineCommentItem alloc] init];
        commentItem.commentId = [[NSDate date] timeIntervalSince1970];
        commentItem.userId = myXId;
        commentItem.userNick = self.userNickName;
        commentItem.text = text;
        [self addCommentItem:commentItem itemId:itemId replyCommentId:commentId];
//        [self setupFriendCircleMessagePage:1];
    }else{
        //评论
        //网络请求可以放在这里
        __weak __typeof(self)weakSelf = self;
        [[FriendCircleService sharedInstance] friendCircleCommentUerXid:parameterXid UserID:parameterUser_Id TalkId:self.speakId Com_type:@"1" Con:text To_Who_Xid:@"" succeed:^(id request) {
            
            NSLog(@"点赞/评论 数据 --- %@", request);
            NSString *code = [request objectForKey:@"code"];
            NSDictionary *data = [request objectForKey:@"data"];
            
            if ([code integerValue] == 1) {
                
                XXECommentModel *commentModel = [[XXECommentModel alloc] init];
                commentModel.commentId = data[@"id"];
                commentModel.commentXid = [NSString stringWithFormat:@"%ld", (long)myXId];
                commentModel.commentNicknName = weakSelf.userNickName;
                commentModel.con = text;
                
                DFLineCommentItem *commentItem = [[DFLineCommentItem alloc] init];
                [commentItem configure:commentModel];
                [weakSelf addCommentItem:commentItem itemId:itemId replyCommentId:commentId];
                [weakSelf hudShowText:@"评论成功" second:1.f];
                
                //刷新本地数据
                XXECircleModel * model = weakSelf.circleListDatasource[(int)itemId - 1];
                [model.comment_group addObject:commentModel];
                weakSelf.circleListDatasource[(int)itemId - 1] = model;
            }else{
                
                [weakSelf hudShowText:@"评论失败" second:1.f];
            }
            
        } fail:^{
            {
                [weakSelf hudShowText:@"网络失败" second:1.f];
            }
        }];
    }
}

//如果是回复就会执行这个方法所以回复的网络请求就可以放在这里
- (void)xxe_friendCirclePageCommentToWhoXid:(NSInteger)toWhoXid commentId:(NSString *)commentId itemId:(long long)itemId replyCommentId:(NSString *)replyCommentId replyNickname:(NSString*)replyNickname
{
//    NSLog(@"%ld",(long)toWhoXid);

    NSString *stringToWhoXid = [NSString stringWithFormat:@"%ld",(long)toWhoXid];
    __weak __typeof(self)weakSelf = self;
    [[FriendCircleService sharedInstance] friendCircleCommentUerXid:parameterXid UserID:parameterUser_Id TalkId:self.speakId Com_type:@"2" Con:self.toWhoComment To_Who_Xid:stringToWhoXid succeed:^(id request) {
        NSString *code = [request objectForKey:@"code"];
        if ([code integerValue] == 1) {
            [weakSelf hudShowText:@"回复成功" second:1.f];
            [weakSelf.tableView reloadData];
            
            XXECommentModel *commentModel = [[XXECommentModel alloc] init];
            commentModel.con = weakSelf.toWhoComment;
            commentModel.to_who_xid = stringToWhoXid;
            commentModel.commentId = commentId;
            commentModel.commentNicknName = [XXEUserInfo user].nickname;
            commentModel.to_who_nickname = replyNickname;
            
            //刷新本地数据
            XXECircleModel * model = weakSelf.circleListDatasource[(int)itemId - 1];
            [model.comment_group addObject:commentModel];
            weakSelf.circleListDatasource[(int)itemId - 1] = model;
            
        }else{
            [weakSelf hudShowText:@"回复失败" second:1.f];
        }
    } fail:^{
        [weakSelf hudShowText:@"回复失败" second:1.f];
    }];

}

//删除评论 网络请求
#pragma mark - 删除评论 的网络请求

-(void) deleteComment:(long long)commentId itemId:(long long)itemId {
    
    long indexId = itemId-1;
    //    NSLog(@"新的:%ld",indexId);
    if (self.circleListDatasource.count ==0) {
        [self hudShowText:@"没有数据" second:1.f];
    }else{
        XXECircleModel *circleModel = self.circleListDatasource[indexId];
        self.speakId = circleModel.talkId;
    }
    NSString *commentID = [NSString stringWithFormat:@"%lld",commentId];
    __weak __typeof(self)weakSelf = self;
    [[FriendCircleService sharedInstance] friendCircleDeleteCommentEventType:@"3" TalkId:self.speakId CommentId:commentID UserXid:parameterXid UserId:parameterUser_Id succeed:^(id request) {
        NSString *code = [request objectForKey:@"code"];
        if ([code integerValue]==1 || [code integerValue]==5 ) {
            XXECommentModel *commentModel = [[XXECommentModel alloc]init];
            commentModel.commentId = [NSString stringWithFormat:@"%lld", commentId];
            commentModel.commentXid = parameterXid;
            commentModel.commentNicknName = @"";
            commentModel.con = @"";
            
            DFLineCommentItem *commentItem = [[DFLineCommentItem alloc] init];
            [commentItem configure:commentModel];
            [self cancelCommentItem:commentItem itemId:itemId replyCommentId:commentId];
            [self hudShowText:@"删除成功" second:1.f];
            [self.tableView reloadData];
            
            //刷新本地数据
            XXECircleModel * model = weakSelf.circleListDatasource[(int)itemId - 1];
            
            for (XXECommentModel * commentModel in model.comment_group) {
                
                if ([commentModel.commentId isEqualToString:[NSString stringWithFormat:@"%lld",commentId]]) {
                    [model.comment_group removeObject:commentModel];
                    break;
                }
                
            }
            
            weakSelf.circleListDatasource[(int)itemId - 1] = model;
            
        }else{
            [self hudShowText:@"删除失败" second:1.f];
        }
    } fail:^{
        [self hudShowText:@"网络请求失败" second:1.f];
    }];

}

-(void) deleteClickComment:(long long) commentId itemId:(long long) itemId
{
//    NSLog(@"长按删除评论");
//    
//    long indexId = itemId-1;
////    NSLog(@"新的:%ld",indexId);
//    if (self.circleListDatasource.count ==0) {
//        [self hudShowText:@"没有数据" second:1.f];
//    }else{
//        XXECircleModel *circleModel = self.circleListDatasource[indexId];
//        self.speakId = circleModel.talkId;
//    }
//    
////    NSLog(@"commentId%lld itemI%lld",commentId, itemId);
////    NSLog(@"说说ID%@",self.speakId);
////    NSLog(@"CommentId%lld",commentId);
//    NSString *commentID = [NSString stringWithFormat:@"%lld",commentId];
//    XXEDeleteCommentApi *commentApi = [[XXEDeleteCommentApi alloc]initWithDeleteCommentEventType:@"3" TalkId:self.speakId CommentId:commentID UserXid:parameterXid UserId:parameterUser_Id];
//    [commentApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
////        NSLog(@"%@",request.responseJSONObject);
//        NSString *code = [request.responseJSONObject objectForKey:@"code"];
//        NSString *data = [request.responseJSONObject objectForKey:@"data"];
////        NSLog(@":data%@",data);
//        if ([code integerValue]==1 || [code integerValue]==5 ) {
////            NSLog(@"%@",[request.responseJSONObject objectForKey:@"msg"]);
////            NSLog(@"%@",[request.responseJSONObject objectForKey:@"data"]);
//            DFLineCommentItem *commentItem = [[DFLineCommentItem alloc] init];
//            commentItem.commentId = commentId;
//            commentItem.userId = [parameterXid integerValue];
//            commentItem.userNick = @"";
//            commentItem.text = @"";
//            [self cancelCommentItem:commentItem itemId:itemId replyCommentId:commentId];
//            [self hudShowText:@"删除成功" second:1.f];
//            [self setupFriendCircleMessagePage:_page];
//        }else{
//            [self hudShowText:@"删除失败" second:1.f];
//        }
//    } failure:^(__kindof YTKBaseRequest *request) {
//        [self hudShowText:@"网络请求失败" second:1.f];
//    }];
}




#pragma mark *******************  点赞  ********************
- (void)onLike:(long long)itemId
{
    NSLog(@"%lld",itemId);

    long indexId = itemId-1;
//    NSLog(@"新的:%ld",indexId);
    if (self.circleListDatasource.count ==0) {
        [self hudShowText:@"没有数据" second:1.f];
    }else{
       XXECircleModel *circleModel = self.circleListDatasource[indexId];
        self.speakId = circleModel.talkId;
        
        __weak __typeof(self)weakSelf = self;
        [[FriendCircleService sharedInstance] friendCircleGoodOrCancelUserXid:parameterXid UserID:parameterUser_Id TalkId:self.speakId succeed:^(id request) {
            /*
             code = 10;    //取消点赞 成功
             data =     {
             nickname = summer;
             xid = 18886394;
             };
             msg = "Success!\U53d6\U6d88\U8d5e\U6210\U529f!";
             */
            
            //        NSLog(@"zan ===== %@", request.responseJSONObject);
            
            NSString *code = [request objectForKey:@"code"];
            NSDictionary *data = [request objectForKey:@"data"];
            
            XXEGoodUserModel * goodModel = [[XXEGoodUserModel alloc] init];
            goodModel.goodXid = [data objectForKey:@"xid"];
            goodModel.goodNickName = [data objectForKey:@"nickname"];
            DFLineLikeItem *likeItem = [[DFLineLikeItem alloc] init];
            [likeItem configure:goodModel];
            
            //刷新本地数据
            XXECircleModel * model = weakSelf.circleListDatasource[(int)itemId - 1];
            
            if ([code integerValue]==1) {
                [self addLikeItem:likeItem itemId:itemId isSelet:NO];
                [self hudShowText:@"点赞成功" second:1.f];
                [model.good_user addObject:goodModel];
                
            }else if ([code integerValue]==10){
                
                [self addLikeItem:likeItem itemId:itemId isSelet:YES];
                [self hudShowText:@"取消成功" second:1.f];
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    for (XXEGoodUserModel * good in model.good_user) {
                        if ([good.goodXid isEqualToString:[XXEUserInfo user].xid]) {
                            [model.good_user removeObject:good];
                            break;
                        }
                    }
                });
            }
            weakSelf.circleListDatasource[(int)itemId - 1] = model;
            
        } fail:^{
            [self hudShowText:@"网络不通，请检查网络！" second:1.f];
        }];
//    NSLog(@"说说ID%@ XID%@ UserID%@",self.speakId ,strngXid,homeUserId);
//    XXEFriendCirclegoodApi *friendGoodApi = [[XXEFriendCirclegoodApi alloc]initWithFriendCircleGoodOrCancelUerXid:parameterXid UserID:parameterUser_Id TalkId:self.speakId];
//    [friendGoodApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
//        /*
//         code = 10;    //取消点赞 成功
//         data =     {
//         nickname = summer;
//         xid = 18886394;
//         };
//         msg = "Success!\U53d6\U6d88\U8d5e\U6210\U529f!";
//         */
//        
////        NSLog(@"zan ===== %@", request.responseJSONObject);
//        
//        NSString *code = [request.responseJSONObject objectForKey:@"code"];
//        NSDictionary *data = [request.responseJSONObject objectForKey:@"data"];
//        
//        XXEGoodUserModel * goodModel = [[XXEGoodUserModel alloc] init];
//        goodModel.goodXid = [data objectForKey:@"xid"];
//        goodModel.goodNickName = [data objectForKey:@"nickname"];
//        DFLineLikeItem *likeItem = [[DFLineLikeItem alloc] init];
//        [likeItem configure:goodModel];
//        
//        //刷新本地数据
//        XXECircleModel * model = weakSelf.circleListDatasource[(int)itemId - 1];
//        
//        if ([code integerValue]==1) {
//            [self addLikeItem:likeItem itemId:itemId isSelet:NO];
//            [self hudShowText:@"点赞成功" second:1.f];
//            [model.good_user addObject:goodModel];
//            
//        }else if ([code integerValue]==10){
//            
//            [self addLikeItem:likeItem itemId:itemId isSelet:YES];
//            [self hudShowText:@"取消成功" second:1.f];
//            dispatch_async(dispatch_get_global_queue(0, 0), ^{
//                for (XXEGoodUserModel * good in model.good_user) {
//                    if ([good.goodXid isEqualToString:[XXEUserInfo user].xid]) {
//                        [model.good_user removeObject:good];
//                        break;
//                    }
//                }
//            });
//        }
//        weakSelf.circleListDatasource[(int)itemId - 1] = model;
//    
//    } failure:^(__kindof YTKBaseRequest *request) {
//        [self hudShowText:@"网络不通，请检查网络！" second:1.f];
//    }];
    
    }
}

//点击左边头像 或者 点击评论和赞的用户昵称
-(void)onClickUser:(NSUInteger)userId
{
//    NSLog(@"%lu",(unsigned long)userId);
    XXEFriendMyCircleViewController *myCircleVC = [[XXEFriendMyCircleViewController alloc]init];
    myCircleVC.otherXid = [NSString stringWithFormat:@"%lu", userId];
    myCircleVC.friendCirccleRefreshBlock = ^(){
        [self refresh];
    };
    [self.navigationController pushViewController:myCircleVC animated:YES];
}

-(void)onClickHeaderUserAvatar
{
    
    NSInteger myXId = [parameterXid integerValue];
    [self onClickUser:myXId];
}


//发送视频 目前没有实现填写文字
//-(void)onSendVideo:(NSString *)text videoPath:(NSString *)videoPath screenShot:(UIImage *)screenShot name:(NSString *)name fileName:(NSString *)fileName
//{
//    NSData *data = [NSData dataWithContentsOfFile:videoPath];
////    NSURL *sourceUrl = [NSURL URLWithString:videoPath];
////    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:sourceUrl options:nil];
////    
////    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
////    
////    NSLog(@"%@",compatiblePresets);
////    
////    if ([compatiblePresets containsObject:AVAssetExportPresetHighestQuality]) {
////        
////        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:avAsset presetName:AVAssetExportPresetMediumQuality];
////        
////        NSDateFormatter *formater = [[NSDateFormatter alloc] init];//用时间给文件全名，以免重复
////        [formater setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];
////        
////        NSString * resultPath = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/output-%@.mp4", [formater stringFromDate:[NSDate date]]];
////        
////        NSLog(@"resultPath = %@",resultPath);
////        
////        exportSession.outputURL = [NSURL fileURLWithPath:resultPath];
////        
////        exportSession.outputFileType = AVFileTypeMPEG4;
////        
////        exportSession.shouldOptimizeForNetworkUse = YES;
////        
////        [exportSession exportAsynchronouslyWithCompletionHandler:^(void)
////         
////         {
////             
////             switch (exportSession.status) {
////                     
////                 case AVAssetExportSessionStatusUnknown:
////                     
////                     NSLog(@"AVAssetExportSessionStatusUnknown");
////                     
////                     break;
////                     
////                 case AVAssetExportSessionStatusWaiting:
////                     
////                     NSLog(@"AVAssetExportSessionStatusWaiting");
////                     
////                     break;
////                     
////                 case AVAssetExportSessionStatusExporting:
////                     
////                     NSLog(@"AVAssetExportSessionStatusExporting");
////                     
////                     break;
////                     
////                 case AVAssetExportSessionStatusCompleted:
////                     
////                     NSLog(@"AVAssetExportSessionStatusCompleted");
////                     
////                     break;  
////                     
////                 case AVAssetExportSessionStatusFailed:  
////                     
////                     NSLog(@"AVAssetExportSessionStatusFailed");  
////                     
////                     break;  
////                     
////             }  
////             
////         }];  
////        
////    }
//    
//    
//
//    DFVideoLineItem *videoItem = [[DFVideoLineItem alloc] init];
//    videoItem.itemId = 1; //随便设置一个 待服务器生成
//    videoItem.userId = 10018;
//    videoItem.userAvatar = @"http://file-cdn.datafans.net/avatar/1.jpeg";
//    videoItem.userNick = @"富二代";
//    videoItem.title = @"发表了";
//    videoItem.text = @"新年过节 哈哈"; //这里需要present一个界面 用户填入文字后再发送 场景和发图片一样
////    XXEWhoCanLookController *whoVC = [[XXEWhoCanLookController alloc]init];
////    [self presentViewController:whoVC animated:YES completion:nil];
//    
//    videoItem.location = @"广州";
//    
//    videoItem.localVideoPath = videoPath;
//    videoItem.videoUrl = @""; //网络路径
//    videoItem.thumbUrl = @"";
//    videoItem.thumbImage = screenShot; //如果thumbImage存在 优先使用thumbImage
//    [self wwwqqqqqqWithPath:data name:name fileName:fileName dataURL:[NSURL URLWithString:videoPath]];
////    [self addItemTop:videoItem];
//    
//    //接着上传图片 和 请求服务器接口
//    //请求完成之后 刷新整个界面
//    
////    NSDictionary *dict = @{@"file_type":@"2",
////                           @"page_origin":@"35",
////                           @"upload_format":@"1",
////                           @"appkey":APPKEY,
////                           @"user_type":USER_TYPE,
////                           @"backtype":BACKTYPE
////                           };
////    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
////    [manager POST:XXERegisterUpLoadPicUrl parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
////        [formData appendPartWithFileData:data name:@"video" fileName:@"video.mov" mimeType:@"video/quicktime"];
////        
////    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
////        
////        NSLog(@"%@",responseObject);
//////        NSLog(@"%@",[responseObject objectForKey:@"msg"]);
////        
////    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
////        NSLog(@"%@",error);
////    }];
//}


//测试传视频
//- (void)wwwqqqqqqWithPath:(NSData *)data1 name:(NSString*)name fileName:(NSString*)fileName dataURL:(NSURL*)dataURL
//{
//    NSDictionary *dict = @{@"file_type":@"2",
//                           @"page_origin":@"35",
//                           @"upload_format":@"1",
//                           @"appkey":APPKEY,
//                           @"user_type":USER_TYPE,
//                           @"backtype":BACKTYPE,
//                           @"return_param_all":@"1",
//                           @"return":@"re"
//                           };
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    [manager POST:XXERegisterUpLoadPicUrl parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
////        NSString *name = [NSString stringWithFormat:@"video2"];
////        NSString *formKey = [NSString stringWithFormat:@"video2.mp4"];
//        NSString *type = @"video/mp4";
//        NSError *error = nil;
//        [formData appendPartWithFileURL:dataURL name:name fileName:fileName mimeType:type error:&error];
//        NSLog(@"%@",error);
////        [formData appendPartWithFileURL:dataURL name:formKey fileName:name mimeType:type];
//        
//    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
//        
//        NSLog(@"%@",responseObject);
////        NSLog(@"%@",[responseObject objectForKey:@"msg"]);
//        
//    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
//        NSLog(@"%@",error);
//    }];
//
//}
//- (void)aaa{
////    NSDictionary *dict = @{@"file_type":@"2",
////                           @"page_origin":@"35",
////                           @"upload_format":@"1",
////                           @"appkey":APPKEY,
////                           @"user_type":USER_TYPE,
////                           @"backtype":BACKTYPE,
////                           @"return_param_all":@"1",
////                           @"return": @"return"
////                           };
////    AFHTTPRequestSerializer *ser = [[AFHTTPRequestSerializer alloc] init];
////    NSMutableURLRequest *request = [ser multipartFormRequestWithMethod:@"POST"
////                                                             URLString:XXERegisterUpLoadPicUrl parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
////                                                                 [formData appendPartWithFileURL:fileURL name:@"file" fileName:@"fileName" mimeType:@"video/mp4" error:nil];
////                                                             } error:nil];
////    
////    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
////    
////    NSProgress *progress = nil;
////    
////    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request progress:&progress completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
////        if (error) {
////            NSLog(@"request = %@", request );
////            //            MyLog(@"response = %@", response );
////            //            MyLog(@"Error: %@", error );
////            //            [_hud hide:YES];
////            //            CXAlertView *alert=[[CXAlertView alloc]initWithTitle:NSLocalizedString(@"Warning", nil)
////            //                                                         message:NSLocalizedString(@"Upload Failed",nil)
////            //                                               cancelButtonTitle:NSLocalizedString(@"Iknow", nil)];
////            //            alert.showBlurBackground = NO;
////            //            [alert show];
////        } else {
////            NSLog(@"%@ %@", response, responseObject);
////            NSDictionary *backDict=(NSDictionary *)responseObject;
////            if ([backDict[@"success"] boolValue] != NO) {
////                //                _hud.labelText = NSLocalizedString(@"Updating", nil);
////                //                [self UpdateResxDateWithDict:backDict discription:dict[@"discription"]];
////                //                [_hud hide:YES];
////            }else{
////                //                [_hud hide:YES];
////                //                [MyHelper showAlertWith:nil txt:backDict[@"msg"]];
////            }
////        }
////        //        [progress removeObserver:self
////        //                      forKeyPath:@"fractionCompleted"
////        //                         context:@"1"];
////    }];
////    
////    //    [progress addObserver:self
////    //               forKeyPath:@"fractionCompleted"
////    //                  options:NSKeyValueObservingOptionNew
////    //                  context:@"1"];
////    //    [progress setUserInfoObject:@"someThing" forKey:@"Y.X."];
////    [uploadTask resume];
//}
#pragma mark - TabelViewDelegate

//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    //点击所有cell空白地方 隐藏toolbar
//    NSInteger rows =  [tableView numberOfRowsInSection:0];
//    for (int row = 0; row < rows; row++) {
//        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
//        DFBaseLineCell *cell  = (DFBaseLineCell *)[tableView cellForRowAtIndexPath:indexPath];
//        [cell hideLikeCommentToolbar];
//    }
//    NSLog(@"第几个单元格%ld",(long)indexPath.row);
//}


//#pragma mark - Method
//
//-(DFBaseLineCell *) getCell:(Class)itemClass
//{
//    DFLineCellManager *manager = [DFLineCellManager sharedInstance];
//    return [manager getCell:itemClass];
//}

-(void) onClickLikeCommentBtn:(id)sender{
/*
 _likeCommentToolbar.zanFlag = @"赞";
 _isLikeCommentToolbarShow = !_isLikeCommentToolbarShow;
 _likeCommentToolbar.hidden = !_isLikeCommentToolbarShow;
 */
    DFBaseLineCell *cell = [[DFBaseLineCell alloc] init];
    cell.likeCmtButton = sender;
    
    NSLog(@"aaa");
    
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
