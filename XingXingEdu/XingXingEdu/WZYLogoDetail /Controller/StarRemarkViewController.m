//
//  StarRemarkViewController.m
//  XingXingEdu
//
//  Created by keenteam on 16/3/21.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//
#define kPData @"HomerRemarkCell"
#import "StarRemarkViewController.h"
#import "HomerRemarkCell.h"

#import "RedFlowerViewController.h"

#import "WZYTool.h"


@interface StarRemarkViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    
    //老师 名称
    NSMutableArray *titleArray;
    //评分
    NSMutableArray *starNumberArray;
    //评论 内容
    NSMutableArray *contentArray;
    //评论 时间
    NSMutableArray *timeArray;
    //头像 类型
    NSMutableArray *head_img_typeArray;
    //头像
    NSMutableArray *head_imgArray;
    //图片
    NSMutableArray *imageViewData;
    
    NSInteger buttonTag;
    NSInteger selectedRow;
    UIImageView *starImageView;
    UIView *starView;
    
    NSInteger page;
    NSString *parameterXid;
    NSString *parameterUser_Id;
    
}

@property (nonatomic, copy) NSString *schoolIdStr;

@end

@implementation StarRemarkViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }
    
    [_tableView reloadData];
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //    self.tabBarController.navigationItem.rightBarButtonItem = nil;
    [_tableView.header beginRefreshing];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        titleArray = [[NSMutableArray alloc] init];
        starNumberArray = [[NSMutableArray alloc] init];
        contentArray = [[NSMutableArray alloc] init];
        
        timeArray = [[NSMutableArray alloc] init];
        head_imgArray = [[NSMutableArray alloc] init];
        head_img_typeArray = [[NSMutableArray alloc] init];
        
        imageViewData = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    page = 0;
    
    self.title =@"星级评分";
    self.view.backgroundColor = UIColorFromRGB(229, 232, 233);
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
//    [self fetchNetData];
    
    [self createTableView];
}
- (void)createTableView{
    _tableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight) style:UITableViewStyleGrouped];
    _tableView.dataSource =self;
    _tableView.delegate =self;
    
    _tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
    _tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadFooterNewData)];
    
    [self.view addSubview:_tableView];

    
}

-(void)loadNewData{
    
    [self fetchNetData];
    [ _tableView.header endRefreshing];
}
-(void)endRefresh{
    [_tableView.header endRefreshing];
    [_tableView.footer endRefreshing];
}

- (void)loadFooterNewData{
    page ++ ;
    
    [self fetchNetData];
    [ _tableView.footer endRefreshing];
    
}

- (void)fetchNetData{
    /*
     接口:
     http://www.xingxingedu.cn/Global/sch_course_comment
     传参:
     school_id		//学校id
     page			//页码(加载更多),不传参默认1
     */
    
    //路径
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/sch_course_comment";
    
    //请求参数
    //获取学校id数组
     _schoolIdStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"SCHOOL_ID"];
    //    NSLog(@"%@",_schoolIdStr);
    NSString *pageStr = [NSString stringWithFormat:@"%ld", page];
    
    NSDictionary *params = @{@"appkey":APPKEY, @"backtype":BACKTYPE, @"xid":parameterXid, @"user_id":parameterUser_Id, @"user_type":USER_TYPE, @"school_id":_schoolIdStr, @"page":pageStr};
    
    [WZYHttpTool post:urlStr params:params success:^(id responseObj) {
        
//                        NSLog(@"=================%@", responseObj);
        if ([responseObj[@"code"] integerValue] == 1) {
            NSArray *array = responseObj[@"data"];
            for (NSDictionary *dic in array) {
                //头像 类型
                NSString *head_img_type = dic[@"head_img_type"];
                
                //头像
                //判断是否是第三方头像
                //    0 :表示 自己 头像 ，需要添加 前缀
                //    1 :表示 第三方 头像 ，不需要 添加 前缀
                NSString * head_img;
                if([[NSString stringWithFormat:@"%@",head_img_type]isEqualToString:@"0"]){
                    head_img=[picURL stringByAppendingString:dic[@"head_img"]];
                }else{
                    head_img=dic[@"head_img"];
                }
                
                [head_imgArray addObject:head_img];
                
                //时间
                NSString *date_tm = dic[@"date_tm"];
                [timeArray addObject:[WZYTool dateStringFromNumberTimer:date_tm]];
                
                //老师 名称
                NSString *nickname = dic[@"nickname"];
                [titleArray addObject:nickname];
                
                //评分
                NSString *school_score = dic[@"school_score"];
                [starNumberArray addObject:school_score];
                
                //内容
                NSString *con = dic[@"con"];
                [contentArray addObject:con];
                
                //图片
                NSArray *picArray = [[NSArray alloc] initWithArray:dic[@"pic_arr"]];
                [imageViewData addObject:picArray];
            }
            
        }else{
  
            
        }
        [self customContent];

    } failure:^(NSError *error) {
        
        //
        NSLog(@"%@", error);
    }];
    
}


// 有数据 和 无数据 进行判断
- (void)customContent{
    
    if (titleArray.count == 0) {
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        // 1、无数据的时候
        UIImage *myImage = [UIImage imageNamed:@"人物"];
        CGFloat myImageWidth = myImage.size.width;
        CGFloat myImageHeight = myImage.size.height;
        
        UIImageView *myImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kWidth / 2 - myImageWidth / 2, (kHeight - 64 - 49) / 2 - myImageHeight / 2, myImageWidth, myImageHeight)];
        myImageView.image = myImage;
        [self.view addSubview:myImageView];
        
    }else{
        //2、有数据的时候
        [_tableView reloadData];
        
    }
    
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return titleArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *imageArr = imageViewData[indexPath.row];
    
    if (imageArr.count != 0) {
        return 160;
    }
    
    return 100;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0000001;

}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HomerRemarkCell *cell = (HomerRemarkCell*) [tableView dequeueReusableCellWithIdentifier:kPData];
    if(cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:kPData owner:[HomerRemarkCell class] options:nil];
        cell = (HomerRemarkCell *)[nib objectAtIndex:0];
        
    }
    //老师 名称
    cell.pareLabel.text =titleArray[indexPath.row];
    //时间
    cell.timeLabel.text = timeArray[indexPath.row];
    
    //老师 头像
    cell.imageV.layer.cornerRadius = 34;
    cell.imageV.layer.masksToBounds = YES;

    [cell.imageV sd_setImageWithURL:[NSURL URLWithString:head_imgArray[indexPath.row]] placeholderImage:[UIImage imageNamed:@"人物头像占位图136x136"]];
//    cell.imageV.image =[UIImage  imageNamed:iconArray[indexPath.row]];
    
    //评分
    CGFloat k = [starNumberArray[indexPath.row] doubleValue] ;
    CGFloat i;

    starView  = [[UIView alloc] initWithFrame:CGRectMake(120 + 16, 47, 80, 16)];

    for ( i = 0; i < 5; i++) {

        starImageView = [[UIImageView alloc] initWithFrame:CGRectMake(16 * i , 0, 16, 16)];

        starImageView.image = [UIImage imageNamed:@"星星32x32"];

        [starView addSubview:starImageView];
        
    }
    
    [cell.contentView addSubview:starView];

    CGRect rect = starView.frame;
    rect.size.width = starView.frame.size.width / 5 * k;
    starView.frame = rect;
    
    //设置填充模式为靠左
    starView.contentMode = UIViewContentModeLeft;
    //超出边界剪切掉
    starView.clipsToBounds = YES;
  
    //评论 内容
    cell.contentLabel.text = contentArray[indexPath.row];
    
    //评论 是否有图片
    NSArray *imageArr = imageViewData[indexPath.row];
    
    NSLog(@"KKKK%@", imageArr);
    NSInteger num = imageArr.count;
    if (num != 0) {
        NSInteger j;
        for ( j = 0; j < num; j++) {
            
            UIImageView *pictureImageView = [[UIImageView alloc] initWithFrame:CGRectMake(100 + (50 + 10) * j, 100, 50, 50)];
            
            [pictureImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", picURL, imageArr[j]]]];
            pictureImageView.tag = 20 + j;
            pictureImageView.userInteractionEnabled = YES;
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickPicture:)];
            [pictureImageView addGestureRecognizer:tap];
            [cell.contentView addSubview:pictureImageView];
            
        }

    }else{
        cell.pictureLabel.hidden = YES;
    }
    
        return cell;
    
}

- (void)onClickPicture:(UITapGestureRecognizer *)tap{
    
    UIImageView *clickImageView = (UIImageView *)tap.view;

    HomerRemarkCell *cell = (HomerRemarkCell *)clickImageView.superview.superview;
    
    NSIndexPath *path = [_tableView indexPathForCell:cell];

    RedFlowerViewController *redFlowerVC =[[RedFlowerViewController alloc]init];
    redFlowerVC.isFromStarRemark = YES;
    NSMutableArray *imageArr = imageViewData[path.row];
    redFlowerVC.index = tap.view.tag - 20;
    
    redFlowerVC.imageArr = imageArr;
    //举报 来源 8:星级评分
    redFlowerVC.origin_pageStr = @"8";
    
    redFlowerVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:redFlowerVC animated:YES];
    
}


@end
