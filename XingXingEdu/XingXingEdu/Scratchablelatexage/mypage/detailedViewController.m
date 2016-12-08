//
//  detailedViewController.m
//  Homepage
//
//  Created by super on 16/1/22.
//  Copyright © 2016年 Edu. All rights reserved.
//
#define DETAIL @"DetailCell"
#import "detailedViewController.h"
#import "RedFlowerViewController.h"
#import "HHControl.h"
#import "DetailCell.h"
#import "flowerViewController.h"
#import "SDWebImageCompat.h"
#import "SDWebImageManager.h"

#define kScreenWidth self.view.frame.size.width
#define kScreenHeight self.view.frame.size.height

@interface detailedViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    
    //
    UIButton *collcetionButton;
    //照片墙 的图片 可以排列几行
    
    //图片 有字符串 拆成的数组
    NSMutableArray *picWallArray;
    
    NSInteger picRow;
    //照片墙 照片 宽
    CGFloat picWidth;
    //照片墙 照片 高
    CGFloat picHeight;
    
    CGFloat maxWidth;
    
    NSArray *arr;
    NSString *parameterXid;
    NSString *parameterUser_Id;
    
}
@property (nonatomic) NSArray *iconArray;
@property (nonatomic) NSArray *titleArray;
@property (nonatomic) NSArray *contentArray;

@property (nonatomic) UITableView *tableView;
@property (nonatomic) UIImageView *backgroundImageView;
@property (nonatomic) UIImageView *iconImageView;
@property (nonatomic) UIView *lineView;
@property (nonatomic, assign) NSInteger buttonTag;
@property (nonatomic) MBProgressHUD *HUDH;

@property (nonatomic, strong) flowerViewController *flowerVC;

@end

@implementation detailedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellAccessoryNone;
    self.title =@"小红花详情";
    
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }
    
    picWallArray = [[NSMutableArray alloc] init];
    
    NSLog(@"%@", _model.pic);
    if (![_model.pic isEqualToString:@""]) {
        if (![_model.pic containsString:@","]) {
            [picWallArray addObject:_model.pic];
        }else{
            NSArray *picArr = [NSArray array];
            picArr = [_model.pic componentsSeparatedByString:@","];
            [picWallArray addObjectsFromArray:picArr];
        }
    }
    
    [self createImageView];
    [self.view addSubview:self.tableView];
    //设置收藏
    [self customCollection];
    
}

- (void)createImageView{
    
    self.iconArray =[[NSMutableArray alloc]initWithObjects:@"赠送人40x40", @"时间40x40", @"学校40x40", @"班级40x40", @"科目40x40", @"赠言40x40",  @"教师风采40x40",nil];
    self.titleArray =[[NSMutableArray alloc]initWithObjects:@"赠送人:",@"赠送时间:",@"学校:", @"班级:", @"课程:", @"赠言:", @"照片墙:", nil];
    
    self.contentArray =[[NSMutableArray alloc]initWithObjects:_model.tname, [WZYTool dateStringFromNumberTimer:_model.date_tm], _model.school_name, _model.class_name, _model.teach_course, _model.con, @"", nil];

    _backgroundImageView = [[UIImageView alloc] init];
    _iconImageView = [[UIImageView alloc] init];
    
    _backgroundImageView.frame = CGRectMake(0, 0, kScreenWidth, 130);
    _backgroundImageView.backgroundColor = UIColorFromRGB(0, 170, 42);
    
    _iconImageView.frame = CGRectMake(kScreenWidth / 2 - 87/2, _backgroundImageView.frame.size.height / 2 - 87/2, 87, 87);
    
    NSString *headImage;
    
    if ([_model.head_img_type integerValue] == 0) {
        headImage = [NSString stringWithFormat:@"%@%@", picURL, _model.head_img];
    }else{
        headImage = [NSString stringWithFormat:@"%@", _model.head_img];
    }
    
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:headImage] placeholderImage:[UIImage imageNamed:@"小红花详情人物头像174x174"]];
    _iconImageView.layer.cornerRadius = _iconImageView.frame.size.width / 2;
    _iconImageView.layer.masksToBounds = YES;
    [self.backgroundImageView addSubview:_iconImageView];
    
    self.tableView.tableHeaderView = self.backgroundImageView;
}

//设置收藏
- (void)customCollection{
    if ([_model.collect_condit integerValue] == 1) {
        collcetionButton =[HHControl createButtonWithFrame:CGRectMake(251, 0, 22, 22) backGruondImageName:@"收藏(H)icon44x44" Target:self Action:@selector(collectionClick:) Title:nil];
    }
    else if ([_model.collect_condit integerValue] == 2){
        
        collcetionButton =[HHControl createButtonWithFrame:CGRectMake(251, 0, 22, 22) backGruondImageName:@"收藏icon44x44" Target:self Action:@selector(collectionClick:) Title:nil];
    }
    
    
    UIBarButtonItem* rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:collcetionButton];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

- (void)collectionClick:(UIButton *)shareBtn{
    self.HUDH =[[MBProgressHUD alloc]initWithView:self.view];
    [self.view addSubview:self.HUDH];
    
    if ([_model.collect_condit integerValue] == 1) {
        //已收藏
        if (shareBtn.selected ) {
            shareBtn.selected=NO;
            [self saveFlower];

        }
        else{
            shareBtn.selected=YES;
            [self deleteFlower];
        }
        
    }
    else if ([_model.collect_condit integerValue] == 2){
        //未收藏
        
        if (shareBtn.selected ) {
            [self deleteFlower];
            shareBtn.selected=NO;
        }
        else{
            shareBtn.selected=YES;
            [self saveFlower];

        }
        
    }
}

#pragma Mark ************ 收藏 ****************
- (void)saveFlower{
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/collect";
    NSDictionary *dict = @{@"appkey":APPKEY,
                           @"backtype":BACKTYPE,
                           @"xid":parameterXid,
                           @"user_id":parameterUser_Id,
                           @"user_type":USER_TYPE,
                           @"collect_id":[NSString stringWithFormat:@"%@", _model.flowerId],
                           @"collect_type":@"6"
                           };
    
    [WZYHttpTool post:urlStr params:dict success:^(id responseObj) {
        
//        NSLog(@"collect === %@", responseObj);
        
        if ([responseObj[@"code"]  integerValue] == 1) {
            self.HUDH.dimBackground =YES;
            [collcetionButton setBackgroundImage:[UIImage  imageNamed:@"收藏(H)icon44x44"] forState:UIControlStateNormal];
            self.HUDH.labelText =@"已收藏";
            
            [self.HUDH showAnimated:YES whileExecutingBlock:^{
                sleep(1);
            } completionBlock:^{
                [self.HUDH removeFromSuperview];
                self.HUDH =nil;
            }];
        }
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark =========== 取消 收藏 =========
- (void)deleteFlower{
    
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/deleteCollect";
    NSDictionary *dict = @{@"appkey":APPKEY,
                           @"backtype":BACKTYPE,
                           @"xid":parameterXid,
                           @"user_id":parameterUser_Id,
                           @"user_type":USER_TYPE,
                           @"collect_id":_model.flowerId,
                           @"collect_type":@"6"
                           };
    
    [WZYHttpTool post:urlStr params:dict success:^(id responseObj) {
        
//        NSLog(@"deleteCollect ---- %@", responseObj);
        if ([responseObj[@"code"] integerValue] == 1) {
            [collcetionButton setBackgroundImage:[UIImage  imageNamed:@"收藏icon44x44"] forState:UIControlStateNormal];
            self.HUDH.dimBackground =YES;
            self.HUDH.labelText =@"取消收藏";
            
            [self.HUDH showAnimated:YES whileExecutingBlock:^{
                sleep(1);
            } completionBlock:^{
                [self.HUDH removeFromSuperview];
                self.HUDH =nil;
            }];

        }
        
    } failure:^(NSError *error) {
        
    }];
    
}
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 20  - self.backgroundImageView.frame.size.height )];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.scrollEnabled = YES;
        _tableView.userInteractionEnabled = YES;
        
    }
    return _tableView;
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DetailCell *cell =(DetailCell*)[tableView dequeueReusableCellWithIdentifier:DETAIL];
    if (cell == nil) {
        NSArray *nib =[[NSBundle mainBundle] loadNibNamed:DETAIL owner:[DetailCell class] options:nil];
        cell =(DetailCell *)[nib objectAtIndex:0];
    }
    
    
//    NSLog(@"_contentArray *******  %@ ---- %ld", _contentArray, indexPath.row);
    
    cell.lineImageView.backgroundColor = [UIColor colorWithRed:224.0/255 green:224.0/255 blue:224.0/255 alpha:1.0];
    cell.titleLabel.text = self.titleArray[indexPath.row];
    cell.contentLabel.text = self.contentArray[indexPath.row];
    cell.contentLabel.numberOfLines = 0;
    maxWidth = cell.contentLabel.width;
    CGFloat height = [StringHeight contentSizeOfString:_contentArray[indexPath.row] maxWidth:maxWidth fontSize:14];
    
    CGSize size = cell.contentLabel.size;
    size.height = height;
    cell.contentLabel.size = size;
    cell.pictureImageView.image = [UIImage imageNamed:_iconArray[indexPath.row]];
    
    if (indexPath.row == 6) {
        
        if (picWallArray.count % 3 == 0) {
            picRow = picWallArray.count / 3;
        }else{
            picRow = picWallArray.count / 3 + 1;
        }
        
        int margin = 10;
        picWidth = (kWidth - 20 - 4 * margin) / 3;
        picHeight = picWidth;
        
//        NSLog(@"%@", picWallArray);
        
        for ( int i = 0; i < picWallArray.count; i++) {
            //行
            int buttonRow = i / 3;
            //列
            int buttonLine = i % 3;
            CGFloat buttonX = 10 + (picWidth + margin) * buttonLine;
            CGFloat buttonY = 40 + (picHeight + margin) * buttonRow;
            
            UIImageView *pictureImageView = [[UIImageView alloc] initWithFrame:CGRectMake(buttonX, buttonY, picWidth, picHeight)];
            pictureImageView.contentMode = UIViewContentModeScaleAspectFill;
            pictureImageView.clipsToBounds = YES;
            [pictureImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", picURL , picWallArray[i]]] placeholderImage:[UIImage imageNamed:@""]];
            pictureImageView.tag = 20 + i;
            pictureImageView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickPicture:)];
            [pictureImageView addGestureRecognizer:tap];
            
            [cell.contentView addSubview:pictureImageView];
            
        }
        
        
    }
    return cell;
    
}

- (void)onClickPicture:(UITapGestureRecognizer *)tap{
    
    //    NSLog(@"--- 点击了第%ld张图片", tap.view.tag - 20);
    
    RedFlowerViewController *redFlowerVC =[[RedFlowerViewController alloc]init];
    redFlowerVC.imageArr = picWallArray;
    redFlowerVC.index = tap.view.tag - 20;
    redFlowerVC.hidesBottomBarWhenPushed = YES;
    //图片 举报 来源 小红花 1:小红花赠言中的图片
    redFlowerVC.origin_pageStr = @"1";
    
    [self.navigationController pushViewController:redFlowerVC animated:YES];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 5) {
        CGFloat height = [StringHeight contentSizeOfString:_contentArray[indexPath.row] maxWidth:maxWidth fontSize:14];
        return height + 20;
    }else if (indexPath.row == 6) {
        return 44 + picRow * picHeight;
    }
    return 44;
}


- (void)buttonClick:(UIButton *)button{
    
    
}


@end
