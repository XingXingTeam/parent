//
//  XXEFriendMyCircleViewController.m
//  teacher
//
//  Created by codeDing on 16/9/6.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEFriendMyCircleViewController.h"
#import "XXEFriendMyCircleApi.h"
#import "XXECircleUserModel.h"
#import "XXECircleModel.h"
#import "XXECommentModel.h"
#import "XXEGoodUserModel.h"
#import "XXEInfomationViewController.h"
#import "XXEMessageHistoryController.h"
#import "FriendCircleService.h"

@interface XXEFriendMyCircleViewController ()

/** 朋友圈的头部视图信息 */
@property (nonatomic, strong)NSMutableArray *headerMyCircleDatasource;
/** 朋友圈列表的信息 */
@property (nonatomic, strong)NSMutableArray *circleMyCircleListDatasource;

/** 保存数据源数据 */
@property (nonatomic, strong)NSMutableArray *circleDatasource;

/** 页数 */
@property (nonatomic, assign)NSInteger page;

@end

@implementation XXEFriendMyCircleViewController
- (NSMutableArray *)headerMyCircleDatasource
{
    if (!_headerMyCircleDatasource) {
        _headerMyCircleDatasource = [NSMutableArray array];
    }
    return _headerMyCircleDatasource;
}

- (NSMutableArray *)circleMyCircleListDatasource
{
    if (!_circleMyCircleListDatasource) {
        _circleMyCircleListDatasource = [NSMutableArray array];
    }
    return _circleMyCircleListDatasource;
}

- (NSMutableArray *)circleDatasource
{
    if (!_circleDatasource) {
        _circleDatasource = [NSMutableArray array];
    }
    return _circleDatasource;
}

/** 这两个方法都可以,改变当前控制器的电池条颜色 */
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - 下拉刷新 与上拉加载更多
- (void)refresh
{
    self.page = 1;
    [self FriendMyCircleMessagePage:self.page];
}

- (void)loadMore
{
    self.page ++;
    NSLog(@"%ld",(long)self.page);
    [self FriendMyCircleMessagePage:self.page];
}

//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    //获取数据
////    [self refresh];
//}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(229, 232, 233);
    if ([self.rootChat isEqualToString:@"my"]) {
        self.tableView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
    }else {
        self.tableView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight - 44);
    }
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, -64, 70, 64);
    button.backgroundColor = [UIColor redColor];
    [self.view addSubview:button];
    [self refresh];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.rootChat != nil) {
        
    }else{
        self.friendCirccleRefreshBlock();
    }
    UIButton*rightButton = [[UIButton alloc]initWithFrame:CGRectMake(-10,0,22,22)];
    [rightButton setImage:[UIImage imageNamed:@"查看历史44x44"]  forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(messageHistory) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem= rightItem;
}


#pragma mark - 获取数据
- (void)FriendMyCircleMessagePage:(NSInteger )page
{
    NSString *strngXid;
    NSString *homeUserId;
    if ([XXEUserInfo user].login) {
        strngXid = [XXEUserInfo user].xid;
        homeUserId = [XXEUserInfo user].user_id;
    }else {
        strngXid = XID;
        homeUserId = USER_ID;
    }
//    NSString *otherXid = [NSString stringWithFormat:@"%ld",(long)self.otherXid];
    
    NSString *page1 = [NSString stringWithFormat:@"%ld",(long)page];
    [[FriendCircleService sharedInstance] friendCircleCheckOtherCircleWithXid:_otherXid page:page1 UserId:homeUserId MyCircleXid:strngXid succeed:^(id request) {
        
        if (page ==1) {
            [self.circleMyCircleListDatasource removeAllObjects];
            [self xxe_userRefreshTableViewWithItem:@""];
        }
        [self.circleDatasource removeAllObjects];
        
        NSLog(@"%@",request);
        NSLog(@"%@",[request objectForKey:@"msg"]);
        NSString *code = [request objectForKey:@"code"];
        if ([code intValue]==1) {// && [[request.responseJSONObject objectForKey:@"data"] isKindOfClass:[NSDictionary class]]
            NSDictionary *data = [request objectForKey:@"data"];
            NSArray *listSS = [data objectForKey:@"ss"];
            NSLog(@"数组信息%@",listSS);
            NSLog(@"用户信息%@",[data objectForKey:@"user_info"]);
            NSDictionary *userInfo = [data objectForKey:@"user_info"];
            [self.items removeAllObjects];
            XXECircleUserModel *Usermodel = [[XXECircleUserModel alloc]initWithDictionary:userInfo error:nil];
            [self.headerMyCircleDatasource addObject:Usermodel];
            //设置顶部视图信息
            [self setHeaderMyCircleMessage:Usermodel];
            NSLog(@"评论信息的列表的%@",listSS);
            for (int i =0; i<listSS.count; i++) {
                XXECircleModel *circleModel = [[XXECircleModel alloc]initWithDictionary:listSS[i] error:nil];
                [self.circleMyCircleListDatasource addObject:circleModel];
                [self.circleDatasource addObject:circleModel];
            }
            [self endRefresh];
            //朋友圈的信息列表
            [self myFriendCircleMessage];
            [self.tableView reloadData];
            //            NSLog(@"圈子顶部信息数组信息%@",self.headerMyCircleDatasource);
        } else{
            [self hudShowText:@"获取数据错误" second:2.f];
            [self endRefresh];
            [self endLoadMore];
        }
    } fail:^{
        
    }];
    
//    XXEFriendMyCircleApi *friendMyApi = [[XXEFriendMyCircleApi alloc]initWithChechFriendCircleOtherXid:_otherXid page:page1 UserId:homeUserId MyCircleXid:strngXid];
//    [friendMyApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
//        
//        if (page ==1) {
//            [self.circleMyCircleListDatasource removeAllObjects];
//            [self xxe_userRefreshTableViewWithItem:@""];
//        }
//        [self.circleDatasource removeAllObjects];
//        
//        NSLog(@"%@",request.responseJSONObject);
//        NSLog(@"%@",[request.responseJSONObject objectForKey:@"msg"]);
//        NSString *code = [request.responseJSONObject objectForKey:@"code"];
//        if ([code intValue]==1) {// && [[request.responseJSONObject objectForKey:@"data"] isKindOfClass:[NSDictionary class]]
//            NSDictionary *data = [request.responseJSONObject objectForKey:@"data"];
//            NSArray *listSS = [data objectForKey:@"ss"];
//            NSLog(@"数组信息%@",listSS);
//            NSLog(@"用户信息%@",[data objectForKey:@"user_info"]);
//            NSDictionary *userInfo = [data objectForKey:@"user_info"];
//            [self.items removeAllObjects];
//            XXECircleUserModel *Usermodel = [[XXECircleUserModel alloc]initWithDictionary:userInfo error:nil];
//            [self.headerMyCircleDatasource addObject:Usermodel];
//            //设置顶部视图信息
//            [self setHeaderMyCircleMessage:Usermodel];
//            NSLog(@"评论信息的列表的%@",listSS);
//            for (int i =0; i<listSS.count; i++) {
//                XXECircleModel *circleModel = [[XXECircleModel alloc]initWithDictionary:listSS[i] error:nil];
//                [self.circleMyCircleListDatasource addObject:circleModel];
//                [self.circleDatasource addObject:circleModel];
//            }
//            [self endRefresh];
//            //朋友圈的信息列表
//            [self myFriendCircleMessage];
//            [self.tableView reloadData];
////            NSLog(@"圈子顶部信息数组信息%@",self.headerMyCircleDatasource);
//        } else{
//            [self hudShowText:@"获取数据错误" second:2.f];
//            [self endRefresh];
//            [self endLoadMore];
//        }
//    } failure:^(__kindof YTKBaseRequest *request) {
//        
//    }];
}

/** 朋友圈头部信息 */
- (void)setHeaderMyCircleMessage:(XXECircleUserModel *)model
{
    NSLog(@"======%@",model.head_img);
    
    NSString *cover;
    if ([model.head_img_type isEqual: @"0"]) {
        cover = [NSString stringWithFormat:@"%@%@",kXXEPicURL,model.head_img];
    } else if ([model.head_img_type  isEqual: @"1"]) {
        cover = [NSString stringWithFormat:@"%@", model.head_img];
    }
    
    [self setCover:cover];
    [self setUserAvatar:cover];
    [self setUserNick:model.nickname];
    [self setUserSign:@""];
}

/** 个人圈子的信息 */
- (void)myFriendCircleMessage
{
//    XXECircleModel *circleModel = self.circleMyCircleListDatasource[0];
//    NSLog(@"%@",circleModel.words);
    
    if (self.circleMyCircleListDatasource.count != 0) {
        for (int i =0; i<self.circleMyCircleListDatasource.count; i++) {
            XXECircleModel *circleModel = self.circleMyCircleListDatasource[i];
            DFTextImageUserLineItem *textItem = [[DFTextImageUserLineItem alloc]init];
            textItem.itemId = i;
            NSLog(@"%@",circleModel.date_tm);
            textItem.ts = [circleModel.date_tm integerValue];
            textItem.cover = circleModel.pic_url;
            textItem.text = circleModel.words;
            //如果发布的圈子有图片则显示图片
            [self myFritnd_CircleImageShowTextImageItem:textItem CircleModel:circleModel];
        }
    }else{
        NSLog(@"没有数据");
        [self hudShowText:@"没有数据" second:1.f];
        [self endLoadMore];
    }
}

#pragma mark - 显示图片
- (void)myFritnd_CircleImageShowTextImageItem:(DFTextImageUserLineItem *)textItem CircleModel:(XXECircleModel *)circleModel
{
    //处理发布圈子的图片问题
    NSMutableArray *srcSmallImages = [NSMutableArray array];
    NSMutableArray *thumbBigImages = [NSMutableArray array];
    //判断图片的字符串里面有没有逗号
    
    if ([circleModel.pic_url containsString:@","]) {
        NSLog(@"包含");
        NSArray *array = [circleModel.pic_url componentsSeparatedByString:@","];
        for (NSString *image in array) {
            [srcSmallImages addObject:[NSString stringWithFormat:@"%@%@",kXXEPicURL,image]];
            [thumbBigImages addObject:[NSString stringWithFormat:@"%@%@",kXXEPicURL,image]];
            NSLog(@"小图片%@ 大图片%@",srcSmallImages,thumbBigImages);
            textItem.photoCount = srcSmallImages.count;
            textItem.cover = srcSmallImages[0];
            
        }
    }else{
        NSLog(@"不包含");
        
        [srcSmallImages addObject:[NSString stringWithFormat:@"%@%@",kXXEPicURL,circleModel.pic_url ]];
        [thumbBigImages addObject:[NSString stringWithFormat:@"%@%@",kXXEPicURL,circleModel.pic_url ]];
        textItem.photoCount = srcSmallImages.count;
        textItem.cover = srcSmallImages[0];
        NSLog(@"小图片%@ 大图片%@",srcSmallImages,thumbBigImages);
    }
    [self addItem:textItem];
}



-(void)onClickItem:(DFBaseUserLineItem *)item
{
    XXECircleModel *circleModel = self.circleMyCircleListDatasource[item.itemId];
    NSLog(@"click item: %lld", item.itemId);
    NSLog(@"时间%@",circleModel.date_tm);
    NSLog(@"发布的照片%@",circleModel.pic_url);
    NSLog(@"次图片的评论ID%@",circleModel.talkId);
    NSLog(@"评论的%@",circleModel.comment_group);
    NSLog(@"点赞的%@",circleModel.good_user);
    NSLog(@"发布内容%@",circleModel.words);
    
    XXEInfomationViewController *infomationVC = [[XXEInfomationViewController alloc]init];
    infomationVC.infoCircleModel = circleModel;
    infomationVC.ts = item.ts;
    infomationVC.itemId = [NSString stringWithFormat:@"%lld",item.itemId];
    infomationVC.conText = circleModel.words;
    infomationVC.imagesArr = circleModel.pic_url;
    infomationVC.goodArr = circleModel.good_user;
    infomationVC.hidesBottomBarWhenPushed = YES;
    infomationVC.deleteOtherXid = [self.otherXid integerValue];
    
    infomationVC.deteleModelBlock = ^ (XXECircleModel *model, NSString *item){
        [self.circleMyCircleListDatasource enumerateObjectsUsingBlock:^(XXECircleModel  *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj == model) {
                [self.circleMyCircleListDatasource removeObject:obj];
                *stop = YES;
                [self xxe_userRefreshTableViewWithItem:item];
            }
        }];
    };
    [self.navigationController pushViewController:infomationVC animated:YES];
}


#pragma mark - 导航栏中信息列表
- (void)messageHistory
{
    XXEMessageHistoryController *messageHistoryVC = [[XXEMessageHistoryController alloc]init];
    [self.navigationController pushViewController:messageHistoryVC animated:YES];
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
