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
    NSArray *arr;
    NSString *parameterXid;
    NSString *parameterUser_Id;
    
}
@property (nonatomic) NSArray *pictureArray;
@property (nonatomic) NSArray *titleArray;
@property (nonatomic) NSArray *contentArray;
@property (nonatomic) NSMutableArray *pictureWallArray;

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
    
    
    [self createImageView];
    [self.view addSubview:self.tableView];
    //设置收藏
    [self customCollection];
    
}

- (void)createImageView{
    
    self.pictureArray =[[NSMutableArray alloc]initWithObjects:@"赠送人40x40@2x.png", @"时间40x40@2x.png", @"学校40x40@2x.png", @"班级40x40@2x.png", @"科目40x40@2x.png", @"赠言40x40@2x.png",  @"教师风采40x40@2x.png",nil];
    self.titleArray =[[NSMutableArray alloc]initWithObjects:@"赠送人:",@"赠送时间:",@"学校:", @"班级:", @"课程:", @"赠言:", @"照片墙:", nil];
    self.contentArray =[[NSMutableArray alloc]initWithObjects:self.name, self.time, self.schoolName, self.className, self.couseName, self.text, @"", nil];
    self.pictureWallArray = [[NSMutableArray alloc] initWithObjects:@"照片182x182@2x.png", @"照片(1)182x182@2x.png", nil];
    
    _backgroundImageView = [[UIImageView alloc] init];
    _iconImageView = [[UIImageView alloc] init];
    
    _backgroundImageView.frame = CGRectMake(0, 0, kScreenWidth, 130);
    _backgroundImageView.backgroundColor = UIColorFromRGB(0, 170, 42);
    
    _iconImageView.frame = CGRectMake(kScreenWidth / 2 - 87/2, _backgroundImageView.frame.size.height / 2 - 87/2, 87, 87);
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:self.imageName] placeholderImage:[UIImage imageNamed:@"小红花详情人物头像174x174@2x.png"]];
    _iconImageView.layer.cornerRadius = 87/2;
    _iconImageView.layer.masksToBounds = YES;
    [self.backgroundImageView addSubview:_iconImageView];
    
    self.tableView.tableHeaderView = self.backgroundImageView;
}

//设置收藏
- (void)customCollection{
    if ([self.i isEqualToNumber:@1]) {
        self.collcetionButton =[HHControl createButtonWithFrame:CGRectMake(251, 0, 22, 22) backGruondImageName:@"收藏(H)icon44x44" Target:self Action:@selector(collectionClick:) Title:nil];
    }
    else if ([self.i isEqualToNumber:@2]){
        
        self.collcetionButton =[HHControl createButtonWithFrame:CGRectMake(251, 0, 22, 22) backGruondImageName:@"收藏icon44x44" Target:self Action:@selector(collectionClick:) Title:nil];
    }
    
    
    UIBarButtonItem* rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.collcetionButton];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

- (void)collectionClick:(UIButton *)shareBtn{
    self.HUDH =[[MBProgressHUD alloc]initWithView:self.view];
    [self.view addSubview:self.HUDH];
    
    if ([self.i isEqualToNumber:@1]) {
        //已收藏
        if (shareBtn.selected ) {
            shareBtn.selected=NO;
            [self saveFlower];
            self.HUDH.dimBackground =YES;
            [shareBtn setBackgroundImage:[UIImage  imageNamed:@"收藏(H)icon44x44"] forState:UIControlStateNormal];
            self.HUDH.labelText =@"已收藏";
            
            [self.HUDH showAnimated:YES whileExecutingBlock:^{
                sleep(1);
            } completionBlock:^{
                [self.HUDH removeFromSuperview];
                self.HUDH =nil;
            }];
        }
        else{
            shareBtn.selected=YES;
            [self deleteFlower];
            [shareBtn setBackgroundImage:[UIImage  imageNamed:@"收藏icon44x44"] forState:UIControlStateNormal];
            self.HUDH.dimBackground =YES;
            self.HUDH.labelText =@"取消收藏";
            
            [self.HUDH showAnimated:YES whileExecutingBlock:^{
                sleep(1);
            } completionBlock:^{
                [self.HUDH removeFromSuperview];
                self.HUDH =nil;
            }];
        }
        
    }
    else if ([self.i isEqualToNumber:@2]){
        //未收藏
        
        if (shareBtn.selected ) {
            [self deleteFlower];
            shareBtn.selected=NO;
            
            self.HUDH.dimBackground =YES;
            [shareBtn setBackgroundImage:[UIImage  imageNamed:@"收藏icon44x44"] forState:UIControlStateNormal];
            self.HUDH.labelText =@"取消收藏";
            
            [self.HUDH showAnimated:YES whileExecutingBlock:^{
                sleep(1);
            } completionBlock:^{
                [self.HUDH removeFromSuperview];
                self.HUDH =nil;
            }];
        }
        else{
            shareBtn.selected=YES;
            [self saveFlower];
            [shareBtn setBackgroundImage:[UIImage  imageNamed:@"收藏(H)icon44x44"] forState:UIControlStateNormal];
            self.HUDH.dimBackground =YES;
            self.HUDH.labelText =@"已收藏";
            
            [self.HUDH showAnimated:YES whileExecutingBlock:^{
                sleep(1);
            } completionBlock:^{
                [self.HUDH removeFromSuperview];
                self.HUDH =nil;
            }];
        }
        
    }
}

- (void)saveFlower{
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/collect";
    NSDictionary *dict = @{@"appkey":APPKEY,
                           @"backtype":BACKTYPE,
                           @"xid":parameterXid,
                           @"user_id":parameterUser_Id,
                           @"user_type":USER_TYPE,
                           @"collect_id":[NSString stringWithFormat:@"%@",self.idKT],
                           @"collect_type":@"6"
                           };
    
    [WZYHttpTool post:urlStr params:dict success:^(id responseObj) {
        
    } failure:^(NSError *error) {
        
    }];
}
- (void)deleteFlower{
    
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/deleteCollect";
    NSDictionary *dict = @{@"appkey":APPKEY,
                           @"backtype":BACKTYPE,
                           @"xid":parameterXid,
                           @"user_id":parameterUser_Id,
                           @"user_type":USER_TYPE,
                           @"collect_id":self.idKT,
                           @"collect_type":@"6"
                           };
    
    [WZYHttpTool post:urlStr params:dict success:^(id responseObj) {
        
        
        
        
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
    
    
    cell.lineImageView.backgroundColor = [UIColor colorWithRed:224.0/255 green:224.0/255 blue:224.0/255 alpha:1.0];
    cell.titleLabel.text = self.titleArray[indexPath.row];
    cell.contentLabel.text = self.contentArray[indexPath.row];
    cell.pictureImageView.image = [UIImage imageNamed:self.pictureArray[indexPath.row]];
    
    if (indexPath.row == 6) {
        //  NSLog(@"%@",self.imageStr);
        if (![self.imageStr isEqualToString:@""]) {
            arr =[self.imageStr componentsSeparatedByString:@","];
            //            NSLog(@"%ld",arr.count);
            for (int i =0; i<arr.count; i++) {
                UIButton *pictureWallButton = [UIButton buttonWithType:UIButtonTypeCustom];
                pictureWallButton.frame = CGRectMake(10 + (10 + 100) * i, 60, 100, 100);
                pictureWallButton.tag = 10 + i;
                self.buttonTag = pictureWallButton.tag;
                [pictureWallButton setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",picURL,arr[i]]]]] forState:UIControlStateNormal];
                [pictureWallButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:pictureWallButton];
                
            }
            
        }
        
        
        
    }
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 6) {
        return 180;
    }
    return 48;
}


- (void)buttonClick:(UIButton *)button{
    
    RedFlowerViewController *redFlowerVC =[[RedFlowerViewController alloc]init];
    redFlowerVC.imageArr = arr;
    redFlowerVC.index = button.tag - 10;
    redFlowerVC.hidesBottomBarWhenPushed = YES;
    //图片 举报 来源 小红花 1:小红花赠言中的图片
    redFlowerVC.origin_pageStr = @"1";
    
    [self.navigationController pushViewController:redFlowerVC animated:YES];
    
}


@end
