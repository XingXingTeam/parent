//
//  DFBaseTimeLineViewController.m
//  DFTimelineView
//
//  Created by Allen Zhong on 15/10/15.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//

#import "DFBaseTimeLineViewController.h"
#import "MJRefresh.h"
#import "XXEMessageHistoryController.h"

#define TableHeaderHeight 290*([UIScreen mainScreen].bounds.size.width / 375.0)
#define CoverHeight 240*([UIScreen mainScreen].bounds.size.width / 375.0)


#define AvatarSize 70*([UIScreen mainScreen].bounds.size.width / 375.0)
#define AvatarRightMargin 15
#define AvatarPadding 2

#define KScreenWidth [UIScreen mainScreen].bounds.size.width
#define KScreenHeight [UIScreen mainScreen].bounds.size.height

#define NickFont [UIFont systemFontOfSize:20]

#define SignFont [UIFont systemFontOfSize:11]

@interface DFBaseTimeLineViewController(){
    UIButton *_messageButton;
}

@property (nonatomic, strong) UIImageView *coverView;

@property (nonatomic, strong) UIImageView *userAvatarView;

@property (nonatomic, strong) MLLabel *userNickView;

@property (nonatomic, strong) MLLabel *userSignView;

@property (strong, nonatomic) UIRefreshControl *refreshControl;

@property (nonatomic, strong) UIView *footer;

@property (nonatomic, assign) BOOL isLoadingMore;

//
@property (nonatomic, strong)UIView *header;

/** 判断是否有值 有值为新消息*/
@property (nonatomic, copy)NSString *isNumber;

@end


@implementation DFBaseTimeLineViewController



- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _isLoadingMore = NO;
        
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self initTableView];
    
    [self initHeader];
//
//    [self initFooter];
    
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self showHeader];
    }];
    
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self.tableView.footer beginRefreshing];
        [self showFooter];
    }];
}



-(void) initTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorInset = UIEdgeInsetsZero;
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        _tableView.layoutMargins = UIEdgeInsetsZero;
    }
    [self.view addSubview:self.tableView];
}

-(void) initHeader
{
    CGFloat x,y,width, height;
    x=0;
    y=0;
    width = self.view.frame.size.width;
    height = TableHeaderHeight;
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    self.header = header;
    header.backgroundColor = [UIColor whiteColor];
    _tableView.tableHeaderView = header;
    
    //封面
    height = CoverHeight;
    _coverView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    _coverView.backgroundColor = [UIColor darkGrayColor];
    
    self.coverWidth  = width*2;
    self.coverHeight = height*2;
    [header addSubview:_coverView];
    
    //用户头像
    x = self.view.frame.size.width - AvatarRightMargin - AvatarSize;
    y = header.frame.size.height - AvatarSize - 20;
    width = AvatarSize;
    height = width;
    
    UIButton *avatarBg = [[UIButton alloc] initWithFrame:CGRectMake(x, y, width, height)];
    avatarBg.backgroundColor = [UIColor whiteColor];
    avatarBg.layer.borderWidth=0.5;
    avatarBg.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [avatarBg addTarget:self action:@selector(onClickUserAvatar:) forControlEvents:UIControlEventTouchUpInside];
    [header addSubview:avatarBg];
    
    x = AvatarPadding;
    y = x;
    width = CGRectGetWidth(avatarBg.frame) - 2*AvatarPadding;
    height = width;
    _userAvatarView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    [avatarBg addSubview:_userAvatarView];
    self.userAvatarSize = width*2;
    
    
    //用户昵称
    if (_userNickView == nil) {
        _userNickView = [[MLLabel alloc] initWithFrame:CGRectZero];
        _userNickView.textColor = [UIColor whiteColor];
        _userNickView.font = NickFont;
        _userNickView.numberOfLines = 1;
        _userNickView.adjustsFontSizeToFitWidth = NO;
        [header addSubview:_userNickView];
        
        
    }
    
    
    //用户签名
    if (_userSignView== nil) {
        _userSignView = [[MLLabel alloc] initWithFrame:CGRectZero];
        _userSignView.textColor = [UIColor lightGrayColor];
        _userSignView.font = SignFont;
        _userSignView.numberOfLines = 1;
        _userSignView.adjustsFontSizeToFitWidth = NO;
        [header addSubview:_userSignView];
        
        
    }
    
//    下拉刷新
//    if (_refreshControl == nil) {
//        _refreshControl = [[UIRefreshControl alloc] init];
//        [_refreshControl addTarget:self action:@selector(onPullDown:) forControlEvents:UIControlEventValueChanged];
//        [_tableView addSubview:self.refreshControl];
//    }
//    
    
    
}


-(void) initFooter
{
    CGFloat x,y,width, height;
    x=0;
    y=0;
    width = self.view.frame.size.width;
    height = 0.1;
    
    _footer = [[UIView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    _footer.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = _footer;
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    indicator.center = CGPointMake(_footer.frame.size.width/2, 30);
    indicator.hidden = YES;
    [indicator startAnimating];
    
    [_footer addSubview:indicator];
    
    
}

#pragma mark - TableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}


#pragma mark - TabelViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}





#pragma mark - PullMoreFooterDelegate

//-(void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    //NSLog(@"size: %f  offset:  %f", scrollView.contentSize.height, scrollView.contentOffset.y+self.tableView.frame.size.height);
//    
//    if (_isLoadingMore) {
//        return;
//    }
//    
//    if (scrollView.contentOffset.y+self.tableView.frame.size.height -30 > scrollView.contentSize.height) {
//        NSLog(@"scrollViewY:%f",scrollView.contentOffset.y);
//        NSLog(@"height:%f",self.tableView.frame.size.height);
//        NSLog(@"scrollViewHeight:%f",scrollView.contentSize.height);
//        
//        [self showFooter];
//    }
//    
//}


-(void) showFooter
{
    NSLog(@"show footer");
    
//    CGRect frame = _tableView.tableFooterView.frame;
//    CGFloat x,y,width,height;
//    width = frame.size.width;
//    height = 50;
//    x = frame.origin.x;
//    y = frame.origin.y;
//    _footer.frame = CGRectMake(x, y, width, height);
//    _tableView.tableFooterView = _footer;
//    
//    _isLoadingMore = YES;
    [self loadMore];
    [self.tableView reloadData];
}

- (void)showHeader
{
    [self refresh];
    [self.tableView reloadData];
}

-(void) hideFooter
{
//    NSLog(@"hide footer");
//    
//    [UIView animateWithDuration:0.5 animations:^{
//        
//        CGRect frame = _tableView.tableFooterView.frame;
//        CGFloat x,y,width,height;
//        width = frame.size.width;
//        height = 0.1;
//        x = frame.origin.x;
//        y = frame.origin.y;
//        _footer.frame = CGRectMake(x, y, width, height);
//        _tableView.tableFooterView = _footer;
//        
//        _isLoadingMore = NO;
//        
//    }];
    
}


//-(void) onPullDown:(id) sender
//{
//    [self refresh];
//    [self.tableView reloadData];
//}


-(void) refresh
{
}

-(void) loadMore
{
}


-(void)endLoadMore
{
//    [self hideFooter];
    [self.tableView.footer endRefreshingWithNoMoreData];
}

-(void)haveMore{
    [self.tableView.footer endRefreshing];
}

-(void)endRefresh
{
//    [_refreshControl endRefreshing];
    [self.tableView.header endRefreshing];
    [self.tableView.footer endRefreshing];
}

#pragma mark - Method

-(void)setCover:(NSString *)url
{
    [_coverView sd_setImageWithURL:[NSURL URLWithString:url]];
}

-(void)setUserAvatar:(NSString *)url
{
    [_userAvatarView sd_setImageWithURL:[NSURL URLWithString:url]];
}

-(void)setUserNick:(NSString *)nick
{
    CGFloat x, y, width, height;
    
    CGSize size = [MLLabel getViewSizeByString:nick font:NickFont];
    width = size.width;
    height = size.height;
    x = CGRectGetMinX(_userAvatarView.superview.frame) - width - 5;
    y = CGRectGetMidY(_userAvatarView.superview.frame) - height - 2;
    _userNickView.frame = CGRectMake(x, y, width, height);
    _userNickView.text = nick;
}


-(void)setUserSign:(NSString *)sign
{
    CGFloat x, y, width, height;
    
    CGSize size = [MLLabel getViewSizeByString:sign font:SignFont];
    width = size.width;
    height = size.height;
    x = CGRectGetWidth(self.view.frame) - width - 15;
    y = CGRectGetMaxY(_userAvatarView.superview.frame) + 5;
    _userSignView.frame = CGRectMake(x, y, width, height);
    _userSignView.text = sign;
}


-(void) onClickUserAvatar:(id) sender
{
    [self onClickHeaderUserAvatar];
}


-(void)onClickHeaderUserAvatar
{
    
}

- (void)creatNewMessageRemindcircleNoread:(NSString *)Number
{
    self.isNumber = Number;
    UIButton *messageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _messageButton = messageButton;
    messageButton.frame = CGRectMake(KScreenWidth/2 - 60, TableHeaderHeight-30, 120, 30);
    [messageButton setTitle:@"你有新信息" forState:UIControlStateNormal];
    [messageButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [messageButton addTarget:self action:@selector(messageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    messageButton.layer.cornerRadius = 8;
    messageButton.backgroundColor = XXEColorFromRGB(229, 233, 232);
    messageButton.tag = 1000;
    messageButton.userInteractionEnabled = YES;
    messageButton.layer.masksToBounds = YES;
    messageButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.header addSubview:messageButton];
}

- (void)messageButtonClick:(UIButton *)sender
{
    UIButton *button = [self.header viewWithTag:1000];
    XXEMessageHistoryController *message = [[XXEMessageHistoryController alloc]init];
    [button removeFromSuperview];
    [_messageButton removeFromSuperview];
    message.messageNumber = self.isNumber;
    [self.navigationController pushViewController:message animated:YES];
}



@end
