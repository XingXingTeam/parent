//
//  XXEInfomationViewController.m
//  teacher
//
//  Created by codeDing on 16/9/19.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEInfomationViewController.h"
#import "AFNetworking.h"
#import "CommentInputViewController.h"
#import "MessageListDetailController.h"
#import "UMSocial.h"
#import "XXECircleModel.h"
#import "XXEFriendCirclegoodApi.h"
#import "XXEDeleteCommentApi.h"
#import "XXETool.h"

@interface XXEInfomationViewController ()<UIActionSheetDelegate,UIScrollViewDelegate,UMSocialUIDelegate>
{
    UIImageView *imageView;
//    UIScrollView *_scrollView;
    UIButton *_detaileBtn;
    BOOL isGood;
}

//@property (nonatomic, strong) UIView *panelView;

@property (nonatomic, strong)UIScrollView *scrollView;

/**
 *  加载视图
 */
@property (nonatomic, strong) UIActivityIndicatorView *loadingView;
//@property(nonatomic,retain) NSMutableArray *ittms;

@property (nonatomic, strong) UIButton *likeButton;

@property (nonatomic, strong) UIButton *commentButton;

/** 图片的下标 */
@property (nonatomic, assign)NSInteger indexImage;

@end

@implementation XXEInfomationViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.backgroundColor = [UIColor blackColor];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"" forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"dian"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"dian"] forState:UIControlStateHighlighted];
    button.size = CGSizeMake(70, 30);
    // 让按钮内部的所有内容左对齐
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    //        [button sizeToFit];
    // 让按钮的内容往左边偏移10
    button.contentEdgeInsets = UIEdgeInsetsMake(0, 50, 0, 0);
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
    
    // 修改导航栏左边的item
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
}
/** 这两个方法都可以,改变当前控制器的电池条颜色 */
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.indexImage = 0;
    NSLog(@"图片的数组%@",self.imagesArr);
    
//    NSLog(@"click item: %@",_itemId);
//    NSLog(@"时间%@",_infoCircleModel.date_tm);
//    NSLog(@"发布的照片%@",_infoCircleModel.pic_url);
//    NSLog(@"次图片的评论ID%@",_infoCircleModel.talkId);
//    NSLog(@"评论的%@",_infoCircleModel.comment_group);
//    NSLog(@"点赞的%@",_infoCircleModel.good_user);
//    NSLog(@"发布内容%@",_infoCircleModel.words);
    NSString *timeFomatter = [XXETool dateAboutStringFromNumberTimer:_infoCircleModel.date_tm];
    self.title = timeFomatter;
    
    [self createscrollView];
    [self createToolbtn];
}

-(void)createscrollView{
//    self.view.backgroundColor = [UIColor blackColor];
    self.scrollView =  [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 113)];
    self.scrollView.pagingEnabled =YES;
    self.scrollView.bounces = NO;
    self.scrollView.showsHorizontalScrollIndicator = YES;
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
//    self.automaticallyAdjustsScrollViewInsets = NO;
    
    NSArray *arrayImage;
    arrayImage = nil;
    if ([_imagesArr containsString:@","]) {
        arrayImage = [_imagesArr componentsSeparatedByString:@","];
        //  加载图片
        NSLog(@"图片个数%lu",(unsigned long)arrayImage.count);
        NSLog(@"图片数组%@",arrayImage);
        for (int i=0; i< arrayImage.count; i++) {
            UIImageView *imV = [[UIImageView alloc]initWithFrame:CGRectMake(KScreenWidth*i, 0, KScreenWidth, KScreenHeight-113)];
            NSString *imageUrl = [NSString stringWithFormat:@"%@%@",picURL,arrayImage[i]];
            NSURL *url =[NSURL URLWithString:imageUrl];
            
//            [imV sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@""]];
            [imV sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@""] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                CGFloat imageWidth = image.size.width;
                CGFloat imageHeight = image.size.height;
                CGFloat imVHeight = KScreenWidth/imageWidth * imageHeight;
                imV.frame = CGRectMake(KScreenWidth*i, (KScreenHeight - 113)/2 - imVHeight/2, KScreenWidth, imVHeight);
            }];
            [self.scrollView addSubview:imV];
        }
        CGPoint contentOffset = self.scrollView.contentOffset;
        [self.scrollView setContentOffset:contentOffset animated:YES];
        self.scrollView.contentSize =CGSizeMake(arrayImage.count*kWidth, 0);
//        _scrollView.delegate =self;

    }else{
        NSLog(@"图片数组%@",_imagesArr);
        UIImageView *imV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight-113)];
        NSString *imageUrl = [NSString stringWithFormat:@"%@%@",picURL,_imagesArr];
        NSLog(@"图片地址%@",imageUrl);
        NSURL *url =[NSURL URLWithString:imageUrl];
        [imV sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@""] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            CGFloat imageWidth = image.size.width;
            CGFloat imageHeight = image.size.height;
            CGFloat imVHeight = KScreenWidth/imageWidth * imageHeight;
            imV.frame = CGRectMake(0, (KScreenHeight - 113)/2 - imVHeight/2, KScreenWidth, imVHeight);
        }];
        [self.scrollView addSubview:imV];
        CGPoint contentOffset = self.scrollView.contentOffset;
        [self.scrollView setContentOffset:contentOffset animated:YES];
        self.scrollView.contentSize =CGSizeMake(kWidth, 0);
//        _scrollView.delegate =self;
    }
}
- (void)createToolbtn{
    
    //UILabel 加白字
    UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, KScreenHeight-153, KScreenWidth - 20, 50)];
//    textLabel.backgroundColor = [UIColor colorWithWhite:0.35 alpha:0.35];
//    textLabel.backgroundColor =UIColorFromRGB(125, 130, 147);
    [self.view addSubview:textLabel];
    textLabel.numberOfLines =0;
    textLabel.font =[UIFont systemFontOfSize:15];
    textLabel.text = _conText;
    textLabel.textColor =UIColorFromRGB(255, 255, 255);
    
    UIImageView *imageV= [[UIImageView alloc]initWithFrame:CGRectMake(0, KScreenHeight-108, KScreenWidth, 44)];
//    imageV.backgroundColor = UIColorFromRGB(255, 233, 233 );
    [self.view addSubview:imageV];
    imageV.userInteractionEnabled =YES;
    
    _likeButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 2, 60, 40)];
    _likeButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [_likeButton setTitle:@"赞" forState:UIControlStateNormal];
    [_likeButton setImage:[UIImage imageNamed:@"AlbumLike"] forState:UIControlStateNormal];
    [_likeButton addTarget:self action:@selector(onLike:) forControlEvents:UIControlEventTouchUpInside];
    [imageV addSubview:_likeButton];
    _likeButton.selected = YES;
    
    for (XXEGoodUserModel * good in _goodArr) {
        if ([good.goodXid integerValue] == [[XXEUserInfo user].xid integerValue]) {
            [_likeButton setTitle:@"取消" forState:UIControlStateNormal];
            [_likeButton setImage:[UIImage imageNamed:@"AlbumLike"] forState:UIControlStateNormal];
            _likeButton.selected = NO;
            break;
        }
    };
    
//    if (![_goodArr isEqual:@""]) {
//        _likeButton = [self getButton:CGRectMake(5, 2, 60, 40) title:@"取消" image:@"AlbumLike"];
//        [_likeButton addTarget:self action:@selector(onLike:) forControlEvents:UIControlEventTouchUpInside];
//        [imageV addSubview:_likeButton];
//        _likeButton.selected = NO;
//    }else{
//        _likeButton = [self getButton:CGRectMake(5, 2, 60, 40) title:@"赞" image:@"AlbumLike"];
//        [_likeButton addTarget:self action:@selector(onLike:) forControlEvents:UIControlEventTouchUpInside];
//        [imageV addSubview:_likeButton];
//        _likeButton.selected = YES;
//    }

    _commentButton = [self getButton:CGRectMake(70, 2, 60, 40) title:@"评论" image:@"AlbumComment"];
    [_commentButton addTarget:self action:@selector(commentButton:) forControlEvents:UIControlEventTouchUpInside];
    [imageV addSubview:_commentButton];
    
    _detaileBtn = [self getButton:CGRectMake(kWidth-45, 2, 40, 40) title:@"" image:@"AlbumOperateMoreHL"];
    [_detaileBtn addTarget:self action:@selector(detaileButton:) forControlEvents:UIControlEventTouchUpInside];
    [imageV addSubview:_detaileBtn];
}

- (void)delete:(UINavigationItem*)sender{
    UIActionSheet *actionSheet =[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"分享" otherButtonTitles:@"保存图片",@"删除", nil];
    actionSheet.delegate = self;
    [actionSheet showInView:self.view];
    actionSheet.tag=100;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (actionSheet.tag==100) {
        if (buttonIndex ==0) {
            NSLog(@"分享");
            [self performSelector:@selector(sendQQFriend) withObject:nil afterDelay:0.6];
        }
        else if (buttonIndex==1){
            NSLog(@"保存图片");
            [self performSelector:@selector(savePic) withObject:nil afterDelay:0.6];
        }
        else  if (buttonIndex==2){
            NSLog(@"删除");
            [self performSelector:@selector(delayDelete) withObject:nil afterDelay:0.6];
            
        }else{
            NSLog(@"cancel");
        }
   }
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
     NSInteger index = scrollView.contentOffset.x/CGRectGetWidth(scrollView.bounds);
    self.indexImage = index;
    NSLog(@"%ld",(long)index);
}

- (void)savePic{
    
    NSArray *arrayImage;
    NSString *imageStringUrl;
    arrayImage = nil;
    if ([_imagesArr containsString:@","]) {
        arrayImage = [_imagesArr componentsSeparatedByString:@","];
        imageStringUrl = [NSString stringWithFormat:@"%@%@",picURL,arrayImage[self.indexImage]];
    }else{
        imageStringUrl = [NSString stringWithFormat:@"%@%@",picURL,self.imagesArr];
    }
    NSURL *url = [NSURL URLWithString:imageStringUrl];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *image = [UIImage imageWithData:data];
    NSLog(@"%@",image);
    
    [self saveImageToPgoto:image];
}

#pragma mark - 保存图片
- (void)saveImageToPgoto:(UIImage *)image
{
    
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error != NULL) {
        [self showString:@"保存失败" forSecond:1.f];
    }else {
        [self showString:@"保存成功" forSecond:1.f];
    }
}


- (void)delayDelete{
    
    NSString *strngXid;
    NSString *homeUserId;
    if ([XXEUserInfo user].login) {
        strngXid = [XXEUserInfo user].xid;
        homeUserId = [XXEUserInfo user].user_id;
    }else {
        strngXid = XID;
        homeUserId = USER_ID;
    }
    
    if ([strngXid integerValue] != self.deleteOtherXid) {
        [self showString:@"没权利删除" forSecond:1.f];
    }else{
        [self xxe_infomationDeleteCircleMessageStringXid:strngXid HomeUserId:homeUserId];
    }
}

#pragma mark - 删除的网络请求
- (void)xxe_infomationDeleteCircleMessageStringXid:(NSString *)strngXid HomeUserId:(NSString *)homeUserId
{
    XXEDeleteCommentApi *commentApi = [[XXEDeleteCommentApi alloc]initWithDeleteCommentEventType:@"1" TalkId:_infoCircleModel.talkId CommentId:@"" UserXid:strngXid UserId:homeUserId];
    [commentApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        NSLog(@"%@",request.responseJSONObject);
        NSString *code = [request.responseJSONObject objectForKey:@"code"];
        if ([code integerValue]==1) {
            NSLog(@"%@",[request.responseJSONObject objectForKey:@"msg"]);
            NSLog(@"%@",[request.responseJSONObject objectForKey:@"data"]);
            [self showString:@"删除成功" forSecond:1.f];
            self.deteleModelBlock ? self.deteleModelBlock(self.infoCircleModel,self.itemId) : nil;
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self showString:@"删除失败" forSecond:1.f];
        }
    } failure:^(__kindof YTKBaseRequest *request) {
        [self showString:@"网络请求失败" forSecond:1.f];
    }];
}
    
- (void)sendQQFriend{
    NSString *shareText = @"来自猩猩教室";
    NSString *image = @"http://qzapp.qlogo.cn/qzapp/1105651422/9FFBD19645379A28C1F98EE2C2526DC4/100";
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:image]];
    UIImage *imageA = [UIImage imageWithData:data];
    //调用快速分享接口
    [UMSocialSnsService presentSnsIconSheetView:self appKey:UMSocialAppKey shareText:shareText shareImage:imageA shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToQzone,UMShareToQQ,UMShareToWechatSession,UMShareToWechatTimeline,nil] delegate:self];
}

//分享的代理方法
#pragma mark - 分享的代理方法
- (void)didCloseUIViewController:(UMSViewControllerType)fromViewControllerType
{
    NSLog(@"关闭的是%u",fromViewControllerType);
}

//分享完成后的回调
- (void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    NSLog(@"信息是什么%@",response);
    //根据responseCode得到发送结果,如果分享成功
    if (response.responseCode == UMSResponseCodeSuccess) {
        //得到分享的微博平台名
        NSLog(@"share to sns name is%@",[[response.data allKeys]objectAtIndex:0]);
    }
}

- (void)commentButton:(UIButton*)shareBtn{
    CommentInputViewController *commentInputVC = [[CommentInputViewController alloc] init];
    commentInputVC.itemId = _infoCircleModel.talkId;
    [self.navigationController pushViewController:commentInputVC animated:YES];
    
}

- (void)detaileButton:(UIButton*)btn{
    MessageListDetailController *messageListDetailVC = [[MessageListDetailController alloc] init];
    messageListDetailVC.talkId = _infoCircleModel.talkId;
    [self.navigationController pushViewController:messageListDetailVC animated:YES];
}

//点赞
-(void)onLike:(UIButton *)shareBtn{
    
    if (_likeButton.selected == NO) {
        
        [self onClickLikeButton];
        
    }else if (_likeButton.selected == YES){
        
        [self onClickLikeButton];
    }
}
-(void)onClickLikeButton{
    
    NSString *strngXid;
    NSString *homeUserId;
    if ([XXEUserInfo user].login) {
        strngXid = [XXEUserInfo user].xid;
        homeUserId = [XXEUserInfo user].user_id;
    }else {
        strngXid = XID;
        homeUserId = USER_ID;
    }
        NSLog(@"说说ID%@ XID%@ UserID%@",_infoCircleModel.talkId ,strngXid,homeUserId);
        XXEFriendCirclegoodApi *friendGoodApi = [[XXEFriendCirclegoodApi alloc]initWithFriendCircleGoodOrCancelUerXid:strngXid UserID:homeUserId TalkId:_infoCircleModel.talkId];
        [friendGoodApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
            NSString *code = [request.responseJSONObject objectForKey:@"code"];
            NSLog(@"%@",request.responseJSONObject);
            if ([code integerValue]==1) {
                [self showString:@"点赞成功" forSecond:1.f];
                [_likeButton setTitle:@"取消" forState:UIControlStateSelected];
                _likeButton.selected = !_likeButton.selected;
            }else if ([code integerValue]==10){
                [self showString:@"取消点赞" forSecond:1.f];
                [_likeButton setTitle:@"赞" forState:UIControlStateNormal];
                _likeButton.selected = !_likeButton.selected;
            }
            
        } failure:^(__kindof YTKBaseRequest *request) {
            [self showString:@"网络不通，请检查网络！" forSecond:1.f];
        }];
}


- (BOOL)isDirectShareInIconActionSheet{
    return YES;
}

-(UIButton *) getButton:(CGRect) frame title:(NSString *) title image:(NSString *) image
{
    UIButton *btn = [[UIButton alloc] initWithFrame:frame];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 6, 0, 0)];
    [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    return btn;
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
